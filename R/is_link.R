##' Test for symlink
##'
##' Always false if symbolic links are not supported by the platform.
##' Returns \code{FALSE} for non-existent paths.
##'
##' @param paths Paths to test
##' @return Logical vector.
##'
##' @export
##' @examples
##' path_is_link(c(tempdir(), "/tmp/foo", NA_character_))
path_is_link <- function(paths) {
  ## This should be done more following the code here:
  ##   https://github.com/python-git/python/blob/master/Lib/stat.py
  is_link <- function(x) {
    info <- Sys.readlink(x)
    !(is.na(info) | info == "")
  }
  na_skip(paths, is_link)
}
