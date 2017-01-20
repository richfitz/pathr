path_expand_vars <- function(path) {
  if (is_windows()) {
    posix_path_expand_vars(path)
  } else {
    windows_path_expand_vars(path)
  }
}

## TODO: more work is needed here to expand windows varaiables, as we
## need to also support %varname% (but *only* on windows, or when
## called as winodws_path_expand_vars)
posix_path_expand_vars <- function(path) {
  path <- reasonable_path(path)
  i <- !is.na(path) & grepl("$", path, fixed = TRUE)
  path[i] <- vcapply(path[i], posix_path_expand_vars1)
  path
}

posix_path_expand_vars1 <- function(p) {
  re <- "\\$(\\w+|\\{[^}]*\\})"
  i <- regexpr(re, p)
  if (i > 0) {
    j <- i + attr(i, "match.length") - 1L
    if (substr(p, i + 1L, i + 1L) == "{") {
      v <- substr(p, i + 2L, j - 1L)
    } else {
      v <- substr(p, i + 1L, j)
    }
    value <- Sys.getenv(v, NA_character_)
    rest <- posix_path_expand_vars1(substr(p, j + 1L, nchar(p)))
    if (!is.na(value)) {
      p <- paste0(substr(p, 1L, i - 1L), value, rest)
    } else {
      p <- paste0(substr(p, 1L, j), rest)
    }
  }
  p
}

windows_path_expand_vars <- function(path) {
  path <- reasonable_path(path)
  i <- !is.na(path) & grepl("[$%]", path)
  path[i] <- vcapply(path[i], windows_path_expand_vars1)
  path
}

windows_path_expand_vars1 <- function(p) {
  .NotYetImplemented()
}
