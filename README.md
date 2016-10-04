# pathr

Port of Python's `os.path` module to R.  The aim is a fairly faithful transliteration with minimal extra features except for vectorisation and error handling.  That way, anyone familiar with the Python module can immediately start using the package.

On the other hand, there is sufficient semantic gap between python and R that a direct transliteration could be confusing for users.  Vectorisation and missing value handling for example are totally different.  Then there are things like `commonprefix` that are basically broken in Python that we'd probably want to implement a fixed version of.

## Status

* [ ] `normcase`
* [ ] `isabs`
* [ ] `join`
* [ ] `splitdrive`
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
* [ ] `isdir`
* [ ] `isfile`
* [ ] `ismount`
* [ ] `walk`
* [ ] `expanduser`
* [ ] `expandvars`
* [ ] `normpath`
* [ ] `abspath`
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
* [ ] `relpath`
