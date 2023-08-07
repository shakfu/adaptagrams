.PHONY: all build test clean

all: build

build:
	@mkdir -p build && cd build && cmake .. && cmake --build .

test:
	@mkdir -p build && cd build && cmake .. -DBUILD_TESTS=ON && cmake --build . && ctest


clean:
	@rm -rf build
