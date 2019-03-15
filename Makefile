EXTENSION = roaringbitmap
DATA = roaringbitmap--*.sql
MODULE_big = roaringbitmap
OBJS = roaringbitmap.o

roaringbitmap.o: override CFLAGS += -march=native -std=c11 -fPIC

PG_CONFIG = pg_config

PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)