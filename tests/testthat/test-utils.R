
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
