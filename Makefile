CC = gcc
CXX = g++
FLAGS = -Ilib -Itest -O2 -Wall -g
CFLAGS = -std=c99 $(FLAGS)
CXXFLAGS = -std=c++11 $(FLAGS)

LIB_TARGET = lib/libbfp.a
LIB_OBJ = bfp/lib/posit.o bfp/lib/pack.o bfp/lib/util.o bfp/lib/op1.o bfp/lib/op2.o

VCFLAGS = -I/home/brsf11/Code/Posit-FMAU/bfp/lib/ 
VLFLAGS = -lbfp -L../lib/

all: top32

s88: build_SignedMultiplier8x8 run_SignedMultiplier8x8

build_SignedMultiplier8x8:
	verilator --cc --build -f flist/SignedMultiplier8x8 --exe ./testbench/verilator/tb_main_s88.cpp -Wno-UNOPTFLAT --autoflush --top-module SignedMultiplier8x8
	echo "\n\n\n\n"

run_SignedMultiplier8x8:
	./obj_dir/VSignedMultiplier8x8 8


u77: build_UnsignedMultiplier7x7 run_UnsignedMultiplier7x7

build_UnsignedMultiplier7x7:
	verilator --cc --build -f flist/UnsignedMultiplier7x7 --exe ./testbench/verilator/tb_main_u77.cpp -Wno-UNOPTFLAT --autoflush --top-module UnsignedMultiplier7x7
	echo "\n\n\n\n"

run_UnsignedMultiplier7x7:
	./obj_dir/VUnsignedMultiplier7x7 7

top32: TOP32_TARGET TOP32_RUN

TOP32_TARGET: $(LIB_TARGET)
	verilator --cc --build --exe -f flist/top ./testbench/verilator/tb_main_top_32.cpp -CFLAGS "$(VCFLAGS)" -LDFLAGS "$(VLFLAGS)" -Wno-UNOPTFLAT -Wno-WIDTHCONCAT -Wno-WIDTH --autoflush --top-module top

TOP32_RUN:
	./obj_dir/Vtop 32

top16: TOP16_TARGET TOP16_RUN

TOP16_TARGET: $(LIB_TARGET)
	verilator --cc --build --exe -f flist/top ./testbench/verilator/tb_main_top_16.cpp -CFLAGS "$(VCFLAGS)" -LDFLAGS "$(VLFLAGS)" -Wno-UNOPTFLAT -Wno-WIDTHCONCAT -Wno-WIDTH --autoflush --top-module top

TOP16_RUN:
	./obj_dir/Vtop 16

top8: TOP8_TARGET TOP8_RUN

TOP8_TARGET: $(LIB_TARGET)
	verilator --cc --build --exe -f flist/top ./testbench/verilator/tb_main_top_8.cpp -CFLAGS "$(VCFLAGS)" -LDFLAGS "$(VLFLAGS)" -Wno-UNOPTFLAT -Wno-WIDTHCONCAT -Wno-WIDTH --autoflush --top-module top

TOP8_RUN:
	./obj_dir/Vtop 8


clean:
	rm -rf ./obj_dir/
	rm -f bfp/lib/*.o $(LIB_TARGET)



$(LIB_TARGET): $(LIB_OBJ)
	ar rcs $@ $^

%.o: %.cpp
	$(CXX) -o $@ $(CXXFLAGS) -c $^

%.o: %.c
	$(CC) -o $@ $(CFLAGS) -c $^