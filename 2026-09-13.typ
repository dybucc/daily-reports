#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-13)])

#title()

= Summary
Today work has focused on two things; Solving more problems in Idris while
reading through the crash course, and working out some initial implementation
ideas for the `ctest` extension work.

Thus far, I have progressed some more in the Idris crash course, and have
finished up solving more problems from the OCaml repo. I have started finding
some interesting uses of dependent typing.

Presently, though, it seems like most new ideas that prove to the type checker
that, say, my list splitting routine is correct, require a new type. Granted,
one can base themselves off of an existing type, but I'm not yet used to it.

I have had great success in encoding size invariants through vectors (which are
akin to lists but, in the dependently-typed lingo, are "indexed" by a natural
type parameter,) and to some extent, proving right some routines.

On the `ctest` side of things, I have thought through some more stuff in my
attempts to extend the test harness with support for modules. This time, I have
drafted the implementation for the algorithm to perform secondary passes.

As commented yesterday, I eventually settled that I would need to implement some
form of crate-wide item resolution mechanism. Today I have attempted thinking
about this in terms of recursively inlining items as reexports are found.

The idea is that once initial parsing is done, and we have packed up all our
items in an ```rust FfiItems``` instance, the "second" pass starts by checking
whether we have _resolvable_ or _unresolvable_ reexports.

We determine _resolvable_ reexports as being those for which we can find an
arbitrarily-nested item path from the present module down its child modules.

If we find a reexport that refers to an item implicitly introduced by another
reexport of a child module of the present module, we tag it as _unresolvable_.
These we do not yet have enough information to compute the source module of.

Then we recursively run this pass on every child module that we find involved in
a reexport. The base case of the recurrence relation is defined by a module with
no containing reexports.

At that point, we simply return, and the immediate call that triggered that pass
(on the parent module), parses anew all items in the child module to add them
back to the set of items in the parent module.

I have yet to think through some finer details of reexports that refer to child
modules of child modules and eventually reexport back to a super module of a
super module, but those do not seem to require too much state across calls.

Once all recursive calls to this pass are resolved (i.e. once we are back to the
top-level module,) we can start to scan anew the top-level module for unresolved
modules. If any are found, we search among the possibly new items in the module.

= Blockers
None.

= Plan for the week
The proposed algorithm is far from ideal in terms of how many copies I will
require of the same set of data structures. Nevertheless, I would want to first
have something feasible, and then try out implementing it. Efficiency can wait.

In terms of side-project work, the plan continues as set since last week;
Continue working through the Idris crash course and solve problems. Then I will
move on to working through the tutorial, to get some more in-depth explanations.
