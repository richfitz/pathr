context("split_unc")

test_that("python suite", {
  ## There are only two test cases given
  expect_equal(path_split_unc("\\\\conky\\mountpoint\\foo\\bar"),
               list(unc = "\\\\conky\\mountpoint", path = "\\foo\\bar"))
  expect_equal(path_split_unc("//conky/mountpoint/foo/bar"),
               list(unc = "//conky/mountpoint", path = "/foo/bar"))
})

test_that("vectors; corner cases", {
  ## No entries
  expect_equal(path_split_unc(character(0)),
               list(unc = character(0), path = character(0)))
  expect_equal(path_split_unc(NULL),
               list(unc = character(0), path = character(0)))

  ## all missing
  expect_equal(path_split_unc(NA),
               list(unc = NA_character_, path = NA_character_))
  expect_equal(path_split_unc(c(NA, NA)),
               list(unc = rep(NA_character_, 2),
                    path = rep(NA_character_, 2)))
})

test_that("vectors of non-unc paths", {
  expect_equal(path_split_unc(c("foo", "bar")),
               list(unc = c("", ""), path = c("foo", "bar")))
  expect_equal(path_split_unc(c("foo", NA, "bar")),
               list(unc = c("", NA, ""), path = c("foo", NA, "bar")))
  expect_equal(path_split_unc(c("c:/foo", "bar")),
               list(unc = c("", ""), path = c("c:/foo", "bar")))
  expect_equal(path_split_unc(c("c:\\foo", "bar")),
               list(unc = c("", ""), path = c("c:\\foo", "bar")))
})

test_that("vectors of unc hosts", {
  expect_equal(path_split_unc(c("//foo/bar", "//host/drive")),
               list(unc = c("//foo/bar", "//host/drive"), path = c("", "")))
  expect_equal(path_split_unc(c("//foo/bar", NA, "//host/drive")),
               list(unc = c("//foo/bar", NA, "//host/drive"),
                    path = c("", NA, "")))

  expect_equal(
    path_split_unc(c("\\\\foo\\bar", "\\\\host\\drive")),
    list(unc = c("\\\\foo\\bar", "\\\\host\\drive"), path = c("", "")))
})

test_that("vectors of full unc paths", {
  expect_equal(
    path_split_unc(c("//foo/bar//path", "//host/drive//another")),
    list(unc = c("//foo/bar", "//host/drive"),
         path = c("//path", "//another")))
  expect_equal(
    path_split_unc(c("//foo/bar//path", NA, "//host/drive//another")),
    list(unc = c("//foo/bar", NA, "//host/drive"),
         path = c("//path", NA, "//another")))

  expect_equal(
    path_split_unc(c("\\\\foo\\bar\\\\path", "\\\\host\\drive\\\\another")),
    list(unc = c("\\\\foo\\bar", "\\\\host\\drive"),
         path = c("\\\\path", "\\\\another")))
})

test_that("vector of full and drive paths", {
  expect_equal(
    path_split_unc(c("//foo/bar//path", "c:/local")),
    list(unc = c("//foo/bar", ""),
         path = c("//path", "c:/local")))
  expect_equal(
    path_split_unc(c("//foo/bar//path", NA, "c:/local")),
    list(unc = c("//foo/bar", NA, ""),
         path = c("//path", NA, "c:/local")))

  expect_equal(
    path_split_unc(c("\\\\foo\\bar\\\\path", "c:\\local")),
    list(unc = c("\\\\foo\\bar", ""),
         path = c("\\\\path", "c:\\local")))

})

test_that("invalid", {
  expect_error(path_split_unc("\\\\conky"), "illegal UNC path: \\\\conky",
               fixed = TRUE)
  expect_error(path_split_unc(c("\\\\foo\\bar", "\\\\conky")),
               "illegal UNC path: \\\\conky",
               fixed = TRUE)
  expect_error(path_split_unc(c("\\\\foo\\bar", NA, "\\\\conky")),
               "illegal UNC path: \\\\conky",
               fixed = TRUE)
  expect_error(path_split_unc(c("\\\\foo\\bar", "\\\\err", "\\\\conky")),
               "illegal UNC paths: \\\\err, \\\\conky",
               fixed = TRUE)
  expect_error(path_split_unc(c("\\\\foo\\bar", "\\\\err", "\\\\err")),
               "illegal UNC path: \\\\err",
               fixed = TRUE)
})
