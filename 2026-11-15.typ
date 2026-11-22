#import "@local/scratchpad:0.1.5": *

#show: template.with(title: [Daily report (2026-11-15)])

#title()

= Summary
Today work has, once again, focused on tweaking my Neovim configuration. From
the goals set out yesterday, I've only accomplished to finish the Lua language
server configuration, as well as its formatter integration.

I started off by tweaking a bunch of stuff from the proxy server --- That didn't
take too long. Afterwards, I moved on to review yesterday's work on the Neovim
configuration, and on tweaking my configuration for the Lua language server.

This was not too time-consuming either --- The language server uncovered a few
mistakes I had made in my implementation of the in-process LS/formatter. That
spun out into a fairly deep rabbit hole.

The main issue was concerned with one parameter I was passing to the exit
notification a server is meant to react to in the LSP spec. One of those
parameters is literally meant to be a `signal.h` constant.

For this, I used the `luv` bindings that Neovim already packs. The issue was in
that those bindings define the constant as the lowercase string that is
internally interpreted in the `luv` library as the signal name.

So I was essentially passing a string where a number was expected. Of course, I
could have simply replaced the signal number I was interested in reporting
through, but that didn't seem like a good enough solution.

#html.blockquote[*Edit (one day after:)* in the following paragraph I mention
  that LuaJIT is the Lua implementation that comes packed with Neovim. This is
  not entirely accurate because it's really Lua 5.1 that comes packed with
  Neovim. Though LuaJIT is based on Lua 5.1, and the Neovim documentation
  recommends its use over vanilla Lua @neovim-luajit.]

So I instead started reading through the LuaJIT documentation. LuaJIT is the Lua
implementation that comes embedded in Neovim. I had read somewhere that it had a
fairly decent FFI story to interoperate with C, so I gave it a go.

After much reading and sidetracking to experiment, I reached the part of the
documentation that mentions declared C bindings are not run through a
preprocessor. This meant I couldn't just paste right in the `signal.h` header.

All of those signals are `#define`d, which means I would have had to pre-process
the header files to change them into C `enum`s or `static const`s. Before I
reached this point, though, a few other things happened.

Firstly, I went through the list of syntax extensions from LuaJIT 3 that were
backported to LuaJIT 2.1 (current stable version.) This prompted me to go
through one fairly large refactor of my Neovim configuration to use them.

This refactor also lead to another refactor to properly provide EmmyLua-style
annotations for all of my code. Lua being dynamically-typed, language servers
will provide diagnostics if you provide type annotations as comments.

All of this already consumed a fairly large amount of time, but then came
another rabbit hole --- Autoformatter support for the afore-mentioned syntax
extensions. These don't seem to have a great deal of support in `stylua`.

Of course, hot-headed as I am, I decided I would go look for another
autoformatter that did support them in full. That went sort of well, because
even though I found it, I think the quality of its output is comparably worse.

But that's still not the end of the story --- I still had to worry about
Treesitter support for those syntax extensions. Most of them were handled just
fine, except for one extension, which broke fragments of the parsed syntax tree.

And that's about as far as it went today.

= Blockers
None.

= Plan for the week
I still have to tweak the `rust-analyzer` configuration to keep working on the
`ctest` extension matters from Neovim. That I will do tomorrow. I will probably
refactor the Neovim configuration once more to get rid of the syntax extensions.

That should hopefully clear out the way for setting up `tinymist` (the Typst
language server,) and HLS (the Haskell language server.) Then I will finally be
able to come back to my main work.

#bibliography("bib.yaml")
