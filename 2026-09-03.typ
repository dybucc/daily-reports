#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-03)])

#title()

= Summary
Today work was centered around reading through the parsing chapter in the Appel
book on a compiler implementation in ML, and on further advancing work on the
`ctest` extension.

I started off by tweaking a bit the operator expression in the Typst compiler,
and starting to read through chapter 3 of the _Modern compiler implementation in
ML_ book. I wanted to understand some more LALR(1) grammars, and possibly get
some tips on both solving reduce/reduce conflicts and designing a grammar that
is primarily left-recursive.

I have almost finished the chapter, and have learnt about the exact opposite to
achieving left-recursion, which is great because reversing those steps seems
feasible. It doesn't seem to provide much insight into solving conflicts, as
those don't seem to get a lot of treatment from what I've read.

I have reached the SLR parser, but have not yet read that subsection.

In terms of rust-lang/libc work, today I opened a draft PR with the work I've
put into `ctest` for the last couple of days. I also CCed some maintainers and
connoisseurs of `ctest` to get their stance on whether I should let the users
handle item resolution conflicts or otherwise generate separate tests for each
module.

I have also worked on fixing up yesterday's implementation of filtering, as I
had missed one major thing. I was completely missing the fact that filtering
items in submodules requires keeping track of the parent path of modules to the
item until reaching the item.

That needed me refactoring the code that parses that information from `syn`'s
visitor interface, such that instead of only catching the item identifier (i.e.
the last element of the punctuated path,) we build a path up from the current
module (saved now as state on the visitor type) and any future modules until we
reach an item (where we extract the path gathered thus far.)

= Blockers
None.

= Plan for the week
Today I did not get any work done with respect to the C side of tests. Either
way, what I did today was a pre-requisite to that, so there's that. Tomorrow, I
expect to have finished working through the filtering logic, such that I can
actually yield paths that are syntactically identical to those parsed into `syn`
data structures. Currently, they're losslessly convertible in a roundtrip, but
they don't preserve the look users would expect when calling into
`TestGenerator`'s public API.

In terms of compiler work, I believe I will be done with the rest of the chapter
by tomorrow, and will then continue working on the parser and lexer. There's not
much more to comment here, except that before making any progress on the former
two, I will have to adapt some token sequences that I previously considered
expressions.
