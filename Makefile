all: s88

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

clean:
	-rm -rf ./obj_dir/