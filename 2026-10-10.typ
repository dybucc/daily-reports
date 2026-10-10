#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-10)])

#title()

= Summary
Today work has focused on two things. One of them was research into the proxy
server. This followed up from last weekend's efforts. The other one is Idris
work on the community tutorial.

Last weekend a conlusion had been reached. NGINX would not cut it. There is need
for a forward proxy server that is invisible to the client. NGINX's proxy module
does not seem capable of this.

A book on HTTP was picked up. Research went into the chapters treating proxy
servers. One taxonomy explained there was between explicit and intercepting
proxies. The former are known to the client. The latter are what was needed.

The book does not go into many details on the latter. OS-wide proxy settings are
neither an option. Those can be "queried" by clients. These end up producing
requests using the `CONNECT` method. That comes with TLS baked in with HTTP
1.1+.

There is need to pry into a request. Then there is also need to manipulate a
request's response. Certain URI patterns should be detected. These should be
redirected to a local server with custom responses.

And yet the client must know nothing about this man-in-the-middle scheme. That
is exactly what an intercepting proxy does. Further research lead to reading
relevant sections on two books on penetration-testing.

Two such proxies have been considered for this. One is a closed-source solution
that would be best avoided. The other one is open-source. Other approaches were
also considered. DNS redirection at the OS level is feasible and simple.

The issue comes with the redirected patterns. DNS redirection can only ever
access the queried host name. That is not enough. Specific paths under a given
remote server must be manipulated.

Idris work has been slow. And yet it has been incredibly satisfactory. Not many
problems were solved today. The reason for that was to make the solutions fully
tacit. That has provided some new insight into manipulation of propositions.

The best example of this is the following one-liner.

```idris
mapFirst : (a -> b) -> First a -> First b

mapFirst = MkFirst .: (. value) . map
```

This is heaven on Earth. The proposition only does one thing. It maps a product
from being parameterized by one proposition to another. And yet proofing this
without ever referring to the assumptions takes some time.

The first assumption is the transform. The second is the product. It has one
projection to another coproduct. One corresponds with an injective const
functor. The other corresponds with an identity functor.

`First` a is essentially a wrapper for `Maybe`. The first map is over the inner
coproduct. Composition ensures the rhs will get parts of the map proposition.
The lhs is a partially applied composition.

This latter composition acts as proof witness. It also "adds" another assumption
to the proposition resulting from composition. Note how the value projection
needs a First to extract the coproduct.

The outer composition can then yield the rhs as a partially applied map. It has
the guarantee that the rhs will provide the functor of the map. In this instance
that is the wrapped coproduct.

The end result is a composition that accepts two assumptions instead of a single
assumption. The `MkFirst .:` wraps the coproduct anew into the single-projection
product. That uses the blackbird operator (`.:`.)

This operator composes a unary proposition after a binary proposition. The
binary proposition comes from the composition explained above. The unary
proposition is the product's constructor (`MkFirst`.)

= Blockers
None.

= Plan for the week
The open-source solution for the intercepting proxy will be further researched
tomorrow. That should yield nice results. The docs seem to be what the goal here
needs. Though one complication comes to mind; Distribution over other systems.

Work will continue on the Idris community tutorial as usual. Tacitnes will be
attempted whenever possible. It seems tacitness is always possible. It just so
happens it requires a lot of thought in some cases.
