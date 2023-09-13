# Disable make's irritating builtin rules
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:


all:
	@echo Please run one of the following targets:
	@echo arith_machine, clean
.PHONY: all arith_machine clean

# Verilog simulations sometimes enter infinite loops, and piping the simulation
# through grep (below) causes it to be block-buffered, meaning nothing gets
# printed out to the screen, confusing people. This is to force line-buffering;
# script should be available everywhere but it uses different parameters on
# Linux and OS X, making it simpler to use stdbuf on Linux instead
ifneq ($(shell command -v stdbuf;),)
    UNBUFFER = stdbuf -oL
else ifneq ($(shell command -v script;),)
    UNBUFFER = script -q /dev/null
endif

# dumping register values causes spurious VCD warnings to be printed during execution,
# hence the use of grep to filter them up. However, the presence of 'VCD warning' in a
# command freaked a bunch of people out last time, so I'm echoing a fake command instead
# of the actual one to prevent any confusion
arith_machine: arith_machine_exe
	@echo ./$<
	@$(UNBUFFER) ./$< | grep -v 'VCD warning'

arith_machine_exe: alu32.v mux_lib.v rf.v arith_machine.v arith_machine_tb.v
	iverilog -o $@ -Wall $^

clean:
	rm -f arith_machine_exe arith_machine.vcd
