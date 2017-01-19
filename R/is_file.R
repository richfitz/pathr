## os.path.isfile(path)
##
##   Return True if path is an existing regular file. This follows
##   symbolic links, so both islink() and isfile() can be true for the
##   same path.
path_is_file <- function(paths) {
  ## See here for what is needed to get this right
  ##   https://github.com/python-git/python/blob/master/Lib/stat.py
  ## file_test might be enough here, but we need to trim NA values.
  utils::file_test("-f", paths)
}
