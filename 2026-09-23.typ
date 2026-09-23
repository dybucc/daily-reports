#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-23)])

#title()

= Summary
Today work has focused solely on one thing; Continuing work on adding support
for ```rust super``` reexports. This follows from yesterday's initial attempts
at this.

I started off by reviewing the driver resolution logic. This I had modified late
yesterday after starting to work on the ```rust super```-support, so I was not
entirely sure that it would work out just fine.

I tested it out some, and it turned to have no obvious regressions. The next
thing I did was to start thinking about actually using the running state I added
support for yesterday in the single-reexport resolution function.

This seemed fairly simple at first, as I thought I would only need to implement
two additional helper functions, and modify the logic for the case where we
encountered paths in the reexport.

Now the case for paths first checks if the extracted head matches the
```rust super``` keyword, and if so, it will proceed to run the first helper
function. Otherwise, it just keeps going with the same logic as before.

The first helper function munches through the reexport until it finds the path
has been left with a single glob or name, or until it finds a
non-```rust super``` segment in it. It returns the trimmed path and a natural.

The natural number indicates the amount of ```rust super```-keywords trimmed
from the path. This is then passed off to the next helper function, which takes
in the module against which to perform the search, and the whole-crate tree.

It extracts the path of the module against which we are searching the ancestor.
It then reverses the module path, trims however as many segments from the path
as the input natural number indicates and reverse it anew.

This yields the specific ancestor module we want to return, and that we will
traverse the whole-crate module tree for. This did require changing the type I
used in the demo for module paths to be a list of strings instead of a string.

Then the module is returned back to the single reexport resolution function.
This then proceeds as usual by recursing with this module and the trimmed path
returned from the first helper function as state.

In the case the path is left with a single ```rust super``` keyword because the
helper did not trim the final non-path, this is handled in the name case. It
just calls into the second helper with 1 as the input natural (i.e. the parent.)

This seems and, indeed, I think to be correct. The issue lies in that the second
helper function, when it does the reverse-trimming-reverse to get the right path
to the ancestor, cannot determine if the list used for the path is non-empty.

I know that well-formed input will never have a ```rust super``` keyword
appearing in the root module, which is the only one with an empty list as its
path. But the Idris type checker does not, so I started working on a proof.

Thus far, I have had moderate success in devising a few types that would
communicate this constraint. The latest solution I have found was to directly
make the module type correct by construction through a type parameter.

This type parameter is used in a function that treats types as first class
values, and depending on the data constructor with which the type parameter was
constructed, returns a differently constrained type.

This allows differentiating between root modules and node modules. The former
have no path, so their path is a ```idris Void```. The latter have a
```idris List1``` path, which is a non-empty list by construction.

This was working out just fine until I got to the part of the type that is
supposed to prove that root modules cannot have ```rust super```-prepended
imports. I have had issues expressing the negation of propositional equality.

I need this to ensure that a certain string used as an input parameter to the
reexports for root modules are never ```rust super```-prepended. But for some
reason, I cannot quite grasp what exactly does the type checker need.

I am not even sure if it is right to assume that the type checker can trust in
propositional equality for strings. We shall see tomorrow with fresher eyes.

= Blockers
None.

= Plan for the week
I expect to continue working on this tomorrow, and potentially finish up before
the end of the day. If I can not get the issue I commented on in today's summary
solved, I will just switch to using a dedicated type for ```rust super```.

Beyond that, I expect to have a working MVP before the end of tomorrow. Then I
would like to prepare the write up I mentioned for the PR update, and then I
would like to start working on the Rust port.
