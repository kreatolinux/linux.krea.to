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

It has started concept phase in early 2025, when `kpkg` started feeling the issues of using the old `sh`-backed runFile format.

It is designed to be very simple and modular, as it is used in many Kreato Linux projects today (including kpkg and Jumpstart, to name a few). It is basically a generic interpreter that projects using should use in a way that fits to their needs. For example, while runFile 3 is based on Kongue it looks nothing like regular Kongue code other than the syntax, same with Jumpstart services.

The examples on this page run as JavaScript in your browser. They can print values and write to a virtual filesystem, but they cannot spawn processes, access your filesystem, or read your environment. Any `exec` command reports this limitation instead of running.

## Features of Kongue

Kongue currently is a mostly full-featured language with support to;

* Objects
* Variable types (list, string, int, bool, etc.)
* If/Else statements
* For loops
* Local and global variables

We are also planning to add;

* While loops
* Math support
* Generic standard library
* import/include

## Why Kongue?

The solutions we were using before were either too reliant on the external environment (`sh`) or it didn't give us the flexibility a full language gives (`ini`). Embedding Lua or Nimscript was costly and required a lot of hacks/external libraries which we didn't want.

# Let's Learn!

In this basic course, we will show what pure Kongue looks like. After that, we will show you our reference implementation of Kongue in a project (`kpkg` runFile 3) for you to get a feel of how you might encounter it.

The code examples below are interactive. Press **Run** to execute an example, or press **Edit** to change it first.

## Your first Kongue program

A Kongue file has variables at the top and one or more functions below them. `main` is the default entrypoint used by these examples.

```kongue
name: "Kreato Linux"

main {
    print "Hello, $name!"
}
```

The browser runner captures output instead of writing to your terminal. It also keeps each example in a sandbox, so a program cannot access the host filesystem or environment.

## Lists and loops

Lists use an indented sequence. A `for` loop binds each item to a local name for the duration of the loop.

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

## Conditions and functions

Functions can be called from `main`. Function arguments are available as `$1`, `$2`, and so on.

```kongue
func greet {
    print "hello, $1"
}

main {
    greet "tinkerer"
}
```


