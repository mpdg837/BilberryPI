
    keydetectxx:
                // Usuniecie zbednych informacji
                    anda eax 0x00ff

                    cmpa eax 0xe0
                        jeq startdetectkeyboardpress
                    cmpa eax 0x00
                        jeq ignorekeymekeyboard
                    cmpa eax 0xff
                        jeq ignorekeymekeyboard
                // Wykrywanie rozpoczecia puszczenia
                    cmpa eax 0xf0
                        jeq startdetectkeyboard
                    // Czy rozpoczeto puszczenie
                    ram 0x2103
                        read ebx
                        set ecx 0xffff
                        cmp ecx ebx
                            jeq startanalysekeyboard // puszczanie

                            jmp ignorekeymekeyboard
                        startanalysekeyboard:
                        // analizuje
                        set ebx 0x0
                            save ebx
                    cmpa eax 0x59
                        jeq shiftkeyboarddetected
                        jmp endshiftkeyboarddetected
                    startdetectkeyboardpress:
                        ram 0x2105
                            savea 0xffff
                            jmp finstartdetectkeyboard

                    startdetectkeyboard:
                        ram 0x2105
                            savea 0x0

                        finstartdetectkeyboard:
                            ram 0x2103
                                savea 0xffff

                                set eax 0x0

                            jmp eloopkeyboard
                    shiftkeyboarddetected:
                        // Wykryto shifta
                            ram 0x2104
                                read eax
                                set ebx 0xffff
                                    cmp eax ebx
                                        jeq isshiftdetected
                                            savea 0xffff
                                        jmp ignorekeymekeyboard
                            isshiftdetected:
                                set ebx 0x0
                                    save ebx
                            jmp ignorekeymekeyboard

                    endshiftkeyboarddetected:

                set ebx 0x07c0
                set edx 0x0

                loopkeyboard:
                    uram ebx
                        read ecx

                        ram 0x2100
                            save ebx
                        ram 0x2101
                            save edx

                            ram 0x2104
                                read ebx

                                    cmpa ebx 0xffff
                                        jeq shiftkeyboardpress
                                    // Bez shifra
                                    anda ecx 0xff

                                    jmp endshiftkeyboardpress
                                shiftkeyboardpress:

                                    // Z shiftem
                                    set edx 0x7
                                    shr ecx edx
                                        res ecx

                    endshiftkeyboardpress:
                        ram 0x2100
                            read ebx
                        ram 0x2101
                            read edx

                        cmp eax ecx
                            jeq deceloopkeyboard

                        set ecx 0x3f
                        cmp ecx edx
                            jeq finishddeceloopkeyboard

                            jmp ddeceloopkeyboard

                            finishddeceloopkeyboard:
                                set eax 0x0
                                jmp reduceshiftkeyboard
                            deceloopkeyboard:
                                mov eax edx

                                jmp reduceshiftkeyboard
                            ddeceloopkeyboard:

                                inc edx
                                inc ebx
                    jmp loopkeyboard
                reduceshiftkeyboard:
                    ram 0x2104
                        set ebx 0x0
                        save ebx
                    jmp eloopkeyboard
                nonekeyboardkey:
                    set eax 0x0
                eloopkeyboard:
                    set ebx 0x0
                        cmp eax ebx
                            jeq ignorekeymekeyboard

                ram 0x1fe1
                    save eax // Zapis do bufora klawiatury

                ram 0x2106
                    savea 0xffff

                    jmp beforeignorekeymekeyboard
                ignorekeymekeyboard:

                ram 0x2106
                    set ebx 0x0
                    save ebx

                beforeignorekeymekeyboard:

                call regbackinter // Powrot do stanu pierwotnego
        ret

    keyboard:

         call regcopyinter // Zapis rejestrow

         ram 0x2111 // Aby przyspieszyc procesy ladowania
             read eax
             cmpa eax 0xffff
             jeq ignorekeyboard

         sot 0x3

         in eax 0x0

        call keydetectxx
        ignorekeyboard:
        call regbackinter

        ret







