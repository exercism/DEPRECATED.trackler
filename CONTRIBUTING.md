# Contributing Guide

The exercises for each language are stored in separate repositories, included
here as git submodules under `./tracks`.

The common metadata which is shared between all the language tracks are also
included as a git submodule in `./common`.

## Terminology

* _Language_ - the name of a programming language, e.g. _C++_.
* _Track_ - a collection of exercises in a programming language.
* _Track ID_ - a url-friendly version of the language name, e.g. `cpp`.
* _Problem_ - a high-level, language-independent description of a problem to solve.
* _Implementation_ - a language-specific implementation of a problem. This contains at
  minimum a README and a test suite.

## Adding a New Language Track

To start a new language track, ask [Katrina](https://github.com/kytrinyx) to bootstrap a
repository for you.

Once the repository exists, it can be added as a submodule here (using C++ as an example):

```
$ TRACK_ID=cpp git submodule add https://github.com/exercism/x$TRACK_ID.git tracks/$TRACK_ID
```
