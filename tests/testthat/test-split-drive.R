context("path_split_drive")

test_that("posix", {
  expect_equal(posix_path_split_drive("c:\\foo\\bar"),
               list(drive = "", path = "c:\\foo\\bar"))
  expect_equal(posix_path_split_drive("/foo/bar"),
               list(drive = "", path = "/foo/bar"))
  expect_equal(posix_path_split_drive(c(NA, "c:\\foo\\bar")),
               list(drive = c(NA, ""), path = c(NA, "c:\\foo\\bar")))
})

test_that("windows", {
  cases <- list(
    list("c:\\foo\\bar", c("c:", "\\foo\\bar")),
    list("c:/foo/bar", c("c:", "/foo/bar")),
    list("\\\\conky\\mountpoint\\foo\\bar",
         c("\\\\conky\\mountpoint", "\\foo\\bar")),
    list("//conky/mountpoint/foo/bar", c("//conky/mountpoint", "/foo/bar")),
    list("\\\\\\conky\\mountpoint\\foo\\bar",
         c("", "\\\\\\conky\\mountpoint\\foo\\bar")),
    list("///conky/mountpoint/foo/bar",
         c("", "///conky/mountpoint/foo/bar")),
    list("\\\\conky\\\\mountpoint\\foo\\bar",
         c("", "\\\\conky\\\\mountpoint\\foo\\bar")),
    list("//conky//mountpoint/foo/bar",
         c("", "//conky//mountpoint/foo/bar")),
    list("//conky/MOUNTPOİNT/foo/bar",
         c("//conky/MOUNTPOİNT", "/foo/bar"))
  )

  cases_path <- vcapply(cases, "[[", 1L)
  cases_drive <- vcapply(cases, function(x) x[[2]][[1]])
  cases_subpath <- vcapply(cases, function(x) x[[2]][[2]])

  res <- windows_path_split_drive(cases_path)
  expect_equal(res$drive, cases_drive)
  expect_equal(res$path, cases_subpath)

  expect_equal(windows_path_split_drive(NA),
               list(drive = NA_character_, path = NA_character_))
  expect_equal(windows_path_split_drive(""),
               list(drive = "", path = ""))
})
