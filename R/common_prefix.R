path_common_prefix <- function(path) {
  if (is_windows()) {
    windows_path_common_prefix(path)
  } else {
    posix_path_common_prefix(path)
  }
}

posix_path_common_prefix <- function(path) {
  ## Not sure about NA behaviour; probably most R-ish is to return NA
  ## here?  Or add an na.rm argument?
  path <- reasonable_path(path)
  if (length(path) < 2L) {
    path
  } else {
    ord <- order(path)
    ## NOTE: This trick will not work when there are multiple slashes
    ## among paths (e.g., if some paths have 'foo//bar' and others
    ## have 'foo/bar' as the sort will not work correctly unless all
    ## files have the same set of duplicated paths.  We could check
    ## for this (here, it's going to be a case of any(grepl("//",
    ## path, fixed = TRUE)), though slightly more complicated for the
    ## windows case.  Another option here would be to normalise the
    ## paths first, perhaps?
    ##
    ## A further option would be to use path_split and collect
    ## fragments together
    p1 <- path[[which.min(ord)]]
    p2 <- path[[which.max(ord)]]
    if (p1 == p2) {
      p1
    } else {
      re <- "/+"
      i1 <- regexp_find_all(re, p1)
      pp1 <- strsplit_at(p1, i1$start, i1$length)

      i2 <- regexp_find_all(re, p2)
      pp2 <- strsplit_at(p2, i2$start, i2$length)

      substr(p1, 1L, i1$start[[length(common_prefix(pp1, pp2))]] - 1L)
    }
  }
}

windows_path_common_prefix <- function(path) {
  stop("FIXME")
}
