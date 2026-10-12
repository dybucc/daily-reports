#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-12)])

#title()

#html.blockquote[Today my wrtiting style changes again. Yesterday's Idris
  example made me realize that tacit style of writing is considerably harder to
  use than tacit code expressions.

  So we're taking a few things from tacit and going back to using the first
  person.]

= Summary
Today work has focused on two things; The `ctest` extension stuff, and to a
considerably smaller extent, the Idris work. It has been a messy day. The
`ctest` extension work ended up taking more time than expected.

Work actually started by continuing the Idris community tutorial. Then again,
this went on at a snail's pace but tacitness is enforced whenever possible. I
have found that there are, indeed, cases where tacitness is impossible.

One such case is the interface implementation proof for `Functor` on some
coproduct with some number of injections greater than one. One is forced into
matching on the data constructor of the type no matter what.

This is unfortunate, but I have yet to read through the Bird-Meertens formalism
papers. According to the Haskell wiki, that is one interesting piece of
literature treating tacitness implicitly (pun not intended.)

Other work sessions concerning Idris work ended up with me refactoring prior
proofs into a point-free style. One such beautiful example is the following. It
is a logical #smallcaps[and] of two predicates.

```idris
namespace Or
  foo : (Integer -> Bool) -> (Integer -> Bool) -> Integer -> Bool
  foo = \f => \g => \x => f x || g x

  foo' : (Integer -> Bool) -> (Integer -> Bool) -> Integer -> Bool
  foo' = \f => \g => \x => (||) (f x) (g x)

  foo'' : (Integer -> Bool) -> (Integer -> Bool) -> Integer -> Bool
  foo'' = \f => \g => \x => uncurry (||) $ (bimap f (delay . g) (x, x))

  foo''' : (Integer -> Bool) -> (Integer -> Bool) -> Integer -> Bool
  foo''' = \f => \g => \x => uncurry (||) $ (bimap f (delay . g) (dup x))

  foo'''' : (Integer -> Bool) -> (Integer -> Bool) -> Integer -> Bool
  foo'''' = \f => \g => uncurry (||) . (bimap f (delay . g)) . dup

  foo''''' : (Integer -> Bool) -> (Integer -> Bool) -> Integer -> Bool
  foo''''' = \f => (uncurry (||) .) . (. dup) . bimap f . (delay .)

  foo'''''' : (Integer -> Bool) -> (Integer -> Bool) -> Integer -> Bool
  foo'''''' = ((uncurry (||) .) .) . (. dup) .: (. (delay .)) . bimap

public export
or : (Integer -> Bool) -> (Integer -> Bool) -> Integer -> Bool
or = (uncurry (||) .) .: (. dup) .: (. (delay .)) . bimap
```

As yesterday, the end result is the or proposition. Its proof is a slight
rewriting of the proof for the final iteration (`foo''''''`.) The namespace
serves to scope scratch attempts at eta-abstraction and subsequent reductions.

The proposition starts with an application of the blackbird operator. That takes
as its binary proposition a composition of a `Bifunctor`'s map and a nested
composition that wraps one predicate's implication as a lazy value.

The lazy value is an unfortunate consequence of the fact Idris is eagerly
evaluated. And yet its boolean operators are short-circuiting; That is done by
means of the special `Lazy` type. The delay proposition builds such type.

The idea is to duplicate the proof of the predicates' assumptions (the third
parameter) such that it is now a pair. A pair is a product with two projections
on the identity functors. It also happens to be a bifunctor.

That means both predicates can be applied to the bifunctor mapping, which
expects two predicates; One for each of the values in the bifunctor. That is the
whole point of the right hand side of the composition (up to the last `.:`.)

Then comes the duplication of the predicates' assumption's proof through `dup`.
All of this looks more obfuscated than it actually is because it has to be made
into a single proposition that is equivalent to the or proposition.

The last thing ends up being the uncurrying of the actual #smallcaps[or]
operator. That is necessary so that its proposition goes from assuming two
booleans, to assuming a single pair of booleans.

In terms of Rust work, yesterday a new algorithm for use declaration resolution
had been devised. This actually seemed to work quite nicely, and a WIP
implementation had even started. Today I have finished that implementation.

A lot of the components from the first revision of the algorithm have been
reused. The whole thing is now on hold, as I go through the algorithm again by
taking some notes on how I think it should proceed.

Beyond that, there is not much to add. A few things were refactored in the
single-`use` resolution proposition, and now it is both simpler to grok and uses
fewer macros (they were all just specialized versions of another one.)

The merging proposition was also pending some changes. The original `use`
declaration that was packed alongside a resolved item is not necessary anymore.
`use` declarations are not removed in this version of the algorithm.

That also prompted me to refactor the type used for resolution items. These are
the ones that actually hold the container with the item(s) to which the `use`
declaration resolved. It also contained the above use declaration.

Another big thing was documentation. Multiple core propositions and all of the
helper propositions (the "lemmas" if these were actual proofs) were missing
documentation comments. Now everything is documented.

= Blockers
None.

= Plan for the week
The part of the `ctest` extension work concerning use declaration resolution
seems to be nearing its end. Granted, this algorithm could turn out to be
completely incorrect, but something tells me that is not going to be the case.

Either way, the afore mentioned review over it will continue tomorrow. Once that
is done, testing will follow. The Idris work will continue as usual. This is the
last week before I have to move on from the community tutorial.
