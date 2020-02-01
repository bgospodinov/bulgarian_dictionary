CC := gcc
CFLAGS := -g
LIB := -lsqlite3
SHELL = /bin/bash

EXEC_DIR := bin
LIB_DIR := lib
SRC_DIR := src
OBJ_DIR := obj

SLOVNIK_TARGET = $(EXEC_DIR)/import_slovnik
LIBEXTFUN_TARGET = $(LIB_DIR)/libextfun.so
LIBDICT_TARGET = $(LIB_DIR)/libdict.a
TARGETS = $(LIBDICT_TARGET) $(LIBEXTFUN_TARGET) $(SLOVNIK_TARGET)

SLOVNIK_DEPS = $(addprefix $(OBJ_DIR)/,import_slovnik.o sqlite3_aux.o) lib/libdict.a
LIBEXTFUN_DEPS = $(addprefix $(SRC_DIR)/,libextfun.c libdict.c string_aux.c)
LIBDICT_DEPS = $(addprefix $(OBJ_DIR)/,libdict.o string_aux.o)

REBUILDABLES = $(OBJ_DIR) $(EXEC_DIR) $(LIB_DIR)
CLEANABLES = dictionary.db dictionary.db-journal

vpath %.c src
vpath %.h inc
vpath % src

.SUFFIXES:
.SUFFIXES: .c .o

all : $(TARGETS)
	@echo All done

$(LIBEXTFUN_TARGET) : $(LIBEXTFUN_DEPS) | $(LIB_DIR)
	$(CC) $(CFLAGS) -fPIC -shared $^ -o $@

$(LIBDICT_TARGET) : $(LIBDICT_DEPS) | $(LIB_DIR)
	ar rcsv $@ $^

$(SLOVNIK_TARGET) : $(SLOVNIK_DEPS) | $(EXEC_DIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LIB)

$(OBJ_DIR)/%.o : %.c | $(OBJ_DIR)
	@echo Building $@...
	$(CC) $(CFLAGS) -o $@ -c $< $(LIB)

$(OBJ_DIR):
	mkdir $(OBJ_DIR)

$(EXEC_DIR):
	mkdir $(EXEC_DIR)

$(LIB_DIR):
	mkdir $(LIB_DIR)

clean :
	-rm -rf $(REBUILDABLES) $(CLEANABLES)
	@echo Cleaning done

.PHONY : all clean
