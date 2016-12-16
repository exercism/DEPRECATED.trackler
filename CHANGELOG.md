# Change log

The Trackler gem almost follows [semantic versioning](http://semver.org/).

We've added a forth level, which tracks content. It gets bumped each time we
update the submodules.

      1   .   0   .   0   .   0
    MAJOR   MINOR   PATCH   CONTENT

The changelog will not be updated for content updates.

----------------

## Next Release
* **Your contribution here**

## v2.0.5.0 (2016-12-16)

* Handle full URLs as documentation images

## v2.0.4.0 (2016-12-16)

* Make documentation image paths configurable

## v2.0.3.0 (2016-11-29)

* Remove test fixture that breaks x-api

## v2.0.2.0 (2016-11-29)

* Add support for SVG icons by default

## v2.0.1.0 (2016-11-25)

* Make track documentation accessible via messages.

## v2.0.0.0 (2016-10-22)

* Fix domain concept confusion on Tracks. **Backwards incompatible**

## v1.0.4.0 (2016-10-21)

* Provide a list of unimplemented exercises for a track

## v1.0.3.0 (2016-10-21)

* Add more granular states for track state

## v1.0.2.0 (2016-10-17)

* Add script to update submodules and bump version
* Invalidate the data caches when switching track data path

## v1.0.1.0 (2016-10-16)

Make the location of the track data configurable so we can use fixture
data for the x-api and exercism.io tests.

## v1.0.0.0 (2016-10-03)

This is an extraction of the tracks, problems, and implementations logic
from [x-api][xapi].

[xapi]: https://github.com/exercism/x-api
