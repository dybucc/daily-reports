#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-06)])

#title()

= Summary
Today work has focused on two things; The `ctest` extension matters and the Lean
book. I have finished the state monad parsing and UID refactors I started
yesterday and have since moved on to refactoring affected areas of the codebase.

Efforts were first set on finishing the state monad. This I had started working
on yesterday after determining that the UID strategy would need some state. I
also knew I wanted to get rid of the current state I used for parsing.

The approach with the state monad remains as explained in yesterday's report.
The monad essentially captures the current module's path and the UID of the
items. The UID is then incremented whenever we're sequencing a computation.

I was honestly surprised at the amount of code that got suddenly clearer. The
state monad barely comes at an apparent cost in space beyond the fact it forces
its use to be linear, and thus the whole thing is full of ownership transfers.

Once I finished that up (the details of which I will leave to the PR to
explain,) I moved on to removing the path aggregate logic. That also went
through removing the relevant fields in the types we use post-parsing.

All in all, the clean-up and the time it took is definitely worth it. Even the
mutation at the boundary with the `syn` interface is scoped to a new monad that
is then sequenced in a pure computation to reconcile itself with another monad.

Work is now ongoing on tweaking the filtering logic, which happens after both
parsing and resolution are done, once we're generating the test templates. This
needed me to change the prior uses of methods that used items' path aggregate.

Lean-wise, things have gone quite well. I have continued working through the
monad problems, though this time they're taking longer because I've been reading
some more of the Lean language reference as well.

The current problem I'm solving wants me to extend a small interpreter for
arithmetic expressions that allows state space exploration through a custom
operator that prompts evaluation to attempt going down multiple paths.

The idea with the evaluator is that stuff like division by zero could be handled
in a monad that can report the error once the monad function that alters the
state detects that the operands are not part of the defined domain.

But the chapter develops an alternative where we introduce another "operator" of
arbitrary arity greater than or equal to 2 that prompts evaluation to take each
one of the operands and attempt to solve the expression through each of them.

Then evaluation yields a list of expressions that correspond with each of the
paths that were explored. Without any occurrence of the above "choose" operator,
the list is a singleton.

The problem then expects me to extend this in two ways, but those I've yet to
get to. I didn't want to copy the implementation that was explained in the
chapter, so I'm doing it from scratch from memory for an extra challenge.

I also noticed a bunch of code repetition when I was implementing certain type
classes for the atoms of the arithmetic language, so I started studying the
chapter on syntax extensions in the language reference.

= Blockers
None.

= Plan for the week
I will continue working on the `ctest` matters next week, and I hope to have
finished the current refactor of the filtering logic by Monday. Then only
debugging should remain, which I expect will be mostly concerned with parsing.

Lean-wise, I will continue working on the problems as per the usual throughout
the weekend. This weekend I will go through the usual proxy server maintenance,
and I will continue the Haskell course I started last weekend.
