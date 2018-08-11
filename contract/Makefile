all: compile abi

compile: contract.cpp
	eosiocpp -o contract.wast contract.cpp 

abi: contract.cpp
	eosiocpp -g contract.abi contract.cpp

clean:
	rm -f *~ *.o *.wast *.abi *.wasm


