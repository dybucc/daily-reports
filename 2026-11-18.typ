#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-18)])

#title()

= Summary
Today work has focused on two things --- The `ctest` extension matters and the
arithmetic evaluator. Both of them have seen very slow progress as a consequence
of the proofs of boolean equality (resp. excluded middle) taking quite long.

On the `ctest` side of things, I've been busy proving reflexivity of boolean
equality between items. This followed up from yesterday's attempts, but I've yet
to finish the proof because case analysis is proving harder than expected.

See, as it is currently structured, the proof tackles the proposition by
considering both the possibility for boolean equality on definitionally equal
inputs to yield data-level truth and falsehood.

The case for truth trivially holds for that reduces to definitionally equal
terms on the data-level boolean type. The case for falsehood still expects me to
prove the same proposition but now with a proof of falsehood in the context.

I would guess that here I'm meant to proceed by contradiction, such that I may
use the proof of falsehood to prove the "truthyness" of the statement. This I've
yet to find success in, or to even confirm is the right approach.

Evaluator-wise, things have gone quite similarly, though possibly worse. I have
nothing new compared to yesterday's proof of the principle of excluded middle
from the double-negation elimination theorem.

I've spent quite a bit of time writing and rewriting different arguments in
prose I had for the proof, alongside attempts at them. None of these cleared up
my mind as to how do I conjure a proof of double negation on some proposition.

See, the authors of the theorem proving book motivate readers to try this as an
exercise, but that's not part of the chapter's problem set. Just to check
whether it was a skill issue on my side, I tried my hand at those problems.

Thus far, I've only solved those that use constructivist concepts, but I can
definitely say they are far easier. Either I'm terribly missing something from
the principle of excluded middle, or the authors really did mean "try."

= Blockers
None.

= Plan for the week
I will continue solving the problems in the theorem proving book before moving
on with any other task. I hope to either reach the point where I actually have
an idea of what is it that I'm supposed to do, both `ctest`- and evaluator-wise.
