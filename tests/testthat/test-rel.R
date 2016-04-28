
context("path_rel")

test_that("posix_path_rel", {

  curdir <- basename(getwd())

  cases <- list(
    list("a", "a"),
    list(path_abs("a"), "a"),
    list("a/b", "a/b"),
    list("../a/b", "../a/b"),
    list(c("a", "../b"), paste0("../", curdir, "/a")),
    list(c("a/b", "../c"), paste0("../", curdir, "/a/b")),
    list(c("a", "b/c"), "../../a"),
    list(c("a", "a"), "."),
    list(c("/foo/bar/bat", "/x/y/z"), "../../../foo/bar/bat"),
    list(c("/foo/bar/bat", "/foo/bar"), "bat"),
    list(c("/foo/bar/bat", "/"), "foo/bar/bat"),
    list(c("/", "/foo/bar/bat"), "../../.."),
    list(c("/foo/bar/bat", "/x"), "../foo/bar/bat"),
    list(c("/", "/"), "."),
    list(c("/a", "/a"), "."),
    list(c("/a/b", "/a/b"), "."),
    list(list(c(NA, "a"), "."), c(NA, "a")),
    list(c("a", NA), NA_character_)
  )

  for (case in cases) {
    expect_equal(do.call(posix_path_rel, as.list(case[[1]])), case[[2]])
  }
})

test_that("win_path_rel", {

  curdir <- basename(getwd())

  cases <- list(
    list("a", "a"),
    list(path_abs("a"), "a"),
    list("a/b", "a\\b"),
    list(c("a", "../b"), paste0("..\\", curdir, "\\a")),
    list(c("a/b", "../c"), paste0("..\\", curdir, "\\a\\b")),
    list(c("a", "b/c"), "..\\..\\a"),
    list(c("c:/foo/bar/bat", "c:/x/y"), "..\\..\\foo\\bar\\bat"),
    list(c("//conky/mountpoint/a", "//conky/mountpoint/b/c"), "..\\..\\a"),
    list(c("a", "a"), "."),
    list(c("/foo/bar/bat", "/x/y/z"), "..\\..\\..\\foo\\bar\\bat"),
    list(c("/foo/bar/bat", "/foo/bar"), "bat"),
    list(c("/foo/bar/bat", "/"), "foo\\bar\\bat"),
    list(c("/", "/foo/bar/bat"), "..\\..\\.."),
    list(c("/foo/bar/bat", "/x"), "..\\foo\\bar\\bat"),
    list(c("/x", "/foo/bar/bat"), "..\\..\\..\\x"),
    list(c("/", "/"), "."),
    list(c("/a", "/a"), "."),
    list(c("/a/b", "/a/b"), "."),
    list(c("c:/foo", "C:/FOO"), "."),
    list(list(c(NA, "a"), "."), c(NA, "a")),
    list(c("a", NA), NA_character_)
  )

  wd <- gsub("/", "\\", fixed = TRUE, getwd())

  for (case in cases) {
    with_mock(
      `base::getwd` = function() wd,
      `pathr::is_windows` = function() TRUE,
      expect_equal(do.call(win_path_rel, as.list(case[[1]])), case[[2]])
    )
  }
})
