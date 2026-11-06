#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-05)])

#title()

= Summary
Today work has focused on two things; The `ctest` extension matters and the Lean
book. The former has seen great progress in the refactor I thought up yesterday
for implementing a better strategy than the path aggregate logic from last week.

I started off by reviewing yesterday's plan for the logic that would replace the
path aggregate synchronization logic. It seemed fair and nothing major has
changed from what was explained in yesterday's report.

Work then started on the parser logic refactor, in which I now use a tuple-based
state monad to carry both the current module path as well as the unique item ID.
This type is essentially the same as what is found in Lean's functor library.

Then I started implementing and have almost finished working on an
implementation of the `syn::visit::Visit` interface for the state monad. The
idea is to have the value of the monad be the item container with the parsed
items.

The implementation doesn't differ too greatly from that used with the item
container type itself, though it seems cleaner. The monad allows for delaying
all computations until I actually seed the sequencing with the parsing state.

This essentially allows me to both avoid mutating state (unlike when parsing
directly with the item container), and to scope in-place mutation in contact
with the `syn` interface to identity monads that use the actual monad's state.

The parsing also turned out to now be more straightforward, though this is still
something I have to more thoroughly check because the idea that brought this to
mind I had towards the end of the day, so chances of being wrong were higher.

Lean-wise, things have gone quite well; I kept working through more monad
problems, and have had two beautiful tacit definitions for a reader monad that
is constrained in its codomain by one of an `Option` or an `Except`.

In Lean, `Option` is a two-injection sum with the identity functor representing
one injection and the injective const functor to unit representing the other.
`Except` has two injections, both represented by the identity functor.

The reader functor itself is really just a function that carries some state
#sym.rho as the domain of the function, and yields in its domain some value
#sym.alpha. The monad magic comes in when you sequence it with itself.

For more details, it's best to read an actual manual (because I would rather not
finish today's report late.) Without further ado, here are the two pearls I came
up with as part of today's work.

```lean
abbrev ReaderOption : Type → Type → Type := (·∘ Option) ∘ (·→·)

def ReaderOption.pure : α → ReaderOption ρ α :=
open Const in
  const ∘ some

def ReaderOption.bind :
  ReaderOption ρ α       →
  (α → ReaderOption ρ β) →
  ReaderOption ρ β       :=
open Function in
  -- λs f ↦ λs' ↦ match s s' with | some x => f x s' | none => none
  -- λs f ↦ λs' ↦ s s' ≫= flip f s'
  -- λs f ↦ λs' ↦ ((·Φ·) (·≫=·) s (flip f)) s'
  -- λs f ↦ ((·Φ·) (·≫=·) s (flip f))
  -- λs ↦ ((·≫=·) Φ s) ∘ flip
  (·∘ flip) ∘ ((·≫=·) Φ·)

instance ReaderOption.Monad : Monad (ReaderOption ρ) where
  pure := pure
  bind := bind
```

```lean
abbrev ReaderExcept : Type → Type → Type → Type :=
  (·∘ (·→·)) ∘ flip (·∘·) ∘ Except

def ReaderExcept.pure : α → ReaderExcept ε ρ α :=
open Const Except in
  const ∘ ok

def ReaderExcept.bind :
  ReaderExcept ε ρ α       →
  (α → ReaderExcept ε ρ β) →
  ReaderExcept ε ρ β       :=
open Function Except in
  -- λr f ↦ λr' ↦ match r r' with | ok x => f x r' | error e => error e
  -- λr f ↦ λr' ↦ r r' ≫= flip f r'
  -- λr f ↦ uncurry (·≫=·) ∘ bimap r (flip f) ∘ dup
  -- λr ↦ uncurry (·≫=·) ⍤ (·∘ dup) ∘ bimap r ∘ flip
  (uncurry (·≫=·) ∘·) ⍤ (·∘ dup) ⍤ (·∘ flip) ∘ bimap

instance ReaderExcept.Monad : Monad (ReaderExcept ε ρ) where
  pure := pure
  bind := bind
```

The goldmine here is in the two implementations of the monadic bind operation.
This I both solved through the #sym.Phi combinator as well as a combination of
the B and B#sub([1]) combinators.

In the above code, the phoenix is encoded as the #sym.Phi greek letter, while
the bluebird and blackbird are encoded with the same glyphs as used in APL; ∘
and ⍤, respectively.

The steps I followed from #sym.eta;-expansion and subsequent
#sym.beta;-reductions are included as comments above the one-liners that define
the functions.

= Blockers
None.

= Plan for the week
I expect to continue working on the `ctest` matters throughout tomorrow and next
week. I would like to finish by this week (meaning Friday because the weekend,
as per the usual, is dedicated to other matters) the parsing refactor.

Lean-wise, work will continue as it has thus far. I've been reading up a bunch
more on combinators and have been thinking about a first serious project I would
have after finishing the book; A small APL interpreter as an embedded DSL.
