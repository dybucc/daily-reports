#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-19)])

#title()

= Summary
Today work has focused on one thing alone --- Finishing the next chapter of the
theorem proving book in Lean. I'm not sure why, but it feels like doing proofs
actually lets one focus on the task at hand. Let me elaborate on this.

I started off by continuing where I left off yesterday. As mentioned then, I
would first reach the point where tactics are introduced, and then go back to my
work on both the `ctest` extension and the arithmetic evaluator.

Surprisingly, I've both finished the chapter and 95% of the proofs in it,
amounting to #sym.approx;230 lines of Lean. This is quite a feat compared with
non-proof problems, where my mind ends up wandering into harder problems.

I believe this is due to my inexperience in theorem proving compared to
functional programming more broadly. Even though I'm no expert in neither one of
those, the latter is easier to "fondle" for me at the time being.

To a large extent, this has lead me to rethink my strategy when studying and
working. I believe grinding problems does not mean endeslessly smattering your
head against the wall, as I have done thus far.

If a problem does not seem to have a solution to you after giving it some
careful thought, just move on. There's other problems, and you can always come
back later. I know --- Elementary. But today is the first time I tried this out.

The result is quite astounding. Beyond the fact that I didn't go off into the
weeds and think up my own version of a problem, I finished a sizeable amount in
one day. This is in stark contrast with my approach to the other Lean book.

I think I will apply this more generally. I shouldn't sink into tasks as hard as
I do on the regular. Discipline and work should always be there, but there is no
isomorphism between those and mental torture. The latter is also a time sink.

Anyway. I'll probably upload my solutions to the problem sets form the theorem
proving book somewhere. Unlike tacit programming, I don't yet have an eye to see
beauty in a proof, so I won't bother showcasing any examples in the report.

= Blockers
None.

= Plan for the week
I expect to go back to `ctest` matters tomorrow. The same applies to the other
Lean book. I honestly really like theorem proving, but I must first finish my
commitment to the other book.

I will scratch the whole evaluator stuff. I will instead focus on just solving
the problems as stated in the book, without extra self-assigned requirements on
my part. I'm also going to implement the codata stuff straight in Rust.
