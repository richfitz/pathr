##' Split a pathname into drive/UNC sharepoint and relative path specifiers
##'
##' Returns a 2 element list with character vectors: drive/UNC and
##' path, either part may contain empty strings ("") but both will
##' have the same length as the input.
##'
##' It always holds that \code{paste0(output[1], output[2]) == input}
##' (note that this means that the path part is an \emph{absolute}
##' path, including a leading slash, when a drive or UNC mountpoint is
##' present).
##'
##' If the path contained a drive letter, the drive/UNC part will contain
##' everything up to and including the colon. E.g.
##' \code{path_split_drive("c:/dir")} returns
##' \code{list(drive = "c:", path = "/dir")}.
##'
##' If the path contained a UNC path, the drive/UNC will contain the host
##' name and share up to but not including the fourth directory separator
##' character. E.g. \code{path_split_drive("//host/computer/dir")} returns
##' \code{list(drive = "//host/computer", path = "/dir")}.
##'
##' Paths cannot contain both a drive letter and a UNC path.
##'
##' Note that this differs from the Python \code{os.path} module in
##' that UNC parts are considered drives here.
##'
##' @param path Character vector.
##' @return List of character vectors of length two. The first elements
##'   contain the drive letters or UNC paths, the second elements the
##'   relative paths.
##'
##' @export
##' @examples
##' # path_split_drive(c("c:/Rtools/bin", "\\\\machine\\share\\folder"))
path_split_drive <- function(path) {
  if (is_windows()) {
    windows_path_split_drive(path)
  } else {
    posix_path_split_drive(path)
  }
}

## Split a pathname into a drive specification and the rest of the
## path.  Useful on DOS/Windows/NT; on Unix, the drive is always
## empty.
posix_path_split_drive <- function(path) {
  list(drive = na_skip(path, function(x) rep_len("", length(x))),
       path = na_skip(path, identity))
}

windows_path_split_drive <- function(path) {
  ## TODO: make it optional that unc paths are considered drives?
  ## That would make the treatment of this easier...
  npath <- gsub("/", "\\", path, fixed = TRUE)

  drive <- subpath <- character(length(path))
  na <- is.na(path)
  drive[na] <- subpath[na] <- NA_character_

  i <- !na & startswith(npath, "\\\\") & substr(npath, 3, 3) != "\\"
  nunc <-
    ifelse(grepl("^\\\\\\\\[^\\\\]+\\\\[^\\\\]+.*$", npath[i]),
           nchar(sub("^(\\\\\\\\[^\\\\]+\\\\[^\\\\]+).*$", "\\1", npath[i])),
           0L)
  drive[i] <- substr(path[i], 1L, nunc)
  subpath[i] <- substr(path[i], nunc + 1L, nchar(path[i]))

  j <- !na & !i & substr(npath, 2L, 2L) == ":"
  drive[j] <- substr(path[j], 1L, 2L)
  subpath[j] <- substr(path[j], 3, nchar(path[j]))

  k <- !na & !i & !j
  subpath[k] <- path[k]

  list(drive = drive, path = subpath)
}
