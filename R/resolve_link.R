posix_path_resolve_link <- function(path) {
  paths_seen <- character(0)
  while (path_is_link(path)) {
    if (path %in% paths_seen) {
      ## Already seen this path, so we must have a symlink loop
      return(NULL)
    }
    paths_seen <- c(paths_seen, path)
    ## Resolve where the link points to
    resolved <- Sys.readlink(path)

    if (!posix_path_is_abs(resolved)) {
      ## Not sure what is going on here!
      dir <- dirname(path)
      path <- posix_path_norm(file.path(dir, resolved))
    } else {
      path <- posix_path_norm(resolved)
    }
  }
  path
}
