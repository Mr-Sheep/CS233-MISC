CXX = clang++
CPPFLAGS = -Wall -g

alu1_deps = mux.v logicunit.v alu1.v alu1_tb.v
alu32_deps = mux.v logicunit.v alu1.v alu32.v alu32_tb.v

BENCHES = alu1 alu32 
all: $(BENCHES) example_generator generator
.PHONY: all $(BENCHES) clean
.SECONDEXPANSION:

$(BENCHES): %: %_exe
	./$<

%_exe: $$(%_deps)
	iverilog -o $@ -Wall $^

clean:
	rm -rf example_generator generator *_exe *.exe *.vcd *.dSYM
