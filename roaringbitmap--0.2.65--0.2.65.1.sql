--- Create by ZEROMAX on 2019/12/11 ---
-- For Update -- 

CREATE 
  OR REPLACE FUNCTION roaringbitmap(bytea) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'roaringbitmap' LANGUAGE C STRICT IMMUTABLE;

CREATE CAST (bytea AS roaringbitmap) WITH FUNCTION roaringbitmap(bytea);
CREATE CAST (roaringbitmap AS bytea) WITHOUT FUNCTION;

CREATE
  OR REPLACE FUNCTION rb_build(integer[]) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_build' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_or(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_or' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_or_cardinality(roaringbitmap, roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_or_cardinality' LANGUAGE C STRICT IMMUTABLE; 
CREATE
  OR REPLACE FUNCTION rb_and(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_and' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_and_cardinality(roaringbitmap, roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_and_cardinality' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_xor(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_xor' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_xor_cardinality(roaringbitmap, roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_xor_cardinality' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_andnot(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_andnot' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_andnot_cardinality(roaringbitmap, roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_andnot_cardinality' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_cardinality(roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_cardinality' LANGUAGE C STRICT IMMUTABLE;
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


  CREATE
OR REPLACE FUNCTION rb_and_trans(internal, roaringbitmap) RETURNS internal AS 'MODULE_PATHNAME',
'rb_and_trans' LANGUAGE C IMMUTABLE;
CREATE
OR REPLACE FUNCTION rb_or_trans(internal, roaringbitmap) RETURNS internal AS 'MODULE_PATHNAME',
'rb_or_trans' LANGUAGE C IMMUTABLE;
CREATE
OR REPLACE FUNCTION rb_xor_trans(internal, roaringbitmap) RETURNS internal AS 'MODULE_PATHNAME',
'rb_xor_trans' LANGUAGE C IMMUTABLE;
CREATE
OR REPLACE FUNCTION rb_and_combine(internal, internal) RETURNS internal AS 'MODULE_PATHNAME',
'rb_and_combine' LANGUAGE C IMMUTABLE;
CREATE
OR REPLACE FUNCTION rb_or_combine(internal, internal) RETURNS internal AS 'MODULE_PATHNAME',
'rb_or_combine' LANGUAGE C IMMUTABLE;
CREATE
OR REPLACE FUNCTION rb_xor_combine(internal, internal) RETURNS internal AS 'MODULE_PATHNAME',
'rb_xor_combine' LANGUAGE C IMMUTABLE;
CREATE
OR REPLACE FUNCTION rb_final(internal) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
'rb_serialize' LANGUAGE C IMMUTABLE;
CREATE
OR REPLACE FUNCTION rb_cardinality_final(internal) RETURNS integer AS 'MODULE_PATHNAME',
'rb_cardinality_final' LANGUAGE C IMMUTABLE;
CREATE
OR REPLACE FUNCTION rb_serialize(internal) RETURNS bytea AS 'MODULE_PATHNAME',
'rb_serialize' LANGUAGE C IMMUTABLE;
CREATE
OR REPLACE FUNCTION rb_deserialize(bytea, internal) RETURNS internal AS 'MODULE_PATHNAME',
'rb_deserialize' LANGUAGE C IMMUTABLE;
CREATE
OR REPLACE FUNCTION rb_build_trans(internal, integer) RETURNS internal AS 'MODULE_PATHNAME',
'rb_build_trans' LANGUAGE C IMMUTABLE;

DROP AGGREGATE IF EXISTS rb_or_agg(roaringbitmap);
CREATE AGGREGATE rb_or_agg(roaringbitmap)(
  SFUNC = rb_or_trans,
  STYPE = internal,
  FINALFUNC = rb_final,
  COMBINEFUNC = rb_or_combine,
  SERIALFUNC = rb_serialize,
  DESERIALFUNC = rb_deserialize
);
DROP AGGREGATE IF EXISTS rb_or_cardinality_agg(roaringbitmap);
CREATE AGGREGATE rb_or_cardinality_agg(roaringbitmap)(
  SFUNC = rb_or_trans,
  STYPE = internal,
  FINALFUNC = rb_cardinality_final,
  COMBINEFUNC = rb_or_combine,
  SERIALFUNC = rb_serialize,
  DESERIALFUNC = rb_deserialize
);
DROP AGGREGATE IF EXISTS rb_and_agg(roaringbitmap);
CREATE AGGREGATE rb_and_agg(roaringbitmap)(
  SFUNC = rb_and_trans,
  STYPE = internal,
  FINALFUNC = rb_final,
  COMBINEFUNC = rb_and_combine,
  SERIALFUNC = rb_serialize,
  DESERIALFUNC = rb_deserialize
);
DROP AGGREGATE IF EXISTS rb_and_cardinality_agg(roaringbitmap);
CREATE AGGREGATE rb_and_cardinality_agg(roaringbitmap)(
  SFUNC = rb_and_trans,
  STYPE = internal,
  FINALFUNC = rb_cardinality_final,
  COMBINEFUNC = rb_and_combine,
  SERIALFUNC = rb_serialize,
  DESERIALFUNC = rb_deserialize
);
DROP AGGREGATE IF EXISTS rb_xor_agg(roaringbitmap);
CREATE AGGREGATE rb_xor_agg(roaringbitmap)(
  SFUNC = rb_xor_trans,
  STYPE = internal,
  FINALFUNC = rb_final,
  COMBINEFUNC = rb_xor_combine,
  SERIALFUNC = rb_serialize,
  DESERIALFUNC = rb_deserialize
);
DROP AGGREGATE IF EXISTS rb_xor_cardinality_agg(roaringbitmap);
CREATE AGGREGATE rb_xor_cardinality_agg(roaringbitmap)(
  SFUNC = rb_xor_trans,
  STYPE = internal,
  FINALFUNC = rb_cardinality_final,
  COMBINEFUNC = rb_xor_combine,
  SERIALFUNC = rb_serialize,
  DESERIALFUNC = rb_deserialize
);
DROP AGGREGATE IF EXISTS rb_build_agg(integer);
CREATE AGGREGATE rb_build_agg(integer)(
  SFUNC = rb_build_trans,
  STYPE = internal,
  FINALFUNC = rb_final,
  COMBINEFUNC = rb_or_combine,
  SERIALFUNC = rb_serialize,
  DESERIALFUNC = rb_deserialize
);