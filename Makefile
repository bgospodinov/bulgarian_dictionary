CC := gcc
CFLAGS := -g
LIB := -lsqlite3
SHELL = /bin/bash
EXEC_DIR := bin
LIB_DIR := lib
SRC_DIR := src
OBJ_DIR := obj
SLOVNIK_TARGET = $(EXEC_DIR)/import_slovnik
LIB_TARGET = $(LIB_DIR)/libextfun.so
TARGETS = $(LIB_TARGET) $(SLOVNIK_TARGET)
SLOVNIK_OBJS = import_slovnik.o sqlite3_aux.o
LIB_OBJS = libextfun.o
OBJS = $(SLOVNIK_OBJS) $(LIB_OBJS)
REBUILDABLES = $(OBJ_DIR) $(EXEC_DIR) $(LIB_DIR)
CLEANABLES = dictionary.db dictionary.db-journal

vpath %.c src
vpath %.h inc
vpath % src

.SUFFIXES:
.SUFFIXES: .c .o

all : $(TARGETS)
	@echo All done

$(LIB_TARGET) : src/libextfun.c | $(LIB_DIR)
	$(CC) $(CFLAGS) -fPIC -shared $^ -o $@

$(SLOVNIK_TARGET) : $(addprefix $(OBJ_DIR)/, $(SLOVNIK_OBJS)) | $(EXEC_DIR)
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
