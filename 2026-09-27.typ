#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-27)])

#title()

= Summary
Today work has focused on two things; Moving the Rust port further along, and
continuing work on the second revision of the algorithm. Unfortunately, though
as predicted, the deadline for the latter goal has not been met.

In terms of Rust work, a few things have been completed today; The
single-reexport resolution proposition has been mostly fully proofed, and the
type used for resolution has been refactored into having a simpler structure.

The ideas considered yesterday for the rename case of the single-reexport
proposition have been expanded upon today. This case requires there being a full
subtree path rewriting to yield a coherent item when the item is a module.

Beyond that, though, all other cases have already been proofed. There has been a
new proposition added to those grouped by the item container type. This
proposition implies a coproduct of const and identity functor for searching.

The searching proof yields an item from the item container that is either found
(and thus uses the identity functor) or not found (and thus uses the const
functor.) This is used when looking up a name in the resolution running state.

The resolution running state is, as commented in prior reports, the module that
either carried the source reexport (during the first iteration,) or the module
corresponding with the last munched segment of the reexport's path.

The rename case, which had been anticipated to require further work yesterday,
turned out to require more work than expected. This has not yet been completed,
but notes have been taken with respect to a proposition for it.

The proposition would take an identifier with which to rename the last segment
of the passed module. Then it would recurse through all child modules, rewriting
the same segment of their path, corresponding to the ancestor's old identifier.

The resolution type has been simplified into having two injections, one of which
is now only representative of the const functor. This was good enough for
representing unresolved reexports, because they only indicate non-removal.

In terms of proof work on the second revision of the algorithm, this has moved
along slowly. The only exercised change has been a completion of the proof for
the module update proposition. The rest has all been note-taking.

The module update proposition is used in the resolution driver everytime a full
resolution pass is performed over it, and before diffing it to determine whether
termination should take place. It integrates the updated module into the state.

This needed the same type of refactoring as yesterday's item seeking proposition
within a module. All other work focused on rethinking the algorithm, as I had
started coming up with counterexamples that made the second revision useless.

To avoid spending too much time in the multiple iterations those notes took, a
summary will be provided. The summary reflects the general idea about why the
second revision of the algorithm does not solve bidirectional reexports.

In the general case, one can expect there to be a super reexport to some
ancestor module, which itself has a forward reexport to some child module.
Suppose these pairs of reexports do not form a cycle.

The second revision of the algorithm would gladly resolve and remove the super
reexport, even though it would miss the contents of the forward reexport. If
chosen to be resolved the other way around, one finds a satisfiable solution.

But merely separating the passes that resolve forward from super reexports, and
inverting the order in which one or the other runs is not enough. Another
counterexample follows for which the above solution does not work.

Suppose the root module has a forward reexport of some grandchild module's
items, and some child module contains a super reexport of the root module's
items. Resolving the latter first would miss on the grandchild module's items.

= Blockers
None.

= Plan for the week
Work on the proof will halt for the next week as time will instead be spent on
working through the Idris community tutorial. Ideally, working through the book
afterwards would be ideal, but that may very well not end up happenning.

Either way, the Rust efforts will continue implementing the port of the first
revision of the algorithm, which even though not supporting super reexports, is
known to work (from the tests and proofs ran on the Idris program.)
