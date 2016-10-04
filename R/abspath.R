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
  res <- path

  na  <- is.na(path)
  abs <- path_isabs(path)
  res[!abs & !na] <- file.path(getwd(), path[!abs & !na])

  res[!na] <- path_norm(res[!na])

  res
}
