
    changecursor:
        call regcopy

        ram 0x212b
            read ebx

                cmpa ebx 0x4b0
                jgt changecursortodo
            inc ebx
            save ebx

        jmp echangecursortonotvisible
        changecursortodo:

        set ebx 0x0
            save ebx

        ram 0x2160
            read ebx
            cmpa ebx 0xffff
                jeq changecursortonotvisible

                savea 0xffff

                jmp echangecursortonotvisible
        changecursortonotvisible:

            set eax 0x0
            save eax

        echangecursortonotvisible:
            call setcursortexture
        call regback
        ret

    setcursortexture:
        call regcopy

            set ebx 0x41

            set eax 0x6
                call sendGraphics

                set ecx 0x0
                    loopcharcursor:

                            set eax 0x7
                            mov ebx ecx
                                call sendGraphics

                            ram 0x2160
                                read ebx

                                set eax 0x8
                                    call sendGraphics
                                set eax 0x9
                                    call sendGraphics
                            inc ecx // YLINE

                            // Warunek koncowy petli
                                cmpa ecx 0x7
                                jgt endloopcharcursor

                            jmp loopcharcursor

                    endloopcharcursor:

        call regback
        ret

