all: build run wave

prj = testbench

build:
	# append a `.ivo` suffix for differentiation
	iverilog -o $(prj).ivo $(prj).sv -g2012

run:
	# convert to `fst` file to reduce the size
	vvp -n $(prj).ivo -fst

wave:
	gtkwave $(prj).fst

clean:
	rm $(prj).fst $(prj).ivo
