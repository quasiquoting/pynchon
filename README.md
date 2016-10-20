# pynchon

[![Build Status][Travis badge]][Travis link]
[![Hex.pm][Hex badge]][Hex link]
[![Min Erlang version][Erlang badge]][erlang.org]
[![Documentation][Doc badge]][Doc link]
[![Eclipse Public License][EPL badge]](LICENSE)

[Travis badge]: https://travis-ci.org/quasiquoting/pynchon.svg?branch=master
[Travis link]: https://travis-ci.org/quasiquoting/pynchon
[Hex badge]: https://img.shields.io/hexpm/v/pynchon.svg
[Hex link]: https://hex.pm/packages/pynchon
[Erlang badge]: https://img.shields.io/badge/erlang-%E2%89%A518.x-red.svg
[erlang.org]: http://www.erlang.org/downloads
[EPL badge]: https://img.shields.io/badge/license-EPL-blue.svg
[Doc badge]: https://img.shields.io/badge/docs-100%25-green.svg
[Doc link]: http://quasiquoting.org/pynchon

*A collection of arrow macros.*

Ported from [@rplevy]'s Clojure library, [swiss-arrows].
See its [README] for usage examples.

[![Muted post horn][MutedPosthorn.png]][MutedPosthorn link]

"Muted post horn" image created by [Zafiroblue05] and
distributed under the [CC BY-SA 3.0] license.

[@rplevy]: https://github.com/rplevy
[swiss-arrows]: https://github.com/rplevy/swiss-arrows
[README]: https://github.com/rplevy/swiss-arrows/blob/master/README.md
[MutedPosthorn.png]: https://upload.wikimedia.org/wikipedia/commons/4/45/MutedPosthorn.png
[MutedPosthorn link]: https://en.wikipedia.org/wiki/Thomas_Pynchon#/media/File:MutedPosthorn.png
[Zafiroblue05]: https://en.wikipedia.org/wiki/User:Zafiroblue05
[CC BY-SA 3.0]: http://creativecommons.org/licenses/by-sa/3.0/

## Installation

Add `pynchon` to your `deps` in your `rebar.config`:

```erlang
{deps, [
  {pynchon, "0.5.0"}
]}.
```

## Usage

To use the arrow macros, you can either include `arrows.lfe`:

```lfe
(include-lib "pynchon/include/arrows.lfe")

(defun foo ()
  (-<>< (+ 1 2)
        (list <> 2 1)
        (list 5 <> 7)
        (list 9 4 <>)))
```

... or make fully-qualified calls to the exported macros:

```lfe
(defun bar ()
  (pynchon:-<>< (+ 1 2)
                (list <> 2 1)
                (list 5 <> 7)
                (list 9 4 <>)))
```

## Documentation

For (sparse) documentation, check out the
[Lodox]-generated [API docs][Doc link].

Be sure to peruse the [usage examples][README] in the original [swiss-arrows]
repo, too.
<br>
Although some Clojure idioms therein don't translate to LFE,
the general ideas apply.

[Lodox]: https://github.com/lfe-rebar3/lodox

## Credits

*Copied from the [swiss-arrows][] [README].*

> Walter Tetzner, Stephen Compall, and I designed and implemented something
> similar to the "diamond wand" a couple of years ago.
>
> Thanks to Alex Baranosky, Roman Perepelitsa, Paul Dorman, [@rebcabin], and
> Stephen Compall for code contributions and conceptual contributions.

[@rebcabin]: https://github.com/rebcabin

## License

Copyright (C) 2012 Robert P. Levy

Copyright (C) 2015-2016 Eric Bailey

Distributed under the Eclipse Public License, the same as Clojure.
