#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-11)])

#title()

= Summary
Today work has focused on two things. The proxy matters have been resolved.
Idris work has progressed nicely. A few excerpts of delightful tacit proofs have
been gathered. Those will be showcased here today.

Work started off by looking into the proxy tool found yesterday. This had been
found to potentially do exactly what was needed. The goal is to have specific
URI patterns be redirected to local files. These have been tampered with.

Documentation on the tool was read. It turned out fairly simple to configure.
The basics of it were also straightforward to grasp. The intercepting
functionality required installation of a macOS network extension.

The tool then has an option to configure URI patterns. Every outgoing request
from the system is matched against this list. Then each pattern can be made to
automatically return a local file.

Tests revealed this worked nicely. The end goal is to have this distributed over
multiple systems. This intercepting proxy also has a way to accomplish this. One
sets up a main machine with the proxy. Other machines connect through WireGuard.

That is still pending. Work on tampering the local files is still ongoing.

Idris work has continued nicely. Tacitness is enticing. Something similar to
yesterday also took place today. Not many problems were solved. The ones solved
were made into beautifully tacit solutions.

Today a more step-by-step explanation of the process has been gathered.
Yesterday's example was hurried. The explanation was a bit too terse. Hopefully
this example goes to show the beauty in these mental gymanstics.

```idris
public export
record Last a where
  constructor MkLast
  value : Maybe a

public export
pureLast : a -> Last a
pureLast = MkLast . Just

namespace Combine
  foo : Last a -> Last b -> Last (a, b)
  foo = \x => \y => case (value x, value y) of
                         ((Just x), (Just y)) => pureLast (x, y)
                         (_       , _       ) => MkLast Nothing

  foo' : Last a -> Last b -> Last (a, b)
  foo' = \x => \y =>
    map (\x => (\y => (x, y))) (value x) |> (<*> value y) |> MkLast

  foo'' : Last a -> Last b -> Last (a, b)
  foo'' = \x => \y =>
    map (\x => \y => (x, y)) (value x) |> (<*> value y) |> MkLast

  foo''' : Last a -> Last b -> Last (a, b)
  foo''' = \x => \y => map (,) (value x) |> (<*> value y) |> MkLast

  foo'''' : Last a -> Last b -> Last (a, b)
  foo'''' = \x => \y => map (,) (value x) <*> value y |> MkLast

  foo''''' : Last a -> Last b -> Last (a, b)
  foo''''' = \x => \y => (.:) MkLast (<*>) (map (,) (value x)) (value y)

  foo'''''' : Last a -> Last b -> Last (a, b)
  foo'''''' = \x => (.:) MkLast (<*>) (map (,) (value x)) . value

  foo''''''' : Last a -> Last b -> Last (a, b)
  foo''''''' = MkLast .: ((. value) . (<*>)) . (map (,) . value)

public export
combine : Last a -> Last b -> Last (a, b)
combine = MkLast .: (. value) . (<*>) . map (,) . value
```

The target proposition is the `combine` proposition at the end. The namespace
exists to have a dummy proposition build up reductions. Think about the
propositions in the namespace as a scratchpad. Each is increasingly tacit.

The quantified proposition (type) itself is included up top. Proposition
`pureLast` is a utility to avoid cluttering an `Applicative` interface
implementation. That just wraps some proof of `a` in the product.

Each proposition in the namespace is an iteration in the thought process. The
very first one (`foo`) is a reduction of a straightforward implementation. It is
tacit in that it refers to no proofs of its assumptions.

It instead yields another proposition of another proposition of another
proposition. That is a basic reduction. Proposition `combine` implies a product
of a pair if the assumed coproducts are proofed through identity functors.

The second iteration attempts to get rid of language control structures.
Proposition `foo'` uses applicative operator `<*>`. It maps one inner coproduct
to a mapping that will make up a pair provided another coproduct's inner proof.

This is then applied through the afore mentioned operator. Then it builds anew
the product whose only injection is the coproduct. All other iterations build up
on this idea to make it increasingly tacit.

Proposition `combine` ends up as a use of the blackbird combinator. The binary
proposition it assumes is a composition of 4 propositions. The projection of the
product is extracted. Then it gets mapped to a pair-implying proposition.

Then that gets fed as the first operand to the `<*>` operator. Then that gets
applied to another composition. That composition first fetches the projection of
the second coproduct. Then it feeds that into the partially applied `<*>`.

= Blockers
None.

= Plan for the week
Tomorrow `ctest` extension work will resume. Idris work will continue as per the
usual. Tacit solutions provide good mental challenges. There is a lot of insight
to be gained from reading about reductions in the typed lambda calculus.
