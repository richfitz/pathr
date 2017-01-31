context("path_real")

## This might also include tests of the resolve_link function
##
## I think that we might be prone to multi-level symbolic links still,
## but it's an effort to make them.  See what the python tests include
## and see if we can come up a counter example that does not work.

test_that("python suite: basic", {
  expect_equal(posix_path_real("foo"),
               file.path(normalizePath(getwd()), "foo"))
})

test_that("python suite: loops", {
  skip_if_no_symlink()

  tmp <- basename(tempfile())
  tmp1 <- paste0(tmp, "1")
  tmp2 <- paste0(tmp, "2")
  on.exit(unlink(c(tmp, tmp1, tmp2)))

  file.symlink(tmp, tmp)
  file.symlink(tmp1, tmp2)
  file.symlink(tmp2, tmp1)

  expect_equal(path_real(tmp), path_abs(tmp))
  expect_equal(path_real(tmp1), path_abs(tmp1))
  expect_equal(path_real(tmp2), path_abs(tmp2))

  with_wd(dirname(tmp),
          expect_equal(path_real(basename(tmp)), path_abs(tmp)))
})

test_that("python suite: resolve parents", {
  skip_if_no_symlink()
  ## We also need to resolve any symlinks in the parents of a relative
  ## path passed to realpath. E.g.: current working directory is
  ## /usr/doc with 'doc' being a symlink to /usr/share/doc. We call
  ## realpath("a"). This should return /usr/share/doc/a/.

  tmp <- tempfile()
  dir.create(tmp)
  tmp <- normalizePath(tmp) # drop links at this step
  on.exit(unlink(tmp, recursive = TRUE))

  tmp_y <- file.path(tmp, "y")
  tmp_k <- file.path(tmp, "k")

  dir.create(tmp_y)
  file.symlink(tmp_y, tmp_k)

  with_wd(tmp_k,
          expect_equal(path_real("a"), file.path(path_abs(tmp_y), "a")))
})

test_that("python suite: resolve before normalising", {
  skip_if_no_symlink()
  ## Bug #990669: Symbolic links should be resolved before we
  ## normalize the path. E.g.: if we have directories 'a', 'k' and 'y'
  ## in the following hierarchy:
  ## a/k/y
  ##
  ## and a symbolic link 'link-y' pointing to 'y' in directory 'a',
  ## then realpath("link-y/..") should return 'k', not 'a'.

  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE))
  tmp <- normalizePath(tmp) # drop links at this step

  tmp_k      <- file.path(tmp, "k")
  tmp_ky     <- file.path(tmp, "k", "y")
  tmp_link_y <- file.path(tmp, "link-y")
  dir.create(tmp_k)
  dir.create(tmp_ky)
  file.symlink(tmp_ky, tmp_link_y)

  expect_equal(path_real(file.path(tmp_link_y, "..")),
               path_abs(tmp_k))
  with_wd(dirname(tmp),
          expect_equal(path_real(file.path(basename(tmp), "link-y", "..")),
                       path_abs(tmp_k)))
})

test_that("python suite: resolve first", {
  skip_if_no_symlink()
  ## Bug #1213894: The first component of the path, if not absolute,
  ## must be resolved too.
  container <- tempfile()
  dir.create(container)
  container <- normalizePath(container)
  on.exit(unlink(container, recursive = TRUE))

  tmp <- file.path(container, "x")
  tmp_k <- file.path(container, "x", "k")
  tmp_link <- file.path(container, "x_link") # at same level as 'x'

  dir.create(tmp_k, FALSE, TRUE)
  file.symlink(tmp, tmp_link)

  base <- basename(tmp)

  with_wd(container, {
    expect_equal(path_real(basename(tmp_link)), tmp)
    expect_equal(path_real(file.path(basename(tmp_link), "k")), tmp_k)
  })
})
