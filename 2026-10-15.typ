#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-15)])

#title()

= Summary
Today work has focused on two things; The module resolution algorithm for
`ctest` and the Idris problem I mentioned yesterday. The new revision of the
algorithm has been found to be faulty, though the tacit train continues its
course.

Work started off with the `ctest` extension stuff. Yesterday's fix turned out to
be futile; The algorithm still recursed infinitely. So much so, that an even
smaller test proved to be enough to cause non-termination.

After an embarassing amount of time printf-debugging because `rust-lldb`'s
expression parser didn't cut it, the issue was found. The repeated module
resolution strategy does not only rely on keeping a stable number of imports.

Yesterday, I mentioned that the one invariant termination relies on is that the
number of `use` declarations won't change across resolution passes. This was not
well-founded, as I've realized today.

Suppose there is crate root module with a single child module, and that the
child contains a `super`-relative glob import. After one pass, the child module
ends up with itself nested as a child module.

During deduplication, the "larger" subtree is favored. The issue comes when this
behavior is repeated in subsequent passes. The next pass will bring over to the
now node module a snapshot of itself, as a one-level deep subtree.

This will again be favored against the zero-level deep nested child module. The
same process is repeated over and over again back at the resolution driver,
which keeps seeing changes in the crate module tree, and starting another pass.

Quite a lof of thought was put into this, and one of the latest ideas goes
through a reduction of the problem to finding connected components in a graph,
and resolving `use` declarations in reverse order to a walk over graph paths.

We'd be talking of a directed graph where the nodes consist of modules, and the
edges of `use` declarations. The source of the edge is the module where the
`use` declaration appears at.

The destination is the module where the target item(s) lie in. Each connected
component would then have all possible paths gathered, and sorted by whether
they're cycles or not. The non-cyclic paths would appear first.

Then each of these buckets of graph paths would be walked in reverse, resolving
the `use` declarations in this reverse order. Each resolved `use` declaration
could be safely removed, much in the same vein as the first revision of the
algorithm.

Though we would still keep the stateful pair of a subtree and the whole-crate
module tree. Note these are not the same as the graph that would be built off of
modules and `use` declarations between modules.

Each time a `use` declaration were resolved, the whole thing would run again,
building the graph anew, detecting connected components, detecting paths,
sorting them and walking the next path among the non-cyclic ones.

I've yet to think through how to deal with cyclic graph paths, but the above has
thus far seemed feasible.

Idris work has continued smoothly, and the problem I was delighted to showcase
has almost been finished. The proof for the proposition is finished, but there's
some type errors I've yet to solve. Either way, here it goes.

```idris
public export
record Artist where
  constructor MkArtist
  name : String

public export
Eq Artist where (==) = (==) `on` name

public export
record Album where
  constructor MkAlbum
  name   : String
  artist : Artist

public export
Eq Album where (==) = (==) `on` bimap name artist . dup

public export
record Email where
  constructor MkEmail
  value : String

public export
Eq Email where (==) = (==) `on` value

public export
record Password where
  constructor MkPassword
  value : String

public export
Eq Password where (==) = (==) `on` value

public export
record User where
  constructor MkUser
  name     : String
  email    : Email
  password : Password
  albums   : List Album

public export
Eq User where
  (==) =
    (==) `on` bimap (bimap name email) (bimap password albums) . dup . dup

public export
record Credentials where
  constructor MkCreds
  email    : Email
  password : Password

public export
record Request where
  constructor MkRequest
  creds : Credentials
  album : Album

public export
data Response : Type where
  UnknownUser  : Email -> Response
  BadCreds     : Response
  AccessDenied : Email -> Album -> Response
  Success      : Album -> Response

public export
DB : Type
DB = List User

public export
dumb : a -> b -> ((), b)
dumb = (() ,) .: flip const

public export
combine : (a -> b, c -> d) -> (a, c) -> ((), (b, d))
combine =
  (() ,) .: (. bimap (flip apply) (flip apply)) . (flip . uncurry $ bimap)

public export
firstTwo : (a, b, c) -> (a, b)
firstTwo = mapSnd fst

public export
exAlbum : (Request, Maybe Album) -> Response
exAlbum =
  uncurry (foldr (Success .: const))
    . bimap
      (uncurry AccessDenied . bimap (email . creds) album . dup . fst)
      snd
      . dup

public export
fin : (Response, Bool) -> Response
fin =
  (flip apply $ delay BadCreds)
    . uncurry ifThenElse
      . bimap snd (delay . fst)
        . dup

public export
transform : User -> (Request, Response) -> (Request, Response)
transform =
  bimap fst (fin . bimap (exAlbum . firstTwo) (snd . snd) . dup)
    . dup
      . snd
        .: (.
          bimap
            (fst . fst)
            (bimap
              ((==) . album . fst)
              (bimap email password . dup . creds . fst))
            . dup
              . dup)
          . uncurry bitraverse
            . bimap
              dumb
              (combine . bimap (flip find) (==))
              . mapSnd (bimap (albums . fst) (bimap email password))
                . dup
                  . dup
                    . dup

public export
handleRequest : DB -> Request -> Response
handleRequest =
  snd .:
    (. bimap id (UnknownUser . email . creds) . dup) . flip (foldr transform)
```

I will not go into the details of it just yet because there's a lot to explain
and not nearly as much time in today's report. Suffice to say, everything is
tacit. Now onto the problem statement.

This time we're tackling something slightly more realistic; There's propositions
for a set of entities that would exist in a music streaming platform, and a
single proposition to proof; `handleRequest`.

This is meant to try and match the credentials in the request with some user in
the "database" (a list of users,) followed by matching on the requested album in
the list of albums acquired by the user.

A different error is meant to be returned for each possible failure point
(except machine failure.) The idea is to fold over the database with a
`transform` proposition that checks the email and password, and looks up the
album.

= Blockers
None.

= Plan for the week
Thinking through the new approach to the third revision of the algorithm will
continue tomorrow. The idea seems feasible in principle, but as per the usual,
it could very well end up being incorrect.

Idris work has been a great challenge, and explanations of each of the
propositions will be given in the coming days' reports.
