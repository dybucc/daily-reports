#import "@local/scratchpad:0.1.3": *

#show: template.with(title: [Daily report (2026-08-25)])

#title()

= Summary
Today work has consisted of two things; Working out the initial details of this
repository, and continuing work on my alternative Typst compiler. No work has
gone today towards any matters Rust-related.

This repository is meant to hold daily reports akin to those I wrote during GSoC
2026, only potentially featuring content that falls outside the scope of my GSoC
project. I've so far not yet gotten to set up a live site, but hat have had
relative success in setting up the content infrastructure.

I've been working on a Typst template that I should make public shortly, and
that will hopefully make all matters in this and other pages on my GitHub Pages
site easier to handle. I would say it's complete; It automates all of the
styling details, and appropriately exposes semantic HTML content when the
compilation target is HTML.

I've also started working on a `justfile` that should help me have an easier
time once I start testing out the deployment through GitHub Actions. Thus far,
it does what I expect it to, and my work now lies in setting up a `.env` file
with which to change the local package path the Typst compiler looks up.

This is necessary because the template I implemented is not published in Typst
Universe (the only public package registry that the Typst compiler currently
checks for remote packages.)

The alternative I've thought about is to use a Git submodule that points to the
template's repo, and only check it one out when needed. The ideal scenario here
is to use it during deployment to resolve the (modified) local package path.

I would quite definitely like to avoid polluting this repository with the
compilation artifacts for the GitHub Pages site. That's why I'm also setting up
a GitHub Actions workflow to run the just commands automatically.

Beyond that, I've continued work on my Typst compiler. This has been a recent
project of mine that I got into because I was dissatisfied with the current
options one has for practicing literate programming with OCaml and Typst.

I don't plan on implementing the entire compiler, as my goal is not to provide a
final document, but rather to be capable of parsing and running through the
evaluator some arbitrary markup/script. Then I can extract the raw code blocks
for use in the "alternative" compilation artifacts (à-la-WEB by DEK.)

For the last few days, I've been learning Menhir (a parser generator used in
OCaml as a modern replacement for `ocamlyacc`) and working on figuring out the
grammar for Typst (which unfortunately doesn't feature a spec.)

Reading throug the Typst reference, there's some subtle details and fairly crazy
partial derivation trees that are theoretically possible but I don't think
average Typst code would generate. Still, I think I'm almost done with the
script interpreter syntax.

The markup syntax will be a bit more challenging as it's quite free form and
atom grouping seems to be a bit complex (given it's arbitrary prose with select
atom sequences producing inline scripting code within the markup.)

Though that complexity is more something I'm concerned with respect to the
lexical analyzer than the parser. Getting an `ocamllex`-generated lexer with the
right regexes for that seems a bit odd (but I've yet to even learn `ocamllex`.)

= Blockers
None.

= Plan for the week
I expect the site for this repo be live either by tomorrow or the day after. I
don't expect the work that's left to be too annoying. The only two things that
worry me are the GitHub CI, and the Git submodules (both of which I seldom use.)

Either way, the parser will continue progressing. I'm presently refactoring some
of the supporting type infrastructure, which means I'm not even solving
non-benign conflicts. Those will likely take some more time to both wrap my head
around and to solve.
