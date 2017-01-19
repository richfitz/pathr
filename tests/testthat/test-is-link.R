context("path_is_link")

test_that("basic", {
  new_empty_file("foo")
  file.symlink("foo", "bar")
  on.exit(file.remove(c("foo", "bar")))
  expect_true(path_is_link("bar"))
  expect_equal(path_is_link(rep("bar", 4)), rep(TRUE, 4))
})

test_that("dots", {
  expect_false(path_is_link("."))
  expect_false(path_is_link(".."))
  expect_false(path_is_link("./."))
  expect_false(path_is_link("/"))
})

test_that("missing values", {
  expect_equal(path_is_link(character(0)), logical(0))
  expect_equal(path_is_link(NA), NA)
  expect_error(path_is_link(NULL),
               "invalid 'paths' argument")
  expect_equal(path_is_link(c("test-is_link.R", NA)),
              c(FALSE, NA))
})

test_that("Dangling links", {
  new_empty_file("foo")
  file.symlink("foo", "bar")
  expect_true(path_is_link(c("bar")))
  on.exit(file.remove("bar")) # won't clear dangling symlinks
  file_remove("foo")
  expect_true(path_is_link("bar"))
})
