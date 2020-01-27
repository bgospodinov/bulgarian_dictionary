SHELL = /bin/bash
EXEC_DIR := bin
LIB_DIR := lib
SLOVNIK_TARGET = $(EXEC_DIR)/import_slovnik
LIB_TARGET = $(LIB_DIR)/libextfun.so
TARGETS = $(LIB_TARGET) $(SLOVNIK_TARGET)
OBJS = import_slovnik.o sqlite3_aux.o
REBUILDABLES = $(OBJS) $(TARGETS) $(EXEC_DIR) $(LIB_DIR)
CLEANABLES = dictionary.db dictionary.db-journal

vpath %.c src
vpath %.h include
vpath % src

.SUFFIXES:
.SUFFIXES: .c .o

all : $(LIB_TARGET) $(SLOVNIK_TARGET) 
	@echo All done

$(LIB_TARGET) : | $(LIB_DIR) ;

$(SLOVNIK_TARGET) : $(OBJS) | $(EXEC_DIR)
	gcc -o $@ $^ -lsqlite3 -g

%.o : %.c
	@echo Building $@...
	gcc -o $@ -c $< -lsqlite3 -g


$(EXEC_DIR):
        mkdir $(EXEC_DIR)

$(LIB_DIR):
        mkdir $(LIB_DIR)

.PHONY : clean
clean :
	-rm -f $(REBUILDABLES) $(CLEANABLES)
	@echo Cleaning done
