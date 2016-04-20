posix_curdir <- '.'
posix_pardir <- '..'
posix_extsep <- '.'
posix_sep <- '/'
posix_pathsep <- ':'
posix_defpath <- ':/bin:/usr/bin'
posix_altsep <- NULL
posix_devnull <- '/dev/null'

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
  path
}

## os.path.join(path, *paths)
##
##   Join one or more path components intelligently. The return value
##   is the concatenation of path and any members of *paths with
##   exactly one directory separator (os.sep) following each non-empty
##   part except the last, meaning that the result will only end in a
##   separator if the last part is empty. If a component is an
##   absolute path, all previous components are thrown away and
##   joining continues from the absolute path component.
##
##   On Windows, the drive letter is not reset when an absolute path
##   component (e.g., r'\foo') is encountered. If a component contains
##   a drive letter, all previous components are thrown away and the
##   drive letter is reset. Note that since there is a current
##   directory for each drive, os.path.join("c:", "foo") represents a
##   path relative to the current directory on drive C: (c:foo), not
##   c:\foo.
##
## from posixpath.py
##
##   Join pathnames.
##   Ignore the previous parts if a part is absolute.
##   Insert a '/' unless the first part is empty or already ends in '/'.
## posix_path_join <- function(...) {
## """Join two or more pathname components, inserting '/' as needed.
## If any component is an absolute path, all previous path components
## will be discarded."""
## path = a
## for b in p:
##     if b.startswith('/'):
##         path = b
##     elif path == '' or path.endswith('/'):
##         path +=  b
##     else:
##         path += '/' + b
## return path
## }
##
## This one is nasty to deal with recycling; need to check this
## carefully


## from posixpath.py:
##
##   Split a path in head (everything up to the last '/') and tail
##   (the rest).  If the path ends in '/', tail will be empty.  If
##   there is no '/' in the path, head will be empty.  Trailing '/'es
##   are stripped from head unless it is the root.
posix_path_split <- function(paths) {

}
