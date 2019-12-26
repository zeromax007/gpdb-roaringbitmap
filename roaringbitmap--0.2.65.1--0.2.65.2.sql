--- Create by ZEROMAX on 2017/3/20 ---
SET
  search_path = pg_catalog;


-- functions --
CREATE
  OR REPLACE FUNCTION rb_build(integer[]) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_build' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_build(integer, integer, integer default 1) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_build_range' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_or(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_or' LANGUAGE C STRICT IMMUTABLE;
DROP FUNCTION IF EXISTS rb_or_cardinality(roaringbitmap, roaringbitmap);
CREATE
  OR REPLACE FUNCTION rb_or_cardinality(roaringbitmap, roaringbitmap) RETURNS BIGINT AS 'MODULE_PATHNAME',
  'rb_or_cardinality' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_and(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_and' LANGUAGE C STRICT IMMUTABLE;
DROP FUNCTION IF EXISTS rb_and_cardinality(roaringbitmap, roaringbitmap);
CREATE
  OR REPLACE FUNCTION rb_and_cardinality(roaringbitmap, roaringbitmap) RETURNS BIGINT AS 'MODULE_PATHNAME',
  'rb_and_cardinality' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_xor(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_xor' LANGUAGE C STRICT IMMUTABLE;
DROP FUNCTION IF EXISTS rb_xor_cardinality(roaringbitmap, roaringbitmap);
CREATE
  OR REPLACE FUNCTION rb_xor_cardinality(roaringbitmap, roaringbitmap) RETURNS BIGINT AS 'MODULE_PATHNAME',
  'rb_xor_cardinality' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_andnot(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_andnot' LANGUAGE C STRICT IMMUTABLE;
DROP FUNCTION IF EXISTS rb_andnot_cardinality(roaringbitmap, roaringbitmap);
CREATE
  OR REPLACE FUNCTION rb_andnot_cardinality(roaringbitmap, roaringbitmap) RETURNS BIGINT AS 'MODULE_PATHNAME',
  'rb_andnot_cardinality' LANGUAGE C STRICT IMMUTABLE;
DROP FUNCTION IF EXISTS rb_cardinality(roaringbitmap);
CREATE
  OR REPLACE FUNCTION rb_cardinality(roaringbitmap) RETURNS BIGINT AS 'MODULE_PATHNAME',
  'rb_cardinality' LANGUAGE C STRICT IMMUTABLE;
DROP FUNCTION IF EXISTS rb_cardinality(roaringbitmap, integer, integer);
CREATE
  OR REPLACE FUNCTION rb_cardinality(roaringbitmap, integer, integer) RETURNS BIGINT AS 'MODULE_PATHNAME',
  'rb_cardinality_range' LANGUAGE C STRICT IMMUTABLE;
DROP FUNCTION IF EXISTS rb_cardinality(roaringbitmap, integer, integer, integer);
CREATE
  OR REPLACE FUNCTION rb_cardinality(roaringbitmap, integer, integer, integer) RETURNS BIGINT AS 'MODULE_PATHNAME',
  'rb_cardinality_step' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_cardinality(roaringbitmap, integer, integer, integer, integer[]) RETURNS BIGINT AS 'MODULE_PATHNAME',
  'rb_cardinality_step_intval' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_is_empty(roaringbitmap) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_is_empty' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_equals(roaringbitmap, roaringbitmap) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_equals' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_not_equals(roaringbitmap, roaringbitmap) RETURNS bool AS $$
SELECT
  NOT rb_equals($1, $2) $$ LANGUAGE SQL STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_intersect(roaringbitmap, roaringbitmap) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_intersect' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_contains(roaringbitmap, integer) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_contains' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_contains(roaringbitmap, integer, integer) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_contains_range' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_contains(roaringbitmap, roaringbitmap) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_contains_bitmap' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_becontained(integer, roaringbitmap) RETURNS bool AS $$
SELECT
  rb_contains($2, $1) $$ LANGUAGE SQL STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_becontained(roaringbitmap, roaringbitmap) RETURNS bool AS $$
SELECT
  rb_contains($2, $1) $$ LANGUAGE SQL STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_add(roaringbitmap, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_add' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_add_2(integer, roaringbitmap) RETURNS roaringbitmap AS $$
SELECT
  rb_add($2, $1) $$ LANGUAGE SQL STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_add(roaringbitmap, integer, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_add_range' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_remove(roaringbitmap, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_remove' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_remove(roaringbitmap, integer, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_remove_range' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_flip(roaringbitmap, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_flip' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_flip(roaringbitmap, integer, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_flip_range' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_minimum(roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_minimum' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_maximum(roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_maximum' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_rank(roaringbitmap, integer) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_rank' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_jaccard_index(roaringbitmap, roaringbitmap) RETURNS float8 AS 'MODULE_PATHNAME',
  'rb_jaccard_index' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_to_array(roaringbitmap) RETURNS integer[] AS 'MODULE_PATHNAME',
  'rb_to_array' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_iterate(roaringbitmap) RETURNS SETOF integer AS 'MODULE_PATHNAME',
  'rb_iterate' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_iterate_decrement(roaringbitmap) RETURNS SETOF integer AS 'MODULE_PATHNAME',
  'rb_iterate_decrement' LANGUAGE C STRICT IMMUTABLE;

---- end ----
SET search_path = public;