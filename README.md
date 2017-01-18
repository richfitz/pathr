# pathr

Port of Python's `os.path` module to R.  The aim is a fairly faithful transliteration with minimal extra features except for vectorisation and error handling.  That way, anyone familiar with the Python module can immediately start using the package.

On the other hand, there is sufficient semantic gap between python and R that a direct transliteration could be confusing for users.  Vectorisation and missing value handling for example are totally different, and need to be handled consistently.

Then there are things like `commonprefix` that are basically broken in Python that we'd probably want to implement a fixed version of.  And there are behaviours in normcase/normpath that we'd possibly not want to mimic exactly (such as changing slack direction and not correcting case on macOS).

## Status

The names here (immediately by the checkboxes) are the python names for the functions

* [ ] `normcase`
* [ ] `isabs`
* [ ] `join`
* [x] `splitdrive` - as `path_split_drive`
* [ ] `split `
* [ ] `splitext`
* [ ] `basename`
* [ ] `dirname`
* [ ] `commonprefix`
* [ ] `getsize`
* [ ] `getmtime`
* [ ] `getatime`
* [ ] `getctime`
* [ ] `islink`
* [ ] `exists`
* [ ] `lexists`
* [x] `isdir` - as `path_is_directory`
* [ ] `isfile`
* [ ] `ismount`
* [ ] `walk`
* [ ] `expanduser`
* [ ] `expandvars`
* [x] `normpath` - as `path_norm`
* [x] `abspath` - as `path_abs`
* [ ] `samefile`
* [ ] `sameopenfile`
* [ ] `samestat`
* [ ] `curdir`
* [ ] `pardir`
* [ ] `sep`
* [ ] `pathsep`
* [ ] `defpath`
* [ ] `altsep`
* [ ] `extsep`
* [ ] `devnull`
* [ ] `realpath`
* [ ] `supports_unicode_filenames`
* [x] `relpath` - as `path_rel`

## Design

In the Python implementation, POSIX and Windows paths are treated separately.  We want to continue this, but (to the extent that things don't rely on calling back to the underlying OS) allow path manipulations to simulate a different operating system (so while on Linux, construct and manipulate windows paths).  I'm not sure how best to expose this

## Documentation

Every file should have a section indicating which python function they are descended from and how they differ

## Other

* abbreviations (dir, norm, rel) or full words (directory, normalise, relative); all the functions should have the same approach here
* organisation of the posix code - at present things slightly mimic the python version, but I'm going to roll the posix/windows bit together and split by function instead I think
* harmonise treatment of NA values.  There are two approaches scattered through the functions - using `na_skip` which splits the processing into NA bits and non-NA bits, and manual indexing.  I'd be surprised if there was a big speed difference between the two approaches but it's not clear which is easier to understand.  For functions that return lists rather than vectors, the NA handling needs to be quite different.
