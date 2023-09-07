CXX = clang++
LD = clang++
CPPFLAGS = -g -Wall -Werror -Wno-narrowing

.PHONY: all keypad clean

EXES = extractMessage
all: $(EXES)

extractMessage: extractMessage_main.o extractMessage.o
	$(LD) -o $@ $(filter %.o,$^)

extractMessage_main.o: extractMessage_main.cpp extractMessage.h

extractMessage.o: extractMessage.cpp extractMessage.h 

clean:
	rm -f $(EXES) *.o *.exe *.vcd
