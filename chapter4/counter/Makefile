all: build run wave

# defult CntSecMinHr, pass parameter `prj=TestCounter` through shell command
prj = TestCounter

build:
	iverilog -o $(prj) $(prj).sv -g2012

run:
	vvp -n ./$(prj)

wave:
	gtkwave $(prj).vcd

clean:
	rm $(prj).vcd $(prj)
