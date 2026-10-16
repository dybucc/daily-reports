#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-16)])

= Summary
Today work has focused on three things; The `ctest` extension stuff, a WIP blog
post about the tacit Idris program I presented yesterday, and a Neovim plugin I
made to strain my eyes a tad bit less.

The `ctest` extension work started off by continuing discussion on the module
resolution algorithm. Yesterday, I thought I had found the algorithm to be
incorrect, but today I've come to realize it actually isn't.

Remember how yesterday's example showcased a non-terminating case? Back then, I
thought that termination relied on both a stable number of `use` declarations
and on avoiding having the same module nested within the subtree rooted at it.

But today I decided to give the same failing test a spin in `rustc`, to see what
the emitted error was. The example code snippet is as follows.

```rust
mod foo {
    use crate as root;

    pub struct Foo;

    const FOO: root::foo::root::foo::Foo = Foo;
}
```

Lo and behold, `rustc` accepts this. The non-terminating path that comes from
attempting to repeatedly resolve the above import somehow terminates in
`rustc`'s internals. That meant I could keep the same algorithm, but tweak just
this.

Seeing how the above code snippet was considered well-formed input, I decided to
go down the route of an algorithm for detecting codata. I assume `rustc` also
does this; It finds the pattern in the infinite induction and stores only that.

In the above example, termination is possible because such an infinitely nested
path follows a pattern. The pattern is given by the nested crate root; A walk
from the crate root down the `foo` module gets you to the nested crate root.

That two-segment path thus becomes our pattern. Any paths that refer to items of
the module where the nested module appears at (here `Foo` in `foo`,) can now
also be referred to by an arbitrarily long sequence of chained `root::foo`s.

This also prompted me to rethink about the way paths for a given item are
handled. The current algorithm will import over items from one module to
another, but will not draw a relationship between these two.

The whole point of resolution is to have skips set up by downstream crates be
capable of referring to an item by any one of the paths with which that item is
"addressable." The current approach doesn't accomplish this.

Though the solution was simple; All items get their path record field changed to
reflect a collection of possible paths instead of a single path. At parse-time,
this is a singleton list we have for all items.

At merge-time (i.e. after each single-module pass is done,) the items to merge
get looked up in the whole-crate module tree and their list of addressable paths
is updated. This list is also updated in the imported copy of the item.

Today I also answered a comment by a maintainer on this same PR, which asked for
a general overview of the architectural changes. Then I started working on a
blog post on the Idris program I showcased yesterday.

I know I said I would explain the program in the coming days' reports, but I
thought that would be a bit messy to follow up. So instead I'm now writing a
blog post that also serves as a literate program ready for Idris to typecheck.

Halfway through this, I also started (and finished) working on a Neovim plugin
to properly center my cursor line. There's a little trick that can be used with
a built-in option to get a similar effect, but it isn't quite there for me.

Without the nifty trick nor the plugin, you can move the cursor everywhere. If
you increase the scrolloff threshold beyond half the height of your current
window, you can get the text to be the one that moves as the cursor moves.

This basically allows the cursor to always be positioned on the first half of
the screen, which is great for my eyesight. The exception to this is when you
hit the last few lines in the current buffer, where the cursor moves down.

That is a bit of a generalization, but it will do. The solution I came up with
in the plugin basically sets up an autocommand for all cursor movements in
normal and visual mode, and checks if the line has changed.

If the cursor line with respect to the current window changed, then I trigger a
behind-the-scenes redraw of the screen after moving the whole displayed text up
or down by one line.

Getting this to work is fairly simple with a built-in command. The complexity
came from having to ensure there were no mappings set over the keys that trigger
the built-in. That required more thought.

The solution was fairly simple, though; Fetch a list of global and buffer-local
keymaps, try to find if there's any that overwrite the built-in, remove it, do
the redrawing, and then restore it back again. And all of the details there.

= Blockers
None.

= Plan for the week
The `ctest` extension work will continue on Monday, as the weekend will be spent
resuming work on the intercepting proxy server. The Idris blog post I hope to
have finished by either tomorrow or the end of the weekend.
