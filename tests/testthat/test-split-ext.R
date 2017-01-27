context("path_split_ext")

test_that("python posix test suite", {
  test_split_ext <- function(path, filename, ext) {
    for (dot in c(FALSE, TRUE)) {
      if (dot && nzchar(ext)) {
        ext <- paste0(".", ext)
      }
      expect_equal(path_split_ext(path, dot),
                   list(base = filename, ext = ext))

      expect_equal(path_split_ext(paste0("/", path), dot),
                   list(base = paste0("/", filename), ext = ext))

      expect_equal(path_split_ext(paste0("abc/", path), dot),
                   list(base = paste0("abc/", filename), ext = ext))

      expect_equal(path_split_ext(paste0("abc.def/", path), dot),
                   list(base = paste0("abc.def/", filename), ext = ext))

      expect_equal(path_split_ext(paste0("/abc.def/", path), dot),
                   list(base = paste0("/abc.def/", filename), ext = ext))

      expect_equal(path_split_ext(paste0(path, "/"), dot),
                   list(base = paste0(paste0(path, "/")), ext = ""))
    }
  }

  test_split_ext("foo.bar", "foo", "bar")
  test_split_ext("foo.boo.bar", "foo.boo", "bar")
  test_split_ext("foo.boo.biff.bar", "foo.boo.biff", "bar")
  test_split_ext(".csh.rc", ".csh", "rc")
  test_split_ext("nodots", "nodots", "")
  test_split_ext(".cshrc", ".cshrc", "")
  test_split_ext("...manydots", "...manydots", "")
  test_split_ext("...manydots.ext", "...manydots", "ext")
  test_split_ext(".", ".", "")
  test_split_ext("..", "..", "")
  test_split_ext("........", "........", "")
  test_split_ext("", "", "")
})

test_that("python nt test suite", {
  expect_equal(path_split_ext("foo.ext"),
               list(base = "foo", ext = "ext"))
  expect_equal(path_split_ext("/foo/foo.ext"),
               list(base = "/foo/foo", ext = "ext"))
  expect_equal(path_split_ext(".ext"),
               list(base = ".ext", ext = ""))
  expect_equal(path_split_ext("\\foo.ext\\foo"),
               list(base = "\\foo.ext\\foo", ext = ""))
  expect_equal(path_split_ext("foo.ext\\"),
               list(base = "foo.ext\\", ext = ""))
  expect_equal(path_split_ext(""),
               list(base = "", ext = ""))
  expect_equal(path_split_ext("foo.bar.ext"),
               list(base = "foo.bar", ext = "ext"))
  expect_equal(path_split_ext("xx/foo.bar.ext"),
               list(base = "xx/foo.bar", ext = "ext"))
  expect_equal(path_split_ext("xx\\foo.bar.ext"),
               list(base = "xx\\foo.bar", ext = "ext"))
  expect_equal(path_split_ext("c:a/b\\c.d"),
               list(base = "c:a/b\\c", ext = "d"))
})

test_that("extra windows pathology", {
  expect_equal(path_split_ext("\\.bashrc"),
               list(base = "\\.bashrc", ext = ""))
  expect_equal(path_split_ext("\\.bashrc", TRUE),
               list(base = "\\.bashrc", ext = ""))
})

test_that("missing values", {
  expect_equal(path_split_ext(NA),
               list(base = NA_character_, ext = NA_character_))
  expect_equal(path_split_ext(c(NA, "foo")),
               list(base = c(NA, "foo"), ext = c(NA, "")))
  expect_equal(path_split_ext(c(NA, "foo.bar")),
               list(base = c(NA, "foo"), ext = c(NA, "bar")))
})
