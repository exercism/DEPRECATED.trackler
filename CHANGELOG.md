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
