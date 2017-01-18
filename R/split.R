## from posixpath.py:
##
##   Split a path in head (everything up to the last '/') and tail
##   (the rest).  If the path ends in '/', tail will be empty.  If
##   there is no '/' in the path, head will be empty.  Trailing '/'es
##   are stripped from head unless it is the root.
posix_path_split <- function(path) {
  head <- tail <- character(length(path))
  na <- is.na(path)
  head[na] <- tail[na] <- NA_character_
  i <- find_last_sep(path[!na], TRUE)
  j <- i != 0
  head[!na][j] <- strip_trailing_slash(substr(path[!na][j], 1, i[j]))
  tail[!na][j] <- substr(path[!na][j], i[j] + 1L, nchar(path[!na][j]))
  tail[!na][!j] <- path[!na][!j]
  ## TODO: options here are to return a list or return a matrix.  Not
  ## sure which is a better option really (and if returning a matrix,
  ## is it rows or columns).  This could be configurable perhaps.
  list(head = head, tail = tail)
}
