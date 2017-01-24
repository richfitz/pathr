context("path_join")

test_that("posix_path_join, scalar", {
  ## Fairly simple cases:
  expect_equal(posix_path_join("foo"), "foo")
  expect_equal(posix_path_join("foo", "bar"), "foo/bar")
  expect_equal(posix_path_join("foo/", "bar/"), "foo/bar/")
  expect_equal(posix_path_join("foo/", "bar"), "foo/bar")
  expect_equal(posix_path_join("foo", "bar/"), "foo/bar/")

  ## Path containing an absolute component:
  expect_equal(posix_path_join("foo", "/bar/"), "/bar/")
  expect_equal(posix_path_join("foo", "/bar/", "baz"), "/bar/baz")

  ## First component can be abs:
  expect_equal(posix_path_join("/foo", "bar/"), "/foo/bar/")
  expect_equal(posix_path_join("/foo", "bar/", "baz"), "/foo/bar/baz")

  ## but subsequent overrides
  expect_equal(posix_path_join("/foo", "/bar/"), "/bar/")
  expect_equal(posix_path_join("/foo", "/bar/", "baz"), "/bar/baz")

  ## Path containing missing elements
  expect_error(posix_path_join(NA_character_),
               "'NA' path components are not allowed")
})

test_that("posix_path_join, vector", {
  ## expect_equal(posix_path_join(), character(0))
  expect_equal(posix_path_join(c("foo1", "foo2")), c("foo1", "foo2"))

  expect_equal(posix_path_join(c("foo1", "foo2"), "bar"),
               c("foo1/bar", "foo2/bar"))
  expect_equal(posix_path_join(c("foo1/", "foo2/"), "bar"),
               c("foo1/bar", "foo2/bar"))
  expect_equal(posix_path_join(c("foo1/", "foo2/"), "bar/"),
               c("foo1/bar/", "foo2/bar/"))

  expect_equal(posix_path_join("foo", c("bar1", "bar2")),
               c("foo/bar1", "foo/bar2"))
  expect_equal(posix_path_join("foo/", c("bar1", "bar2")),
               c("foo/bar1", "foo/bar2"))
  expect_equal(posix_path_join("foo/", c("bar1/", "bar2/")),
               c("foo/bar1/", "foo/bar2/"))

  expect_equal(posix_path_join(c("foo1", "foo2"), c("bar1", "bar2")),
               c("foo1/bar1", "foo2/bar2"))

  ## Internal absolute paths
  expect_equal(posix_path_join(c("foo1", "foo2"), c("/bar1", "/bar2")),
               c("/bar1", "/bar2"))
  expect_equal(posix_path_join(c("foo1", "foo2"), c("/bar1", "bar2")),
               c("/bar1", "foo2/bar2"))

  expect_equal(posix_path_join(c("foo1", "foo2", "foo3"),
                               c("/bar1", "/bar2", "/bar3"),
                               c("/baz1", "/baz2", "baz3")),
               c("/baz1", "/baz2", "/bar3/baz3"))
})

test_that("posix_path_join, corner case", {
  ## I don't know how useful these will be, but they simplify the code
  ## and seem like a reasonable versions of the limit cases.
  expect_equal(posix_path_join(), character(0))
  expect_equal(posix_path_join(character(0)), character(0))
  expect_equal(posix_path_join(character(0), character(0)), character(0))
})

test_that("invalid lengths", {
  expect_error(posix_path_join("a", c("b", "c"), c("d", "e", "f")),
               "expected all lengths to be 1 or 3")
  expect_error(posix_path_join("a", character(0)),
               "expected all lengths to be 1")
})

test_that("invalid content", {
  expect_error(posix_path_join("a", 1),
               "All path elements must be character")
})
