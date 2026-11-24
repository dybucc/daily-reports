#import "@local/scratchpad:0.1.5": *

#show: template.with(title: [Daily report (2026-11-24)])

#title()

= Summary
Today work has focused on the `ctest` extension matters and on the Lean problem
set for the next section in the chapter on monads. I've made progress on both
fronts, though most notably, I've gotten codata detection working.

On the `ctest` side of things, I've finished debugging the codata detection
algorithm. This has meant that I have finished working on most of the
implementation, and now only the marking of items remains.

I remember not what exactly was it that I was missing in my prior implementation
but now it's complete and it behaves as specified. This is concerned with both
detection and removal --- Tests that previously didn't terminate now do.

Item marking is concerned with keeping track of which items are part of modules
where codata was detected. This is so that, at filter time, we can ensure any
codata-pattern-matched path that refers to such item is accepted in skips.

This has also gone fairly well in that the I've already got a pretty good idea
of what I intend on implementing. For any given item within a module where
codata was detected, there's a simple regex that models the codata pattern.

In other words, if some item `Bar` exists within some module where codata was
detected in, say, module `foo`, then `Bar` may be referred to as, among others,
`<ancestor-path>::foo::Bar` or `<ancestor-path>::foo::foo::Bar`.

For more complex cases where there exists some larger graph path between the
module where codata was detected in, and the item proper, we must keep track of
one more thing --- The graph path from the codata module to the item's parent.

This graph path is the same as the one computed during codata detection
previously. All of the work involved in fetching that information is quite
cheap, though for now, we're keeping owned data to it.

Lean-wise, things have also gone quite well, though the speed of work has been
slower than the `ctest` extension stuff. This time I've worked through the
problems in the section on `do`-notation for monads.

I was miserably going through a problem that asked to transform a prior problem
solved through monadic combinators into using `do`-notation. This essentially
means making the code "clearer" at the cost of making it look imperative.

So I instead decided to make it all tacit. This I've not yet finished but it's
feasible and I've already gone through most of the problem. Following I leave
some delightful tacit pearls, often stemming from implementing monadic bind.

```lean
abbrev Reader : (ρ α : Type) → Type := (·→·)

def Reader.monadicBind : Reader ρ α → (α → Reader ρ β) → Reader ρ β :=
open Function Prod in
  -- λr ↦ λf ↦ λs ↦ f (r s) s
  -- λr ↦ λf ↦ uncurry f ∘ fst r ∘ dup
  -- λr ↦ (·∘ fst r ∘ dup) ∘ uncurry
  -- (·∘ uncurry) ∘ flip (·∘·) ∘ (·∘ dup) ∘ fst
  uncurry (·∑·) ⍤ swap ⍤ (·,·)
```

The above is an implementation of monadic bind for a well-known monad --- The
reader. This is essentially a monad that carries state in the form of a
continuation by simply being a type alias to a polymorphic function type.

I've left in the comments where I showcase the "steps" followed while getting
rid of each point (parameter) to the function. The beauty in this example I see
from the use of the #sym.sum combinator, also known as the violet scarling.

Before the line where it is used, I've also left the definition that does not
use this combinator. It just so happened that I looked twice at the function
abstraction (the initial comment,) and thought this surely was a known pattern.

Application of a binary function over a nullary function and a unary function
that is itself applied over the nullary function is known in combinatory logic
as the #sym.sum combinator. #acite(<smullyan-1985>) calls it the violet
starling.

The next tacit pearl is a more heavy-weight example that I won't provide much
explanation for because I'm running out of time for today's report and because
"you just have to see it".

```lean
abbrev Env : Type := List (String × (Int → Int → Int))
def read : Reader ρ ρ := id

example : String → (x y : Int) → Reader Env Int :=
open Reader List Function in
  -- λop ↦ λx ↦ λy ↦
  --   read ≫= λenv ↦
  --     Option.elim (lookup op env) (pure 0) λf ↦ pure $ f x y
  -- λop ↦
  --   (read ≫=·)
  --     ⍤ (·∘ lookup op)
  --       ⍤ flip (flip Option.elim (monadicPure 0))
  --         ⍤ (·∘ uncurry)
  --           ⍤ (monadicPure ∘·)
  --             ⍤ flip apply
  --               ⍤ (·,·)
  ((read ≫=·) ⍤·)
    ∘ (·⍤ flip (flip Option.elim (pure 0))
      ⍤ (·∘ uncurry)
        ⍤ (pure ∘·)
          ⍤ flip apply
            ⍤ (·,·))
      ∘ flip (·∘·)
        ∘ lookup
```

= Blockers
None.

= Plan for the week
I expect to continue working on the item marking stuff tomorrow. If I complete
this and run a few more successful tests, we could very well be calling it a day
in a couple of weeks. The end of this long-winded PR may be nigh.

Lean-wise, work will continue as per the usual.

#bibliography("bib.yaml")
