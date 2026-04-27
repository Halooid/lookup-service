-- name: GetLookupValues :many
SELECT lv.id, lv.code, lv.name, lv.metadata
FROM lookup_values lv
JOIN lookup_types lt ON lv.type_id = lt.id
WHERE lt.key = $1 AND lv.is_active = TRUE;
