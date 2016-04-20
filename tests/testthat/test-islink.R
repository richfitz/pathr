context("path_islink")

test_that("basic", {
  new_empty_file("foo")
  file.symlink("foo", "bar")
  on.exit(file.remove(c("foo", "bar")))
  expect_true(path_islink("bar"))
  expect_equal(path_islink(rep("bar", 4)), rep(TRUE, 4))
})

test_that("dots", {
  expect_false(path_islink("."))
  expect_false(path_islink(".."))
  expect_false(path_islink("./."))
  expect_false(path_islink("/"))
})

test_that("missing values", {
  expect_equal(path_islink(character(0)), logical(0))
  expect_equal(path_islink(NA), NA)
  expect_error(path_islink(NULL),
               "invalid 'paths' argument")
  expect_equal(path_islink(c("test-islink.R", NA)),
              c(FALSE, NA))
})

test_that("Dangling links", {
  new_empty_file("foo")
  file.symlink("foo", "bar")
  expect_true(path_islink(c("bar")))
  on.exit(file.remove("bar")) # won't clear dangling symlinks
  file_remove("foo")
  expect_true(path_islink("bar"))
})
