context("common_prefix")

test_that("posix", {
  expect_equal(posix_path_common_prefix(character()), character())

  ## One path is the identity function:
  expect_equal(posix_path_common_prefix("foo"), "foo")
  expect_equal(posix_path_common_prefix("foo/bar"), "foo/bar")

  ## With no variation this is trivial:
  p <- "a/b/c"
  expect_equal(posix_path_common_prefix(c(p, p)), p)
  expect_equal(posix_path_common_prefix(c(p, p, p)), p)

  ## Starts getting more interesting with more bits:
  expect_equal(posix_path_common_prefix(c("aa/bb", "aa/cc")), "aa")
})
