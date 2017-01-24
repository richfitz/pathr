posix_curdir <- '.'
posix_pardir <- '..'
posix_extsep <- '.'
posix_sep <- '/'
posix_pathsep <- ':'
posix_defpath <- ':/bin:/usr/bin'
posix_altsep <- NULL
posix_devnull <- '/dev/null'
posix_supports_unicode_filenames <- FALSE

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
posix_path_normcase <- function(path) {
  if (is_darwin()) {
    tolower(path)
  } else {
    path
  }
}
