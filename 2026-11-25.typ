#import "@local/scratchpad:0.1.5": *

#show: template.with(title: [Daily report (2026-11-25)])

#title()

= Summary
Today work has all been handwritten. This is due to the fact I needed to clear
up my thoughts on codata detection on the `ctest` side of things. I also believe
this should enable me to avoid useless time sinks like editor configurations.

The codata detection algorithm I believe may be incorrect. I've finished the day
tracing through what I think is a counterexample for which the current
implementation will not halt. But using pen and paper takes considerably longer.

Lean-wise, I have essentially done the same thing --- Verify if I could find a
more beautiful approach to a tacit solution and re-solve the ones I had already
come up with in pen and paper, with what I believe to be extensive commentary.

I can highlight one tacit pearl I came up with while going through a problem.
This I think is beautiful because it is a `Type`-monomorphic function that
constructs the type of the reader monad's environment tacitly.

```lean
example : (Type → Type) → (Type → Type → Type) → Type → Type → Type :=
open Function Bifunctor in
  ((·∘ uncurry (·→·) ∘ snd (uncurry (·→·) ∘ dup) ∘ dup) ∘·) ⍤ (·⍤·)
```

The type of the environment on the reader is an association list of strings and
monormorphic binary functions over `Int`s. The above function essentially
constructs the type itself (not a term in the type) to be used in another type.

The result of an application such as `f List Prod String Int` is
`List (String × (Int → Int → Int))`. The beauty of this comes from the fact it's
mostly just an elimination rule over the B#sub[1] combinator (the blackbird).

= Blockers
None.

= Plan for the week
I hope to have concluded my investigation into the current workings of the
codata detection algorithm tomorrow. It could be I will not, which really would
be for the best if it turns out to be wrong.

Lean-wise, work will continue as per the usual. Pen and paper are considerably
slower but I hope to keep a more steady pace of work (without as many
timesinks), at the cost of slower speed.
