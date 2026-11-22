#import "@local/scratchpad:0.1.5": *

#show: template.with(title: [Daily report (2026-11-20)])

#title()

= Summary
Today work has focused on implementing an initial version of the codata
detection algorithm as part of the `ctest` extension matters, and on continuing
the problems in the Lean book (not the one on theorem proving.)

I started off by giving some more thought to the last proof that remained from
yesterday's work on the Lean theorem proving book. This I couldn't figure out
after a while of trying my hand at different approaches, so I let it be for now.

Then I went on to work on the `ctest` extension matters, which I have almost
finished. The implementation for the codata pattern detection algorithm is done
but I've yet to debug it. The idea is as explained in early reports this week.

Lean-wise, I've been reorganizing the project where I was hosting solutions to
the functional programming book. The goal was to find out where the implicit
coercions and instance search were defined, so as to remove them.

Then I went on to implement the contents of the practical example in the chapter
on monads. This is what took up the last two weeks' worth of Lean work because I
had obssesed over writing my own, more generic evaluator.

Following yesterday's goals, I've been avoiding unnecessary work, and just
focusing on the requirements of the problem at hand. I originally started that
work to make one of the monad problems harder, but it's one huge time sink.

I don't think it will take long for me to finish the problems in that chapter.
My outlook for them was to take over a month, but I will probably finish them by
this weekend because the problem requirements are fairly simple.

= Blockers
None. Today I had to write the report earlier than usual because I've got some
stuff to deal with in the evening.

= Plan for the week
I expect to start debugging the codata detection algorithm tomorrow. I hope it
won't take long to either prove the whole approach is wrong, or otherwise get a
lead on what I should change.

Lean-wise, work will continue as the per the usual. I hope to finish the
functional programming book halfway through next month, and continue the theorem
proving book by late December.
