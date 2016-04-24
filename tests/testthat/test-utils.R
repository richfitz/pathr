
context("utility functions")

test_that("startswith", {

  expect_equal(startswith(character(), character()), logical())
  expect_equal(startswith(character(), "x"), logical())
  expect_equal(startswith(character(), "foobar"), logical())

  expect_true(startswith("", ""))
  expect_true(startswith("xxx", ""))
  expect_true(startswith("xxx", "x"))
  expect_true(startswith("xxx", "xx"))
  expect_true(startswith("xxx", "xxx"))
  expect_true(startswith("foobar", "foo"))
  expect_true(startswith("foobar", "foobar"))

  expect_false(startswith("", "x"))
  expect_false(startswith("x", "xx"))
  expect_false(startswith("foo", "b"))

  expect_equal(startswith(c("", ""), ""), c(TRUE, TRUE))
  expect_equal(startswith(c("xxx", ""), c("x", "")), c(TRUE, TRUE))
  expect_equal(startswith(c("xxx", "foo"), c("x", "bar")), c(TRUE, FALSE))
  expect_equal(startswith(c("foobar", "bar"), c("foo", "bar")), c(TRUE, TRUE))

})
