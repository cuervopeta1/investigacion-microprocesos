library(openalexR)
options(openalexR.mailto = "cuervopeta1@gmail.com")

actores <- '(cooperativa OR campesino OR camponês OR indígena OR "organización social" OR "organização social" OR "movimiento social" OR "movimento social" OR "economía solidaria" OR comunidad OR comunidade)'

tecnologia <- '("software libre" OR "software livre" OR "código abierto" OR "código aberto" OR "tecnologías libres" OR "redes comunitarias")'

soberania <- '("soberanía tecnológica" OR "soberanía digital" OR "autonomía tecnológica")'

bloques <- list(
  "A. Apropiacion sola"            = '("apropiación tecnológica" OR "apropriação tecnológica" OR "apropiación social de la tecnología")',
  "B. Soberania sola"              = soberania,
  "C. Soberania AND actores"       = paste(soberania, "AND", actores),
  "D. Tecnologia AND actores"      = paste(tecnologia, "AND", actores)
)

for (nombre in names(bloques)) {
  n <- oa_fetch(entity = "works", title_and_abstract.search = bloques[[nombre]],
                from_publication_date = "2005-01-01",
                to_publication_date = "2026-12-31", count_only = TRUE)
  cat(sprintf("%-32s %6d\n", nombre, n[["count"]]))
  Sys.sleep(3)
}
