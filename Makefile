CC = gcc
CXX = g++
VERILATOR = verilator
FLAGS = -Ilib -Itest -O2 -Wall -g
CFLAGS = -std=c99 $(FLAGS)
CXXFLAGS = -std=c++11 $(FLAGS)

LIB_TARGET = lib/libbfp.a
LIB_OBJ = bfp/lib/posit.o bfp/lib/pack.o bfp/lib/util.o bfp/lib/op1.o bfp/lib/op2.o

TEST = top
TEST_TARGET = ./obj_dir/V$(TEST)
TEST_WIDTH = 32

VCFLAGS = -I/home/brsf11/Code/Posit-FMAU/bfp/lib/ 
VLFLAGS = -lbfp -L../lib/
VFLAGS  = -j 16 --cc --build --exe -CFLAGS "$(VCFLAGS)" -LDFLAGS "$(VLFLAGS)" -Wno-UNOPTFLAT -Wno-WIDTHCONCAT -Wno-WIDTH --autoflush --trace

all: $(TEST)

$(TEST): $(TEST_TARGET)
	$(TEST_TARGET) $(TEST_WIDTH)

$(TEST_TARGET): $(LIB_TARGET) clean_verilator
	$(VERILATOR) $(VFLAGS) -f flist/$(TEST) ./testbench/verilator/tb_main_$(TEST).cpp --top-module $(TEST)

wave:
	gtkwave wave/wave.vcd

clean:
	-rm -rf ./obj_dir/
	-rm -f bfp/lib/*.o $(LIB_TARGET)

clean_verilator:
	-rm -rf ./obj_dir/

$(LIB_TARGET): $(LIB_OBJ)
	ar rcs $@ $^

%.o: %.cpp
	$(CXX) -o $@ $(CXXFLAGS) -c $^

%.o: %.c
	$(CC) -o $@ $(CFLAGS) -c $^