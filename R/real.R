path_real <- function(path) {
  if (is_windows()) {
    windows_path_real(path)
  } else {
    posix_path_real(path)
  }
}

posix_path_real <- function(path) {
  path <- reasonable_path(path)
  na_skip(path, function(x) vcapply(x, posix_path_real1, USE.NAMES = FALSE))
}

posix_path_real1 <- function(path) {
  bits <- posix_path_split_all(path)[[1L]]
  for (i in seq_along(bits)) {
    if (!nzchar(bits[[i]])) {
      next
    }
    j <- seq_len(i)
    component <- paste(bits[j], collapse = "/")
    if (posix_path_is_link(component)) {
      resolved <- posix_path_resolve_link(component)
      if (is.null(resolved)) { # infinite loop
        return(path_abs(paste(c(component, bits[-j]), collapse = "/")))
      } else {
        newpath <- paste(c(resolved, bits[-j]), collapse = "/")
        return(posix_path_real1(newpath))
      }
    }
  }

  path_abs(path)
}
