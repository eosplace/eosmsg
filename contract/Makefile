all: compile abi

compile: game.cpp
	eosiocpp -o contract.wast game.cpp ../../common/mydate.cpp

abi: game.cpp
	eosiocpp -g contract.abi game.cpp

clean:
	rm -f *~ *.o *.wast *.abi *.wasm


