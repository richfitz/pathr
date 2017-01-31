## Will overwrite quite happily
new_empty_file <- function(filename) {
  writeLines(character(0), filename)
}

skip_if_not_posix <- function() {
  if (is_posix()) {
    return()
  }
  skip("this test needs to be run on a POSIX platform")
}

skip_if_not_windows <- function() {
  if (is_windows()) {
    return()
  }
  skip("this test needs to be run on a Windows platform")
}

skip_if_no_symlink <- function() {
  ## TODO: better to make this a constant in the package, probably
  if (!is_windows()) {
    return()
  }
  skip("this test needs symlink support")
}

with_wd <- function(path, expr) {
  owd <- setwd(path)
  on.exit(setwd(owd))
  expr
}
