context("path_exists")

test_that("basic", {
  new_empty_file("foo")
  on.exit(file.remove("foo"))
  expect_true(path_exists("foo"))
  expect_equal(path_exists(rep("foo", 4)), rep(TRUE, 4))

  expect_true(path_lexists("foo"))
  expect_equal(path_lexists(rep("foo", 4)), rep(TRUE, 4))
})

test_that("Case sensitivity", {
  new_empty_file("foo")
  on.exit(file.remove("foo"))

  ## See issue #6
  sysname <- Sys.info()[["sysname"]]
  if (sysname == "Windows" || sysname == "Darwin") {
    ## MAC: -- this will fail on a case-sensitive system (e.g., Linux)
    expect_true(path_exists("Foo"))
    expect_true(path_lexists("Foo"))
  } else {
    ## MAC: -- this will fail on a case-sensitive system (e.g., Linux)
    expect_false(path_exists("Foo"))
    expect_false(path_lexists("Foo"))
  }
})

test_that("dots", {
  expect_true(path_exists("."))
  expect_true(path_exists(".."))
  expect_true(path_exists("./."))
  expect_true(path_exists("/"))

  expect_true(path_lexists("."))
  expect_true(path_lexists(".."))
  expect_true(path_lexists("./."))
  expect_true(path_lexists("/"))
})

test_that("missing values", {
  expect_equal(path_exists(NA), NA)
  expect_error(path_exists(NULL),
               "invalid 'file' argument")
  expect_equal(path_exists(c("test-exists.R", NA)),
               c(TRUE, NA))

  expect_equal(path_lexists(NA), NA)
  expect_error(path_lexists(NULL),
               "invalid 'file' argument")
  expect_equal(path_lexists(c("test-exists.R", NA)),
               c(TRUE, NA))
})

test_that("Dangling links", {
  file_remove("foo")
  file_remove("bar")

  new_empty_file("foo")
  file.symlink("foo", "bar")
  expect_equal(path_exists(c("foo", "bar")), c(TRUE, TRUE))
  expect_equal(path_lexists(c("foo", "bar")), c(TRUE, TRUE))
  on.exit(file.remove("bar")) # won't clear dangling symlinks
  file_remove("foo")

  expect_equal(path_exists(c("foo", "bar")), c(FALSE, FALSE))
  expect_equal(path_lexists(c("foo", "bar")), c(FALSE, TRUE))
  expect_false(path_exists("bar"))
  expect_true(path_lexists("bar"))
})
