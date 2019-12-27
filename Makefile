LINK_TARGET = import_slovnik
OBJS = src/import_slovnik.o src/sqlite3_aux.o
REBUILDABLES = $(OBJS) $(LINK_TARGET) dictionary.db

all: $(LINK_TARGET)
	@echo All done

$(LINK_TARGET): $(OBJS)
	gcc -o $@ $^ -lsqlite3 -g

%.o: %.c
	@echo Building $@...
	gcc -o $@ -c $< -lsqlite3 -g

clean:
	rm -f $(REBUILDABLES)
	@echo Cleaning done
