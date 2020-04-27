EXEC_DIR := bin
LIB_DIR := lib
SRC_DIR := src
OBJ_DIR := obj
INC_DIR := inc

SRC_EXT := c
OBJ_EXT := o
DEP_EXT := d

CC := gcc
RM := rm -f
CFLAGS := -g -O3 -I$(INC_DIR)
LIBS := -lsqlite3

LIBDICT_TARGET = $(LIB_DIR)/libdict.a
LIBEXTFUN_TARGET = $(LIB_DIR)/libextfun.so
SLOVNIK_TARGET = $(EXEC_DIR)/import_slovnik
SYLLABLE_TARGET = $(EXEC_DIR)/generate_syllable
TARGETS = $(LIBDICT_TARGET) $(LIBEXTFUN_TARGET) $(SLOVNIK_TARGET) $(SYLLABLE_TARGET)

LIBDICT_OBJS = $(addprefix $(OBJ_DIR)/,libdict.o string_aux.o)
LIBEXTFUN_SRCS = $(addprefix $(SRC_DIR)/,libextfun.c libdict.c string_aux.c)
SLOVNIK_OBJS = $(addprefix $(OBJ_DIR)/,import_slovnik.o sqlite3_aux.o)
SYLLABLE_OBJS = $(addprefix $(OBJ_DIR)/,generate_syllable.o sqlite3_aux.o string_aux.o)

REBUILDABLES = $(OBJ_DIR) $(EXEC_DIR) $(LIB_DIR)
RESULTS = *.db *.db-journal *.dump *.tar.gz

# DON'T EDIT ANYTHING BELOW THIS LINE
vpath %.c $(SRC_DIR)
vpath %.h $(INC_DIR)
vpath % $(SRC_DIR)

SRCS := $(shell find $(SRC_DIR) -type f -name *.$(SRC_EXT))
DEPS := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(SRCS:.$(SRC_EXT)=.$(DEP_EXT)))

all : $(TARGETS)
	@echo All done

-include $(DEPS)

$(LIBDICT_TARGET) : $(LIBDICT_OBJS) | $(LIB_DIR)
	$(AR) rcsv $@ $^

$(LIBEXTFUN_TARGET) : $(LIBEXTFUN_SRCS) | $(LIB_DIR)
	$(CC) $(CFLAGS) -fPIC -shared -o $@ $^

$(SLOVNIK_TARGET) : $(SLOVNIK_OBJS) $(LIBDICT_TARGET) | $(EXEC_DIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

$(SYLLABLE_TARGET) : $(SYLLABLE_OBJS) $(LIBDICT_TARGET) | $(EXEC_DIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

$(OBJ_DIR)/%.o : %.c | $(OBJ_DIR)
	@echo Building $@
	$(CC) $(CFLAGS) -MMD -MP -c -o $@ $< $(LIBS)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(EXEC_DIR):
	mkdir -p $(EXEC_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

clean-code :
	@echo Cleaning code
	-$(RM) -r $(REBUILDABLES)

clean-result :
	@echo Cleaning results
	-$(RM) -r $(RESULTS)

clean : clean-code clean-result
	@echo All cleaned

.PHONY : all clean clean-code clean-result
