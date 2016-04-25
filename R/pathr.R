## Note Since different operating systems have different path name
## conventions, there are several versions of this module in the
## standard library. The os.path module is always the path module
## suitable for the operating system Python is running on, and
## therefore usable for local paths. However, you can also import and
## use the individual modules if you want to manipulate a path that is
## always in one of the different formats. They all have the same
## interface:
##   posixpath for UNIX-style paths (includes Darwin!)
##   ntpath for Windows paths
##
##   macpath for old-style MacOS paths
##   os2emxpath for OS/2 EMX paths

## https://docs.python.org/2/library/os.path.html

## os.path.basename(path)
##
##   Return the base name of pathname path. This is the second element
##   of the pair returned by passing path to the function
##   split(). Note that the result of this function is different from
##   the Unix basename program; where basename for '/foo/bar/' returns
##   'bar', the basename() function returns an empty string ('').

## os.path.commonprefix(list)
##
##   Return the longest path prefix (taken character-by-character)
##   that is a prefix of all paths in list. If list is empty, return
##   the empty string (''). Note that this may return invalid paths
##   because it works a character at a time.
path_commonprefix <- function(paths) {
  if (length(paths) == 0L) {
    ""
  } else {
    ## s1 = min(m)
    ## s2 = max(m)
    ## for i, c in enumerate(s1):
    ##     if c != s2[i]:
    ##         return s1[:i]
    ## return s1
  }
}

## os.path.dirname(path)
##
##   Return the directory name of pathname path. This is the first
##   element of the pair returned by passing path to the function
##   split().

## os.path.exists(path) -- genericpath.py
##
##   Return True if path refers to an existing path. Returns False for
##   broken symbolic links. On some platforms, this function may
##   return False if permission is not granted to execute os.stat() on
##   the requested file, even if the path physically exists.

##' @title Test if path exists
##' @param paths Vector of paths to test
##' @export
path_exists <- function(paths) {
  ## TODO: na.action
  ##       - omit
  ##       - error
  if (is.null(paths)) {
    stop("invalid 'file' argument")
  }
  stat <- os_stat(paths)
  na_screen(!is.na(stat$size), paths)
}

## os.path.lexists(path)
##
##   Return True if path refers to an existing path. Returns True for
##   broken symbolic links. Equivalent to exists() on platforms
##   lacking os.lstat().

path_lexists <- function(paths) {
  path_exists(paths) | path_islink(paths)
}

## os.path.expanduser(path)
##
##   On Unix and Windows, return the argument with an initial
##   component of ~ or ~user replaced by that user‘s home directory.

##   On Unix, an initial ~ is replaced by the environment variable
##   HOME if it is set; otherwise the current user’s home directory is
##   looked up in the password directory through the built-in module
##   pwd. An initial ~user is looked up directly in the password
##   directory.

##   On Windows, HOME and USERPROFILE will be used if set, otherwise a
##   combination of HOMEPATH and HOMEDRIVE will be used. An initial
##   ~user is handled by stripping the last directory component from
##   the created user path derived above.
##
##   If the expansion fails or if the path does not begin with a
##   tilde, the path is returned unchanged.

## os.path.expandvars(path)
##
##   Return the argument with environment variables
##   expanded. Substrings of the form $name or ${name} are replaced by
##   the value of environment variable name. Malformed variable names
##   and references to non-existing variables are left unchanged.
##
##   On Windows, %name% expansions are supported in addition to $name
##   and ${name}.

## os.path.getatime(path)
##
##   Return the time of last access of path. The return value is a
##   number giving the number of seconds since the epoch (see the time
##   module). Raise os.error if the file does not exist or is
##   inaccessible.
##
##   Changed in version 2.3: If os.stat_float_times() returns True,
##   the result is a floating point number.
path_getatime <- function(path) {
  os_stat(path)$atime
}

## os.path.getmtime(path)
##
##   Return the time of last modification of path. The return value is
##   a number giving the number of seconds since the epoch (see the
##   time module). Raise os.error if the file does not exist or is
##   inaccessible.
##
##   Changed in version 2.3: If os.stat_float_times() returns True,
##   the result is a floating point number.
path_getmtime <- function(path) {
  os_stat(path)$mtime
}

## os.path.getctime(path)
##
##   Return the system’s ctime which, on some systems (like Unix) is
##   the time of the last metadata change, and, on others (like
##   Windows), is the creation time for path. The return value is a
##   number giving the number of seconds since the epoch (see the time
##   module). Raise os.error if the file does not exist or is
##   inaccessible.
path_getctime <- function(path) {
  os_stat(path)$ctime
}

