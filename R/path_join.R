path_join <- function(..., collapse = FALSE) {
  if (is_windows()) {
    windows_path_join(..., collapse = collapse)
  } else {
    posix_path_join(..., collapse = collapse)
  }
}

## An option is to do this as scalars if any component is an absolute
## path and is vectorised and is not _always_ absolute.  Otherwise we
## can skip ahead fairly easily.

## TODO: what should the behaviour be with NA values?  I don't think
## that they should make it through as the string "NA", which is what
## will happen if I don't do anything...
##
## Another option could be that paths that contain an NA value would
## be entirely NA, but we could use the empty string to indicate a
## path join failure and filter/test for that (as NA is currently
## treated)

## os.path.join(path, *paths)
##
##   Join one or more path components intelligently. The return value
##   is the concatenation of path and any members of *paths with
##   exactly one directory separator (os.sep) following each non-empty
##   part except the last, meaning that the result will only end in a
##   separator if the last part is empty. If a component is an
##   absolute path, all previous components are thrown away and
##   joining continues from the absolute path component.
##
##   On Windows, the drive letter is not reset when an absolute path
##   component (e.g., r'\foo') is encountered. If a component contains
##   a drive letter, all previous components are thrown away and the
##   drive letter is reset. Note that since there is a current
##   directory for each drive, os.path.join("c:", "foo") represents a
##   path relative to the current directory on drive C: (c:foo), not
##   c:\foo.
posix_path_join <- function(..., collapse = FALSE) {
  re_trailing_slash <- "(?<=[^/])/+"

  paths <- list(...)
  if (collapse) {
    stopifnot(length(paths) == 1L)
    paths <- paths[[1L]]
  }
  n <- length(paths)
  len <- lengths(paths)

  ok <- vlapply(paths, is.character)
  if (!all(ok)) {
    stop("All path elements must be character")
  }

  if (n == 0) {
    return(character(0))
  }

  if (all(len == 1L)) {
    p <- unlist(paths)
    if (anyNA(p)) {
      stop("'NA' path components are not allowed")
    }
    is_abs <- startswith(p, "/")
    if (any(is_abs)) {
      p <- p[seq.int(max(which(is_abs)), n)]
      n <- length(p)
    }
    j <- seq_len(n - 1L)
    p[j] <- sub(re_trailing_slash, "", p[j], perl = TRUE)
    paste(p, collapse = "/")
  } else {
    max_len <- max(len)
    if (!all(len == 1L | len == max_len)) {
      expected <- if (max_len == 1L) "1" else sprintf("1 or %d", max_len)
      stop("Invalid lengths; expected all lengths to be ", expected)
    }

    if (all(len == max_len)) {
      p <- matrix(unlist(paths, FALSE, FALSE), max_len, n)
    } else {
      p <- vapply(paths, rep_len, character(max_len), max_len)
    }

    is_abs <- startswith(p, "/")
    if (any(is_abs)) {
      f <- function(x) {
        i <- which(x)
        if (length(i) == 0) 0L else max(i) - 1L
      }
      j <- apply(is_abs, 1, f)
      p[cbind(rep(seq_along(j), j), sequence(j))] <- NA_character_
    }

    j <- seq_len(n - 1L)
    p[, j] <- sub(re_trailing_slash, "", p[, j], perl = TRUE)

    apply(p, 1, function(x) paste(x[!is.na(x)], collapse = "/"))
  }
}

windows_path_join <- function(...) {
  stop("FIXME")
}
