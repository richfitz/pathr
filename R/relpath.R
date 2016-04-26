
##' Relative filepath from a path to another
##'
##' Return a relative filepath to another path, either from the current
##' directory or from an optional start directory. This is a path
##' computation: the filesystem is not accessed to confirm the
##' existence or nature of path or start.
##'
##' @param path Character vector of paths.
##' @param start Start directory, character scalar. Defaults to
##'   the current working directory.
##'
##' @include posixpath.R
##' @export
##' @examples
##' path_rel("./bar/foo/bar", "/")
##' path_rel("./bar/foo/bar", "bar/baz/ize")
##' path_rel("./bar/foo/bar", "../../")

path_rel <- function(path, start = ".") {
  if (is_windows()) {
    win_path_rel(path, start)
  } else {
    posix_path_rel(path, start)
  }
}

posix_path_rel <- function(path, start = ".") {
  stopifnot(length(start) == 1)
  start <- drop_empty(strsplit(path_abs(start), "/")[[1]])
  vapply(path, posix_path_rel1, "", start = start, USE.NAMES = FALSE)
}

posix_path_rel1 <- function(path1, start) {

  path1 <- drop_empty(strsplit(path_abs(path1), "/")[[1]])

  i <- length(common_prefix(path1, start))

  rel_list <- c(
    rep(posix_pardir, length(start) - i),
    if (i == 0) path1 else tail(path1, -i)
  )

  if (length(rel_list) == 0) {
    "."
  } else {
    paste(rel_list, collapse = posix_sep)
  }
}

win_path_rel <- function(path, start = ".") {
  stopifnot(length(start) == 1)
  start <- path_abs(win_path_norm(start))
  vapply(path, win_path_rel1, "", start = start, USE.NAMES = FALSE)
}

win_path_rel1 <- function(path1, start) {
  sstart <- path_split_drive(start)
  start_drive <- sstart[[1]][1]
  start_rest <- sstart[[1]][2]

  path1 <- path_abs(win_path_norm(path1))
  spath1 <- path_split_drive(path1)
  path1_drive <- spath1[[1]][1]
  path1_rest <- spath1[[1]][2]

  if (normcase(start_drive) != normcase(path1_drive)) {
    stop(sprintf(
      "path is on mount %s, start on mount %s",
      path1_drive, start_drive
    ))
  }

  start_list <- drop_empty(strsplit(start_rest, "\\", fixed = TRUE)[[1]])
  path1_list <- drop_empty(strsplit(path1_rest, "\\", fixed = TRUE)[[1]])

  i <- length(common_prefix(normcase(start_list), normcase(path1_list)))

  rel_list <- c(
    rep("..", length(start_list) - i),
    if (i == 0) path1_list else tail(path1_list, -i)
  )

  if (length(rel_list) == 0) {
    "."
  } else {
    paste(rel_list, collapse = "\\")
  }
}
