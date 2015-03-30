## To make things more like Python implementations, and to get some
## consistent behaviour with NA input.
os_stat <- function(files) {
  ok <- !is.na(files)
  if (all(ok)) {
    file.info(files)
  } else {
    ## This *does* make a mess of the rownames.
    m <- file.info(as.character(files[ok]))
    i <- rep(NA_integer_, length(files))
    i[ok] <- seq_len(nrow(m))
    m[i,]
  }
}

na_screen <- function(x, screen) {
  x[is.na(screen)] <- NA
  x
}

is_posix <- function() {
  .Platform$OS.type == "unix"
}

is_windows <- function() {
  Sys.info()[["sysname"]] == "Windows"
}

## TODO: Add warn=FALSE as default.
## TODO: vectorise.
file_remove <- function(path, recursive=FALSE) {
  exists <- file.exists(path)
  if (exists) {
    if (is_directory(path)) {
      if (recursive) {
        unlink(path, recursive)
      } else {
        stop("Use 'recursive=TRUE' to delete directories")
      }
    } else {
      file.remove(path)
    }
  }
  invisible(exists)
}

## TODO: This becomes path_isdir(), or at least aliased to it.
is_directory <- function(path) {
  file.info(path)$isdir
}

startswith <- function(x) {
  substr(x, 1L, length(x)) == x
}
