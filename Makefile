
INSTALL := $(PWD)/build/install

.PHONY: all build test clean install

all: install

build:
	@mkdir -p build && cd build && cmake .. && cmake --build .

test:
	@mkdir -p build && cd build && cmake .. -DBUILD_TESTS=ON && cmake --build . && ctest

install: build
	@mkdir -p $(INSTALL)/lib
	@cp build/*.a $(INSTALL)/lib
	@mkdir -p $(INSTALL)/include/libavoid
	@mkdir -p $(INSTALL)/include/libcola
	@mkdir -p $(INSTALL)/include/libdialect
	@mkdir -p $(INSTALL)/include/libproject
	@mkdir -p $(INSTALL)/include/libtopology
	@mkdir -p $(INSTALL)/include/libvpsc
	@cp -f cola/libavoid/*.h $(INSTALL)/include/libavoid
	@cp -f cola/libcola/*.h $(INSTALL)/include/libcola
	@cp -f cola/libdialect/*.h $(INSTALL)/include/libdialect
	@cp -f cola/libproject/*.h $(INSTALL)/include/libproject
	@cp -f cola/libtopology/*.h $(INSTALL)/include/libtopology
	@cp -f cola/libvpsc/*.h $(INSTALL)/include/libvpsc

clean:
	@rm -rf build
