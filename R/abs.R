##' Normalized, absolutized paths
##'
##' Return a normalized absolutized version of the pathname path. On
##' most platforms, this is equivalent to calling the function
##' \code{\link{path_norm}} as follows:
##' \code{path_norm(file.path(getwd(), path))}.
##'
##' Note that unlike \code{\link{normalizePath}}, the absolute path
##' need not exist yet.
##'
##' @param path Character vector.
##' @return Character vector.
##'
##' @export
##' @examples
##' path_abs(c("foo/bar", "foo/..", "/root/dir"))
path_abs <- function(path) {
  if (is_windows()) {
    windows_path_abs(path)
  } else {
    posix_path_abs(path)
  }
}

windows_path_abs <- function(path) {
  do_path_abs(path, TRUE)
}

posix_path_abs <- function(path) {
  do_path_abs(path, FALSE)
}

do_path_abs <- function(path, as_windows) {
  res <- path
  na  <- is.na(path)
  if (as_windows) {
    p_is_abs <- windows_path_is_abs
    p_norm <- win_path_norm
  } else {
    p_is_abs <- posix_path_is_abs
    p_norm <- posix_path_norm
  }
  abs <- p_is_abs(path)
  i <- !abs & !na
  if (any(i)) {
    if (as_windows != is_windows()) {
      if (as_windows) {
        stop_wrong_platform("path_abs", "windows", "posix")
      } else {
        stop_wrong_platform("path_abs", "posix", "windows")
      }
    }
    res[i] <- p_norm(file.path(getwd(), path[!abs & !na]))
  }
  j <- abs & !na
  res[j] <- p_norm(res[j])
  res
}
