    doubleDabbleAlgorithm:
        call clearreg

            // Inicjacja wartosci

            ram 0x1fa5 // Wskaźnik
                set edx 0x0
                save edx

                set ecx 0x1fa8

                    loopLoadDableNumberLoop:
                    uram ecx

                        set edx 0x0
                        save edx

                    inc ecx
                        cmpa ecx 0x1fad
                            jlt loopLoadDableNumberLoop


            ram 0x1fad // Koniec napisu cyfry
                set edx 0xf
                save edx

            loopDable:

                ram 0x1fa4 // Wartosc konwertowana

                    read eax
                        mov ecx eax

                    // Wyciagniecie najstarszego bitu
                        anda eax 0x8000

                    set ebx 0x7 // Sprowadzenie najstarszego bitu do konca
                        shr eax ebx
                        res eax

                    set ebx 0x6 // Sprowadzenie najstarszego bitu do konca
                        shr eax ebx
                        res eax

                        mov edx eax // Skladowanie najstarszego bitu -->

                    set ebx 0x0 // Przesuniecie
                        shl ecx ebx
                        res ecx

                    // Usuniecie niepotrzebnych bitow
                        anda ecx 0xffff

                        save ecx

                ram 0x1fae
                    savea 0x1fad

                loopDabbleNumber:
                    ram 0x1fae
                        read eax
                            dec eax
                            save eax
                    uram eax
                        read eax


                        // Liczenie

                            cmpa eax 0x5
                                jeq dabble2
                                jgt dabble2
                                jmp endDabble2

                            dabble2:
                                adda eax 0x3

                            endDabble2:
                        mov ecx eax


                        // Wyciagniecie najstarszego bitu
                             anda ecx 0x0008

                        set ebx 0x2 // Sprowadzenie najstarszego bitu do konca
                            shr ecx ebx
                            res ecx // Skladowanie najstarszego bitu -->

                        set ebx 0x0 // Przeuniecie
                            shl eax ebx
                            res eax

                            add eax edx // Dodanie poprzedniego naj bitu

                        // Usuniecie zbednych wartosci
                            anda eax 0xf

                            mov edx ecx
                            save eax

                    ram 0x1fae
                        read eax

                        cmpa eax 0x1fa9
                            jgt loopDabbleNumber

                ram 0x1fa8
                    read eax

                    // Liczenie
                        cmpa eax 0x5
                            jeq dabble0
                            jgt dabble0
                            jmp endDabble0

                        dabble0:
                            adda eax 0x3

                        endDabble0:

                    mov ecx eax

                    set ebx 0x0 // Przeuniecie
                        shl eax ebx
                        res eax

                        add eax edx // Dodanie poprzedniego naj bitu

                    // Usuniecie zbednych wartosci
                        anda eax 0xf

                        save eax

                ram 0x1fa5
                    read eax
                    cmpa eax 0xe
                        jgt finloopDable

                    inc eax
                    save eax

                jmp loopDable
            finloopDable:

            set eax 0x1fa8

            lloopDable:
            // Zamiana liczb na znaki
            uram eax
                read edx
                inc edx
                save edx

                inc eax
                    cmpa eax 0x1fad
                    jeq elloopDable

                jmp lloopDable
            elloopDable:

        ret