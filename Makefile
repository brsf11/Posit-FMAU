all: SignedMultiplier8x8

SignedMultiplier8x8: build_SignedMultiplier8x8 run_SignedMultiplier8x8

build_SignedMultiplier8x8:
	verilator --cc --build -f flist/SignedMultiplier8x8 --exe ./testbench/tb_main.cpp -Wno-UNOPTFLAT --autoflush --top-module SignedMultiplier8x8
	echo "\n\n\n\n"

run_SignedMultiplier8x8:
	./obj_dir/VSignedMultiplier8x8 8

clean:
	-rm -rf ./obj_dir/