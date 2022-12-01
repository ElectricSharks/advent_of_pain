BINN=day_1
$(BINN): $(BINN).o lib.o log.o
	gcc -o ./bin/$(BINN) ./bin/$(BINN).o ./bin/lib.o ./bin/log.o -no-pie
$(BINN).o: $(BINN).asm
	nasm -f elf64 -g -F dwarf $(BINN).asm -l ./bin/$(BINN).lst -o ./bin/$(BINN).o
lib.o: ../../utils/lib.asm
	nasm -f elf64 -g -F dwarf ../../utils/lib.asm -l ./bin/lib.lst -o ./bin/lib.o
log.o: ../../utils/log.asm
	nasm  -f elf64 -g -F dwarf ../../utils/log.asm -l ./bin/log.lst -o ./bin/log.o
clean:
	rm bin/*
