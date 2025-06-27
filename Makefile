
TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(PWD)/asm.v
TOPLEVEL = asm
MODULE = test_asm
SIM = icarus
WAVES = 1

include $(shell cocotb-config --makefiles)/Makefile.sim
