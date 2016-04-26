
#' @include posixpath.R winpath.R
NULL

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
  if (is_windows()) {
    win_path_norm(path)
  } else {
    posix_path_norm(path)
  }
}

win_path_norm <- function(path) {
  vapply(path, win_path_norm1, "", USE.NAMES = FALSE)
}

posix_path_norm <- function(path) {
  vapply(path, posix_path_norm1, "", USE.NAMES = FALSE)
}

posix_path_norm1 <- function(path1) {

  if (path1 == "") return(".")
  if (is.na(path1)) return(NA_character_)

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

  ## in the case of paths with these prefixes:
  ## \\.\ -> device names
  ## \\?\ -> literal paths
  ## do not do any normalization, but return the path unchanged
  if (startswith(path1, "\\\\.\\") ||
      startswith(path1, "\\\\?\\")) return(path1)

  path1 <- gsub("/", "\\", path1, fixed = TRUE)
  spl <- path_split_drive1(path1)
  prefix <- spl[1]
  path1 <- spl[2]

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

##' Split a pathname into drive/UNC sharepoint and relative path specifiers
##'
##' Returns a list with 2 element character vectors: drive/UNC and path,
##' either part may be empty string.
##'
##' It always holds that \code{paste0(output[1], output[2]) == input}.
##'
##' If the path contained a drive letter, the drive/UNC part will contain
##' everything up to and including the colon. E.g.
##' \code{path_split_drive("c:/dir")} returns \code{list(c("c:", "/dir"))}.
##'
##' If the path contained a UNC path, the drive/UNC will contain the host
##' name and share up to but not including the fourth directory separator
##' character. E.g. \code{path_split_drive("//host/computer/dir")} returns
##' \code{list(c("//host/computer", "/dir"))}.
##'
##' Paths cannot contain both a drive letter and a UNC path.
##'
##' @param path Character vector.
##' @return List of character vectors of length two. The first elements
##'   contain the drive letters or UNC paths, the second elements the
##'   relative paths.
##'
##' @export
##' @examples
##' path_split_drive(c("c:/Rtools/bin", "\\\\machine\\share\\folder"))

path_split_drive <- function(path) {
  lapply(path, path_split_drive1)
}

path_split_drive1 <- function(path1) {
  npath1 <- gsub("/", "\\", path1, fixed = TRUE)
  if (startswith(npath1, "\\\\") && substr(npath1, 3, 3) != "\\") {
    if (grepl("^\\\\\\\\[^\\\\]+\\\\[^\\\\]+.*$", npath1)) {
      nunc <- sub("^(\\\\\\\\[^\\\\]+\\\\[^\\\\]+).*$", "\\1", npath1)
    } else {
      nunc <- ""
    }
    c(substr(path1, 1, nchar(nunc)),
      substr(path1, nchar(nunc) + 1, nchar(path1)))

  } else if (substr(npath1, 2, 2) == ":") {
    c(substr(path1, 1, 2), substr(path1, 3, nchar(path1)))

  } else {
    c("", path1)
  }
}
