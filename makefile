cowboy: cowboy.o
	ld -macosx_version_min 10.7 -o cowboy cowboy.o
cowboy.o: getpid.asm
	nasm -f macho -o cowboy.o getpid.asm
