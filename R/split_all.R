path_split_all <- function(path) {
  if (is_windows(path)) {
    windows_path_real(path)
  } else {
    posix_path_real(path)
  }
}

posix_path_split_all <- function(path) {
  strsplit(path, "/+")
}
