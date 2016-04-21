context("path_isabs")

test_that("win", {
  expect_true(win_path_isabs("//server/file"))
  expect_true(win_path_isabs("\\\\server\\file"))
  expect_true(win_path_isabs("C:/Users/"))
  expect_true(win_path_isabs("C:\\Users\\"))
  expect_false(win_path_isabs("C:foo/bar"))
  expect_false(win_path_isabs("C:foo\\bar"))
  expect_false(win_path_isabs("foo/bar"))
  expect_false(win_path_isabs("foo\\bar"))
})

test_that("win vectorized", {

  expect_equal(
    win_path_isabs(character()),
    logical()
  )

  expect_equal(
    win_path_isabs(c("//server/file", "//another/server/file")),
    c(TRUE, TRUE)
  )

  expect_equal(
    win_path_isabs(c("//server/file", "./file")),
    c(TRUE, FALSE)
  )

  expect_equal(
    win_path_isabs(c("./server/file", "another/server/file")),
    c(FALSE, FALSE)
  )

})

test_that("win NA", {

  expect_equal(
    win_path_isabs(NA),
    NA
  )

  expect_equal(
    win_path_isabs(c(NA, "./baz", "C:\\root", NA, "\\\\server\\file")),
    c(NA, FALSE, TRUE, NA, TRUE)
  )

})

test_that("unix", {
  expect_true(posix_path_isabs("/foo/bar"))
  expect_true(posix_path_isabs("/foo/bar/.."))
  expect_false(posix_path_isabs("bar/"))
  expect_false(posix_path_isabs("./bar"))
})

test_that("unix vectorized", {

  expect_equal(
    posix_path_isabs(character()),
    logical()
  )

  expect_equal(
    posix_path_isabs(c("/server/file", "/another/server/file")),
    c(TRUE, TRUE)
  )

  expect_equal(
    posix_path_isabs(c("/server/file", "./file")),
    c(TRUE, FALSE)
  )

  expect_equal(
    posix_path_isabs(c("./server/file", "another/server/file")),
    c(FALSE, FALSE)
  )

})

test_that("unix NA", {

})
