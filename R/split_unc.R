path_split_unc <- function(path) {
  ## Split a pathname into UNC mount point and relative path specifiers.
  ##
  ## Return a 2-tuple (unc, rest); either part may be empty.  If unc
  ## is not empty, it has the form '//host/mount' (or similar using
  ## backslashes).  unc+rest is always the input path.  Paths
  ## containing drive letters never have an UNC part.
  path <- reasonable_path(path)
  n <- length(path)

  start <- substr(path, 1L, 2L)
  i <- !is.na(path) & start %in% c("//", "\\\\")
  if (any(i)) {
    ## is a UNC path:
    ## vvvvvvvvvvvvvvvvvvvv equivalent to drive letter
    ## \\machine\mountpoint\directories...
    ##           directory ^^^^^^^^^^^^^^^
    p <- path[i]
    re <- "[/\\]"
    j <- regexpr_find_after(re, p, 2L)
    if (any(j < 0)) {
      err <- unique(p[j < 0])
      stop(sprintf("illegal UNC %s: %s",
                   ngettext(length(err), "path", "paths"),
                   paste(err, collapse = ", ")))
    }
    index <- regexpr_find_after(re, p, 2L + j)

    j <- index < 0
    nc <- nchar(p)

    if (any(j)) {
      index[j] <- nc[j] + 1L
    }

    unc <- substr(p, 1L, index - 1L)
    rest <- substr(p, index, nchar(p))

    if (all(i)) {
      list(unc = unc, path = rest)
    } else {
      ret_unc <- na_screen(rep_len("", n), path)
      ret_path <- path
      ret_unc[i] <- substr(p, 1L, index - 1L)
      ret_path[i] <- rest
      list(unc = ret_unc, path = ret_path)
    }
  } else {
    list(unc = na_screen(rep_len("", n), path),
         path = path)
  }
}
