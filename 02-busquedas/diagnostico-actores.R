library(openalexR)
options(openalexR.mailto = "cuervopeta1@gmail.com")

tecnologia <- '("software libre" OR "software livre" OR "código abierto" OR "código aberto" OR "tecnologías libres" OR "redes comunitarias")'

soberania <- '("soberanía tecnológica" OR "soberanía digital" OR "autonomía tecnológica")'

apropiacion <- '("apropiación tecnológica" OR "apropriação tecnológica" OR "apropiación social de la tecnología")'

# actores con comunidad en formas precisas, sin el término suelto
precisos <- '(cooperativa OR campesino OR camponês OR indígena OR "organización social" OR "organização social" OR "movimiento social" OR "movimento social" OR "economía solidaria" OR "comunidad indígena" OR "comunidade indígena" OR "comunidad campesina" OR "comunidad rural" OR "comunidade rural" OR "comunidad local" OR "organización comunitaria" OR "organização comunitária")'

vagos <- '(comunidad OR comunidade OR comunitario OR comunitária)'

bloques <- list(
  "E. Tecnologia AND precisos"    = paste(tecnologia, "AND", precisos),
  "F. Tecnologia AND vagos"       = paste(tecnologia, "AND", vagos),
  "G. Codigo abierto AND vagos"   = paste('("código abierto" OR "código aberto")', "AND", vagos),
  "H. CADENA CORREGIDA"           = paste0(apropiacion, " OR (", soberania, " AND ", precisos,
                                           ") OR (", tecnologia, " AND ", precisos, ")")
)

for (nombre in names(bloques)) {
  n <- oa_fetch(entity = "works", title_and_abstract.search = bloques[[nombre]],
                from_publication_date = "2005-01-01",
                to_publication_date = "2026-12-31", count_only = TRUE)
  cat(sprintf("%-32s %6d\n", nombre, n[["count"]]))
  Sys.sleep(3)
}
