
context("utility functions")

sw_cases <- function() {
  list(
    eq = list(
      list(list(character(), character()), logical()),
      list(list(character(), "x"), logical()),
      list(list(character(), "foobar"), logical()),
      list(list(c("", ""), ""), c(TRUE, TRUE)),
      list(list(c("xxx", ""), c("x", "")), c(TRUE, TRUE)),
      list(list(c("xxx", "foo"), c("x", "bar")), c(TRUE, FALSE)),
      list(list(c("foobar", "bar"), c("foo", "bar")), c(TRUE, TRUE))
    ),

    true = list(
      c("", ""),
      c("xxx", ""),
      c("xxx", "x"),
      c("xxx", "xx"),
      c("xxx", "xxx"),
      c("foobar", "foo"),
      c("foobar", "foobar")
    ),

    false = list(
      c("", "x"),
      c("x", "xx"),
      c("foo", "b")
    )
  )
}

test_that("startswith", {

  cases <- sw_cases()

  for (case in cases$eq) {
    expect_equal(
      startswith(case[[1]][[1]], case[[1]][[2]]),
      case[[2]],
      info = paste(unlist(case[[1]]), collapse = ",")
    )
  }

  for (case in cases$true) {
    expect_true(
      startswith(case[[1]], case[[2]]),
      info = paste(case, collapse = ",")
    )
  }

  for (case in cases$false) {
    expect_false(
      startswith(case[[1]], case[[2]]),
      info = paste(case, collapse = ",")
    )
  }
})

rtol <- function(x) {
  vapply(
    lapply(strsplit(x, ""), rev),
    paste,
    FUN.VALUE = "",
    collapse = ""
  )
}

test_that("endswith", {

  cases <- sw_cases()

  for (case in cases$eq) {
    expect_equal(
      endswith(rtol(case[[1]][[1]]), rtol(case[[1]][[2]])),
      case[[2]],
      info = paste(unlist(case[[1]]), collapse = ",")
    )
  }

  for (case in cases$true) {
    expect_true(
      endswith(rtol(case[[1]]), rtol(case[[2]])),
      info = paste(case, collapse = ",")
    )
  }

  for (case in cases$false) {
    expect_false(
      endswith(rtol(case[[1]]), rtol(case[[2]])),
      info = paste(case, collapse = ",")
    )
  }

})

test_that("common_prefix", {

  ll <- function(x) strsplit(x, "")[[1]]

  cases <- list(
    c("/home/swenson/spam", "/home/swen/spam", "/home/swen"),
    c("/home/swen/spam", "/home/swen/eggs", "/home/swen/"),
    c("/home/swen/spam", "/home/swen/spam", "/home/swen/spam"),
    c("home:swenson:spam", "home:swen:spam", "home:swen"),
    c(":home:swen:spam", ":home:swen:eggs", ":home:swen:"),
    c(":home:swen:spam", ":home:swen:spam", ":home:swen:spam")
  )

  for (case in cases) {
    expect_equal(common_prefix(ll(case[1]), ll(case[2])), ll(case[[3]]))
  }

})

test_that("regexp_find_all", {
  expect_equal(regexp_find_all("/+", "foo"),
               list(start = integer(0), length = integer(0)))
  expect_equal(regexp_find_all("/+", "/foo"),
               list(start = 1L, length = 1L))
  expect_equal(regexp_find_all("/+", "/foo/"),
               list(start = c(1L, 5L), length = c(1L, 1L)))
  expect_equal(regexp_find_all("/+", "/foo/bar"),
               list(start = c(1L, 5L), length = c(1L, 1L)))
  expect_equal(regexp_find_all("/+", "foo/bar"),
               list(start = 4L, length = 1L))
  expect_equal(regexp_find_all("/+", "aa/bbbb//cccc/d"),
               list(start = c(3, 8, 14), length = c(1L, 2L, 1L)))
  expect_equal(regexp_find_all("/", "aa/bbbb//cccc/d"),
               list(start = c(3, 8, 9, 14), length = c(1L, 1L, 1L, 1L)))


  ## Here's a little case that fails nicely; there's an off-by-one somewhere.
  expect_equal(regexp_find_all("(/+|$)", "aa/b"),
               list(start = c(3L, 5L), length = c(1L, 0L)))

  ## Little bit of grouping
  expect_equal(regexp_find_all("(/+|$)", "aa/bbbb//cccc/d"),
               list(start = c(3, 8, 14, 16L), length = c(1L, 2L, 1L, 0L)))
  expect_equal(regexp_find_all("(/+)", "aa/bbbb//cccc/d"),
               list(start = c(3, 8, 14), length = c(1L, 2L, 1L)))
  expect_equal(regexp_find_all("($)", "aa/bbbb//cccc/d"),
               list(start = 16L, length = 0L))
})
