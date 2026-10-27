#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-27)])

#title()

= Summary
Today work has focused on the same two things as yesterday; The `ctest`
extension work has progressed to the point where the path aggregate refactor is
almost done, and the Lean proof work has also progressed, though at a slower
pace.

The first thing that I did today was to finish up the remaining piece in my
notes about the path aggregate refactor. The only thing left for everything to
successfully typecheck was an implementation of `Extend` for `FfiItems`.

This is actually used quite pervasively throughout the code that got added in
the refactor. The idea with it is to gather back into an item container an
iterator of generic items, wrapped in the sum type that considers them all.

Thus far, I had sometimes hesitated from using that iterator because I needed
fine-grained control over the item kinds to gather back into, most commonly, a
module. Implementing this trait would allow me to do that more comfortably.

The iterator comes in with a bunch of items of no specified kind whose concrete
type we only find upon pattern-matching the terms in the sum type's injections.
`FfiItems` terms contain fields for each bucket of items, classified by kind.

The point of the trait method is to get the heavy work of partitioning a list
resulting from collecting the iterator into ordered buckets of items.

This is accomplished by sorting with a comparison function that yields orderings
based on the matched injection in the sum type of both input arguments. We then
get the partition point indices, and clone slices off of the partitioned vector.

Then I also worked on finishing up the override for additions to the path
aggregate of module items. This we had found a small flaw in late yesterday, but
that has been readily fixed in the implementation notes.

Then I finally got around to putting of all of this back into the feature
branch. There's still a bunch of unsolved errors from the refactor, but those
are unrelated to the core of the new logic.

In terms of Lean work, I've had a great deal of fun reasoning about yesterday's
problem on even natural numbers. A more complex type with which I would have
spent less time was discarded yesterday in favor of a simple type with lemmas.

See, constraining a type such that it essentially becomes a labeled dependent
product with one projection serving as proof witness and another projection
providing the object of proof, is how I would have done it in Idris.

That is also possible in Lean, but I wanted to try harder. How about a type that
is also possible to replicate in a non-dependently typed system, for which I
provide proofs of the lemmas I wouldn't need with a dependent product?

Welp, that turned out harder than expected and it has been a great ride so far.
As mentioned yesterday, my type considers two injections for which there exists
a zero and a successor to the successor of some natural.

This is not abstracted in any way, but rather defined quite literally as it is
described above. The successor only takes another term in the type and it yields
the top-level type proper.

The idea with this is that we separate the world of naturals from that of even
naturals. It is only at the intersection of both, namely, at the `OfNat` type
class instance for `EvenNat`, that we need to worry about forcing an even
natural.

Today I thus worked on a proposition that encapsulates the observation that a
given natural is said to be even if there exists some natural that is equal to
the addition of this natural with itself.

This, alongside a couple of lemmas on the parity of the zero basecase on my
custom type, have been the main object of work today. It has been slow and I
have not yet finished proving all the lemmas.

= Blockers
None.

= Plan for the week
I expect the `ctest` extension work to also continue tomorrow. I will most
likely start off by just solving all of the errors that popped up in other areas
of the codebase after the path aggregate refactor.

In terms of Lean work, I would want to spend only one more day on these proofs
because otherwise I really am going to start lagging behind in the book. The
biggest hurdle currently is properly understanding the Lean tactic language.