## os.path.getsize(path)
##
##   Return the size, in bytes, of path. Raise os.error if the file
##   does not exist or is inaccessible.
##
## NOTE: What is correct error behaviour here?
path_getsize <- function(files) {
  os_stat(files)$size
}

## os.path.isabs(path)
##
##   Return True if path is an absolute pathname. On Unix, that means
##   it begins with a slash, on Windows that it begins with a
##   (back)slash after chopping off a potential drive letter.

##' @title Test for absolute path
##' @export
path_isabs <- function(path) {
  if (is_windows()) {
    win_path_isabs(path)
  } else {
    posix_path_isabs(path)
  }
}

#' @importFrom rematch re_match

win_path_isabs <- function(path) {
  device_re <- paste0(
    "^([a-zA-Z]:|",
    "[\\\\\\/]{2}[^\\\\\\/]+[\\\\\\/]+[^\\\\\\/]+)?",
    "([\\\\\\/])?([\\s\\S]*?)$"
  )
  result <- re_match(pattern = device_re, text = path)
  device <- result[, 2]
  isunc  <- device != "" & substr(device, 2, 2) != ":";

  unname(isunc | result[, 3] != "")
}

posix_path_isabs <- function(path) {
  startswith(path, "/")
}

## os.path.isfile(path)
##
##   Return True if path is an existing regular file. This follows
##   symbolic links, so both islink() and isfile() can be true for the
##   same path.
path_isfile <- function(paths) {
  ## See here for what is needed to get this right
  ##   https://github.com/python-git/python/blob/master/Lib/stat.py
  ## file_test might be enough here, but we need to trim NA values.
  file_test("-f", paths)
}

## os.path.isdir(path) -- genericpath.py
##
##   Return True if path is an existing directory. This follows
##   symbolic links, so both islink() and isdir() can be true for the
##   same path.
path_isdir <- function(files) {
  os_stat(files)$is_dir
}

## os.path.islink(path)
##
##   Return True if path refers to a directory entry that is a
##   symbolic link. Always False if symbolic links are not supported
##   by the python runtime.

##' @title Test for symlink
##' @param paths Paths to test
##' @export
path_islink <- function(paths) {
  ## This should be done more following the code here:
  ##   https://github.com/python-git/python/blob/master/Lib/stat.py
  islink <- function(x) {
    info <- Sys.readlink(x)
    !(is.na(info) | info == "")
  }
  na_skip(paths, islink)
}

## os.path.ismount(path)
##
##   Return True if pathname path is a mount point: a point in a file
##   system where a different file system has been mounted. The
##   function checks whether path‘s parent, path/.., is on a different
##   device than path, or whether path/.. and path point to the same
##   i-node on the same device — this should detect mount points for
##   all Unix and POSIX variants.

## os.path.join(path, *paths)
##
##   Join one or more path components intelligently. The return value
##   is the concatenation of path and any members of *paths with
##   exactly one directory separator (os.sep) following each non-empty
##   part except the last, meaning that the result will only end in a
##   separator if the last part is empty. If a component is an
##   absolute path, all previous components are thrown away and
##   joining continues from the absolute path component.
##
##   On Windows, the drive letter is not reset when an absolute path
##   component (e.g., r'\foo') is encountered. If a component contains
##   a drive letter, all previous components are thrown away and the
##   drive letter is reset. Note that since there is a current
##   directory for each drive, os.path.join("c:", "foo") represents a
##   path relative to the current directory on drive C: (c:foo), not
##   c:\foo.

## os.path.normcase(path)
##
##   Normalize the case of a pathname. On Unix and Mac OS X, this
##   returns the path unchanged; on case-insensitive filesystems, it
##   converts the path to lowercase. On Windows, it also converts
##   forward slashes to backward slashes.

## os.path.realpath(path)
##
##   Return the canonical path of the specified filename, eliminating
##   any symbolic links encountered in the path (if they are supported
##   by the operating system).

## os.path.relpath(path[, start])
##
##   Return a relative filepath to path either from the current
##   directory or from an optional start directory. This is a path
##   computation: the filesystem is not accessed to confirm the
##   existence or nature of path or start.
##
##   start defaults to os.curdir.
##
##   Availability: Windows, Unix.
##

## os.path.samefile(path1, path2)
##
##   Return True if both pathname arguments refer to the same file or
##   directory (as indicated by device number and i-node
##   number). Raise an exception if a os.stat() call on either
##   pathname fails.
##
## Availability: Unix.

## os.path.sameopenfile(fp1, fp2)
##
##   Return True if the file descriptors fp1 and fp2 refer to the same file.
##
##   Availability: Unix.

