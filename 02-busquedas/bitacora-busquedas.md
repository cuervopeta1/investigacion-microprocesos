## 2026-11-13 — Redalyc
Consultas de frase única (Redalyc no interpreta el espacio como AND;
una frase entrecomillada por consulta, sin palabras sueltas al lado).
Resultados contados en la interfaz; NO exportados a Zotero porque
Redalyc no ofrece exportación por lotes ni traductor de Zotero.

"apropiación tecnológica"			→	 617 
"apropiación social de la tecnología" 		→	 181
"soberanía tecnológica"				→	 198
"soberanía digital"				→	 35
"autonomía tecnológica"				→	 164
"apropriação tecnológica"			→	 158
"redes comunitarias"				→	 1250

## 2026-11-13 — Dialnet

Mismas consultas de frase única. Exportación manual registro por
registro desde la ficha de cada artículo.
Las dos últimas consultas quedaron sin correr: Dialnet bloqueó el
acceso por exceder sus límites de uso. Pendiente retomarlas.
Verificar: los valores 198 y 164 coinciden exactamente con cifras de
Redalyc y pueden ser un error de transcripción.

"apropiación tecnológica"                       →        336 	## Agregados a Zotero
"apropiación social de la tecnología"           →        43 	## Agregados a Zotero
"soberanía tecnológica"                         →        214	## Agregados a Zotero	
"soberanía digital"                             →        198	## Agregados a Zotero
"autonomía tecnológica"                         →        164	## Agregados a Zotero
"apropriação tecnológica"                       →        
"redes comunitarias"                            →        

## 2026-11-13 — Cierre de identificación

### Cadenas definitivas (congeladas)
- Iberoamericana (ES+PT): 1.040 registros en OpenAlex
- Inglesa con recorte regional: 353 registros en OpenAlex
- Ventana: 2005-01-01 a 2026-12-31, campo title_and_abstract.search

### Decisiones de depuración documentadas
- "soberanía tecnológica / digital / autonomía tecnológica" se retiró
  como bloque independiente y pasó a cruzarse con actores. Medición:
  1.163 registros sola, 126 cruzada. Los ~1.037 restantes son
  literatura española y europea de política pública sin actor
  comunitario.
- "comunidad / comunidade / comunitario" sueltos se reemplazaron por
  formas precisas. Medición: 2.156 con el término vago, 246 con las
  formas precisas; 560 eran solo "código abierto" + "comunidad", es
  decir la comunidad de desarrolladores y no la comunidad territorial.
- Efecto conjunto: la cadena pasó de 3.711 a 1.040 (-72%).

### Registros identificados por fuente
| Fuente             | Tipo de búsqueda       | Registros |
|--------------------|------------------------|-----------|
| OpenAlex           | sistemática (API)      | 1.378     |
| Dialnet            | complementaria dirigida|   955     |
| SciELO             | sistemática (interfaz) |   175     |
| Redalyc            | complementaria dirigida|    0*	  |
| **Total en Zotero**|                        | **2.344** |

Nota: Redalyc y Dialnet no permiten exportación masiva reproducible,
por lo que se declaran como búsqueda complementaria dirigida y no
como sistemática.
* Redalyc: 2.603 resultados contados en 7 consultas, ninguno
  incorporado aún. Sin exportación masiva disponible.

### Incidencias técnicas
- openalexR falla con "Column name `doi` must not be duplicated";
  se reemplazó por paginación propia contra la API.
- La paginación por cursor devolvió HTTP 401; se usó paginación por
  número de página.
- Script reproducible: 02-busquedas/descargar-corpus.R
