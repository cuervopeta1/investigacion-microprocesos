# -*- coding: utf-8 -*-
# descargar-corpus.R
# Corpus OpenAlex para el artículo 01 — microprocesos de resistencia tecnológica.
#
# Paginación simple por número de página (no por cursor): válida hasta
# 10.000 resultados, y las dos cadenas están muy por debajo de eso.
# El correo de contacto va en la cabecera User-Agent, como pide OpenAlex
# para el "polite pool", y se lee de la variable de entorno
# OPENALEX_MAILTO para no quedar escrito dentro del script.
#
# Guarda cada cadena en 03-corpus/crudo-*.rds en cuanto la termina, así
# una falla posterior no obliga a repetir lo ya descargado. Para forzar
# una descarga nueva, borra el archivo correspondiente.
#
# Uso:
#   export OPENALEX_MAILTO="tu-correo@ejemplo.org"
#   Rscript 02-busquedas/descargar-corpus.R

library(curl)
library(jsonlite)

EMAIL <- Sys.getenv("OPENALEX_MAILTO", "")
if (!nzchar(EMAIL)) {
  stop("Falta la variable OPENALEX_MAILTO.\n",
       "  Corre antes:  export OPENALEX_MAILTO=\"tu-correo@ejemplo.org\"")
}
AGENTE <- paste0("microprocesos-ti/1.0 (mailto:", EMAIL, ")")

DESDE <- "2005-01-01"
HASTA <- "2026-12-31"
POR_PAGINA <- 200
PAUSA <- 2                                  # segundos entre páginas
ESPERAS <- c(5, 10, 20, 40, 60, 90, 120)    # reintentos ante 429 o caída

dir.create("03-corpus", showWarnings = FALSE)

## ------------------------------------------------------------------ cadenas

apro_es <- '("apropiación tecnológica" OR "apropriação tecnológica" OR "apropiación social de la tecnología")'
sob_es  <- '("soberanía tecnológica" OR "soberanía digital" OR "autonomía tecnológica")'
tec_es  <- '("software libre" OR "software livre" OR "código abierto" OR "código aberto" OR "tecnologías libres" OR "redes comunitarias")'
act_es  <- '(cooperativa OR campesino OR camponês OR indígena OR "organización social" OR "organização social" OR "movimiento social" OR "movimento social" OR "economía solidaria" OR "comunidad indígena" OR "comunidade indígena" OR "comunidad campesina" OR "comunidad rural" OR "comunidade rural" OR "comunidad local" OR "organización comunitaria" OR "organização comunitária")'

apro_en <- '("technological appropriation" OR "technology appropriation" OR "social appropriation of technology")'
sob_en  <- '("technological sovereignty" OR "digital sovereignty" OR "technological autonomy")'
tec_en  <- '("free software" OR "open source" OR "community networks" OR FLOSS OR FOSS)'
act_en  <- '(cooperative OR peasant OR indigenous OR "social movement" OR grassroots OR "community organization" OR "community-based organization" OR "rural community" OR "indigenous community" OR "solidarity economy")'
region  <- '("Latin America" OR "Latin American" OR Colombia OR Mexico OR Brazil OR Argentina OR Ecuador OR Venezuela OR Chile OR Peru OR Bolivia OR Uruguay OR Paraguay OR Guatemala OR Cuba)'

armar <- function(a, s, t, ac) {
  paste0(a, " OR (", s, " AND ", ac, ") OR (", t, " AND ", ac, ")")
}

cadena_ibero  <- armar(apro_es, sob_es, tec_es, act_es)
cadena_ingles <- paste0("(", armar(apro_en, sob_en, tec_en, act_en), ") AND ", region)

## ------------------------------------------------------------- descarga

cuerpo_de <- function(resp) {
  s <- rawToChar(resp$content)
  Encoding(s) <- "UTF-8"
  s
}

