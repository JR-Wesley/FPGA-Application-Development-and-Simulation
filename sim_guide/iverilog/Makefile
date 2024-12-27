.PHONY: all build run wave clean

TB = TestAccu
SRC = $(TB).sv
# append a `.ivo` suffix for differentiation
IVOBJ = $(TB).ivo
# convert to fst format for GTKWAVE, which is smaller than VCD file
WAV = $(TB).fst

all: build run wave

build: $(IVOBJ)
$(IVOBJ): $(SRC)
	@echo "Iverilog compiling..."
	iverilog $(SRC) -o $(IVOBJ) -g2005-sv || (echo "Compilation failed." && exit 1)

run: build $(WAV)
$(WAV): $(IVOBJ)
	@echo "Iverilog simulation and generating waveform dump..."
	vvp -n $(IVOBJ) -dumpfile=$(WAV) -fst || (echo "Simulation failed." && exit 1)

wave: $(WAV)
	@echo "Opening waveform viewer..."
	gtkwave $(WAV)

clean:
	@echo "Cleaning up generated files..."
	rm $(IVOBJ) $(WAV)
