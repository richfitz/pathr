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
    if (path_is_directory(path)) {
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

vlapply <- function(X, FUN, ...) {
  vapply(X, FUN, logical(1), ...)
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

reasonable_path <- function(path) {
  if (is.character(path)) {
    path
  } else if (is.null(path)) {
    character(0)
  } else if (all(is.na(path))) {
    rep(NA_character_, length(path))
  } else {
    stop("Invalid input for path")
  }
}

regexp_find_all <- function(re, x) {
  i <- regexpr(re, x)
  ## TODO: this *does* need width carried forward with it, because
  ## when we split the path that's what this is going to work with.
  if (i > 0L) {
    len_x <- nchar(x)
    len_m <- attr(i, "match.length")
    j <- i + len_m
    if (j <= len_x) {
      rest <- regexp_find_all(re, substr(x, j, len_x))
      list(start = c(i, i + len_m - 1L + rest$start),
           length = c(len_m, rest$length))
    } else {
      list(start = as.integer(i), length = len_m)
    }
  } else {
    list(start = integer(0), length = integer(0))
  }
}

strsplit_at <- function(x, br, len) {
  br1 <- c(0L, br + len)
  len1 <- c(len, nchar(x))
  vcapply(seq_along(br1), function(i)
    substr(x, br1[[i]], br1[[i]] + len1[[i]]))
}
