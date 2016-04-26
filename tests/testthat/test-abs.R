
context("path_abs")

test_that("NAs and vectorization", {

  expect_equal(
    path_abs(character()),
    character()
  )

  expect_equal(
    path_abs(NA_character_),
    NA_character_
  )

  expect_equal(
    path_abs(c(NA, "/foo", NA)),
    c(NA, "/foo", NA)
  )
})
