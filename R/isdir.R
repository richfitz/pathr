##' Test if a path is a directory.  This follows symbolic links, so
##' both \code{\path{path_is_link}} and \code{path_is_directory} can
##' be \code{TRUE} for the same oath on systems that support symlinks
##'
##' @title Test if a path is a directory
##'
##' @param path A vector of paths
##'
##' @param missing_is_not_directory Flag to indicate a return value of
##'   \code{FALSE} for missing files (not for missing values in
##'   \code{path}).  By default missing files have an value of
##'   \code{NA} which matches R's NA semantics, but not Python's
##'   \code{os.path.isdir} function.  Pass \code{TRUE} in here to set
##'   missing files to \code{FALSE} (i.e., a missing path is
##'   \emph{not} a directory, rather than having an unknown state of
##'   directory-ness).
##'
##' @export
##' @examples
##' path_is_directory(".") # TRUE
##' path_is_directory("missing file") # NA
path_is_directory <- function(path, missing_is_not_directory = FALSE) {
  ## NOTE: in python, os.path.isdir("missingpath") is False, but here
  ## it will be NA
  ##
  ## That's not ideal
  res <- logical(length(path))
  na <- is.na(path)
  res[na] <- NA
  if (any(!na)) {
    isdir <- file.info(path[!na], extra_cols = FALSE)$isdir
    if (missing_is_not_directory) {
      isdir[is.na(isdir)] <- FALSE
    }
    res[!na] <- isdir
  }
  res
}
