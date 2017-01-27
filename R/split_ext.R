## In the Python version, the dot is considered part of the extension,
## but similar R functions (tools::file_ext) the dot is not considered
## part of the extension.

## Notes that tools::file_ext treats dotfiles as extensions;
##
##   tools::file_ext("foo/.bashrc") # => .bashrc

## In the python version, the regular expression used sep/altsep here
## to work across posix/nt and have reasonable semantics with slashes.
## I think that for now we'll treat both slash directions as
## separators on both platforms.

path_split_ext <- function(path, ext_includes_dot = FALSE) {
  path <- reasonable_path(path)
  base <- ext <- character(length(path))

  is_na <- is.na(path)
  base[is_na] <- ext[is_na] <- NA_character_

  if (ext_includes_dot) {
    re <- "^(.+)(?<![./\\\\])(\\.[[:alnum:]]+)$"
  } else {
    re <- "^(.+)(?<![./\\\\])\\.([[:alnum:]]+)$"
  }
  i <- grepl(re, path[!is_na], perl = TRUE)
  j <- which(!is_na)[i]
  k <- which(!is_na)[!i]
  base[j] <- sub(re, "\\1", path[j], perl = TRUE)
  ext[j] <- sub(re, "\\2", path[j], perl = TRUE)
  base[k] <- path[k]

  list(base = base, ext = ext)
}
