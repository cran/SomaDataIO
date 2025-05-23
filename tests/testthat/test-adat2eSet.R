
if ( rlang::is_installed("Biobase") ) {
  suppressPackageStartupMessages(library(Biobase))
  sub_adat <- example_data[1:10L, c(1:5L, 35:37L)]
}



test_that("`adat2eSet()` converts `soma_adt` -> eSet correctly", {
  testthat::skip_if_not_installed("Biobase")
  eSet <- adat2eSet(sub_adat)
  expect_s4_class(eSet, "ExpressionSet")
  expect_true(is.matrix(eSet@assayData$exprs))
  expect_equal(dim(eSet@assayData$exprs), c(3L, 10L))
  expect_type(eSet@experimentData@other, "list")
  expect_equal(eSet@experimentData@url, "www.standardbio.com")
  expect_equal(eSet@experimentData@title, "Example Adat Set001, Example Adat Set002")
  expect_equal(eSet@experimentData@lab, "Standard BioTools, Inc.")
  expect_equal(eSet@experimentData@other$Version, "1.2")
  expect_equal(eSet@experimentData@other$ExpDate, "2020-06-18, 2020-07-20")
  expect_equal(eSet@experimentData@other$AssaySite, "SW")
  expect_equal(eSet@experimentData@other$AssayVersion, "V4")
  expect_equal(eSet@experimentData@other$AssayRobot, "Fluent 1 L-307")
  expect_equal(eSet@experimentData@other$StudyMatrix, "EDTA Plasma")
  expect_equal(eSet@experimentData@other$CreatedBy, "PharmaServices")
  expect_equal(eSet@experimentData@other$CalibratorId, "170261")
  expect_equal(eSet@experimentData@title, eSet@experimentData@other$Title)
  anno <- getAnalyteInfo(sub_adat) |> data.frame() |> col2rn("AptName")
  expect_equal(rownames(eSet@featureData@varMetadata), names(anno))
  expect_equal(rownames(eSet@featureData@data), getAnalytes(sub_adat))
  expect_equal(eSet@featureData@data, anno)
  expect_equal(rownames(eSet@phenoData@data), rownames(sub_adat))
  expect_named(eSet@phenoData@data, getMeta(sub_adat))
  expect_equal(eSet@phenoData@data, data.frame(sub_adat[, getMeta(sub_adat)]))
  expect_equal(eSet@phenoData@dimLabels, c("sampleNames", "sampleColumns"))
  expect_equal(eSet@featureData@dimLabels, c("featureNames", "featureColumns"))
  expect_equal(colnames(eSet@assayData$exprs), rownames(sub_adat))
  expect_equal(rownames(eSet@assayData$exprs), rownames(anno))
  expect_equal(rownames(eSet@assayData$exprs), getAnalytes(sub_adat))
  expect_equal(rownames(eSet@assayData$exprs), rownames(eSet@featureData@data))
})
