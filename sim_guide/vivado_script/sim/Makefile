tb = testbench

all : compile elab sim

compile :
	xvlog --sv ../$(tb).sv

elab :
	xelab --debug typical -top $(tb) -s $(tb)_snap

sim :
	xsim $(tb)_snap -t cfg_xsim.tcl # -gui

clean :
	# note: `-r` is for `mv`
	rm -r .Xil/ xsim.dir/ xelab* xsim* xvlog* $(tb)_snap*

