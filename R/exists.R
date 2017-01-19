##' Test if path exists
##'
##' Returns \code{FALSE} for broken symbolic links. On some platforms, this
##' function may return \code{FALSE} if permission is not granted to execute
##' the \code{fstat} system call on the requested file, even if the
##' path physically exists.
##'
##' @param paths Vector of paths to test
##' @return Logical vector.
##'
##' @export
##' @examples
##' path_exists(c('/tmp/foobar', tempdir(), NA))
path_exists <- function(paths) {
  ## TODO: determine and document the difference between this and
  ## file.exists(); it looks like file.exists()
  if (is.null(paths)) {
    stop("invalid 'file' argument")
  }
  stat <- os_stat(paths)
  na_screen(!is.na(stat$size), paths)
}

## os.path.lexists(path)
##
##   Return True if path refers to an existing path. Returns True for
##   broken symbolic links. Equivalent to exists() on platforms
##   lacking os.lstat().
##' @export
##' @rdname path_exists
path_lexists <- function(paths) {
  path_exists(paths) | path_is_link(paths)
}
