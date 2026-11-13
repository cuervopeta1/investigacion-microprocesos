## 2026-09-30 - Entorno R listo: bibliometrix, PRISMA2020, revtools

- Zotero 7 + Better BibTeX + conector, sincronizado por WebDAV con Nextcloud propio.
- Exportación automática de la colección 01-articulo-MTI a 04-analisis/referencias.bib.
- Circuito de citas verificado: Zotero → .bib → Pandoc → ODT con APA 7.
- R 4.5 con bibliometrix, PRISMA2020 y revtools en biblioteca de usuario.
- Repositorio Git inicializado.

- Sondeos en OpenAlex: el campo en español y portugués supera al inglés
  en todos los conceptos. La búsqueda será trilingüe.
- "Hacktivismo" resulta inviable como término de búsqueda (14 registros LatAm).
  Entra como dimensión de análisis.
- "Redes comunitarias" emerge como término central no previsto.

## 2026-11-13 — SciELO
Cadena: ("apropiación tecnológica" OR "apropiación social de la tecnología" OR
"soberanía tecnológica" OR "soberanía digital" OR "autonomía tecnológica") OR
(("software libre" OR "código abierto" OR "tecnologías libres" OR "redes
comunitarias") AND (comunidad OR comunitario OR cooperativa OR campesino OR
indígena OR "organización social" OR "movimiento social" OR "economía solidaria"))
Índice: Todos os índices
Filtros: años 2005–2026, sin filtro de colección
Resultados: 175 — Exportados: 175 (RIS, todos los registros)

## 2026-11-13 — Hallazgo sobre OpenAlex
OpenAlex normaliza los diacríticos: "soberanía tecnológica", "soberania
tecnológica" y "soberania tecnologica" devuelven el mismo conjunto (480).
Consecuencias:
1. Las variantes ES/PT que solo difieren en tildes son redundantes y sus
   conteos no se suman.
2. La distribución por idioma no puede obtenerse corriendo una cadena por
   lengua; se obtiene del campo `language` de los registros recuperados.
3. Verificado solo en OpenAlex. No se asume para SciELO, Redalyc ni Dialnet,
   donde se mantienen las cadenas separadas por idioma.
   
   
### Eliminación de duplicados (2026-11-13)
- Registros identificados: 2.344
- Duplicados detectados y fusionados en Zotero: 211
- Registros únicos para cribado: 2.133

Nota: 2 grupos no pudieron fusionarse automáticamente porque Zotero
los clasificó con tipos de elemento distintos (Tesis / Artículo de
revista); se resolvieron manualmente conservando el registro más
completo.
