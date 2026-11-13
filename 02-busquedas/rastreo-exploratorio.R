library(openalexR)
options(openalexR.mailto = "cuervopeta1@gmail.com")

terminos <- c(
  '"apropiación tecnológica"',
  '"apropiación social de la tecnología"',
  '"soberanía tecnológica"',
  '"soberanía digital"',
  '"autonomía tecnológica"',
  '"apropriação tecnológica"',
  '"soberania tecnológica"',
  '"autonomia tecnológica"',
  '"technological appropriation"',
  '"technological sovereignty"',
  '"digital sovereignty"',
  '"software libre" AND (comunidad OR cooperativa OR campesino OR indígena)',
  '"software livre" AND (comunidade OR cooperativa OR indígena)',
  '"free software" AND (community OR cooperative OR indigenous)',
  '"redes comunitarias" AND (internet OR conectividad)',
  '"community networks" AND (Latin America OR indigenous OR rural)'
)

for (t in terminos) {
  n <- oa_fetch(entity = "works",
                title_and_abstract.search = t,
                from_publication_date = "2005-01-01",
                to_publication_date = "2026-12-31",
                count_only = TRUE)
  cat(sprintf("%-72s %6d\n", t, n[["count"]]))
}
