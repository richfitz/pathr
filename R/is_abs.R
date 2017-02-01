##' Test for absolute paths
##'
##' On Unix, that means it begins with a slash, on Windows that it
##' begins with a (back)slash after chopping off a potential drive
##' letter.  On Windows, UNC paths are considered to be absolute paths.
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

## Now implemented the same way as the Python version; cleave off the
## drive (which leaves any leading "/", so "c:/foo" => "/foo" and test
## for leading slashes.  This tests TRUE for UNC and file paths, and
## avoids duplicating logic present in the split_drive function.
windows_path_is_abs <- function(path) {
  ## At the moment, the thing that this fails for is paths of the form:
  ##
  ##   c:foo
  ##
  ## which splitdrive gives as "c:", "foo" and the Python version
  ## reports False.
  ##
  ## Note that the python version also considers "c:" to be a
  ## non-absolute path too.
  ##
  ## Find out what R resolves "c:foo" and "c:" as and make sure that
  ## we report things that support that behaviour.  Once that's sorted
  ## out then we'll go ahead and tweak this but it might involve
  ## changing the tests.
  p <- windows_path_split_drive(path)
  p$drive != "" | substr(p$path, 1L, 1L) %in% c("/", "\\")
}

posix_path_is_abs <- function(path) {
  startswith(path, "/")
}
