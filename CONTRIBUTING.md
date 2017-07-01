# Contributing Guide

The exercises for [each language][xtracks] are stored in separate repositories,
included here as [git submodules][submodule] under `./tracks`.

The [shared pool of problem specifications][problem-specifications] which is shared between all the language tracks are
also included as a [git submodule][submodule] in `./problem-specifications`.

A git submodule is essentially a project in another project.

## Development Environment

Clone the git repository, then run the bootstrap script:

```
$ git clone https://github.com/exercism/trackler.git
$ cd trackler
$ bin/bootstrap
```

## Terminology

Check out the [glossary][] for an overview of the important terms for Exercism, many
of which are used as class names in this codebase.

## Adding a New Language Track

To start a new language track, open an issue in the [request-new-language-track][] repository.

Once the repository exists, it can be added as a submodule here (using C++ as an example):

```
$ TRACK_ID=cpp; git submodule add https://github.com/exercism/$TRACK_ID.git tracks/$TRACK_ID
```

[submodule]: https://git-scm.com/book/en/v2/Git-Tools-Submodules
[tracks]: https://github.com/exercism/trackler/tree/master/tracks
[problem-specifications]: https://github.com/exercism/problem-specifications
[glossary]: https://github.com/exercism/docs/blob/master/glossary.md
[request-new-language-track]: https://github.com/exercism/request-new-language-track
