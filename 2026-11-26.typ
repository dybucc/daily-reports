#import "@local/scratchpad:0.1.5": *

#show: template.with(title: [Daily report (2026-11-26)])

#title()

= Summary
Today work has focused on two things --- The `ctest` extension matters, and more
problems from the chapter on monads on the Lean side of things. This time I can
say `ctest` matters have not gone as well as Lean matters.

Yesterday I started tracing through what I intuited could be a counterexample
that would prove the incorrectness of the codata detection algorithm. This I
have not made much progress today on.

I started off by coming up with a small DSL for declaratively describing the
states of the module tree at each step of the resolution strategy. The DSL was
necessary because drawing trees out in pen and paper proved inaccurate.

This went fairly well until I started using it to trace the counterexample.
After a few resolution passes, the declarative descriptions were taking up
multiple US letter pages in my notebook. It was unsustainable.

So I instead thought of writing a program that would generate those for me. The
solution I've settled for uses the `termtree` library to draw trees in the
terminal. This I've yet to to hook into the resolution entry point.

I also considered Graphviz and writing a WASM plugin for Typst, but both of
those comparatively seemed like huge time sinks.

Lean-wise, things have gone quite well as I've both finished solving in pen and
paper all of the tacit solutions I wrote in front of the computer, and have
additionally finished more of the point-free conversion from the latest problem.

Following I leave one beautiful tacit pearl that I would love to provide the
same commentary as I handwrote, but that I can't provide because I don't have
time now to find some OCR software to scan my writings.

```lean
example : String → Int → Int → Env → Except String Int :=
open Function List Except in
  uncurry (·⍤·)
    ∘ bimap
      (flip (·∘·) ∘ lookup)
      ((·⍤ (·∘ uncurry) ⍤ (pure ∘·) ⍤ flip apply ⍤ (·,·))
        ∘ flip ∘ flip Option.elim ∘ error ∘ ("op not found: " ++·))
      ∘ dup
```

This I can not provide much context on beyond the fact it was part of one of the
monad problems. This one involves the `ReaderExcept` monad, which specializes
the `Reader` monad with a codomain lifted through the `Except` functor.

The `Except` functor is, for all intents and purposes, equivalent to the
canonical coproduct universal construction, which we also find in Lean as the
`Sum` type and in other languages as the `Either` type.

The function essentially looks up the token (`String`) found during parsing in
the read-only environment provided by the reader monad (`Env`), and uses the
`Option` monad's elimination rule to perform an operation on `Int`s or report
failure.

The beauty of this comes from the fact the "embellished" signature may not come
off as immediately equivalent to the above if we do not take note of the
isomorphism between higher order functions as codomain and curried functions.

```lean
example : String → Int → Int → ReaderExcept Env String Int
```

There's also the fact the eliminations after #sym.eta;-expanding the initial
form map very naturally to subsequent partial applications of both the bluebird
and the blackbird (the B and B#sub[1] combinators.)

= Blockers
None.

= Plan for the week
I've already started writing the plumbing code to hook the tree pretty printing
for tracing the counterexample, but I've also noticed that I had another pending
refactor with unsolved spurious errors. We'll see how that goes.

Lean-wise, work will continue as per the usual.