pedir <- function(url) {
  for (k in seq_along(ESPERAS)) {
    h <- curl::new_handle(useragent = AGENTE)
    resp <- tryCatch(curl::curl_fetch_memory(url, handle = h),
                     error = function(e) NULL)

    if (!is.null(resp) && resp$status_code == 200) {
      dat <- tryCatch(jsonlite::fromJSON(cuerpo_de(resp), simplifyVector = FALSE),
                      error = function(e) NULL)
      if (!is.null(dat) && !is.null(dat$results)) return(dat)
      cat("      respuesta 200 pero ilegible — reintento\n")
    }

    codigo <- if (is.null(resp)) 0L else resp$status_code

    # Un 4xx de este tipo no se arregla esperando: muestra el motivo y para.
    if (codigo %in% c(400L, 401L, 403L, 404L, 422L)) {
      cat("\n   OpenAlex respondió ", codigo, ". Mensaje recibido:\n   ",
          substr(gsub("[[:space:]]+", " ", cuerpo_de(resp)), 1, 700), "\n\n", sep = "")
      cat("   URL usada:\n   ", substr(url, 1, 400), "...\n\n", sep = "")
      stop("Error no recuperable de la API (", codigo, ").")
    }

    cat("      reintento ", k, " (",
        if (codigo == 0L) "sin respuesta" else codigo,
        ") — espero ", ESPERAS[k], " s\n", sep = "")
    Sys.sleep(ESPERAS[k])
  }
  stop("OpenAlex no respondió tras ", length(ESPERAS), " intentos.")
}

bajar_cadena <- function(consulta, etiqueta) {
  archivo <- file.path("03-corpus", paste0("crudo-", etiqueta, ".rds"))
  if (file.exists(archivo)) {
    guardado <- readRDS(archivo)
    cat("== ", etiqueta, ": ya descargada (", length(guardado),
        " registros), se reutiliza ==\n", sep = "")
    return(guardado)
  }

  filtro <- paste0("title_and_abstract.search:", consulta,
                   ",from_publication_date:", DESDE,
                   ",to_publication_date:", HASTA)
  filtro_url <- curl::curl_escape(filtro)

  acumulado <- list()
  total <- NA_integer_
  pagina <- 1L

  repeat {
    url <- paste0("https://api.openalex.org/works",
                  "?filter=", filtro_url,
                  "&per-page=", POR_PAGINA,
                  "&page=", pagina)

    dat <- pedir(url)

    if (is.na(total)) {
      total <- as.integer(dat$meta$count)
      cat("== ", etiqueta, ": ", total, " registros declarados ==\n", sep = "")
    }

    res <- dat$results
    if (!length(res)) break
    acumulado <- c(acumulado, res)
    cat(sprintf("   página %d — %d / %d\n", pagina, length(acumulado), total))

    if (length(acumulado) >= total) break
    pagina <- pagina + 1L
    Sys.sleep(PAUSA)
  }

  if (length(acumulado) < total) {
    cat("   ATENCIÓN: faltaron ", total - length(acumulado),
        " registros de esta cadena.\n", sep = "")
  }

  saveRDS(acumulado, archivo)
  cat("   guardado en ", archivo, "\n", sep = "")
  acumulado
}

ibero <- bajar_cadena(cadena_ibero, "iberoamericana")
Sys.sleep(10)
ingles <- bajar_cadena(cadena_ingles, "inglesa")

crudos <- c(lapply(ibero,  function(r) list(rec = r, cadena = "iberoamericana")),
            lapply(ingles, function(r) list(rec = r, cadena = "inglesa")))

## ------------------------------------------------------------- utilidades

# Baja por una ruta de claves anidadas devolviendo NULL si falta alguna.
baja <- function(x, ...) {
  for (k in c(...)) {
    if (is.null(x)) return(NULL)
    x <- x[[k]]
  }
  x
}

txt <- function(v) {
  if (is.null(v) || length(v) == 0) return(NA_character_)
  v <- as.character(v[[1]])
  if (is.na(v) || !nzchar(v)) return(NA_character_)
  gsub("[[:space:]]+", " ", v)
}

num <- function(v) {
  if (is.null(v) || length(v) == 0) return(NA_integer_)
  suppressWarnings(as.integer(v[[1]]))
}

# OpenAlex guarda el resumen como índice invertido: palabra -> posiciones.
rearmar_resumen <- function(inv) {
  if (is.null(inv) || length(inv) == 0) return(NA_character_)
  posiciones <- unlist(inv, use.names = FALSE)
  palabras   <- rep(names(inv), lengths(inv))
  if (!length(posiciones)) return(NA_character_)
  gsub("[[:space:]]+", " ", paste(palabras[order(posiciones)], collapse = " "))
}

autores_de <- function(rec) {
  a <- rec$authorships
  if (is.null(a) || length(a) == 0) return(character(0))
  nombres <- vapply(a, function(z) {
    n <- baja(z, "author", "display_name")
    if (is.null(n)) NA_character_ else as.character(n)[1]
  }, character(1))
  nombres[!is.na(nombres) & nzchar(nombres)]
}

## ------------------------------------------------------------ tabla plana

