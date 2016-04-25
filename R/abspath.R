
##' Normalized, absolutized paths
##'
##' Return a normalized absolutized version of the pathname path. On
##' most platforms, this is equivalent to calling the function
##' \code{\link{path_norm}} as follows:
##' \code{path_norm(file.path(getwd(), path))}.
##'
##' @param path Character vector.
##' @return Character vector.
##'
##' @export
##' @examples
##' path_absolute(c("foo/bar", "foo/..", "/root/dir"))

path_abs <- function(path) {
  res <- path

  abs <- path_isabs(path)
  res[!abs] <- file.path(getwd(), path[!abs])

  path_norm(res)
}
