getpid: getpid.o
	ld -macosx_version_min 10.7 -o getpid getpid.o
getpid.o: getpid.asm
	nasm -f macho -o getpid.o getpid.asm
