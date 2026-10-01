library(openalexR)
options(openalexR.mailto = "cuervo@manadalibre.org")

consultas <- list(
  '"apropiación tecnológica"',
  '"soberanía tecnológica"',
  '"software libre" "comunidad"',
  '"redes comunitarias"',
  '"apropiación social de la tecnología"',
  '"apropriação tecnológica"',
  '"soberania tecnológica"',
  '"software livre" "comunidade"'
)

for (q in consultas) {
  n <- oa_fetch(entity = "works",
                title_and_abstract.search = q,
                from_publication_date = "2005-01-01",
                count_only = TRUE)
  cat(sprintf("%-40s %5d\n", q, n[["count"]]))
}
