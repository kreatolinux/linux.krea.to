## Kongue in the browser.
##
## Builds to a single JavaScript file:
##
##     nim js -d:release -d:posix -o:kongue.js tools/kongue_playground.nim
##
## ``-d:posix`` is required, not cosmetic. Without it the JS target's
## ``os.isAbsolute`` falls through to ``raiseAssert "unreachable"``. Kongue
## scripts use POSIX paths, so POSIX semantics is also the correct choice here.
##
## What JavaScript sees:
##
##     kongueRun(code, entrypoint) -> JSON string
##
## The JSON:
##
##     {"ok": true, "error": "", "files": {"/playground/note.txt": "..."}}
##
## stdout is captured by the browser glue. Its ``exec`` hook reports that
## process spawning is unavailable; nothing in this file can reach the host.

import kongue
import json
import tables

when defined(js):
  import jscompat

  ## Implemented in kongue_playground.js. Must return a JSON string of the
  ## form {"output": string, "exitCode": int}.
  proc jsExec(cmd: cstring): cstring {.importc: "kongueExec", nodecl.}

const defaultEntrypoint* = "main"
  ## Function run when the caller does not name one. kpkg_run(5) uses `build`.

when defined(js):
  proc sandboxExec(ctx: ExecutionContext, command: string,
      silent: bool): tuple[output: string, exitCode: int] =
    ## Hand `exec` over to the JS shim. Browsers cannot spawn processes, so
    ## the shim returns an explanatory message instead of running anything.
    let raw = $jsExec(command.cstring)
    try:
      let parsed = parseJson(raw)
      var output = ""
      var exitCode = 0
      if parsed.kind == JObject:
        if parsed.hasKey("output"):
          output = parsed["output"].getStr("")
        if parsed.hasKey("exitCode"):
          exitCode = parsed["exitCode"].getInt(0)
      return (output, exitCode)
    except ValueError:
      # A plain string from the shim counts as output that succeeded.
      return (raw, 0)

  proc reportExec(ctx: ExecutionContext, output: string, exitCode: int) =
    ## Surface command results in the captured output stream.
    ##
    ## `builtinExec` never echoes on its own: it hands output to these hooks
    ## and leaves printing to the embedder. kpkg prints to a terminal; here we
    ## echo so the shim can collect it.
    if output.len > 0:
      echo output
    if exitCode != 0:
      echo "[exit code: " & $exitCode & "]"

  proc runScript(code: string, entrypoint: string): JsonNode =
    ## Compile and run `code`. Never raises: every failure comes back in the
    ## `error` field so the page can render it instead of dying silently.
    result = %* {"ok": false, "error": "", "files": newJObject()}
    try:
      let tokens = tokenize(code)
      var parser = initParser(tokens)
      let parsed = parser.parse()

      var ctx = initExecutionContext(packageName = "playground",
                                    srcDir = playgroundDir)
      ctx.execHook = sandboxExec
      ctx.commandResultContextHook = reportExec
      ctx.loadVariablesFromParsed(parsed)
      ctx.loadAllFunctions(parsed)
      discard ctx.executeFunctionByName(parsed, entrypoint)

      result["ok"] = %true
    except Exception as e:
      result["error"] = %e.msg

    var files = newJObject()
    for path, content in jscompat.vfs:
      files[path] = %content
    result["files"] = files

  proc kongueRun*(code: cstring, entrypoint: cstring): cstring {.exportc.} =
    ## Entry point for the browser. `entrypoint` may be empty for `main`.
    jscompat.resetVfs()
    let fnName =
      if entrypoint.len == 0: defaultEntrypoint
      else: $entrypoint
    let payload = $runScript($code, fnName)
    return payload.cstring
