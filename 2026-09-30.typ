#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-30)])

#title()

= Summary
Today work has focused on two things; Continuing ongoing efforts with the Idris
proof on integer primitives to natural conversions, and starting work on the CI
workflow file that was said to be set up today (last Sunday.)

In terms of proof work, progress has been slow and the limits of the type system
with respect to primitive types without a well-defined structure is being
reached. The proof for integer to natural casting has been completed.

This proof is even better than the one defined in the Idris Prelude because it
provides both implicit proof obligations on the signedness of the integer, and a
proof obligation on the implied natural.

The former goes to say that the input integer is either forced into being
proof-searched as a non-negative integer, or otherwise must provide such proof
manually. This is accompished in one of the ways discussed yesterday.

The last report mentioned that one could either go for a boolean predicate
lifted to the type level, which comes with the advantage of immediate
proof-search, or for a type with a well-defined topology.

The issue with the boolean predicate approach is that the casting proposition
needs to recurse with the integer predecessor. This requires proving as well
that the integer predecessor is non-negative.

Boolean predicates are not made for inductive proofs, but rather for one-off
properties that you need to hold for a little while. The alternative was to
build a proposition (type) that would encapsulate this.

The idea is simple; An inductive hypothesis that zero is vacuously true as being
non-negative, and an induction about any integer also being so, so long as there
is proof of its predecessor being a non-negative integer itself.

The key part here is that the induction bases itself off of the predecessor as
existing proof, and then states that the integer in question is non-negative,
rather than stating that the successor to some proven integer is also proven.

This is useful because then one can use this alongside the proposition that was
elaborated yesterday for integer to natural "identity" mappings, such that we
avoid having to come up with contraposition lemmas halfway through casting.

In essence, what this all allows is to have an integer-to-natural casting
proposition that is so constrained at the type-level that the user can be sure
that, if fed a convertible integer, the integer will be the natural they expect.

This also means the proof (implementation) of the proposition (function) is
fully constrained in what it returns. This is thanks to the proposition (type)
that is paired with the implied natural about the map of integers to naturals.

Testing revealed that, indeed, this works nicely, but only does so conveniently
when the integer to convert is smaller than the proof-search limit the Idris
type checker sets up by default. The multiplicities are also garbage.

This means that attempting to cast 1000 will require the user of the casting
proposition a manual proof that 1000 is non-negative. So work then went on to
another proposition that implies decideability of non-negativeness.

To sum it up, in Idris you sometimes hit these cases where proof-search is not
enough and a proof of, say, 1000 as non-negative, is extremly verbose for the
user to type in. So instead you provide a proposition to "auto"-build it.

In non-dependently types languages, error handling at the type level often works
through coproducts with injections representing failure and success. In Idris,
you can communicate that success carries with it a proof of correctness.

This dependent coproduct type is the decideability type. It wraps a type
(proposition) which will only hold if it can be constructed (proofed) on its
"success" injection. Failure then requires providing a contradiction.

The problem thus far with using this approach to proof the utility proposition
for "auto"-building the non-negative proof is that a contradiction is hard to
come up with. Integers are not as well-defined as ADTs (and the like.)

In terms of Rust work, the day was spent setting up CI to have it check that new
changes to rust-lang/libc do not break the work in the branch for LFS support in
targets using uClibc as environment.

This followed from a comment made last Sunday to the target maintainer, who had
already gone through the trouble of setting up the CI file for testing
specifically against supported Rust targets using uClibc.

The only thing left was to get the uClibc toolchain built with Buildroot. This
has proven to be more dispiriting than a hard proof of correctness. Getting the
thing to build locally is a no-go for reasons proven last summer.

So another CI workflow has been set up to build the toolchain in a remote
runner, package it and upload it as artifacts in GitHub Actions. The work is not
done yet, because apparently Buildroot exposes no option for LFS support.

Reading through the uClibc source repo, none of the built-time macros it expects
to enable LFS support are being provided as opt-ins in Buildroot. The template
Makefile for contrib packages just passes the usual ones by default.

= Blockers
None

= Plan for the week
Work on the CI workflow file will potentially continue all through tomorrow, or
otherwise halt with a happy ending if, indeed, all Buildroot toolchains support
LFS by default. That would be a relief, because no building would be necessary.

Either way, the hard cap for setting up CI is Friday. This weekend an NGINX
forward proxy server will be set up, so there's no time for other stuff. The
Idris proof work will continue as usual.

The proof currently seems to be on its way to using a view over integers to
provide a more structured approach to primitive types. Its injections would
replicate those of naturals but with the case for negative integers added.
