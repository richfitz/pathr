context("is_directory")

test_that("missing file treatment", {
  msg <- tempfile()
  expect_false(file.exists(msg))
  ## with a single missing path:
  expect_equal(path_is_directory(msg), NA)
  expect_equal(path_is_directory(msg, TRUE), FALSE)

  ## Included in some present paths:
  expect_equal(path_is_directory(c(msg, ".")), c(NA, TRUE))
  expect_equal(path_is_directory(c(msg, "."), TRUE), c(FALSE, TRUE))
  expect_equal(path_is_directory(c(msg, "test-is-directory.R")), c(NA, FALSE))
  expect_equal(path_is_directory(c(msg, "test-is-directory.R"), TRUE),
               c(FALSE, FALSE))
})

test_that("missing values in path vector", {
  expect_equal(path_is_directory(NA), NA)
  expect_equal(path_is_directory(c(NA, NA)), c(NA, NA))
  expect_equal(path_is_directory(c(".", NA)), c(TRUE, NA))
  expect_equal(path_is_directory(c(NA, ".", NA)), c(NA, TRUE, NA))
  expect_equal(path_is_directory(c(NA, "test-is-directory.R", NA)),
               c(NA, FALSE, NA))
})

test_that("empty file list", {
  expect_equal(path_is_directory(character(0)), logical(0))
})

test_that("symbolic links", {
  ## TODO: should be able to detect if a platform supports symbolic
  ## links within the package.  This is an issue on windows I believe.
  tmp <- tempfile()
  on.exit(unlink(tmp, recursive = TRUE))

  tmp_dir <- tempfile(tmpdir = tmp)
  dir.create(tmp_dir, recursive = TRUE)

  tmp_file <- tempfile(tmpdir = tmp)
  new_empty_file(tmp_file)

  tmp_dir_link <- tempfile(tmpdir = tmp)
  file.symlink(tmp_dir, tmp_dir_link)

  tmp_file_link <- tempfile(tmpdir = tmp)
  file.symlink(tmp_file, tmp_file_link)

  expect_true(path_is_directory(tmp_dir))
  expect_true(path_is_directory(tmp_dir_link))
  expect_false(path_is_directory(tmp_file))
  expect_false(path_is_directory(tmp_file_link))
})
