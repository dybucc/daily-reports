#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-08-30)])

#title()

= Summary
Today work has focused on fixing the CI failures in rust-lang/libc, working some
more into an issue I started on by the end of GSoC, and on further advacing the
dumb binding validator for the Typst compiler.

I first solved the CI stuff in rust-lang/libc. I already knew what was wrong. A
recent patch in rust-lang/rust introduced a new clippy lint to detect duplicated
```rust repr``` attributes. We had a few spots throughout the codebase that
happened to do that.

In a PR I reviewed either yesterday or the day before, I also mentioned that I
would be looking into potentially extending our macros to allow munching those
```rust repr``` attributes if they contained a ```rust repr(C)```, as that is
the one ```rust repr``` attribute that we additionally add during macro
expansion.

But once I started looking into it, I realized a far simpler solution would be
to get rid of the few spots where some type is also annotated with
```rust repr(C)``` at declaration site (within the macro body invocation.) This
did the trick, but by the time I was going to report on this in the PRs where I
commented about these CI failures, a maintainer also opened a PR with a patchset
that fixed the exact same issues I fixed.

I cross-referenced theirs with mine, and seeing how they got everything right, I
decided to move on. Admittedly, their patchset also included a fix for another
recent change in rust-lang/rust that made the toolchain for the
`i686-pc-windows-gnu` target unavailable with host tools.

Then I moved on to update all my PRs with failures by rebasing to latest `main`,
and calling it.

The next thing I did was to start working again on an issue I took some notes in
last week. I unfortunately only partially solved it during GSoC, but I don't
think it's going to be too hard. This one is about ```rust sighandler_t```.

This type happens to have some real funny casts in C, where it itself is an
untagged union with function pointer variants that gets used with null function
pointers. In Rust, you can have dangling function pointers just fine, but simply
creating a null function pointer is immediate UB.

So I started looking through a bunch of issues that discussed as well as some
prior attempts at solving this. TL;DR; raw function pointers would be ideal, but
that is a long way off. The next best thing goes through creating a polyfill
type on our side and providing a minimal surface API to downstream users of
which we can easily replace the implementation for a type alias once (if) we get
raw function pointers.

I have looked into a couple of ways to implement this, and I think the latest
one proposed by a rust-lang/libc maintainer in the tracking issue seems like the
simplest one. Users would really have to deal with two layers of untagged
unions, where one would be an optional function pointer coupled with a "raw"
integer value, and then one of the variants of the optional would itself be the
regular untagged union of function pointers used in C.

I've struggled, though, to find the type itself in upstream glibc, even though
it's supposedly a glibc-specific extension to ```c typedef``` ```c signal```'s
return type. I haven't yet looked through the linux UAPI, but I don't think it
should be there.

In terms of compiler work, I've refactored some stuff from yesterday's
implementation for dictionary merging and slowly started implementing
multi-binding pattern validation. I've also started a fairly large refactor of
the main expression type used in derivation trees.

The dictionary rework just had me replacing one of the routines I implemented
for element search in association lists with a core-provided one. I also wanted
to use the removal function for association lists, but that one is not
tail-recursive in core, so I have continued using the one I implemented (which
uses the unstable tail modulo constructor transformation to achieve
tail-recursiveness.)

Then I decided that attempting to handle eval-specific constructs like loops
would not be worth it in this parse-time validator. So I got rid of them and
refactored some more code from the function that calls into the expression
merger to avoid the little duplication that was left there.

The plan for the multi-binding patterns is to use the same function as used for
sink patterns, but to refactor it into also returning the final merged
expression. This is necessary because the sink pattern only checked that the
expression is destructurable, and not that the destructuring pattern used fits
the rhs expression.

This is done, but the logic down at the multi-binding branch is still very bare
bones.

By the end of the day, I started to experiment with using closed matchings in
polymorphic variants for the expression type, replacing it with a generalized
algebraic data type. This way, I can go on to more ergonomically constrain the
expected expressions in certains places without diverging into using whole
separate types.

This seems to yield ideal results when combining closed matchings in data
constructors with open matchings specific to each expression variant in type
constructors. This is still a WIP, though, and there's tons of stuff to check.

= Blockers
None.

= Plan for the week
I hope to have found and implemented a solution for ```rust sighandler_t``` by
tomorrow. I will comment on the relevant tracking issue whatever new findings I
come upon from further developing the example provided by the project
maintainer.

The compiler work on the mult-binding pattern validator is sort of on halt while
I finish the refactor. Still, it is not quite on hold because that is currently
the main corpus where I plan on testing stuff out, and where I potentially hope
to use refutation cases to avoid some impossible cases in pattern matching.
