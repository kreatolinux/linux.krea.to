---
title: "Kongue"
draft: false
kongue: true
---

**"Write programs to work together."**
    — Doug McIlroy on UNIX Philosophy

*For more up-to-date info, we recommend looking at [kongue(5)](https://linux.krea.to/docs/manpages/kongue.5/)*

# Introduction

## What is Kongue?

Kongue is the language of all Kreato Linux projects. It is a tree-walking interpreted DSL (Domain-Specific Language). It is inspired by YAML and sh among many other languages.

It started as a concept in early 2025, when `kpkg` started feeling the limits of the old `sh`-backed runFile format.

Kongue is designed to be simple and modular. It is used by Kreato Linux projects including `kpkg` and Jumpstart. Projects embed the interpreter and decide which functions, commands, and macros they provide. For example, kpkg's runFile 3 format is based on Kongue but adds its own package lifecycle and build context.

## Features of Kongue

Kongue currently supports:

* String, boolean, list, and object-style values
* Variable interpolation with `$name` and `${name}`
* Objects and property access
* If/else statements and regular-expression matching
* For loops with `break` and `continue`
* Custom functions and local variables
* Virtual or host-backed file operations, depending on the embedding project
* Hooks for command execution and project-specific macros

The language is still growing. Planned work includes while loops, math support, a generic standard library, and import/include support.

## Why Kongue?

The older solutions were either too dependent on the external environment (`sh`) or did not provide enough structure (`ini`). Embedding Lua or Nimscript was costly and required hacks and external libraries. Kongue keeps the syntax small while allowing each project to provide the behavior it needs.

## Browser limitations

The examples on this page run as JavaScript in your browser. They can print values and write to a virtual filesystem, but they cannot spawn processes, access your filesystem, or read your environment. Any `exec` command reports this limitation instead of running.

The browser runner also uses a Web Worker. This keeps a long-running example from freezing the page. The worker is stopped after a short timeout.

# Let's Learn!

This course starts with standalone Kongue. We will begin with values and output, then build up to conditions, loops, functions, files, and objects. At the end, we will look at how a project embeds Kongue and changes its behavior through hooks.

The code examples are interactive. Press **Run** to execute an example, or press **Edit** to change it first. The output appears below each block.

## 1. Your first Kongue program

A Kongue file has variables at the top and one or more functions below them. `main` is the default entrypoint used by these examples.

```kongue
name: "Kreato Linux"

main {
    print "Hello, $name!"
}
```

The `name` declaration creates a top-level variable. The `main` block calls the built-in `print` command. `$name` is replaced with the value of the variable before the command runs.

Kongue uses indentation for values in the header, but function bodies use braces. Keeping those two parts visually separate makes larger scripts easier to read.

## 2. Comments and output

A line beginning with `#` is a comment. Comments can also follow a statement.

`print` writes text to the current output stream. `echo` is an alias for `print`.

```kongue
# This is a comment.
message: "Kongue is small"

main {
    print $message # The variable is expanded here.
    echo "This is also output"
}
```

A bare `$name` is useful for simple names. Braced interpolation, `${name}`, is useful when the variable is next to other identifier characters or when you want to make the boundary clear.

## 3. Strings and variables

Variables are declared before the function blocks. Strings may use single or double quotes. Triple quotes are useful for multi-line text.

```kongue
title: "A short title"
summary: """
Kongue puts configuration near the top
and behavior inside named functions.
"""

main {
    print "$title"
    print $summary
}
```

Variables are resolved when a command or expression is executed. A function can read the global variables declared in the header.

## 4. Lists

A list is declared with an indented sequence. Each item starts with `-`.

```kongue
packages:
    - "kpkg"
    - "kosh"
    - "jumpstart"

main {
    print "The first package is ${packages[0]}"
}
```

List indexing and slices are used inside `${...}` expressions. A list can also be joined into a string with `.join()`.

```kongue
parts:
    - "usr"
    - "local"
    - "bin"

main {
    print "${parts.join("/")}"
}
```

## 5. String manipulation

Kongue has a small set of methods for manipulating strings and lists. Common methods include:

* `split(delimiter)` turns a string into a list.
* `join(delimiter)` turns a list into a string.
* `cut(start, end)` selects part of a string.
* `replace(old, new)` replaces text.
* `lower()`, `upper()`, and `strip()` change or clean a string.

Methods can be chained inside `${...}`.

```kongue
version: "2.78.1"

main {
    print "major: ${version.split(".")[0]}"
    print "short: ${version.cut(0, 4)}"
    print "underscored: ${version.replace(".", "_")}"
}
```

## 6. Objects

Objects group related values. The explicit `object` form is useful when the object has a clear name.

```kongue
object system {
    name: "Kreato Linux"
    architecture: "x86_64"
}

main {
    print "${system.name} runs on ${system.architecture}"
}
```

Object properties can also be accessed with bracket notation, for example `system["name"]`. Dot notation inside `${...}` is usually easier to read.

Objects are especially useful for project-provided context. An embedding project can expose information about the package, target architecture, or build root as one object instead of many unrelated variables.

## 7. Conditions

An `if` block selects one branch. An optional `else` block runs when the condition is false.

```kongue
mode: "debug"

main {
    if "$mode" == "debug" {
        print "debug build"
    } else {
        print "release build"
    }
}
```

The common operators are:

* `==` equality
* `!=` inequality
* `=~` regular-expression match
* `||` logical OR
* `&&` logical AND

Values are often quoted in conditions so that interpolation happens before comparison.

```kongue
architecture: "x86_64"
mode: "debug"

main {
    if "$architecture" == "x86_64" && "$mode" == "debug" {
        print "debug build for x86_64"
    }

    if "$architecture" =~ e"x86_64|aarch64" {
        print "supported architecture"
    }
}
```

The `e"..."` form marks a regular-expression pattern. In the example above, either architecture matches.

## 8. For loops

A `for` loop binds one item at a time to a variable. The loop body can access global variables and use normal interpolation.

```kongue
packages:
    - "kpkg"
    - "kosh"
    - "jumpstart"

main {
    for package in packages {
        print "building $package"
    }
}
```

Inline list literals can be useful for short, local lists.

```kongue
main {
    for shell in ["kosh", "bash", "zsh"] {
        print "checking $shell"
    }
}
```

## 9. `continue` and `break`

Use `continue` to skip the rest of the current iteration. Use `break` to leave the loop.

```kongue
packages:
    - "kpkg"
    - "skip-me"
    - "kosh"
    - "stop-here"
    - "jumpstart"

main {
    for package in packages {
        if "$package" == "skip-me" {
            continue
        }
        if "$package" == "stop-here" {
            break
        }
        print "processing $package"
    }
}
```

The output contains `kpkg` and `kosh`. It does not contain `skip-me` or `jumpstart`.

## 10. Custom functions

A custom function is declared with `func`. Arguments are available as `$1`, `$2`, and so on. `$0` contains the function name.

```kongue
func greet {
    print "hello, $1"
}

main {
    greet "tinkerer"
    greet "builder"
}
```

Functions help keep repeated operations in one place. They can call other custom functions and use the same built-ins as `main`.

## 11. Local and global variables

A function can create a local variable with `local`. Local variables belong to that function call and do not become global configuration.

```kongue
prefix: "Kongue"

func greet {
    local message = "$prefix says hello to $1"
    print $message
}

main {
    greet "the builder"
}
```

The `global` command is available to embedding projects that need a function to update a top-level variable. Prefer local variables when a value only exists to support one function; this keeps functions easier to understand and reuse.

## 12. Writing virtual files

`write` replaces a file and `append` adds to a file. Their exact destination depends on the embedding project.

In this browser course, writes go to an in-memory virtual filesystem. The cell shows the files written after it runs; no file is created on your computer.

```kongue
main {
    write "report.txt" "first line"
    append "report.txt" "\nsecond line"
}
```

This same script embedded in kpkg can write into a package or build root instead. The language describes the operation; the host project decides how the operation is handled.

## 13. Why `exec` is different in the browser

The native interpreter can receive an execution hook that runs a command in a project-controlled environment. A browser has no safe way to spawn a host process, so this page does not execute `exec`.

```kongue
main {
    exec "echo this command is not run"
    print "The script continues after the explanation"
}
```

The example prints an informative browser limitation message. In a native embedding, the host can install an `exec` hook and give the command a sandbox, package root, or other project-specific behavior.

## 14. Entry points and embedding

`main` is only a convention used by this tutorial. An embedding project can choose another entrypoint, such as `build`, `prepare`, or `package`.

The reference interpreter follows this general flow:

1. Tokenize the source.
2. Parse tokens into an abstract syntax tree.
3. Create an execution context.
4. Load variables and functions into that context.
5. Execute the selected function.

The execution context contains variables, functions, the current directory, and optional hooks. Hooks let a project provide behavior that should not be part of the language itself, such as process execution, macros, logging, or a virtual filesystem.

This separation is what lets the same language work in kpkg, Jumpstart, and a browser tutorial with different capabilities.

## 15. A complete small script

The following example combines variables, a list, a function, a condition, and a loop without relying on host commands.

```kongue
project: "Kongue"
targets:
    - "native"
    - "browser"

func describe {
    if "$1" == "browser" {
        print "$project runs in a sandbox"
    } else {
        print "$project runs with host-provided hooks"
    }
}

main {
    for target in targets {
        describe "$target"
    }
}
```

The same structure can be extended by a host project. Native tools can provide filesystem and process hooks, while browser tools can keep the safe subset and explain unavailable operations.

# Next steps

After this course, read the [Kongue manual](https://linux.krea.to/docs/manpages/kongue.5/) for the complete syntax reference. Then look at the Kongue-based runFile implementation in [kpkg](https://github.com/kreatolinux/src/tree/master/kpkg) to see how a real project supplies execution hooks and lifecycle functions.
