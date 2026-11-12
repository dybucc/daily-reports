#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-11)])

#title()

= Summary
Today work has focused on two things; Attempting to solve the thing I believe to
be the issue of resolution failure in the `ctest` PR, and working some more
through the parser for the Lean evaluator.

I started off by looking into the resolution strategy in whole, and essentially
getting back to the mindset from two weeks ago. I remembered the strategy that I
had thought up back then concerning codata, and started working on it.

The issue at present lies in imports of items from ascendant modules to the one
where the `use` declaration appears at. Those will nest this latter module
within itself, which causes non-termination because larger trees are preferred.

The solution I thought I had found two weeks ago consisted of detecting this
codata pattern and removing it as soon as it was detected. That's been the focus
of today's work, though I've taken a different approach than usual.

Instead of working straight in Rust, I decided to model the minimum requirements
for solving this particular problem in Haskell. This has proven to require a
bunch of extra logic for handling stuff that I already did in Rust.

Still, the idea seems solid. For any given module, we try to find all
occurrences of itself within its subtree, and select the first two. If there are
fewer than two occurrences, then there's no codata (yet.)

Then we check if the path in the module tree between the module with which we
are called and each of the two occurrences match. This I've yet to think through
some more, but, to a first approximation, I think it's feasible.

Lean-wise, I've worked through a bunch of stuff concerned with the parsing logic
for the evaluator, but this has been mostly slow work. I was doubting between
separating lexing and parsing logic, but decided against it.

I've implemented the logic for both delimited sequences, as well as literals,
but the parsing entry-point is still not finished. I expect I will have to first
think about the monad I want to keep that state in.

Halfway through that, I started getting a bunch of errors from the Lean compiler
that made no sense. Simple list mappings failed to typecheck even though there
were no apparent issues. Unification was failing to solve metavariables.

= Blockers
None.

= Plan for the week
I expect to continue working on the `ctest` extension matters tomorrow. I still
have to set up some more of the analogous types in the Haskell program, but that
shouldn't take long. I hope to have more leeway to think clearly in Haskell.

Lean-wise, work will continue as per the usual.
