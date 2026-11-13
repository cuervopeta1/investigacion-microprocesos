library(openalexR)
options(openalexR.mailto = "cuervopeta1@gmail.com")

ibero <- '("apropiación tecnológica" OR "apropriação tecnológica" OR "apropiación social de la tecnología" OR "soberanía tecnológica" OR "soberanía digital" OR "autonomía tecnológica") OR (("software libre" OR "software livre" OR "código abierto" OR "código aberto" OR "tecnologías libres" OR "redes comunitarias") AND (comunidad OR comunidade OR comunitario OR cooperativa OR campesino OR camponês OR indígena OR "organización social" OR "organização social" OR "movimiento social" OR "movimento social" OR "economía solidaria"))'

ingles <- '(("technological appropriation" OR "technology appropriation" OR "technological sovereignty" OR "digital sovereignty" OR "technological autonomy") OR (("free software" OR "open source" OR "community networks" OR FLOSS OR FOSS) AND (community OR cooperative OR peasant OR indigenous OR "social movement" OR grassroots))) AND ("Latin America" OR "Latin American" OR Colombia OR Mexico OR Brazil OR Argentina OR Ecuador OR Venezuela OR Chile OR Peru OR Bolivia OR Uruguay OR Paraguay OR Guatemala OR Cuba)'

cadenas <- list("Iberoamericana (ES+PT)" = ibero, "Inglés con recorte regional" = ingles)

for (nombre in names(cadenas)) {
  n <- oa_fetch(entity = "works",
                title_and_abstract.search = cadenas[[nombre]],
                from_publication_date = "2005-01-01",
                to_publication_date = "2026-12-31",
                count_only = TRUE)
  cat(sprintf("%-32s %6d\n", nombre, n[["count"]]))
}
