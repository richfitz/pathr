
context("path_split_drive on windows")

test_that("path_split_drive", {

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

  lapply(cases, function(case) {
    expect_equal(path_split_drive1(case[[1]]), case[[2]])
  })
})
