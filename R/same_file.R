path_same_file <- function(path1, path2) {
  ## As "is_same_file", perhaps?
  if (is_windows()) {
    windows_path_same_file(path1, path2)
  } else {
    posix_path_same_file(path1, path2)
  }
}

windows_path_same_file <- function(path1, path2) {
  ## This is not implemented in ntpath.py, but because windows does
  ## not have links, we should be able to implement this as
  ##   norm_path(path1) == norm_path(path2)
  stop("FIXME")
}

posix_path_same_file <- function(path1, path2, follow_links = TRUE,
                                 absent_is_false = FALSE) {
  ## TODO: consider vectorising in path1, path2 (with appropriate
  ## recycling?)
  assert_scalar(path1)
  assert_scalar(path2)
  if (is.na(path1) || is.na(path2)) {
    return(NA)
  }
  assert_character(path1)
  assert_character(path2)
  assert_scalar_logical(follow_links)
  assert_scalar_logical(absent_is_false)
  .Call("r_posix_path_same_file", path1, path2, follow_links, absent_is_false,
        PACKAGE = "pathr")
}
