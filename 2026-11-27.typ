#import "@local/scratchpad:0.1.5": *

#show: template.with(title: [Daily report (2026-11-27)])

#title()

= Summary
Today work has focused on two things --- The `ctest` extension matters to prove
the codata detection algorithm wrong, and the Lean problems to solve more stuff
tacitly. The latter has left me some tacit pearls.

Yesterday's plan to set up the tree pretty printing to trace through what I
believed was a counterexample went well. I found out the algorithm for detecting
nested occurrences of a module within its subtree was wrong.

This prompted to think about both alternative resolution algorithms, as well as
possible solutions for fixing the codata detection algorithm. The latter I was
really fuzzy on so I couldn't make much progress on that side.

I have thought about an interpretation of the use declaration resolution problem
in terms of solving SMT solver constraints. This I do not have time today to
explain but I will likely report on it this weekend.

Lean-wise, work has gone fairly well. I've had the delight to finish the
function for case analysis of two inductive types for which it seemed like
point-free solutions were not possible.

```lean
inductive Expr' (α : Type) : Type where
  | const : Int → Expr' α
  | expr : Expr' α → Expr' α → α → Expr' α

example : Expr' α → (Int → β) → (Expr' α → Expr' α → α → β) → β :=
open Function in
  λe : Expr' α ↦
    match e with
    | .const x => const _ ∘ flip apply x
    | .expr e1 e2 op =>
      flip apply op ⍤ flip apply e2 ⍤ flip apply e1 ⍤ flip (const _)
```

The above is a function for performing all areas of case analysis itself, except
for, of course, matching on the inductive type, be itself in point-free style. I
have another tacit pearl that I haven't had time to transcribe.

= Blockers
None.

= Plan for the week
I expect to continue working on the `ctest` extension matters this weekend. If
the idea I got about using natural deduction in the style of SMTs goes well, we
may very well have to redo the whole resolution algorithm.

Lean-wise, I expect stuff will go on as it has thus far. I really wanted to
showcase the other tacit pearl today but I started writing today's report later
than usual. That will have to wait until tomorrow.
