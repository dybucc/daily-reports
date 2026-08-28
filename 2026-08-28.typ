#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-08-28)])

#title()

= Summary
Today work was focused on starting work again on `rust-lang/libc`, and on
continuing work on the parse-time pattern-binding validator for the Typst
compiler.

Yesterday I finished up with the site that hosts these reports, so I started
spending that time back on libc. I had already received a bunch of feedback over
the last three days on PRs I had open, so I got to solve most of those.

A bunch of the comments that follow don't provide relevant context, because that
was already reported throughout GSoC 2026. See #link(
  "https://dybucc.github.io/gsoc-2026-report/daily-reports",
)[here] for details on my GSoC daily reports.

The FreeBSD `netlink` PR needed me to solve some small-time stuff. There were
two things I didn't quite see eye-to-eye with the reviewer, so I pushed back on
those. They're concerned with module tree organization and how certain symbols
are skipped in CI tests.

While solving this, I also found out that CI runs now fail on all PRs because
there's been a recent addition to the `unused` lint group in rust-lang/rust.
Apparently, now multiple `repr` attribute annotations will trigger a warning. We
raise those to errors in CI, which messes with bindings that both use that
attribute and are declared within one of the macros we use to annotate all types
with `repr(C)`.

That is pending, though, and I've made sure to make note of it, so as to
potentially solve it once I'm done with the rest of the PR reviews (if there's
not already a PR open or merged.)

Then I moved on to an issue I recently commented on concerning a certain type
that had unsound accessors. The story here is that this type has a Flexible
Array Member on the C side of things, and we both exposed its fields as public,
and used the one field that indicates the length of the trailing
(variably-sized) field.

Granted, if the user is well-behaved, everything is sound. But if the user sets
the field storing the length we use in the accessors to some value larger than
is actually held on the FAM, we're cooked because the accessors will try to read
into an allocation of differing provenance (or even worse, into the void.)

This was fixed soon after the issue was opened and has not been a problem for
about 6 years. The reason why the issue wasn't closed was because that patch got
merged into `main`; Stable releases have continued providing those accessors up
to this day.

I commented there mentioning if it was already time to remove the accessors, as
we had a deprecation warning for those same 6 years. A maintainer said that
would do it, and I've opened a PR now with that patch. There is, though,
something that still concerns me.

This type is exposed to the public with a zero-sized array to replicate the FAM
on the C side of things. Automatically deriving `Clone` on it, like we do now,
will not yield a full copy of the instance, as any accesses (whether it be reads
or writes) to the FAM's memory will always use `unsafe` and not be part of the
type system's nor runtime support for the type. That should probably be noted in
the type's documentation.

Then I reviewed some more the PR that made `Padding` the prevalent type for
padding fields in records. A reviewer mentioned it'd be best if I split the
patch into three patches that individually addressed public fields, private
fields and fields that were already deprecated.

That was some fairly simple rebasing and custom patch work in source control,
but it turned out fine. The changes to the public fields, even though
technically non-breaking due to our "special" SemVer guarantees, have been split
into a different PR, so as to _not_ backport them to the next stable release.

In terms of the compiler, things have progressed slowly. I think I'm mostly done
with the parse-time evaluator. I still believe I won't use it, but I wanted to
get a feel for the implementation patterns that I'd be using once I actually
started working on the evaluator.

Thus far, I've split the code into some functions that only process code blocks
by interleaving execution of some (beatifully) tail-recursive functions. This
ensures I can easily converge a code block into a single expression if possible
at parse-time, or otherwise exit early with a polymorphic variant indicating it
bailed out.

I still have to finish supporting operator expressions, but that should be
fairly simple compared with the stuff I implemented today for loops and control
flow expressions. I must say, though, OCaml recursive patterns are absolutely
delightful.

= Blockers
None.

= Plan for the week
I expect to have finished with the two remaining reviews I got on
`rust-lang/libc` by tomorrow. Unless I get new feedback, I'll go on to solve one
of the above issues or just look up something else in the 1.0 milestone.

The compiler work progresses well. I'm really loving it, and I should be done
with the base work of the expression merger and sink pattern evaluator tomorrow.
Then I'll see about the multi-binding pattern, which is the only one left.
