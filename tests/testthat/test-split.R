context("path_split")

test_that("match python semantics", {
  expect_equal(posix_path_split("/foo"),
               list(head = "/", tail = "foo"))
  expect_equal(posix_path_split("/foo/"),
               list(head = "/foo", tail = ""))
  expect_equal(posix_path_split("/foo//"),
               list(head = "/foo", tail = ""))
  expect_equal(posix_path_split("foo"),
               list(head = "", tail = "foo"))
  expect_equal(posix_path_split("/foo/bar"),
               list(head = "/foo", tail = "bar"))
  expect_equal(posix_path_split("/foo/bar/"),
               list(head = "/foo/bar", tail = ""))
  expect_equal(posix_path_split("foo/bar"),
               list(head = "foo", tail = "bar"))
  expect_equal(posix_path_split("foo/bar/"),
               list(head = "foo/bar", tail = ""))
  expect_equal(posix_path_split("/"),
               list(head = "/", tail = ""))
  expect_equal(posix_path_split(""),
               list(head = "", tail = ""))
  expect_equal(posix_path_split(NA),
               list(head = NA_character_, tail = NA_character_))
  expect_equal(posix_path_split(character(0)),
               list(head = character(0), tail = character(0)))

  ## all at once:
  path <- c("/foo",
            "/foo/",
            "/foo//",
            "foo",
            "/foo/bar",
            "/foo/bar/",
            "foo/bar",
            "foo/bar/",
            "/",
            "",
            NA)
  expect_equal(posix_path_split(path),
               list(head =
                      c("/", "/foo", "/foo", "", "/foo", "/foo/bar",
                        "foo", "foo/bar", "/", "", NA),
                    tail = c("foo", "", "", "foo", "bar", "", "bar",
                             "", "", "", NA)))
})
