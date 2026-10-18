#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-18)])

#title()

= Summary
Today work has focused on finishing up the intercepting proxy stuff and on
exploring Lean as a more community-wise active alternative to Idris. I also took
a look at Haskell.

I started off by working through what was left of the intercepting proxy stuff.
The local files I intended on manipulating are ready, and the server now serves
successfully everytime I execute the mitmproxy binary.

Later on, I continued with the Idris blog post, but halfway through it I decided
to git Haskell a try. That turned out quite badly because one easily notices how
Haskell language extensions are far from being native to the language.

For starters, stuff like type inference of record field selectors just doesn't
work. There's a bunch of extensions to make it seem like it works until you
really need it. Then you need separate propositions for different projections.

The reason why I was looking out for some language other than Idris was that the
Idris errors are just not quite there. Sometimes it's really cryptic to even
start wondering why does something fail to typecheck.

That, and the fact dependent Haskell seems to be stalled, prompted me to go take
another look at Lean. I've been working through the Number Theory Game, and have
started reading and solving problems from a book on Lean.

Eventually, I would like to read through and solve the problems in the Lean
theorem prover book, as that one does introduce more formal notions. One thing I
saw I was lacking in Idris is more native infrastructure for proof tactics.

Beyond that, I gave an initial spin to a Neovim plugin for centering the buffer
in the screen, but this didn't turn out quite too well. The initial
implementation attempted to use Neovim extended marks.

Issues arose when I realized inline extended marks, which cause the actual text
in the buffer to shift, require taking up actual space in the buffer. And this
doesn't quite shift the sign column and color columns.

= Blockers
None.

= Plan for the week
The `ctest` extension work will resume tomorrow. The new algorithm will be
further explored then, and the codata pattern detection will likely receive an
implementation this week.

I am likely to continue solving problems in Lean, as it seems to be more
ergonomic and lets me focus more on the proof. And yet it also doubles as a pure
functional language, so thus far it seems like the natural way forward.

I will ensure that during later weekends I always check that the intercepting
proxy continues to work as expected. That should serve as a fairly alright
maintenance window.
