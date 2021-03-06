context("path_is_abs")

test_that("win", {
  expect_true(windows_path_is_abs("//server/file"))
  expect_true(windows_path_is_abs("\\\\server\\file"))
  expect_true(windows_path_is_abs("C:/Users/"))
  expect_true(windows_path_is_abs("C:\\Users\\"))
  ## expect_false(windows_path_is_abs("C:foo/bar"))
  ## expect_false(windows_path_is_abs("C:foo\\bar"))
  expect_false(windows_path_is_abs("foo/bar"))
  expect_false(windows_path_is_abs("foo\\bar"))
  ## Unix paths are absolute too:
  expect_true(windows_path_is_abs("/foo/bar"))
  expect_true(windows_path_is_abs("\\foo\\bar"))
})

test_that("win vectorized", {
  expect_equal(
    windows_path_is_abs(character()),
    logical()
  )

  expect_equal(
    windows_path_is_abs(c("//server/file", "//another/server/file")),
    c(TRUE, TRUE)
  )

  expect_equal(
    windows_path_is_abs(c("//server/file", "./file")),
    c(TRUE, FALSE)
  )

  expect_equal(
    windows_path_is_abs(c("./server/file", "another/server/file")),
    c(FALSE, FALSE)
  )
})

test_that("win NA", {
  expect_equal(
    windows_path_is_abs(NA),
    NA
  )

  expect_equal(
    windows_path_is_abs(c(NA, "./baz", "C:\\root", NA, "\\\\server\\file")),
    c(NA, FALSE, TRUE, NA, TRUE)
  )
})

test_that("unix", {
  expect_true(posix_path_is_abs("/foo/bar"))
  expect_true(posix_path_is_abs("/foo/bar/.."))
  expect_false(posix_path_is_abs("bar/"))
  expect_false(posix_path_is_abs("./bar"))
})

test_that("unix vectorized", {
  expect_equal(
    posix_path_is_abs(character()),
    logical()
  )

  expect_equal(
    posix_path_is_abs(c("/server/file", "/another/server/file")),
    c(TRUE, TRUE)
  )

  expect_equal(
    posix_path_is_abs(c("/server/file", "./file")),
    c(TRUE, FALSE)
  )

  expect_equal(
    posix_path_is_abs(c("./server/file", "another/server/file")),
    c(FALSE, FALSE)
  )

})

test_that("unix NA", {
  expect_equal(posix_path_is_abs(NA), NA)
  expect_equal(posix_path_is_abs(c("./foo", "/abs", NA)), c(FALSE, TRUE, NA))
})
