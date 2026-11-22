#import "@local/scratchpad:0.1.5": *

#show: template.with(title: [Daily report (2026-11-16)])

#title()

= Summary
Today work has focused on three things --- Finally getting over the hump that
tweaking my Neovim configuration was, and continuing work on both the `ctest`
extension matters as well as the multiway arithmetic evaluator.

The Neovim configuration still took up most of today's time. I did get to set up
all of the remaining language servers, so at least I can forget about that for a
while.

The `ctest` extension matters have barely been touched today because the
timespan in which they ended up falling in did not allow for much. Tomorrow I am
bound to come back to it in a more consistent manner.

The parser for the arithmetic evaluator did receive more attention, though this
was only because, then again, the timespan in my schedule that it ended up
falling in allowed for it.

I found out that my strategy for parsing non-delimited tokens was faulty in that
the part of the token stream that was not part of the parsed span was never
being returned. I decided to scratch the whole thing.

Instead, and remembering the wise words of #cite(<hughes-1990>, form: "author")
in @hughes-1990, I went down the point-free path. This is an attempt to both
simplify the code, and to deepen my understanding of it.

Thus far, I've finished refactoring the auxiliary functions to the literal
parsing function. The core recursive pattern I've yet to translate to a right
fold, but the idea is fairly clear so it shouldn't take long.

= Blockers
None.

= Plan for the week
I expect to actually retake my work on the codata pattern detection tomorrow.
That I believe I can finish an early implementation of by Wednesday or Thursday,
which should allow for debugging throughout the weekend (to compensate.)

Evaluator-wise, work will continue as per the usual.

#bibliography("bib.yaml")
