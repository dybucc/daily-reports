#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-02)])

#title()

= Summary
Today work has focused on implementing initial support for parsing modules in
`ctest`, and on potentially resolving the last few days of sidetracking in the
compiler.

I started off (and went for a few hours) by looking into the GSoC preferred
status as a contributor when applying for roles at Google. I also remade my
resume, getting rid of all projects that I do not consider finished. I also made
all of those repositories private.

This took about half of today, as I read through the Google recruitment sites,
and looked for a few entry position roles and internships. I have ended up not
yet applying to any one role, as they recommend tailoring a resume for each of
them, and I do not consider my projects ready to face the public.

I then moved on to working on the `ctest` stuff. Yesterday, I started looking
into extending our test harness at rust-lang/libc to allow testing items in Rust
modules. Today I added support for parsing arbitrarily nested modules.

This was fairly simple because we use `syn`'s visitor interface. I added a new
type to the set of FFI items we check for, itself containing a set of those FFI
items. Beyond that, I have have looked into what other parts of the crate I will
have to modify.

In principle, the only other part of the crate that needs changing is the
template generation process. Currently, it ignores the newly parsed modules as
they are simply another type in the labeled product type that both Rust and C
templates get passed.

The plan is to inline all module contents (while traversing them) into
root-level items with mangled identifiers on the Rust side of things. On the C
side of things, things look more dire and I have thus far not thought up a
solution.

The problem lies in that the functions cannot have mangled identifiers even if
the C compiler used allows specifying some link name for the symbol through an
attribute. I would prefer to avoid this.

In terms of compiler work, I have decided that it was enough derailing I had had
for the last few days on getting a nicely typed set of expressions. Adding more
constraints is ideal once I implement the evaluator, but at one point today, I
realized that I simply could not use these types for parsing.

I had refactored even more thoroughly the operator type to allow progressively
building up a type equation as each data constructor argument, itself a
parameterized GADT with an arbitrary type variable #sym.alpha, "bubbled up" from
the most deeply nested allowed operand (itself an instance of the
```ocaml yielder``` type) into the top-level operator type and eventually the
overarching expression type containing the former.

The problem lied in that so much specificity is impossible to satisfy without
compilation context to resolve wildcard expressions such as identifiers and
callables. My conclusion was that I could keep some of the constraints but I
would have to lift most of them as they are not satisfiable at parse time.

= Blockers
None.

= Plan for the week
I expect to have come up with a plan to address the C side of the tests in
`ctest` tomorrow. Though I honestly have not the slightest idea about it as I
write this report, so there's that. We'll see; Maybe I start testing stuff out
and see I can get away with something fairly straightforward.

Reassuringly, I know tomorrow I will be coming back to finish up the actual
Menhir grammar in the compiler. I have also decided against going back to the
binding validator, as I believe to have gotten a rough idea of how I would
implement it once I get to the evaluator. I have also thought about potentially
avoiding implementing most logic in the evaluator to instead pass the source
contents to the actual Typst compiler, and only upon getting a successful
response, looking into inlining the expressions to analyze where each raw
element is found.
