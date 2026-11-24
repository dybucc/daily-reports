#import "@local/scratchpad:0.1.5": *

#show: template.with(title: [Daily report (2026-11-23)])

#title()

= Summary
Today work has focused on two things and quite a bit of a third --- The `ctest`
extension matters I've had some fair degree of success in debugging, the Lean
problems have finally seen some progress, and I've wasted time on Emacs.

The day started by optimistically giving Emacs another try to see if I could
potentially make something out of the "ideal" Common Lisp development
environment. This essentially meant I spent a fair bit of time on that. Again.

But once I realized it was a no-go to attempt that with the type of other
responsibilities I have, I finally went back to the `ctest` extension matters.
Here I had to start testing out the codata detection algorithm.

Thus far, I've not fixed that many bugs, and I'm currently pondering at how come
the function that cleanses the nested occurrences of a module off of its subtree
is somehow not quite removing them.

Lean-wise, I've finished the problem set in the section of the chapter on monads
I was currently working through. I also gave the harder proof in chapter 4 of
the theorem proving book another try, but I've failed once again.

= Blockers
None.

= Plan for the week
I will continue debugging the codata detection algorithm tomorrow. It's likely
that my obsession with purity in code has made me miss the one place where the
module ought be "updated" without its nested occurrence.

Lean-wise, work will continue as per the usual. I've already finished reading
through the next section of the book (not the theorem proving one), and I'm
going to be solving its problems tomorrow. This time it's `do`-notation --- Uff.
