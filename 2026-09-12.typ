#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-12)])

#title()

= Summary
Today work has focused on two things; Working through more of the Idris crash
course and solving some problems, and thinking through how to solve the `ctest`
extension stuff.

I first started off by finishing up the LSP set up on my editor to go back to
more ergonomically handling larger projects like `ctest`.

I then went on to work on some more of the Idris crash course. Thus far, I have
yet to learn interesting uses of dependent typing, but I at least have already
started solving problems from the OCaml repo in Idris.

One thing I really like about Idris is that unlike OCaml, one is forced into
delaying the definition of a scoped function or type. This means your only
option is to use recursive binding groups for all nested definitions.

Beyond that, though, Idris is annoying in one respect; Infix operators are not
introduced with some pre-defined precedence and fixity. You are forced to
provide fixity annotations, like in SML; OCaml just handles this for you.

In terms of `ctest` work, I have thus far only taken notes on how should I solve
the current issue with reexports. From that, I gathered that there are two
usecases; Filtering and item resolution in generated tests.

Basically, if downstream users set up a skip through our public callbacks and
match on a reexported item path, we don't have a way to hit the affected item.
This can be solved by parsing reexports, and gathering "synonyms" for paths.

Parsing reexports is fairly simple, but gathering those synonyms to add them to
the set of paths with which an item can be referred to is non-trivial. A second
pass over all parsed ```rust FfiItems``` may not be enough.

Item resolution in the generated Rust tests is not something I am really
concerned by. We already generate tests for private items by default, which is a
bit of a mistery to me as I started thinking about it.

Implementing the second pass is going to be rather complex. I would have to
account for other modules introduced through prior reexports, which further
complicates stuff. I may look into some library that implements path resolution.

= Blockers
None.

= Plan for the week
The `ctest` work I will continue iterating on tomorrow. Recently, I learnt I
would better spend my time thinking through an implementation plan, than
attempting to come up with it on the go straight in code.

In terms of side-project work, I will continue working through the Idris crash
course, which I believe I will most definitely not be finishing this week. No
matter. I will continue with it next week.
