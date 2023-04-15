

    fromstringtoint:
        call regcopy
        ram 0x2164
            read eax

        // Znalezienie konca stringa

        loopfindeoffromstringtoint:

            uram eax
                read ebx
                cmpa ebx 0xf
                    jeq eloopfindeoffromstringtoint

                inc eax

            jmp loopfindeoffromstringtoint
        eloopfindeoffromstringtoint:

        dec eax

        set ecx 0x1 // Potega
        set edx 0x0 // Liczba

        loopnumberic:

                ram 0x2164 // Sprawdzenie przekroczenia zakresu
                    read ebx
                    dec ebx
                        cmp eax ebx
                        jeq eloopnumberic

                uram eax
                    read ebx

                    cmpa ebx 0x1
                        jlt ignorecharacterloopnumberic
                    cmpa ebx 0x10
                        jgt ignorecharacterloopnumberic

                    // Od znaku do rzedu
                    dec ebx

                    mul ebx ecx
                        res ebx

                    add edx ebx

                set ebx 0xa
                    mul ecx ebx
                        res ecx

                ignorecharacterloopnumberic:
                dec eax
            jmp loopnumberic
        eloopnumberic:

        ram 0x2163
            save edx

        call regback
        ret