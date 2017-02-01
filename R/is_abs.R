##' Test for absolute paths
##'
##' On Unix, that means it begins with a slash, on Windows that it
##' begins with a (back)slash after chopping off a potential drive letter.
##' On Windows UNC paths are consideted to be absolute paths.
##'
##' @param path Character vector of absolute paths.
##' @return Logical vector.
##'
##' @export
##' @examples
##' path_is_abs(c("/foo/bar/", "./relative", "../me/too", "and/me"))
path_is_abs <- function(path) {
  if (is_windows()) {
    windows_path_is_abs(path)
  } else {
    posix_path_is_abs(path)
  }
}

#' @importFrom rematch re_match

windows_path_is_abs <- function(path) {
  device_re <- paste0(
    "^([a-zA-Z]:|",
    "[\\\\\\/]{2}[^\\\\\\/]+[\\\\\\/]+[^\\\\\\/]+)?",
    "([\\\\\\/])?([\\s\\S]*?)$"
  )
  result <- re_match(pattern = device_re, text = path)
  device <- result[, 2L]
  isunc  <- device != "" & substr(device, 2L, 2L) != ":";

  unname(isunc | result[, 3L] != "")
}

posix_path_is_abs <- function(path) {
  startswith(path, "/")
}
