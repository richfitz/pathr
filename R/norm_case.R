## os.path.normcase(path)
##
##   Normalize the case of a pathname. On Unix and Mac OS X, this
##   returns the path unchanged; on case-insensitive filesystems, it
##   converts the path to lowercase. On Windows, it also converts
##   forward slashes to backward slashes.
##
## From posixpath.py:
##
##   Normalize the case of a pathname.  Trivial in Posix, string.lower
##   on Mac.  On MS-DOS this may also turn slashes into backslashes;
##   however, other normalizations (such as optimizing '../' away) are
##   not allowed (another function should be defined to do that).

## TODO: There are a few options worth exposing here (and it's a bit
## tricky to know how best to handle these)
##
## * on windows, do we standardise paths as foreward or backslashes?
## * should we collapse multiple consecutive separators
## * on case preserving filesystems should we make files match the correct filename, where a file exists?

## For now, this is implemented as described in the Python module, but
## I think we'll revisit this.  It's quite likely that some of the
## additional things to consider will be better done in path_norm()

## Unlike the Python version, I'm not sure that we should lower the
## case on mac.  Though the appropriate behaviour here depends
## somewhat on the *intent* of this function; the idea is not to
## create a canonical set of names, but to create a set of names that
## can be fed into things like path_common_prefix, path_relative, etc;
## so that names that are equivalent translate approriately.

path_norm_case <- function(path) {
  if (is_windows()) {
    windows_path_norm_case(path)
  } else {
    posix_path_norm_case(path)
  }
}

## TODO: The darwin bit needs to be able to be controlled from outside
## of this function I suspect.
posix_path_norm_case <- function(path) {
  if (is_darwin()) {
    tolower(path)
  } else {
    path
  }
}

windows_path_norm_case <- function(path) {
  tolower(gsub("/", "\\", fixed = TRUE, path))
}
