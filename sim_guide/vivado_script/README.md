# A Definitive Guide to Vivado Simulator Scripted Flow

This note is based on <a href="https://www.itsembedded.com/dhd/vivado_sim_1/">reference</a> with the intension to provide a definitive guide to utilize Vivada simulator using script or Makefile.

## prerequisites

- Xilinx Vivado installed and running on a Linux workstation.
- Basic development tools installed (make, git)
- Familiar with using a terminal

## The Flow of Simulation behind the GUI

1. Compilation

Compiling source files (SystemVerilog, Verilog, VHDL) is the first step.
Compilation only looks at a single source file at a time - the compiler takes the HDL code, parse it and convert it for more steps.
The result of the compilation step is **object files** that the simulator understands.
During this step, any syntax errors, missing symbols or includes, will result in a failure.

The basic syntax to compile sources from the command line is:

- `xvlog src.v`
- `xvlog --sv src.sv`
- `svhdl src.vhdl`

2. Elaboration

During elaboration ,the tool goes through the generated object files, collects information about the module hierarchy, and attempts to connect the modules as well as solve all hierarchical signal paths.
This is the step where you get warnings about mismatched port widths, unused IO, or blocking assignments in sequential blocks.
All of the tool’s hard work results in **a simulation snapshot** that you can pass to the simulator.

The basic syntax to elaborate design from the command line and parameters are:

`xelab -top name_of_the_top_module -snapshot new_sim_snapshot_name`

- `--debug arg`: debugging ability. `typical`: line, wave, drivers.
- `-s [--snapshot] arg`: the name of the design snapshot.

3. Simulation

`xsim -snapshot new_sim_snapshot_name`

- `-R [--runall]`: run the executable until end
- `-t [--tclbatch]`: specify the TCL file for batch mode execution
- `-g [--gui]`: GUI

4. Conclusion

A basic command line flow:

```shell
xvlog --sv src.sv
xelab --debug typical -top top_mod -s snapshot_name
xsim -s snapshot_name -R
```

To generate waveform and load the wave file:

```shell
xsim -s snapshot_name -t xsim_cfg.tcl
xsim -g tb_snapshot.wdb
```

```tcl
# xsim_cfg.tcl
log_wave -recursive *
run all
exit
```
