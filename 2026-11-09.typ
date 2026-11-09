#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-09)])

#title()

= Summary
Today work has focused on two things; The `ctest` extension matters and the Lean
book problems. Both tasks have seen very slow progress because I took
handwritten notes for most of the day.

The `ctest` extension stuff I have not gone through any other changes beyond the
filtering logic, which had a pending refactor. I also implemented a cheaper
iterator over items in an item container and decoupled some logic into a macro.

Beyond that, though, work has only consisted of taking notes about the approach
to parsing I took with the tuple-based state monad. Being handwritten, it's
slower, but I would dare say the logic seems solid. Testing will tell.

Lean-wise, I also didn't get a lot of work done because I tried again to take
handwritten notes. I was planning on abstracting away all operations from the
evaluator into an untyped representation for functions.

The idea here was to perform evaluation based off of the tokens used between
operands or before a delimited list of operands. The tokens proper would be
handed off to a handler extending the monad interface for interpretation.

Along the way, and once I got back to the computer, I realized most of this
approach was not feasible. The actual idea I had was a tad bit crazier than what
I explained above, and it really wasn't hard to realize its shortcomings.

I would still like to adscribe no meaning to an operation and to merely support
both infix as well as prefix notation for functions in the arithmetic language.
The infix notation would be assumed to apply to only two operands.

The prefix notation is the more complex part because it would have to be
delimited such that the untyped operation had a known set of arguments to pass
to the monadic handler. This I'm working on right now.

Getting an ergonomic API going when the known set of operations is unknown seems
like one though endeavor.

= Blockers
None.

= Plan for the week
The `ctest` extension matters I really do hope to push forward tomorrow ---
Handwritten notes have consumed a lot of time today, and I didn't even start
testing, much less debugging the parsing implementation.

Lean-wise, I would also like to test out more stuff in front of the computer
because a lot of the ideas I have on paper are garbage.
