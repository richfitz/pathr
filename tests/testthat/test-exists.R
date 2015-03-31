context("path_exists")

test_that("basic", {
  new_empty_file("foo")
  expect_that(path_exists("foo"), is_true())
  expect_that(path_exists(rep("foo", 4)), equals(rep(TRUE, 4)))
})

test_that("Case sensitivity", {
  ## MAC: -- this will fail on a case-sensitive system (e.g., Linux)
  expect_that(path_exists("Foo"), is_true())
})

test_that("dots", {
  expect_that(path_exists("."), is_true())
  expect_that(path_exists(".."), is_true())
  expect_that(path_exists("./."), is_true())
  expect_that(path_exists("/"), is_true())
})

test_that("missing values", {
  expect_that(path_exists(NA), equals(NA))
  expect_that(path_exists(NULL),
              throws_error("invalid 'file' argument"))
  expect_that(path_exists(c("test-exists.R", NA)),
              equals(c(TRUE, NA)))
})

test_that("symlink", {
  file_remove("foo")
  file_remove("bar")

  new_empty_file("foo")
  on.exit(file_remove("foo"))
  file.symlink("foo", "bar")
  on.exit(file.remove("bar"), add=TRUE)
})

test_that("Dangling links", {
  file_remove("foo")
  file_remove("bar")

  new_empty_file("foo")
  file.symlink("foo", "bar")
  expect_that(path_exists(c("foo", "bar")), equals(c(TRUE, TRUE)))
  on.exit(file.remove("bar")) # won't clear dangling symlinks
  file_remove("foo")

  expect_that(path_exists(c("foo", "bar")), equals(c(FALSE, FALSE)))

  expect_that(path_exists("bar"), is_false())
})
