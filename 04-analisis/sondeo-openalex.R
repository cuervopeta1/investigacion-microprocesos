library(openalexR)
options(openalexR.mailto = "cuervo@manadalibre.org")

consultas <- list(
  "free software AND community",
  "open source AND social movement",
  "technological appropriation AND community",
  "technological sovereignty",
  "hacktivism"
)

for (q in consultas) {
  n <- oa_fetch(
    entity = "works",
    title_and_abstract.search = q,
    from_publication_date = "2005-01-01",
    count_only = TRUE
  )
  cat(q, "->", n[["count"]], "registros\n")
}
