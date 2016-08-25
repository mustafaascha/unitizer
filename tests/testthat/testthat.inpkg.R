library(testthat)
library(unitizer)
context("In Package")

if(!file_test("-d", file.path("helper", "refobjs")))
  stop("Make sure wd is set to tests/testthat")

(.unitizer.fastlm <- copy_fastlm_to_tmpdir())    # package directory
devtools::install(.unitizer.fastlm, quiet=TRUE)  # install first version
.unitizer.test.file <- file.path(.unitizer.fastlm, "tests", "extra", "inpkg.R")
.unitizer.test.store <- file.path(.unitizer.fastlm, "tests", "extra", "inpkg.unitizer")
test.dir <- file.path(.unitizer.fastlm, "tests", "extra")
old.width <- options(width=80L)

unitizer:::read_line_set_vals(c("Q"))
txt1 <- unitizer:::capture_output(
  unitize(.unitizer.test.file, interactive.mode=TRUE)
)
unitizer:::read_line_set_vals(c("Q"))
txt2 <- unitizer:::capture_output(
  unitize(.unitizer.test.file, state=in_pkg(), interactive.mode=TRUE)
)
unitizer:::read_line_set_vals(c("Q"))
txt3 <- unitizer:::capture_output(
  try(
    unitize(
      .unitizer.test.file, state=in_pkg("ASDFASDFA"), interactive.mode=TRUE
) ) )
test_that("in_pkg", {
  expect_equal_to_reference(
    txt1, file.path("helper", "refobjs", "inpkg_txt1.rds")
  )
  expect_equal_to_reference(
    txt2, file.path("helper", "refobjs", "inpkg_txt2.rds")
  )
  expect_equal_to_reference(
    txt3, file.path("helper", "refobjs", "inpkg_txt3.rds")
  )
})

unitizer_cleanup_demo()
unitizer:::read_line_set_vals(NULL)
options(old.width)