fila_de <- function(envoltorio) {
  r <- envoltorio$rec
  data.frame(
    id      = txt(r$id),
    doi     = txt(r$doi),
    titulo  = txt(r$display_name),
    autores = paste(autores_de(r), collapse = "; "),
    anio    = num(r$publication_year),
    fecha   = txt(r$publication_date),
    revista = txt(baja(r, "primary_location", "source", "display_name")),
    volumen = txt(baja(r, "biblio", "volume")),
    numero  = txt(baja(r, "biblio", "issue")),
    pag_ini = txt(baja(r, "biblio", "first_page")),
    pag_fin = txt(baja(r, "biblio", "last_page")),
    idioma  = txt(r$language),
    tipo    = txt(r$type),
    citas   = num(r$cited_by_count),
    acceso  = txt(baja(r, "open_access", "oa_status")),
    resumen = rearmar_resumen(r$abstract_inverted_index),
    cadena  = envoltorio$cadena,
    stringsAsFactors = FALSE
  )
}

corpus <- do.call(rbind, lapply(crudos, fila_de))

cat("\n--------------------------------------------------\n")
cat("Registros antes de deduplicar:", nrow(corpus), "\n")

por_id <- split(corpus$cadena, corpus$id)
ambas  <- names(por_id)[vapply(por_id, function(z) length(unique(z)) > 1, logical(1))]
corpus$en_ambas <- corpus$id %in% ambas

corpus <- corpus[!duplicated(corpus$id), ]
rownames(corpus) <- NULL

cat("Registros únicos:", nrow(corpus), "\n")
cat("Presentes en las dos cadenas:", length(ambas), "\n")
cat("Con resumen:", sum(!is.na(corpus$resumen)), "\n")
cat("Con DOI:", sum(!is.na(corpus$doi)), "\n")
cat("Rango de años:", suppressWarnings(min(corpus$anio, na.rm = TRUE)), "-",
    suppressWarnings(max(corpus$anio, na.rm = TRUE)), "\n")
cat("--------------------------------------------------\n")

saveRDS(corpus, "03-corpus/openalex-corpus.rds")
write.csv(corpus, "03-corpus/openalex-corpus.csv", row.names = FALSE, na = "")
cat("Escrito 03-corpus/openalex-corpus.rds\n")
cat("Escrito 03-corpus/openalex-corpus.csv\n")

## ------------------------------------------------------- exportación RIS

TIPO_RIS <- c("article" = "JOUR", "journal-article" = "JOUR",
              "book" = "BOOK", "book-chapter" = "CHAP",
              "dissertation" = "THES", "report" = "RPRT",
              "preprint" = "UNPB", "paratext" = "JOUR",
              "dataset" = "DATA", "proceedings-article" = "CPAPER",
              "review" = "JOUR", "editorial" = "JOUR",
              "letter" = "JOUR", "other" = "JOUR")

ruta_ris <- "03-corpus/openalex-corpus.ris"
con <- file(ruta_ris, open = "w", encoding = "UTF-8")

for (i in seq_len(nrow(corpus))) {
  f <- corpus[i, ]
  clave <- if (is.na(f$tipo)) "article" else f$tipo
  # corchete simple: devuelve NA en vez de error si el tipo no está en la lista
  ty <- unname(TIPO_RIS[clave])
  if (is.na(ty)) ty <- "JOUR"
  writeLines(paste0("TY  - ", ty), con)

  if (nzchar(f$autores)) {
    for (nm in strsplit(f$autores, "; ", fixed = TRUE)[[1]]) {
      writeLines(paste0("AU  - ", nm), con)
    }
  }

  pares <- list(c("TI", f$titulo), c("AB", f$resumen), c("JO", f$revista),
                c("VL", f$volumen), c("IS", f$numero), c("SP", f$pag_ini),
                c("EP", f$pag_fin), c("DO", f$doi), c("UR", f$id),
                c("LA", f$idioma),
                c("PY", if (is.na(f$anio)) NA_character_ else as.character(f$anio)),
                c("DA", f$fecha),
                c("DB", "OpenAlex"),
                c("KW", f$cadena))

  for (p in pares) {
    if (!is.na(p[2]) && nzchar(p[2])) writeLines(paste0(p[1], "  - ", p[2]), con)
  }

  writeLines(c("ER  - ", ""), con)
}

close(con)
cat("Escrito", ruta_ris, "\n")
cat("\nArrastra el .ris a la subcolección 01-identificados de Zotero.\n")
