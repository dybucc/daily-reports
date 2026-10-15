#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-14)])

#title()

= Summary
Today work has focused on two things; Chief among them has been the `ctest`
extension work, which has seen a few fixes to the new algorithm revision. Idris
work has also continued smoothly; There's some tacit pearls ready.

Efforts on the `ctest` extension started by reviewing the rest of the algorithm,
and trying to reason through the resolution strategy again. Nothing seemed
obviously out of place, so work started on tests.

Thus far, I can say there are no regressions in comparison with the first
revision of the algorithm. In terms of `super`-relative imports and absolute
imports (the two new features,) these work in the absence of cycles.

It's already been a few weeks since I spoke about cycles in `use` declarations,
so a quick refresher is in order. If two `use` declarations refer to the module
where each other appears at, then we have a cycle.

Of course, this is not strictly limited to two `use` declarations. A fairly
simple example is a one-level deep module tree with the crate root and a leaf
module. Suppose there is a `use` declaration in each of the two.

The one in the crate root glob imports the leaf's items, and so does the leaf's
with respect to the crate root. The current algorithm will resolve the imports,
but it will also increase the number of `use` declarations.

The invariant on which termination relies is that the number of `use`
declarations remains fixed once resolution starts. In other words, modules
brought over from an import need to have the subtree rooted at them cleansed of
`use` declarations.

Then, once we are deduplicating after merging, we must consider a different
approach for module items. Among duplicates, we intend on keeping the latest
snapshot we got post-merging, which currently is far from guaranteed.

So instead of blindly sorting and deduplicating by the module path, we further
take into consideration the subtrees rooted at any two given modules during
sorting. The "largest" subtree ought be the one to appear first.

This has all received an implementation today, but testing is pending. The
ordering logic is something I specially want to look at again with fresher eyes.

In terms of Idris work, the tacit train continues its course, and it really
doesn't stop. Contemplate the beauty of the following expression.

```idris
public export
interface MergedBimap ty where
  map2 : (a -> b -> c) -> ty a -> ty b -> ty c

public export
MergedBimap First where
  map2 = (. (<*>) . map (,)) . (.) . map . uncurry
```

This you may have realized is the same proposition as the one explained in a
prior report. Only that time I had decided to divide the logic into a
proposition that would combine the two functors into into a pair under it.

I was refactoring an analogous proposition to the one I showcased back then, and
decided to take on the challenge of solving it tacitly without anciliary
propositions. The only accessible propositions would be those from interfaces.

The end result is an uncurrying of the binary proposition applied over the
functor, which is set up as a map in the lhs of a partially applied composition.
Then that becomes the lhs of a now fully applied composition.

This latter composition munches through the first proof of the image under the
functor, and feeds that into an applicative that will make up a canonical
product. Then, that gets fed into the rhs of the first composition above.

The product is necessary because that is the expected input of the uncurried
first assumption; Namely, the actual mapping of a pair of images under a functor
to a single image.

This latter composition, now awaiting only the proof of the rhs' assumption, is
fed the second image under the functor. That finally sets the machinery in place
for the whole application to resolve.

= Blockers
None.

= Plan for the week
The `ctest` extension work will continue tomorrow. Today I have also posted some
comments on a relevant issue thread in `rust-lang/libc` concerning types that
suddenly become `!Send` because we changed something in the bindings.

That one is still not completely solved. Idris work will continue as per the
usual, though I've been working on a problem today that will be absolutely
delightful to showcase once it's ready. That should hopefully be tomorrow.
