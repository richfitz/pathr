##' Test for symlink
##'
##' Always false if symbolic links are not supported by the platform.
##' Returns \code{FALSE} for non-existent paths.
##'
##' @param path Paths to test
##' @return Logical vector.
##'
##' @export
##' @examples
##' path_is_link(c(tempdir(), "/tmp/foo", NA_character_))
path_is_link <- function(path, absent_is_false = TRUE) {
  if (is_windows()) {
    windows_path_is_link(path, absent_is_false)
  } else {
    posix_path_is_link(path, absent_is_false)
  }
}

windows_path_is_link <- function(path, absent_is_false = TRUE) {
  present <- file.exists(path)
  ret <- rep(FALSE, length(path))
  ret[is.na(path)] <- NA
  if (!absent_is_false) {
    ret[!file.exists(path)] <- NA
  }
  ret
}

posix_path_is_link <- function(path, absent_is_false = TRUE) {
  ## This should be done more following the code here:
  ##   https://github.com/python-git/python/blob/master/Lib/stat.py
  ## TODO: now that we have stat support, do this via the C code, I think.
  is_link <- function(x) {
    info <- Sys.readlink(x)
    !(is.na(info) | info == "")
  }
  na_skip(path, is_link)
}
