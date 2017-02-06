##' Relative filepath from a path to another
##'
##' Return a relative filepath to another path, either from the current
##' directory or from an optional start directory. This is a path
##' computation: the filesystem is not accessed to confirm the
##' existence or nature of path or start.
##'
##' @param path Character vector of paths.
##'
##' @param start Start directory, character scalar. Defaults to
##'   the current working directory.
##'
##' @export
##' @examples
##' path_rel("./bar/foo/bar", "/")
##' path_rel("./bar/foo/bar", "bar/baz/ize")
##' path_rel("./bar/foo/bar", "../../")
path_rel <- function(path, start = ".") {
  if (is_windows()) {
    windows_path_rel(path, start)
  } else {
    posix_path_rel(path, start)
  }
}

posix_path_rel <- function(path, start = ".") {
  assert_scalar_character(start)
  if (is.na(start)) {
    rep_len(NA_character_, length(path))
  } else {
    start <- drop_empty(strsplit(path_abs(start), "/")[[1L]])
    vapply(path, posix_path_rel1, "", start = start, USE.NAMES = FALSE)
  }
}

posix_path_rel1 <- function(path1, start) {
  if (is.na(path1)) {
    return(NA_character_)
  }

  path1 <- drop_empty(strsplit(path_abs(path1), "/")[[1L]])

  i <- length(common_prefix(path1, start))

  rel_list <- c(
    rep_len(posix_pardir, length(start) - i),
    if (i == 0) path1 else tail(path1, -i)
  )

  if (length(rel_list) == 0) {
    "."
  } else {
    paste(rel_list, collapse = posix_sep)
  }
}

windows_path_rel <- function(path, start = ".") {
  assert_scalar_character(start)
  if (is.na(start)) {
    rep_len(NA_character_, length(path))
  } else {
    ## In contrast with the POSIX version, we will have to check that
    ## the paths _can_ be relativised; they must be on the same drive
    ## (alternatively, we could make it that would leave the paths as
    ## absolute paths, which might be a nicer behaviour anyway - and
    ## consistent to some degree with the POSIX approach of some paths
    ## relativising beginning with '/')

    start <- windows_path_abs(win_path_norm(start))
    sstart <- windows_path_split_drive(start)
    start_drive <- sstart$drive
    start_rest <- sstart$path
    start_list <- drop_empty(strsplit(start_rest, "\\", fixed = TRUE)[[1L]])

    path1 <- windows_path_abs(win_path_norm(path))
    spath1 <- windows_path_split_drive(path1)
    path1_drive <- spath1[[1L]]
    path1_rest <- spath1[[2L]]

    err <- !is.na(path1_drive) &
      windows_path_norm_case(start_drive) !=
      windows_path_norm_case(path1_drive)
    if (any(err)) {
      ## TODO: test with > 1 error case
      stop(sprintf("path is on mount %s, start on mount %s",
                   paste(path1_drive[err], collapse = ", "), start_drive))
    }

    path1_list <- strsplit(path1_rest, "\\", fixed = TRUE)

    start_list_norm <- windows_path_norm_case(start_list)

    resolve1 <- function(x) {
      x <- drop_empty(x)
      i <- length(common_prefix(start_list_norm, windows_path_norm_case(x)))

      rel_list <- c(
        rep_len("..", length(start_list) - i),
        if (i == 0) x else tail(x, -i)
      )
      if (length(rel_list) == 0) {
        "."
      } else {
        paste(rel_list, collapse = "\\")
      }
    }

    i <- !is.na(path)
    path[i] <- vcapply(path1_list[i], resolve1, USE.NAMES = FALSE)
    path
  }
}

## TODO: this is one case where we should be careful about what
## direction slashes should go.  I think that having an option to
## control this might be one option (e.g.,
## pathr.windows_forward_slash) though that involves hitting the
## options cache every time.  I don't really want direct arguments to
## functions because then they end up uselessly in the POSIX ones (or
## we do things with '...')
windows_path_rel1 <- function(path1, start_drive, start_path, start_list) {
  if (is.na(path1)) {
    return(NA_character_)
  }

  path1 <- path_abs(win_path_norm(path1))
  spath1 <- windows_path_split_drive(path1)
  path1_drive <- spath1[[1L]]
  path1_rest <- spath1[[2L]]

  if (windows_path_norm_case(start_drive) !=
      windows_path_norm_case(path1_drive)) {
    stop(sprintf("path is on mount %s, start on mount %s",
                 path1_drive, start_drive))
  }

  path1_list <- drop_empty(strsplit(path1_rest, "\\", fixed = TRUE)[[1L]])

  i <- length(common_prefix(windows_path_norm_case(start_list),
                            windows_path_norm_case(path1_list)))

  rel_list <- c(
    rep_len("..", length(start_list) - i),
    if (i == 0) path1_list else tail(path1_list, -i)
  )

  if (length(rel_list) == 0) {
    "."
  } else {
    paste(rel_list, collapse = "\\")
  }
}
