library(openalexR)
options(openalexR.mailto = "cuervopeta1@gmail.com")

apropiacion <- '("technological appropriation" OR "technology appropriation" OR "social appropriation of technology")'

soberania <- '("technological sovereignty" OR "digital sovereignty" OR "technological autonomy")'

tecnologia <- '("free software" OR "open source" OR "community networks" OR FLOSS OR FOSS)'

precisos <- '(cooperative OR peasant OR indigenous OR "social movement" OR grassroots OR "community organization" OR "community-based organization" OR "rural community" OR "indigenous community" OR "solidarity economy")'

region <- '("Latin America" OR "Latin American" OR Colombia OR Mexico OR Brazil OR Argentina OR Ecuador OR Venezuela OR Chile OR Peru OR Bolivia OR Uruguay OR Paraguay OR Guatemala OR Cuba)'

nucleo <- paste0(apropiacion, " OR (", soberania, " AND ", precisos,
                 ") OR (", tecnologia, " AND ", precisos, ")")

bloques <- list(
  "I. Nucleo ingles sin region" = nucleo,
  "J. CADENA INGLESA FINAL"     = paste0("(", nucleo, ") AND ", region)
)

for (nombre in names(bloques)) {
  n <- oa_fetch(entity = "works", title_and_abstract.search = bloques[[nombre]],
                from_publication_date = "2005-01-01",
                to_publication_date = "2026-12-31", count_only = TRUE)
  cat(sprintf("%-32s %6d\n", nombre, n[["count"]]))
  Sys.sleep(3)
}
