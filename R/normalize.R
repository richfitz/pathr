##' Normalize a pathname
##'
##' Normalize a pathname by collapsing redundant separators and
##' up-level references so that \code{A//B}, \code{A/B/}, \code{A/./B} and
##' \code{A/foo/../B} all become \code{A/B}. This string manipulation may
##' change the meaning of a path that contains symbolic links.
##'
##' On Windows, it converts forward slashes to backward slashes.
##'
##' @param path Character vector of paths.
##' @return Character vector of normalized paths.
##'
##' @export
##' @examples
##' path_norm(c("A//B", "A/B/", "A/./B", "A/foo/../B"))

path_norm <- function(path) {
  ## Something like passing in windows = NULL and testing windows %||%
  ## is_windows() would allow for more easily simulating different
  ## path access on different platforms.
  if (is_windows()) {
    win_path_norm(path)
  } else {
    posix_path_norm(path)
  }
}

win_path_norm <- function(path) {
  vcapply(path, win_path_norm1, USE.NAMES = FALSE)
}

posix_path_norm <- function(path) {
  vcapply(path, posix_path_norm1, USE.NAMES = FALSE)
}

posix_path_norm1 <- function(path1) {
  if (is.na(path1)) return(NA_character_)
  if (path1 == "") return(".")

  initial_slashes <- as.integer(startswith(path1, "/"))

  ## POSIX allows one or two initial slashes, but treats three or more
  ## as single slash.
  if (initial_slashes && startswith(path1, "//") &&
      !startswith(path1, "///")) {
    initial_slashes <- 2
  }

  comps <- strsplit(path1, "/")[[1]]
  new_comps <- character()

  for (comp in comps) {

    if (comp == "" || comp == ".") {
      ## nothing to do

    } else if (comp != posix_pardir ||
        (! initial_slashes && length(new_comps) == 0) ||
        (length(new_comps) > 0 && tail(new_comps, 1) == posix_pardir)) {
      new_comps <- c(new_comps, comp)

    } else {
      new_comps <- head(new_comps, -1)
    }
  }

  res <- paste(new_comps, collapse = "/")
  if (initial_slashes) {
    res <- paste0(c(rep("/", initial_slashes), res), collapse = "")
  }

  if (res != "") res else "."
}


win_path_norm1 <- function(path1) {
  if (is.na(path1)) return(NA_character_)

  ## in the case of paths with these prefixes:
  ## \\.\ -> device names
  ## \\?\ -> literal paths
  ## do not do any normalization, but return the path unchanged
  if (startswith(path1, "\\\\.\\") ||
      startswith(path1, "\\\\?\\")) return(path1)

  path1 <- gsub("/", "\\", path1, fixed = TRUE)
  spl <- windows_path_split_drive(path1)
  prefix <- spl[[1]]
  path1 <- spl[[2]]

  ## Collapse initial backslashes
  if (startswith(path1, "\\")) {
    prefix <- paste0(prefix, "\\")
    path1 <- substr(path1, 2, nchar(path1))
  }

  comps <- as.list(strsplit(path1, "\\", fixed = TRUE)[[1]])

  i <- 1
  while (i <= length(comps)) {

    if (comps[[i]] == "" || comps[[i]] == ".") {
      comps[[i]] <- NULL

    } else if (comps[[i]] == win_pardir) {
      if (i > 1 && comps[[i - 1]] != win_pardir) {
        comps[[i - 1]] <- NULL
        comps[[i - 1]] <- NULL
        i <- i - 1
      } else if (i == 1 && endswith(prefix, "\\")) {
        comps[[i]] <- NULL
      } else {
        i <- i + 1
      }

    } else {
      i <- i + 1
    }
  }

  if (prefix == "" && length(comps) == 0) comps <- "."

  paste0(prefix, paste(unlist(comps), collapse = "\\"))
}
