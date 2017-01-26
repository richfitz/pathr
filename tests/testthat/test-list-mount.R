context("list_mount")

test_that("posix_path_list_mount", {
  dat <- posix_path_list_mount()
  expect_is(dat, "matrix")
  expect_equal(colnames(dat), c("fsname", "dir", "type", "opts"))
  expect_true("/" %in% dat[, "dir"])
})
