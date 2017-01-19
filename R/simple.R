## Simple functions, based on directly wrapping base R functions.
## Pulling these out a bit until I can decide on better organisation

##' Base name of pathname path
##'
##' The result is the same as for \code{\link[base]{basename}},
##' and this function is only included here for completeness.
##'
##' Note that this is different from the Python \code{os.path.basename}
##' function, Python always returns a file name or an empty string,
##' i.e. \code{os.path.basename('/foo/bar/')} is \code{''}. In R
##' \code{path_basename("/foo/bar/")} is \code{"bar"}.
##'
##' @param path Character vector of paths.
##' @return Character vector of base names.
##'
##' @seealso \code{\link{path_dirname}}
##'
##' @export
##' @examples
##' path_basename(c("/foo/bar", "/foo/bar/", ".", "foo/bar.c"))
path_basename <- function(path) {
  base::basename(path)
}

##' Directory name of a path
##'
##' Return the directory name of pathname path.
##' The result is the same as for \code{\link[base]{dirname}},
##' and this function is only included here for completeness.
##'
##' @param path Character vector of paths.
##' @return Character vector of directory names.
##'
##' @seealso \code{\link{path_basename}}
##'
##' @export
##' @examples
##' path_dirname(c("/foo/bar", "/foo/bar/", ".", "foo/bar.c", "~"))
path_dirname <- function(path) {
  base::dirname(path)
}

## os.path.getatime(path)
##
##   Return the time of last access of path. The return value is a
##   number giving the number of seconds since the epoch (see the time
##   module). Raise os.error if the file does not exist or is
##   inaccessible.
##
##   Changed in version 2.3: If os.stat_float_times() returns True,
##   the result is a floating point number.
path_getatime <- function(path) {
  os_stat(path)$atime
}

## os.path.getmtime(path)
##
##   Return the time of last modification of path. The return value is
##   a number giving the number of seconds since the epoch (see the
##   time module). Raise os.error if the file does not exist or is
##   inaccessible.
##
##   Changed in version 2.3: If os.stat_float_times() returns True,
##   the result is a floating point number.
path_getmtime <- function(path) {
  os_stat(path)$mtime
}

## os.path.getctime(path)
##
##   Return the system’s ctime which, on some systems (like Unix) is
##   the time of the last metadata change, and, on others (like
##   Windows), is the creation time for path. The return value is a
##   number giving the number of seconds since the epoch (see the time
##   module). Raise os.error if the file does not exist or is
##   inaccessible.
path_getctime <- function(path) {
  os_stat(path)$ctime
}

## os.path.getsize(path)
##
##   Return the size, in bytes, of path. Raise os.error if the file
##   does not exist or is inaccessible.
##
## NOTE: What is correct error behaviour here?
path_getsize <- function(files) {
  os_stat(files)$size
}
