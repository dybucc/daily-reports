#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-08-27)])

#title()

= Summary
Today work has focused on finishing an initial "stable" release for this page
(the one for daily reports,) and on further continuing work on the Typst
compiler.

Yesterday I had almost finished work on the page associated with the repo where
these reports (now) get published at. The only thing left was to have some
messed up Just recipes fixed, so that the files actully got properly compiled.

This was an easy fix. I then added caching support for the Typst compiler
version and `ripgrep`, so that I could speed up the CI runs. This was fairly
straightforward to set up with the "built-in" GitHub Actions action.

Then I worked on brushing up some stuff that was left on the repo, mostly
related to the README and LICENSE files. Then I tweaked some the `justfile` so
as to wire up all dependencies between lazy expressions and recipes.

The site is now deployed, and I have rebased `main` to reflect only a single
commit with all the changes up to the "stable" release. The prior commit history
is kept in a separate branch for posterity on the timestamps of the first two
daily reports.

Work on the Typst compiler has progressed at the expected pace for today's task.
I have been working on the let-binding analyzer, which should provide a query
for Menhir semantic actions to call into and ensure basic (dumb) bindings that
use some form of pattern are catched at parse time.

This initially consisted of a few nested recursive functions that interleaved
their execution to sort out all expressions that I can interpret in-place (i.e.
anything that doesn't require a compilation context, like identifiers or
callables.)

Then I tweaked that some to instead filter on certain "literal" expressions that
I can merge in code blocks. This way, if at parse time I find any expresion on
the right hand side of a let-binding that requires compilation context, I simply
bail out early.

This is still going to require some more thought, though, and I am very much
inclined to end up not using it. I don't think it's worth it to do a half-assed
job at evaluation during parse time, if I can't resolve all expressions then.
Leaving that out for later is likely the best way out.

= Blockers
None. Today I missed a few hours of work in the morning, but I don't think I
lost them. I got the chance to try and explain to somebody my conclusions from
studying basic universal constructions in category theory (initial and terminal
objects, products and coproducts.)

= Plan for the week
The site is done. That means I can go back to working on rust-lang/libc, as I've
received a bunch of notifications there from GitHub PRs and issues I'm involved
in. That should start taking up the time I spent on the site for the last three
days.

The current work on the compiler will be finished but will likely not be used.
As mentioned in today's summary, I'm fairly confident partial evaluation is not
worth it here. But I want to finnish exploring that implementation to get a
better feel once I start working on the evaluator (and once I have a proper
compilation context available.)
