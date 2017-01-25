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
