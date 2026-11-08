#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-07)])

#title()

= Summary
Today work has focused on two things and a bit of a third one; I've continued
working through the Lean problem on the arithmetic evaluator, and have also made
progress on the Haskell course I started last weekend.

The Lean book work has been slow but that's been because I woke up and decided
to give myself a shot at encoding in Lean the Yoneda isomorphism (or rather,
one-to-one correspondence) from the Yoneda lemma in category theory.

That took a while because I was basing myself off of the way it's defined in
Haskell, which always has an implicit universal quantifier prepended to all
terms in an equation. Lean's flexibility seemed to make it impossible.

I thought of changing my approach into a less data-based approach that operates
on non-dependent functions, but then realized that if the data-level
construction makes sense in Haskell then surely I can do the same in Lean.

After struggling a bit more, I finally got to encode the #sym.phi and #sym.psi
functions in the isomorphism. I then attempted to prove a lemma about this but
realized that they aren't propositions proper so that was a no-go.

```lean
def φ [Functor 𝔽] : (∀X, (A → X) → 𝔽 X) → 𝔽 A :=
  λα ↦ α A id

def ψ [Functor 𝔽] : 𝔽 A → (A → X) → 𝔽 X :=
  λ𝔽 α ↦ α <$> 𝔽
```

I couldn't quite solve the quantification constraints without spending a bit too
much time on it, so I decided to leave the point-ful definitions as-is.

Afterwards, I got to finish the initial implementation of the arithmetic
evaluator that I explained yesterday. I noticed that we could altogether make
the code cleaner if the interpreter didn't expect both a monad and a handler.

The implementation as presented in the section (or at least as I remeber it from
two days ago) expected the interpreter to get a handler function for the
specific subset of operations that a monad may consider failure cases for.

I instead thought that I could get the monad to also be the handler from the
get-go, by defining a new type class that extends the `Monad` type class with
methods for each one of the operations the interpreter supports.

This also got at the fact I wasn't convinced that the interpreter should only
delegate a subset of operations to the monad. Just give them all to the monad,
and have default (`pure`) definitions for each of the type class methods.

I also got to define instances for a couple of common monads I remember from the
book. The next step should be to implement the "choose" operator I mentioned
yesterday, to allow state exploration of multiple branches in an expression.

Haskell-wise, things have gone well. I have finished reading through the
material for the first lecture of the course and have since moved on to solving
the problems.

These are fairly interesting in that, at least for my current level of Haskell
knowledge, they provide a good challenge. Though for now there's nothing else to
highlight.

I also went through the usual weekend proxy server maintenance, and have gotten
to tweak some of the files I serve locally.

= Blockers
None.

= Plan for the week
I expect to also tweak some more stuff from the intercepting proxy tomorrow,
though much like today, it will be small. Lean and Haskell work takes priority,
and will continue in the same fashion as it has thus far.
