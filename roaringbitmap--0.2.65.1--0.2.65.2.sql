--- Create by ZEROMAX on 2017/3/20 ---
SET
  search_path = pg_catalog;


-- functions --
CREATE
  OR REPLACE FUNCTION rb_build(integer, integer, integer default 1) RETURNS roaringbitmap AS 'MODULE_PATHNAME',
  'rb_build_range' LANGUAGE C STRICT IMMUTABLE;
CREATE
  OR REPLACE FUNCTION rb_cardinality(roaringbitmap, integer, integer) RETURNS integer AS 'MODULE_PATHNAME',
  'rb_cardinality_range' LANGUAGE C STRICT IMMUTABLE;

---- end ----
SET search_path = public;