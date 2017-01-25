path_is_mount <- function(path, absent_is_false = FALSE) {
  if (is_windows()) {
    windows_path_is_mount(path, absent_is_false)
  } else {
    posix_path_is_mount(path, absent_is_false)
  }
}

posix_path_is_mount <- function(path, absent_is_false = FALSE) {
  ## TODO: Harmonise the "absent_is_false" bit here with is_mount and
  ## with other files that would use this (especially those that go
  ## through os_stat)
  path <- reasonable_path(path)
  .Call("posix_is_mount", path, absent_is_false, PACKAGE = "pathr")
}

windows_path_is_mount <- function(path, absent_is_falsex) {
  stop("FIXME")
}
