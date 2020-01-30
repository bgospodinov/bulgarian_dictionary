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
TARGETS = $(LIBEXTFUN_TARGET) $(LIBDICT_TARGET) $(SLOVNIK_TARGET)

SLOVNIK_OBJS = $(addprefix $(OBJ_DIR)/,import_slovnik.o sqlite3_aux.o libdict.o)
LIBEXTFUN_OBJS = $(addprefix $(OBJ_DIR)/,libdict.o)
LIBDICT_OBJS = $(addprefix $(OBJ_DIR)/,libdict.o)
OBJS = $(SLOVNIK_OBJS) $(LIBEXTFUN_OBJS) $(LIBDICT_OBJS)

REBUILDABLES = $(OBJ_DIR) $(EXEC_DIR) $(LIB_DIR)
CLEANABLES = dictionary.db dictionary.db-journal

vpath %.c src
vpath %.h inc
vpath % src

.SUFFIXES:
.SUFFIXES: .c .o

all : $(TARGETS)
	@echo All done

$(LIBEXTFUN_TARGET) : src/libextfun.c $(LIBEXTFUN_OBJS) | $(LIB_DIR)
	$(CC) $(CFLAGS) -fPIC -shared $^ -o $@

$(LIBDICT_TARGET) : $(LIBDICT_OBJS) | $(LIB_DIR)
	ar rcs $@ $^

$(SLOVNIK_TARGET) : $(SLOVNIK_OBJS) | $(EXEC_DIR)
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
