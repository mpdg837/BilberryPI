
    calltoblock:
        call regcopyn

            ram 0x2113 // Poczatek
                savea 0x1000

            ram 0x2118 // Dodanie sektora do stosu
                read ebx
            push ebx eax
                save ebx

            ram 0x211b
                read eax
            ram 0x2118 // Blok
                save eax

            ram 0x2129
                set eax 0x0
                    save eax

            call loadprogramsector
            call start

            pop ebx eax// pobranie sektora z stosu
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

            ram 0x2129
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
                    ram 0x2129
                        read edx
                        cmpa edx 0xffff

                        jeq smallamountofdataloadprogramsector
                        // big
                            cmpa eax 0x1eff
                        jmp eamountofdataloadprogramsector
                            smallamountofdataloadprogramsector:
                            // small
                                cmpa eax 0x1bff
                            eamountofdataloadprogramsector:



                                jgt eloopprogramloader
                                jeq eloopprogramloader

                        ram 0x2118
                            read eax
                            inc eax
                            save eax
                        jmp loopprogramloader

                eloopprogramloader:

                nop
                nop
                nop
                nop

        // Awaryjny jump
            ram 0x17fe
                savea 0x0050
            ram 0x17ff
                savea 0x1000

        call regback
        ret
