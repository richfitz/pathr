context("is_mount")

test_that("scalar", {
  skip_if_not_posix()

  expect_true(posix_path_is_mount("/"))
  expect_false(posix_path_is_mount(tempdir()))

  ## Missing files currently not mounts (probably fix this)
  expect_equal(posix_path_is_mount(tempfile()), NA)
  expect_equal(posix_path_is_mount(tempfile(), TRUE), FALSE)

  ## Missing values in, missing values out
  expect_equal(posix_path_is_mount(NA_character_), NA)
})

test_that("vector", {
  v <- c("/", tempdir(), tempfile(), ".", NA)
  expect_equal(posix_path_is_mount(v),
               c(TRUE, FALSE, NA, FALSE, NA))
  expect_equal(posix_path_is_mount(v, TRUE),
               c(TRUE, FALSE, FALSE, FALSE, NA))
})
