context("list_mount")

test_that("posix_path_list_mount", {
  dat <- posix_path_list_mount()
  expect_is(dat, "data.frame")

  ## TODO: standardise these
  if (is_linux()) {
    expect_equal(colnames(dat), c("fsname", "dir", "type", "opts"))
    expect_true("/" %in% dat[, "dir"])
  } else if (is_darwin()) {
    expect_equal(colnames(dat), c("fstype", "mnton", "mntfrom"))
    expect_true("/" %in% dat[, "mnton"])
  }
})
