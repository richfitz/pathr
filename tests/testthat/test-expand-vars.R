context("expand_vars")

test_that("missing", {
  expect_equal(posix_path_expand_vars(NA_character_), NA_character_)
  expect_equal(posix_path_expand_vars(NA), NA_character_)
  expect_equal(posix_path_expand_vars(NULL), character(0))
})

test_that("none", {
  expect_equal(posix_path_expand_vars(character(0)), character(0))
  expect_equal(posix_path_expand_vars("foo"), "foo")
  expect_equal(posix_path_expand_vars(c("foo", "bar")), c("foo", "bar"))
})

test_that("single", {
  Sys.setenv("MYVAR" = "foobar")
  on.exit(Sys.unsetenv("MYVAR"))

  expect_equal(posix_path_expand_vars("foo/$MYVAR"), "foo/foobar")
  expect_equal(posix_path_expand_vars("foo/${MYVAR}"), "foo/foobar")

  expect_equal(posix_path_expand_vars(c("foo/${MYVAR}", "$MYVAR")),
               c("foo/foobar", "foobar"))
})

test_that("multiple", {
  Sys.setenv("MYVAR1" = "foo", "MYVAR2" = "bar")
  on.exit(Sys.unsetenv(c("MYVAR1", "MYVAR2")))

  expect_equal(posix_path_expand_vars("root/$MYVAR1/${MYVAR2}"),
               "root/foo/bar")
  expect_equal(posix_path_expand_vars(c("root/$MYVAR1/${MYVAR2}",
                                        "root-$MYVAR1-$MYVAR2")),
               c("root/foo/bar", "root-foo-bar"))
})

test_that("missing variable", {
  Sys.setenv("MYVAR1" = "foo", "MYVAR2" = "bar")
  on.exit(Sys.unsetenv(c("MYVAR1", "MYVAR2")))

  expect_equal(posix_path_expand_vars("$MYVAR3/$MYVAR2/${MYVAR3}"),
               "$MYVAR3/bar/${MYVAR3}")
})
