all: test
.PHONY: all test clean lldb lldb-test ci ci-setup

PKG=struct

bin/struct: $(shell find ${PKG} -name *.pony)
	mkdir -p bin
	ponyc --debug -o bin ${PKG}

test: bin/struct
	$^

clean:
	rm -rf bin

ci: test

ci-setup:
