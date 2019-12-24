LINK_TARGET = builddb
OBJS = src/builddb.o
REBUILDABLES = $(OBJS) $(LINK_TARGET) dictionary.db

all: $(LINK_TARGET)
	@echo All done

$(LINK_TARGET): $(OBJS)
	gcc -o $@ $^ -lsqlite3

%.o: %.c
	@echo Building $@...
	gcc -o $@ -c $< -lsqlite3

clean:
	rm -f $(REBUILDABLES)
	@echo Cleaning done
