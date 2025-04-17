DB_NAME="bdtsige2025"
ENCODING="LATIN1"

SHAPEFILE_DIR="../data"

# SRID por shapefile
declare -A SRIDS=(
  [v_sig_vias]=32721
  [v_sig_manzanas_materializadas]=32721
  [v_sig_espacios_publicos]=32721
  [v_mdg_parcelas_geom]=32721
  [v_camineria_nacional]=4326
  [limites_departamentales_igm_20220211]=4326
  [areas_urbanizadas_2]=4326
)

# SRID por shapefile
declare -A NAMES=(
  [v_sig_vias]="vias"
  [v_sig_manzanas_materializadas]="manzanas"
  [v_sig_espacios_publicos]="espacios_publicos"
  [v_mdg_parcelas_geom]="parcelas"
  [v_camineria_nacional]="camineria"
  [limites_departamentales_igm_20220211]="limites_departamentales"
  [areas_urbanizadas_2]="areas_urbanizadas"
)

FILES=(areas_urbanizadas_2 limites_departamentales_igm_20220211 v_camineria_nacional v_mdg_parcelas_geom v_sig_espacios_publicos v_sig_manzanas_materializadas v_sig_vias)

for NAME in "${FILES[@]}"; do
  SRID=${SRIDS[$NAME]}
  SHP_PATH="${SHAPEFILE_DIR}/${NAME}/${NAME}.shp"
  TABLE_NAME="ft_${NAMES[$NAME]}"
  SQL_FILE="sql/${NAMES[$NAME]}.sql"

  psql -d "$DB_NAME" -c "DROP TABLE IF EXISTS public.\"$TABLE_NAME\" CASCADE;" > /dev/null

  # Convertir shapefile a SQL
  # Intentar con geometrías simples (-S)
  if ! shp2pgsql -S -s $SRID -I -W $ENCODING "$SHP_PATH" public."$TABLE_NAME" > "$SQL_FILE"; then
    echo "Fallo con -S, intentando sin -S (geometrías múltiples)..."
    shp2pgsql -s $SRID -I -W $ENCODING "$SHP_PATH" public."$TABLE_NAME" > "$SQL_FILE"
  fi

  # Importar SQL a la base
  psql -d "$DB_NAME" -f "$SQL_FILE" > /dev/null
done
