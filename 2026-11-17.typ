#import "@local/scratchpad:0.1.5": *

#show: template.with(title: [Daily report (2026-11-17)])

#title()

= Summary
Today work has focused on three things --- Going back to work on the `ctest`
extension matters, working some more on the arithmetic evaluator, and reading
through the first two chapters of a theorem proving book in Lean.

The `ctest` extension matters have gone fairly well but have been really slow. I
started of by scratching the whole thing and starting anew. I had previously
been worrying about some parsing, which made no sense.

As mentioned last week, I isolated the codata detection problem to a separate
program in Haskell, which today I've ported over to Lean. Work has been fruitful
in that the concrete details of the idea I had seem correct.

The codata pattern manifests itself when a module appears nested within its own
subtree at least two times, separated by the same amount of graph step paths.
The steps here mean the amount of nodes separating them in a downward traversal.

The idea with the algorithm is to detect this as soon as it takes place. In
other words, we're meant to detect it as soon as exactly two nested occurrences
of the same module appear post-merging the resolved `use` declarations.

To that extent, I've modeled the module tree as a fairly simple ADT on which an
also fairly simple right fold is performed. The right fold does not recurse into
any one of the items within the tree proper, leaving that to call-site.

State is tracked by the accumulator of the fold. This consists of a pair of
paths and step counters, the former wrapped in a fallible monad. The steps we
"update" every time we go down a path.

Then we start the fold and look only for module items. As soon as we hit one, we
check if our first monad is in the "fallible" state and attempt to compare the
path of the module with the reference path if it is.

If we ever find a match, we ensure the first fallible monad enters its success
state. Then we keep on going with the next fallible monad and its own step
counter. The matching condition is stronger in this latter case.

Upon finding another match, we check, in order, our fallible monads. If we're on
the second monad, we compare its step counter against the step counter of the
prior monad, entering its success state only if they match.

Most of this I've yet to implement because I've been spending quite a bit of
time trying to prove the instances of reflexive boolean equality and lawful
boolean equality for the type that stands in for module trees.

Evaluator-wise, I kept on going with the tacit refactor, though this time I
removed a whole bunch of other stuff. Then I also found out the reason why I was
getting some real odd compiler issues last week.

As it turns out, I had been accumulating quite a lot of implicit program
transformations as I had gone through the chapters of the Lean book I was
reading. This I had kept all in a single file, within the same project.

By the time I got to the code for the evaluator, there were about 1000 lines of
all kinds of shenanigans from prior experiments. This was the root (general)
cause of the mysterious unification errors I was getting from simple stuff.

Instead of creating another project, I decided I would instead just comment out
all lines leading up to the namespace where I was working on the evaluator.
While at this, I came across my attempts at proving the Yoneda isomorphism.

This, in combination with my struggle to prove some of the boolean equality
stuff from the `ctest` side of things, lead me to read through the first two,
and most of the third, chapter of another book on Lean theorem proving.

As part of one of the exercises, I've also been working on proving the law of
excluded middle from the double negation elimination theorem. This shouldn't be
too hard because the latter itself uses it, but it's a good challenge.

= Blockers
None.

= Plan for the week
I expect to continue attempting to prove the boolean equality stuff tomorrow.
Then we'll see about implementing the codata detection algorithm. I will not
have a Rust implementation this week, but a Lean one is more likely.

Evaluator-wise, things are a tad bit on hold while I read some more through the
theorem proving book. I expect to read up until the point where it introduces
tactics, simply because I'd much rather handle "raw" proof terms.
