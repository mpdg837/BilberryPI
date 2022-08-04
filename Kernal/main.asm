
    include Kernal\devices\io.asm
    include Kernal\memory.asm
    include Kernal\out.asm
    include Kernal\program.asm

    include Kernal\resources.dat

    // Inicjator
    int
        jmp init // Odniesienie do petli systemu

        // Przerwania
        jmp keysets // Przerwanie 0x1
        jmp keyboard // Przerwanie 0x2
        jmp outputcontroller // Przerwanie 0x3
        jmp grphstart // Przerwanie 0x4
        jmp grphcleared // Przerwanie 0x5
        jmp diskrdy // Przerwanie 0x6
        jmp exception // Wyjatki

    clearreg:
        set eax 0x0 // Czyszczenie rejestrow
        set ebx 0x0
        set ecx 0x0
        set edx 0x0
        ret

    regcopyn: // Kopia rejestrów w pamięci
        ram 0x1ff0
            save eax // Zapis rejestru a
        ram 0x1ff1
            save ebx // Zapis rejestru a
        ram 0x1ff2
            save ecx // Zapis rejestru a
        ram 0x1ff3
            save edx // Zapis rejestru a

        ret

    regcopy: // Kopia rejestrów w pamięci
        ram 0x1ff0
            save eax // Zapis rejestru a
        ram 0x1ff1
            save ebx // Zapis rejestru a
        ram 0x1ff2
            save ecx // Zapis rejestru a
        ram 0x1ff3
            save edx // Zapis rejestru a

        call clearreg

        ret

    regcopyinter: // Kopia rejestrów w pamięci
        ram 0x1ff4
            save eax // Zapis rejestru a
        ram 0x1ff5
            save ebx // Zapis rejestru a
        ram 0x1ff6
            save ecx // Zapis rejestru a
        ram 0x1ff7
            save edx // Zapis rejestru a

        call clearreg

        ret

    regback: // Powrót pierwornych rejestrów
        ram 0x1ff0
            read eax // Odzysk rejestru a
        ram 0x1ff1
            read ebx // Odzysk rejestru b
        ram 0x1ff2
            read ecx // Odzysk rejestru c
        ram 0x1ff3
            read edx // Odzysk rejestru d

        ret

    regbackinter: // Powrót pierwornych rejestrów
        ram 0x1ff4
            read eax // Odzysk rejestru a
        ram 0x1ff5
            read ebx // Odzysk rejestru b
        ram 0x1ff6
            read ecx // Odzysk rejestru c
        ram 0x1ff7
            read edx // Odzysk rejestru d

        ret

    exception:

        ret

