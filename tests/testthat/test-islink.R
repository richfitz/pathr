context("path_islink")

test_that("basic", {
  new_empty_file("foo")
  file.symlink("foo", "bar")
  on.exit(file.remove(c("foo", "bar")))
  expect_that(path_islink("bar"), is_true())
  expect_that(path_islink(rep("bar", 4)), equals(rep(TRUE, 4)))
})

test_that("dots", {
  expect_that(path_islink("."), is_false())
  expect_that(path_islink(".."), is_false())
  expect_that(path_islink("./."), is_false())
  expect_that(path_islink("/"), is_false())
})

test_that("missing values", {
  expect_that(path_islink(character(0)), equals(logical(0)))
  expect_that(path_islink(NA), equals(NA))
  expect_that(path_islink(NULL),
              throws_error("invalid 'paths' argument"))
  expect_that(path_islink(c("test-islink.R", NA)),
              equals(c(FALSE, NA)))
})

test_that("Dangling links", {
  new_empty_file("foo")
  file.symlink("foo", "bar")
  expect_that(path_islink(c("bar")), is_true())
  on.exit(file.remove("bar")) # won't clear dangling symlinks
  file_remove("foo")
  expect_that(path_islink("bar"), is_true())
})
