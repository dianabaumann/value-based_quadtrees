for ROOT in 01 02 03 04 05 06 07 08 09 10 11 12
do
  echo "Processing $ROOT"

  while IFS= read -r name
  do
    find "$ROOT" -type f -name "$name" -print -delete
  done < "$LIST"

done