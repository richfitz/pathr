
context("path_norm")

test_that("posix_path_norm", {

  expect_equal(posix_path_norm(""), ".")
  expect_equal(posix_path_norm("/"), "/")
  expect_equal(posix_path_norm("//"), "//")
  expect_equal(posix_path_norm("///"), "/")
  expect_equal(posix_path_norm("///foo/.//bar//"), "/foo/bar")
  expect_equal(
    posix_path_norm("///foo/.//bar//.//..//.//baz"),
    "/foo/baz"
  )
  expect_equal(posix_path_norm("///..//./foo/.//bar"), "/foo/bar")

})


test_that("win_path_norm", {

  cases <- list(
    c("A//////././//.//B", "A\\B"),
    c("A/./B",             "A\\B"),
    c("A/foo/../B",        "A\\B"),
    c("C:A//B",            "C:A\\B"),
    c("D:A/./B",           "D:A\\B"),
    c("e:A/foo/../B",      "e:A\\B"),

    c("C:///A//B",         "C:\\A\\B"),
    c("D:///A/./B",        "D:\\A\\B"),
    c("e:///A/foo/../B",   "e:\\A\\B"),

    c("..", ".."),
    c(".", "."),
    c("", "."),
    c("/", "\\"),
    c("c:/", "c:\\"),
    c("/../.././..", "\\"),
    c("c:/../../..", "c:\\"),
    c("../.././..", "..\\..\\.."),
    c("K:../.././..", "K:..\\..\\.."),
    c("C:////a/b", "C:\\a\\b"),
    c("//machine/share//a/b", "\\\\machine\\share\\a\\b"),
    c("\\\\.\\NUL", "\\\\.\\NUL"),
    c("\\\\?\\D:/XY\\Z", "\\\\?\\D:/XY\\Z")
  )

  lapply(cases, function(case) {
    expect_equal(win_path_norm(case[1]), case[2], info = case[[1]])
  })

})

test_that("missing values", {
  with_mock(
    `pathr::is_windows` = function() TRUE,
    expect_equal(win_path_norm(NA_character_), NA_character_))
  with_mock(
    `pathr::is_windows` = function() FALSE,
    expect_equal(win_path_norm(NA_character_), NA_character_))
})
