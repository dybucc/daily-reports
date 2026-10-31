#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-31)])

#title()

= Summary
Today work has focused on three things and a tad bit of a third one. I went
through my weekly intercepting proxy maintenance, and continued working through
both the Hasochism paper from last weekend as well as the Lean book.

The first thing I did was to check that the intercepting proxy still worked
fine, and to tweak some of the local files I serve. This went well, so I got to
start fairly early on with the main tasks of the day.

The Hasochism paper I started taking notes on last weekend is faily interesting
in that it discusses Haskell hacks of varying degrees of funkyness to adopt a
more dependently-typed approach to programming in Haskell.

As per the usual, though, the most interesting part was not so much the paper
but the thoughts that spun in my head as I was taking notes. There's two main
highlights from that, both related to existential quantification.

I first asked myself about the involvement of existentially quantified function
domains in elaborating dependent functions. This lead to reasoning through the
totality of both dependent functions and existential quantification itself.

The second thing I thought about existential quantification was tied with its
involvement in functions when seen from the perspective of implication. My main
question lied in its interaction with intensional type theories.

I wonder whether the proposition stating that there exists some proof of
#sym.alpha from which a proof of #sym.beta can be constructured is in any way
useful in the presence of proof irrelevance, or if I'm just spouting nonsense.

Lean work had me taking more notes, and much like with the paper, asking myself
questions about the elaborator and type checker. This time I explored another
example of instance synthesis with isomorphic but unproven proof terms.

= Blockers
None.

= Plan for the week
I expect to continue working through the Hasochism paper and the Lean book
tomorrow. I've not yet reasoned through the interaction of existential
quantification with proof irrelevance, so that will be the next thing.

Lean-wise, the next thing will just be the next section. I think I already took
notes on everything that crossed my mind after reading the current section of
the book. I will probably also tweak a bit some stuff in the intercepting proxy.
