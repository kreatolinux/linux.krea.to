---
title: "kpkg design decisions"
date: 2023-12-07T00:10:00+03:00
draft: false
---

# Preface

Hello!

As kpkg is becoming more and more stable, I wanted to write this document about some of the design decisions I have made in kpkg.

This document is mostly styled like a FAQ, and may be merged with the FAQ on src after some time.

# Common concerns/issues

## Traditional package management

I get this a lot while talking about kpkg. For some reason, people believe that not traditional must mean its better. But it simply doesn't. Kpkg, like all of my other projects, instead of reinventing the wheel, attempts to improve the traditional model. This makes it easy to use while adding our own differences.

Traditional packaging works well for our usecases. Issues with traditional packaging mostly arise when patched libraries or custom build configurations for dependencies is used, which is not and never will be an issue in Kreato Linux as we will never accept applications that require such software.

One of our philosophies are that patches are never the solution for applications. Libraries should also be backwards-compatible, but since Linux libraries have a horrible track record for that, we still support libraries that do such things.

## Portability

Portability is one of the aspects of kpkg that needs work. It is one of the big features that I will make perfect no matter what, but currently there are bigger issues such as cross-compilation.

Kpkg is designed to be portable, and I doubt it'll require much work to make so completely.

## Feature creep

Kpkg is designed to never have feature creep. The last subcommand that was added is `kpkg audit`, and there will be no more that come by default. I will work on a module system to make community-made subcommands possible.

## Reproducibility

Another question I get a lot is about reproducibility.

The truth is that it is simply not a crucial thing to have. Multiple distributions still don't have full reproducibility and they just get along fine. Of course, this doesn't mean it is a unnecessary feature and will be added at a later date.

# Conclusion

While it is not perfect, kpkg is focused on the right things at the right time and continue in that way.

If you have any questions, you can write [at my email](mailto:kreato@krea.to).
