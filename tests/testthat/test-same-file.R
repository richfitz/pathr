context("same_file")

test_that("missing files return NA/FALSE", {
  expect_equal(posix_path_same_file(tempfile(), tempfile()), NA)
  expect_equal(posix_path_same_file(tempfile(), "."), NA)
  expect_equal(posix_path_same_file(".", tempfile()), NA)

  expect_equal(posix_path_same_file(tempfile(), tempfile(),
                                    absent_is_false = TRUE), FALSE)
  expect_equal(posix_path_same_file(tempfile(), ".",
                                    absent_is_false = TRUE), FALSE)
  expect_equal(posix_path_same_file(".", tempfile(),
                                    absent_is_false = TRUE), FALSE)
})

test_that("NA input returns NA", {
  expect_equal(posix_path_same_file(NA, NA), NA)
  expect_equal(posix_path_same_file(NA, "."), NA)
  expect_equal(posix_path_same_file(".", NA), NA)

  expect_equal(posix_path_same_file(NA_character_, NA_character_), NA)
  expect_equal(posix_path_same_file(NA_character_, "."), NA)
  expect_equal(posix_path_same_file(".", NA_character_), NA)
})

test_that("same file", {
  expect_true(posix_path_same_file(".", "."))
  expect_true(posix_path_same_file("helper-pathr.R", "helper-pathr.R"))
})

test_that("symbolic links", {
  new_empty_file("foo")
  file.symlink("foo", "bar")
  on.exit(file.remove(c("foo", "bar")))
  expect_true(posix_path_same_file("foo", "bar"))
  expect_false(posix_path_same_file("foo", "bar", FALSE))
})

test_that("hard links", {
  new_empty_file("foo")
  file.link("foo", "bar")
  on.exit(file.remove(c("foo", "bar")))
  expect_true(posix_path_same_file("foo", "bar"))
  expect_true(posix_path_same_file("foo", "bar", FALSE))
})