## os.path.samestat(stat1, stat2)
##
##   Return True if the stat tuples stat1 and stat2 refer to the same
##   file. These structures may have been returned by os.fstat(),
##   os.lstat(), or os.stat(). This function implements the underlying
##   comparison used by samefile() and sameopenfile().
##
##   Availability: Unix.

## os.path.split(path)
##
##   Split the pathname path into a pair, (head, tail) where tail is
##   the last pathname component and head is everything leading up to
##   that. The tail part will never contain a slash; if path ends in a
##   slash, tail will be empty. If there is no slash in path, head
##   will be empty. If path is empty, both head and tail are
##   empty. Trailing slashes are stripped from head unless it is the
##   root (one or more slashes only). In all cases, join(head, tail)
##   returns a path to the same location as path (but the strings may
##   differ). Also see the functions dirname() and basename().

## os.path.splitdrive(path)
##
##   Split the pathname path into a pair (drive, tail) where drive is
##   either a drive specification or the empty string. On systems
##   which do not use drive specifications, drive will always be the
##   empty string. In all cases, drive + tail will be the same as
##   path.

## os.path.splitext(path)
##
##   Split the pathname path into a pair (root, ext) such that root +
##   ext == path, and ext is empty or begins with a period and
##   contains at most one period. Leading periods on the basename are
##   ignored; splitext('.cshrc') returns ('.cshrc', '').
##
##   Changed in version 2.6: Earlier versions could produce an empty
##   root when the only period was the first character.
##' @importFrom tools file_path_sans_ext

## def _splitext(p, sep, altsep, extsep):
##     """Split the extension from a pathname.
##     Extension is everything from the last dot to the end, ignoring
##     leading dots.  Returns "(root, ext)"; ext may be empty."""
##
##     sepIndex = p.rfind(sep)
##     if altsep:
##         altsepIndex = p.rfind(altsep)
##         sepIndex = max(sepIndex, altsepIndex)
##
##     dotIndex = p.rfind(extsep)
##     if dotIndex > sepIndex:
##         # skip all leading dots
##         filenameIndex = sepIndex + 1
##         while filenameIndex < dotIndex:
##             if p[filenameIndex] != extsep:
##                 return p[:dotIndex], p[dotIndex:]
##             filenameIndex += 1
##
##     return p, ''
## Hold off implementing until I get file.split working so that we're
## consistent.  Then save the different regexps somewhere or generate
## them with a function.
## rfind <- function(str, x) {
##   re <- sprintf("%s[^%s]*$", x, x)
##   regexpr(re, str)
## }
## .splitext <- function(p, sep, altsep, extsep) {
##   sep_index <- rfind(p, sep)
## }

## os.path.splitunc(path)
##
##   Split the pathname path into a pair (unc, rest) so that unc is
##   the UNC mount point (such as r'\\host\mount'), if present, and
##   rest the rest of the path (such as r'\path\file.ext'). For paths
##   containing drive letters, unc will always be the empty string.
##
##   Availability: Windows.

## os.path.walk(path, visit, arg)
##
##   Calls the function visit with arguments (arg, dirname, names) for
##   each directory in the directory tree rooted at path (including
##   path itself, if it is a directory). The argument dirname
##   specifies the visited directory, the argument names lists the
##   files in the directory (gotten from os.listdir(dirname)). The
##   visit function may modify names to influence the set of
##   directories visited below dirname, e.g. to avoid visiting certain
##   parts of the tree. (The object referred to by names must be
##   modified in place, using del or slice assignment.)
##
##   Note Symbolic links to directories are not treated as
##   subdirectories, and that walk() therefore will not visit them. To
##   visit linked directories you must identify them with
##   os.path.islink(file) and os.path.isdir(file), and invoke walk()
##   as necessary.
##
##   Note This function is deprecated and has been removed in Python 3
##   in favor of os.walk().

##   os.path.supports_unicode_filenames
##
##   True if arbitrary Unicode strings can be used as file names
##   (within limitations imposed by the file system).

## Source is in
##   * https://github.com/python-git/python/blob/master/Lib/genericpath.py
##   * https://github.com/python-git/python/blob/master/Lib/macpath.py
##   * https://github.com/python-git/python/blob/master/Lib/ntpath.py
##   * https://github.com/python-git/python/blob/master/Lib/posixpath.py

## Tests are in:
##   * https://github.com/python-git/python/blob/master/Lib/test/test_genericpath.py
##   * https://github.com/python-git/python/blob/master/Lib/test/test_macpath.py
##   * https://github.com/python-git/python/blob/master/Lib/test/test_ntpath.py
##   * https://github.com/python-git/python/blob/master/Lib/test/test_posixpath.py
## at a minimum we'll need copies of all Python tests so it's clear
## the Right Thing is being done in corner cases that the Python
## people have identified.
