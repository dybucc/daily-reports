# `daily-reports`

This repository hosts the page `daily-reports` in my GitHub Pages. It collects
daily reports akin to those I compiled during GSoC 2026, but it further expands
their contents with a discussion on matters non-Rust (which is to say, at the
time of writing, OCaml and side projects.)

The commits that lead to the initial "stable" release, including the first two
daily reports, can be found (with their original commit author timestamps) in
the `pre` branch.

## Technical details

The site is built with Typst, and uses the experimental HTML export alongside
some Just recipes and CI. See the main workflow file under
`.github/workflows/deploy.yaml`, and the `justfile` at the repo root for
details.

The high-level overview of the CI workflow that deploys the site is as follows:

1. Fetch the Typst version by checking for a hard-coded value in the `justfile`.
This is the only place it appears at, so it's not really hardcoded.

2. Use the Typst version to create an output for that one step in CI, such that
the next step, which consists of caching, can look up whether the Typst compiler
version is available as a cache artifact.

3. Check as well for a compiled `ripgrep` in cache, which is used in the
`justfile` for extracting the version of the Typst template I maintain and use
for the documents in this repo. This could easily be replaced for `grep`, which
is already available in GitHub-hosted runners, but I prefer to keep using the
tools I'm used to.

4. If any of the above two cached entries fails, another step in the CI build
job will compile both the Typst compiler driver and `ripgrep`. This currently is
a bit broken; If the cache miss does not happen with both programs, the Just
recipe that compiles them silently exits.

5. Report on the active Typst settings after setting up some environment
variables in the `justfile` for (1) enabling HTML export, (2) adding a custom
font lookup path, and (3) overriding the local package path. The latter two are
used alongside the `maple-mono` directory in the repo root for the non-HTML
documents to use Maple Mono as the monospaced font, and for making my Typst
template package available on a remote machine.

6. Before compiling, I should explain further the shenanigans behind the
template package. Currently, Typst only allows remote package fetching through
the official package registry (Typst Universe,) but I don't think this template
is worth getting published. So I instead clone the template's repo into a path
local to the CI runner, and set up Typst to check for local packages under that
path.

7. Then the files get compiled, which is a fairly straightforward process. The
`justfile` uses a script recipe to recurse through the results of glob-expanding
all `.typ` files in the repo root. Then I just dump the entire repo contents
into the GitHub Pages artifact that gets served and call it a day. This could
probably be improved.
