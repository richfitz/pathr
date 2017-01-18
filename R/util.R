## To make things more like Python implementations, and to get some
## consistent behaviour with NA input.
os_stat <- function(files) {
  ok <- !is.na(files)
  if (all(ok)) {
    file.info(files)
  } else {
    ## This *does* make a mess of the rownames.
    m <- file.info(as.character(files[ok]))
    i <- rep(NA_integer_, length(files))
    i[ok] <- seq_len(nrow(m))
    m[i, ]
  }
}

na_screen <- function(x, screen) {
  x[is.na(screen)] <- NA
  x
}

## This needs generalising to different output types (matrix/vector)
## and input types (character, other).
na_skip <- function(x, f, ...) {

  ## NULL is special, cannot call is.na() on it, gives a warning
  if (is.null(x)) return(f(x, ...))

  ok <- !is.na(x)
  if (all(ok)) {
    f(x)
  } else {
    ret <- f(as.character(x[ok]), ...)
    i <- rep(NA_integer_, length(x))
    i[ok] <- seq_len(length(ret))
    ret[i]
  }
}

is_posix <- function() {
  .Platform$OS.type == "unix"
}

is_windows <- function() {
  Sys.info()[["sysname"]] == "Windows"
}

is_darwin <- function() {
  Sys.info()[["sysname"]] == "Darwin"
}

## TODO: Add warn=FALSE as default.
## TODO: vectorise.
file_remove <- function(path, recursive = FALSE) {
  exists <- file.exists(path)
  if (exists) {
    if (is_directory(path)) {
      if (recursive) {
        unlink(path, recursive)
      } else {
        stop("Use 'recursive = TRUE' to delete directories")
      }
    } else {
      file.remove(path)
    }
  }
  invisible(exists)
}

## TODO: This becomes path_isdir(), or at least aliased to it.
is_directory <- function(path) {
  file.info(path, extra_cols = FALSE)$isdir
}

startswith <- function(x, y) {
  substr(x, 1L, nchar(y)) == y
}

endswith <- function(x, y) {
  nx <- nchar(x)
  substr(x, nx - nchar(y) + 1L, nx) == y
}

drop_empty <- function(x) {
  x[nzchar(x)]
}

##' The longest prefix of both lists
##'
##' @param x First list.
##' @param y Second list.
##' @return List, longest common prefix of both.
##'
##' @keywords internal

common_prefix <- function(x, y) {

  ## l1 is the shorter list
  if (length(x) > length(y)) {
    l1 <- y
    l2 <- x
  } else {
    l1 <- x
    l2 <- y
  }

  for (i in seq_along(l1)) {
    if (!identical(l1[[i]], l2[[i]])) return(head(l1, i - 1))
  }
  l1
}

normcase <- function(x) {
  tolower(gsub("/", "\\", fixed = TRUE, x))
}

vcapply <- function(X, FUN, ...) {
  vapply(X, FUN, character(1), ...)
}

find_last_sep <- function(path, posix = TRUE, missing = 0) {
  re <- if (posix) ".*/(?!/)" else stop("FIXME")
  i <- regexpr(re, path, perl = TRUE)
  ret <- attr(i, "match.length")
  ret[i == -1] <- missing
  ret
}

strip_trailing_slash <- function(x) {
  sub("(?<=[^/])/+$", "", x, perl = TRUE)
}
