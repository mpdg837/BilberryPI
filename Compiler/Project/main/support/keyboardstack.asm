     getfromstackkey:
        call regcopy

        ram 0x213f
            set eax 0x0
            save eax

        set eax 0x213e

        loopgetfromstack:
            cmpa eax 0x212f // Wykroczenie poza zakres
                jeq eloopgetfromstackx
            uram eax
                read ebx
                cmpa ebx 0x0
                    jeq nloopgetfromstack

                // analiza
                    ram 0x2140
                        save ebx
                    uram eax
                        set ebx 0x0
                        save ebx

                jmp eloopgetfromstack
                nloopgetfromstack:
                    dec eax
            jmp loopgetfromstack
        eloopgetfromstackx:
            ram 0x213f
                savea 0xffff
        eloopgetfromstack:
        call regback
        ret