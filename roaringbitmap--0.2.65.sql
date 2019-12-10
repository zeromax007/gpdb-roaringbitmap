--- Create by ZEROMAX on 2017/3/20 ---
SET
  search_path = pg_catalog;
--- data type --
  CREATE
  OR REPLACE FUNCTION roaringbitmap_in(cstring) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'roaringbitmap_in' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION roaringbitmap_out(roaringbitmap) RETURNS cstring AS 'MODULE_PATHNAME',
  'roaringbitmap_out' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION roaringbitmap_recv(internal) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'roaringbitmap_recv' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION roaringbitmap_send(roaringbitmap) RETURNS bytea AS 'MODULE_PATHNAME',
  'roaringbitmap_send' LANGUAGE C STRICT IMMUTABLE;
CREATE TYPE roaringbitmap (
    INTERNALLENGTH = VARIABLE,
    INPUT = roaringbitmap_in,
    OUTPUT = roaringbitmap_out,
    receive = roaringbitmap_recv,
    send = roaringbitmap_send,
    STORAGE = external
  );
-- functions --
  CREATE
  OR REPLACE FUNCTION rb_build(integer []) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_build' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_or(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_or' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_or_cardinality(roaringbitmap, roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_or_cardinality' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_and(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_and' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_and_cardinality(roaringbitmap, roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_and_cardinality' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_xor(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_xor' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_xor_cardinality(roaringbitmap, roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_xor_cardinality' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_andnot(roaringbitmap, roaringbitmap) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_andnot' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_andnot_cardinality(roaringbitmap, roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_andnot_cardinality' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_cardinality(roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_cardinality' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_is_empty(roaringbitmap) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_is_empty' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_equals(roaringbitmap, roaringbitmap) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_equals' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_not_equals(roaringbitmap, roaringbitmap) RETURNS bool AS $$
SELECT
  NOT rb_equals($1, $2) $$ LANGUAGE SQL STRICT;
CREATE
  OR REPLACE FUNCTION rb_intersect(roaringbitmap, roaringbitmap) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_intersect' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_contains(roaringbitmap, integer) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_contains' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_contains(roaringbitmap, integer, integer) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_contains_range' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_contains(roaringbitmap, roaringbitmap) RETURNS bool AS 'MODULE_PATHNAME',
  'rb_contains_bitmap' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_becontained(integer, roaringbitmap) RETURNS bool AS $$
SELECT
  rb_contains($2, $1) $$ LANGUAGE SQL STRICT;
CREATE
  OR REPLACE FUNCTION rb_becontained(roaringbitmap, roaringbitmap) RETURNS bool AS $$
SELECT
  rb_contains($2, $1) $$ LANGUAGE SQL STRICT;
CREATE
  OR REPLACE FUNCTION rb_add(roaringbitmap, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_add' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_add_2(integer, roaringbitmap) RETURNS roaringbitmap AS $$
SELECT
  rb_add($2, $1) $$ LANGUAGE SQL STRICT;
CREATE
  OR REPLACE FUNCTION rb_add(roaringbitmap, integer, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_add_range' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_remove(roaringbitmap, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_remove' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_remove(roaringbitmap, integer, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_remove_range' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_flip(roaringbitmap, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_flip' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_flip(roaringbitmap, integer, integer) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_flip_range' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_minimum(roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_minimum' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_maximum(roaringbitmap) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_maximum' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_rank(roaringbitmap, integer) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_rank' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_jaccard_index(roaringbitmap, roaringbitmap) RETURNS float8 AS 'MODULE_PATHNAME',
  'rb_jaccard_index' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_to_array(roaringbitmap) RETURNS integer [] AS 'MODULE_PATHNAME',
  'rb_to_array' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_iterate(roaringbitmap) RETURNS SETOF integer AS 'MODULE_PATHNAME',
  'rb_iterate' LANGUAGE C STRICT;
CREATE
  OR REPLACE FUNCTION rb_final(internal) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_serialize' LANGUAGE C IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_serialize(internal) RETURNS bytea AS 'MODULE_PATHNAME',
  'rb_serialize' LANGUAGE C IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_deserialize(bytea, internal) RETURNS internal AS 'MODULE_PATHNAME',
  'rb_deserialize' LANGUAGE C IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_cardinality_final(internal) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_cardinality_final' LANGUAGE C IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_or_trans(internal, roaringbitmap) RETURNS internal AS 'MODULE_PATHNAME',
  'rb_or_trans' LANGUAGE C IMMUTABLE;
-- operator --
  CREATE OPERATOR & (
    LEFTARG = roaringbitmap,
    RIGHTARG = roaringbitmap,
    PROCEDURE = rb_and
  );
CREATE OPERATOR | (
    LEFTARG = roaringbitmap,
    RIGHTARG = roaringbitmap,
    PROCEDURE = rb_or
  );
CREATE OPERATOR # (
  LEFTARG = roaringbitmap,
  RIGHTARG = roaringbitmap,
  PROCEDURE = rb_xor
);
CREATE OPERATOR ~ (
  LEFTARG = roaringbitmap,
  RIGHTARG = roaringbitmap,
  PROCEDURE = rb_andnot
);
CREATE OPERATOR + (
  LEFTARG = roaringbitmap,
  RIGHTARG = integer,
  PROCEDURE = rb_add,
  COMMUTATOR = '+'
);
CREATE OPERATOR + (
  LEFTARG = integer,
  RIGHTARG = roaringbitmap,
  PROCEDURE = rb_add_2,
  COMMUTATOR = '+'
);
CREATE OPERATOR - (
  LEFTARG = roaringbitmap,
  RIGHTARG = integer,
  PROCEDURE = rb_remove
);
CREATE OPERATOR = (
  LEFTARG = roaringbitmap,
  RIGHTARG = roaringbitmap,
  PROCEDURE = rb_equals,
  COMMUTATOR = '=',
  NEGATOR = '<>',
  RESTRICT = eqsel,
  JOIN = eqjoinsel
);
CREATE OPERATOR <> (
  LEFTARG = roaringbitmap,
  RIGHTARG = roaringbitmap,
  PROCEDURE = rb_not_equals,
  COMMUTATOR = '<>',
  NEGATOR = '=',
  RESTRICT = neqsel,
  JOIN = neqjoinsel
);
CREATE OPERATOR & & (
  LEFTARG = roaringbitmap,
  RIGHTARG = roaringbitmap,
  PROCEDURE = rb_intersect,
  COMMUTATOR = '&&',
  RESTRICT = contsel,
  JOIN = contjoinsel
);
CREATE OPERATOR @ > (
  LEFTARG = roaringbitmap,
  RIGHTARG = integer,
  PROCEDURE = rb_contains,
  COMMUTATOR = '<@',
  RESTRICT = contsel,
  JOIN = contjoinsel
);
CREATE OPERATOR @ > (
  LEFTARG = roaringbitmap,
  RIGHTARG = roaringbitmap,
  PROCEDURE = rb_contains,
  COMMUTATOR = '<@',
  RESTRICT = contsel,
  JOIN = contjoinsel
);
CREATE OPERATOR < @ (
  LEFTARG = integer,
  RIGHTARG = roaringbitmap,
  PROCEDURE = rb_becontained,
  COMMUTATOR = '@>',
  RESTRICT = contsel,
  JOIN = contjoinsel
);
CREATE OPERATOR < @ (
  LEFTARG = roaringbitmap,
  RIGHTARG = roaringbitmap,
  PROCEDURE = rb_becontained,
  COMMUTATOR = '@>',
  RESTRICT = contsel,
  JOIN = contjoinsel
);
-- aggragations --
CREATE AGGREGATE rb_or_agg(roaringbitmap)(
  SFUNC = rb_or_trans,
  STYPE = internal,
  FINALFUNC = rb_serialize
);
CREATE AGGREGATE rb_or_cardinality_agg(roaringbitmap)(
  SFUNC = rb_or_trans,
  STYPE = internal,
  FINALFUNC = rb_cardinality_trans
);
CREATE
OR REPLACE FUNCTION rb_and_trans(internal, roaringbitmap) RETURNS internal AS 'MODULE_PATHNAME',
'rb_and_trans' LANGUAGE C IMMUTABLE;
CREATE AGGREGATE rb_and_agg(roaringbitmap)(
  SFUNC = rb_and_trans,
  STYPE = internal,
  FINALFUNC = rb_serialize
);
CREATE AGGREGATE rb_and_cardinality_agg(roaringbitmap)(
  SFUNC = rb_and_trans,
  STYPE = internal,
  FINALFUNC = rb_cardinality_trans
);
CREATE
OR REPLACE FUNCTION rb_xor_trans(internal, roaringbitmap) RETURNS internal AS 'MODULE_PATHNAME',
'rb_xor_trans' LANGUAGE C IMMUTABLE;
CREATE AGGREGATE rb_xor_agg(roaringbitmap)(
  SFUNC = rb_xor_trans,
  STYPE = internal,
  FINALFUNC = rb_serialize
);
CREATE AGGREGATE rb_xor_cardinality_agg(roaringbitmap)(
  SFUNC = rb_xor_trans,
  STYPE = internal,
  FINALFUNC = rb_cardinality_trans
);
CREATE
OR REPLACE FUNCTION rb_build_trans(internal, integer) RETURNS internal AS 'MODULE_PATHNAME',
'rb_build_trans' LANGUAGE C;
CREATE AGGREGATE rb_build_agg(integer)(
  SFUNC = rb_build_trans,
  STYPE = internal,
  FINALFUNC = rb_serialize
);