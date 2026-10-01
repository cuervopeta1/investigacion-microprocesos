library(openalexR)
options(openalexR.mailto = "cuervo@manadalibre.org")

latam <- "mx|co|br|ar|cl|pe|ec|ve|bo|uy|py|cr|gt|cu|hn|ni|pa|sv|do"

consultas <- list(
  '"free software"',
  '"open source" "community"',
  '"technological appropriation"',
  '"technological sovereignty"',
  '"digital sovereignty"',
  '"hacktivism"',
  '"community networks"',
  '"data colonialism"'
)

for (q in consultas) {
  global <- oa_fetch(entity = "works",
                     title_and_abstract.search = q,
                     from_publication_date = "2005-01-01",
                     count_only = TRUE)

  region <- oa_fetch(entity = "works",
                     title_and_abstract.search = q,
                     from_publication_date = "2005-01-01",
                     institutions.country_code = latam,
                     count_only = TRUE)

  cat(sprintf("%-32s global: %6d   LatAm: %5d\n",
              q, global[["count"]], region[["count"]]))
}
