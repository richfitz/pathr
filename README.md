# pathr

Port of Python's `os.path` module to R.  The aim is a fairly faithful transliteration with minimal extra features except for vectorisation and error handling.  That way, anyone familiar with the Python module can immediately start using the package.

On the other hand, there is sufficient semantic gap between python and R that a direct transliteration could be confusing for users.  Vectorisation and missing value handling for example are totally different, and need to be handled consistently.

Then there are things like `commonprefix` that are basically broken in Python that we'd probably want to implement a fixed version of.  And there are behaviours in normcase/normpath that we'd possibly not want to mimic exactly (such as changing slack direction and not correcting case on macOS).

## Status

The names here (immediately by the checkboxes) are the python names for the functions

* [ ] `commonprefix` - as `path_common_prefix` - (windows version to come)
* [ ] `ismount` - as `path_is_mount` - (windows version to come)
* [ ] `join` - as `path_path_join` - (windows version to come)
* [x] `normcase` - as `path_norm_case`, but modifications to come...
* [ ] `realpath`
* [ ] `samefile`
* [ ] `sameopenfile`
* [ ] `samestat`
* [ ] `split` - as `path_split` (windows version to come)
* [x] `splitext` - as `path_split_ext`
* [ ] `splitunc`
* [ ] `walk` (deprecated in python3 in favour of os.walk)
* [x] `abspath` - as `path_abs`
* [x] `basename` - as `path_basename` (trivial)
* [x] `dirname` - as `path_dirname` (trivial)
* [x] `exists` - as `path_exists`
* [x] `expanduser` - as `path_expand_user` (simple)
* [x] `expandvars` - as `path_expand_vars`
* [x] `getatime` - as `path_getatime` (consider rename)
* [x] `getctime` - as `path_getctime` (consider rename)
* [x] `getmtime` - as `path_getmtime` (consider rename)
* [x] `getsize` - as `path_getsize` (consider rename)
* [x] `isabs` - as `path_is_abs`
* [x] `isdir` - as `path_is_directory`
* [x] `isfile` - as `path_is_file`
* [x] `islink` - as `path_is_link`
* [x] `lexists` - as `path_lexists`
* [x] `normpath` - as `path_norm`
* [x] `relpath` - as `path_rel`
* [x] `splitdrive` - as `path_split_drive`

The python module also provides constants

* [ ] `altsep`
* [ ] `curdir`
* [ ] `defpath`
* [ ] `devnull`
* [ ] `extsep`
* [ ] `pardir`
* [ ] `pathsep`
* [ ] `sep`
* [ ] `supports_unicode_filenames`

But it's not clear how these should be provided.  I'd think that upper-case would be more typical for R? (e.g., pathr::CURDIR)

## Design

In the Python implementation, POSIX and Windows paths are treated separately.  We want to continue this, but (to the extent that things don't rely on calling back to the underlying OS) allow path manipulations to simulate a different operating system (so while on Linux, construct and manipulate windows paths).  I'm not sure how best to expose this

Unlike the python version, I think that something that recognises that path handling is different on OSX to traditional POSIX would be useful (particularly around handling of normalised cases, given that OSX is case insensitive but case *preserving*).  Windows is similar in this regard, so I'll need to work that logic through anyway.

## Documentation

Every file should have a section indicating which python function they are descended from and how they differ

Should also document if they can be made to work on the other platform (i.e., where we are using OS-level tools vs plain path calculations).

## Other

* abbreviations (dir, norm, rel) or full words (directory, normalise, relative); all the functions should have the same approach here
  - path_rel
  - path_lexists
  - path_dirname
  - path_expand_vars (variables?, envvar?)
* organisation of the posix code - at present things slightly mimic the python version, but I'm going to roll the posix/windows bit together and split by function instead I think
  - changed tack here and started splitting things out by function.  This leads to a cluttered R/ directory but is helping me work out what is what.  These are likely to get joined together in the medium term
* harmonise treatment of NA values.  There are two approaches scattered through the functions - using `na_skip` which splits the processing into NA bits and non-NA bits, and manual indexing.  I'd be surprised if there was a big speed difference between the two approaches but it's not clear which is easier to understand.  For functions that return lists rather than vectors, the NA handling needs to be quite different.
* distinguish between functions that *only* run on windows/unix (i.e., that use underlying filesystem tools) and functions that do path computations following windows/unix conventions.  The latter will be restricted by platform, the former should be available on other platforms

* Common

* Computational
  - path_join
  - path_common_prefix
  - path_normcase
  - path_split*

* System dependent
  - path_real_path (? - could go through normalizePath)
  - path_same_*

# Extensions

* Add the pwd module bits back in (posix only)
* Get getmntinfo (darwin) and getmntent (linux) working.  Not sure about other platforms - could probably just punt on them; this will be useful for didewin.  On windows, parse the output of running the system command, unless there is a windows API call I can use.

# Work still needed

- [ ] path_rel.R
- [ ] normalise.R
