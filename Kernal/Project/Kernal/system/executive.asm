
    calltoblock:
        call regcopyn

            ram 0x2113 // Poczatek
                savea 0x1000

            ram 0x2118 // Dodanie sektora do stosu
                read ebx
            push ebx
                save ebx

            ram 0x211b
                read eax
            ram 0x2118 // Blok
                save eax

            call loadprogramsector
            call start

            pop ebx // pobranie sektora z stosu
                read ebx
            ram 0x2118
                save ebx

            ram 0x2113 // Poczatek
                savea 0x1000

            call loadprogramsector
        call regback
        ret

    bootloader: // Ladowanie bootsectora
            call regcopy
            ram 0x2113 // Poczatek
                savea 0x1000

            ram 0x2118 // Blok
                set eax 0x0
                save eax

            ram 0x211b
                savea 0x0

            call loadprogramsector

            call regback
        ret

    loadprogramsector: // Ladowanie sektora
        call regcopyn
        loopprogramloader:
                    call diskloader

                    ram 0x2113
                        read eax
                            cmpa eax 0x13ff

                            jgt eloopprogramloader
                            jeq eloopprogramloader

                        ram 0x2118
                            read eax
                            inc eax
                            save eax
                        jmp loopprogramloader

                eloopprogramloader:

                ram 0x10ff // Odczyt
                    read eax

                ram 0x1fe1
                    save eax

        // Awaryjny jump
            ram 0x17fe
                savea 0x0050
            ram 0x17ff
                savea 0x1000

        call regback
        ret
