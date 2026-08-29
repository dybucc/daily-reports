#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-08-29)])

#title()

= Summary
Today work has focused on finishing up work on the reviews I had received in
rust-lang/libc PRs, and on further advancing work on the Typst compiler.

Yesterday, I had only two things left to do in terms of PR reviews. These were
concerned with a PR I opened at the end of GSoC to make `time64` functionality
available publicly through a single unstable `cfg`, and with support for a
custom item attribute in our MBEs to replicate the semantics of the built-in
`non_exhaustive`.

I first addressed the `time64` PR. The review on this one asked me to extend
support for the `cfg` to CI, to also stop using the target-specific `cfg`s
there. I also mistakenly added the `cfg` to the `check-cfg` list, even though it
wasn't necessary as it's only used to set internal `cfg`s for each target and
never gets used in conditionally-compiled source code outside the build script.

Then I went on to the PR regarding our macros. In rust-lang/libc, we use a bunch
of MBEs to declare all records with both `repr(C)` and a set of automatically
derived traits. For quite some time now, though, we've also had the need to mark
those somehow to more explicitly indicate that the ABI could break at any time.

This would be ideally done with Rust's built-in `non_exhaustive` attribute,
which ensures users cannot destructure the type nor avoid field-by-field
initialization without explicitly taking into consideration potentially trailing
fields (that may be there in a future, breaking release.)

The reason why we can't use it is because there's also been discussion for some
time now in rust-lang/rust about a certain lint that is triggered when any such
record marked with the afore mentioned attribute is used in FFI contexts.
Apparently, back when the RFC that proposed it was accepted and implemented, it
was thought that folks should naturally expect FFI contexts to break ABI.

This may or may not be solved, but for the time being, we need to move forward
with the 1.0 release in rust-lang/libc, so we needed a better solution. A
maintainer there thought up a plan to extend the macros we use for declaring
records to also add a private field that would somewhat replicate the effects of
using `non_exhaustive`.

Granted, we can neither just add that and break all downstream users, so my PR
both implemented that extension to the macros, and added an opt-out toggle
through a custom attribute (`exhaustive`) that ensures a given type does not
have the private field added to its definition.

The feedback I got was mostly concerned with trivial stuff; Renaming some
confusing helper macro and token matchers. I also got told that I would probably
want to base the patch on another PR's patch that also touched on these macros
but extended them to solve a different issue.

I have done that in a separate branch, and have linked to that one's patchset,
but I have refrained from replacing the patch in my PR just yet. Once that other
PR gets merged, I'll drop the commits from my PR's patch, and cherry pick the
ones I made on my other patch back onto the PR branch.

Compiler work has progressed quite nicely. I have finished handling the case for
sink patterns in `let`-bindings, and have discarded the possibility for
implementing operator expression evaluation at parse time.

I also got to fix the implementation I had for merging dictionary literals in
the merger function. I idiotically just appended them and thought that would do
it (and it just so happened that the function impelementing that is
tail-recursive.)

But I forgot that dictionaries are meant to replicate associated keys in a set.
This meant merging would have to go through checking if the new dictionary
contained some key already present in our running state, to then update that key
and yield the previous state's unique keys merged with the new dictionary's
unique keys.

The final implementation I am quite satisfied with. It is nicely tail-recursive,
though for the sake of purity and immutable state, I have had to implement the
functionality for key removal and key searching separately. Still, the total
cost is better than the next best solution that is still tail-recursive.

Granted, the nestedness of dictionaries and, more specifically, literals, is
bound to be less than 1 million items, so the overhead wouldn't be noticeable
without a tail-recursive solution, but I prefer to think harder.

I also got to refactor some duplicated code I had in the function handling the
more general case of whether some literal expression could be assumed to be
"destructurable." I also refactored some other code that used a very similar
function application in two places.

This deserves more attention. It was supposed to be simple, because it was only
about making available a nested binding that took on the partial application of
the function with the informal parameters that were identical, such that only
the differing parameters were supplied at call site.

But that wouldn't do it because the first call would make the binding lose its
polymorphism due to the way OCaml handles existial quantification of generic
type variables. So I remembered that while reading the OCaml reference manual,
there was mention of something that could revoer this genericity by means of
explicit universal type variable quanitification.

I read through the relevant part of the manual again, and implemented a little
wrapper against the original function that instead took on a more general type
variable through an explicitly polymorphic annotation, which ensures every time
the function is called, we force the type checker into evaluating concrete types
for the polymorphic version of the function. Previously, the first call would
determine some concrete types and expect further calls to abide by those
constraints.

= Blockers
None.

= Plan for the week
I am done with the GitHub PR reviews, so I'll move on to solving the issue with
the general CI failure across all PRs. It seems there's not yet anybody who has
opened a PR to solve this, but we'll see if that continues being the case
tomorrow. Either way, I'll move on to some other issue in the 1.0 release
milestone afterwards.

The compiler work should now be finishing up work on the "dumb pattern binding
validator." I'm now working through the multi-binding variant, which itself
contains the sink variant as its most complex case. The sink variant I finished
today, and I think I have a rought idea of how to proceed with the former.
