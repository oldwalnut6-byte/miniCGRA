.PHONY: gen sim clean

gen:
	sbt 'runMain minicgra.Generate'

sim: gen
	verilator --cc --exe --build --top-module MiniCGRA generated/*.v sim/test_minicgra.cpp
	./obj_dir/VMiniCGRA

clean:
	rm -rf ./target ./generated ./obj_dir
