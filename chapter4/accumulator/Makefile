all: build run wave

prj = TestAccu

build:
	iverilog -o $(prj) $(prj).sv -g2012

run:
	vvp -n ./$(prj)

wave:
	gtkwave $(prj).vcd

clean:
	rm $(prj).vcd $(prj)
