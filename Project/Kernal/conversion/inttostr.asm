
    intToStr:
            ram 0x1fa4 // Wczytanie wartosci
                read eax

                    cmpa eax 0x0
                    jlt makeMinusINT
                    jmp notMakeMinusINT

                makeMinusINT:
                        ram 0x1fb1 // minus
                            savea 0xb
                    jmp endMakeMinusINT
                notMakeMinusINT:
                        ram 0x1fb1 // Kropka
                        set ebx 0x0
                            save ebx
                    jmp endMakeMinusINT
                endMakeMinusINT:

                ram 0x1fa4
                call abs // Wyciagniecie war bezwzgl

                    save eax

            call doubleDabbleAlgorithm

                set ebx 0x1fa8
                set ecx 0x1fb2

                inttostrloop:
                        uram ebx // Przepisanie
                    read edx
                        uram ecx
                    save edx

                    inc ebx
                    inc ecx


                        cmpa ebx 0x1fad
                        jeq einttostrloop
                        jmp inttostrloop
                einttostrloop:


                    ram 0x1fb7 // Koniec
                        savea 0xf

            call reduceStrNumber

        ret


    reduceStrNumber:

        loopReduceStrNumber:

            ram 0x1fb3
                read eax
                    cmpa eax 0x3a
                        jeq eloopReduceStrNumber
                    cmpa eax 0xf
                        jeq eloopReduceStrNumber

            ram 0x1fb2
                read eax

                    cmpa eax 0x0
                        jeq shiftNumberReduceStr
                    cmpa eax 0x1
                        jeq shiftNumberReduceStr
                jmp eloopReduceStrNumber

            shiftNumberReduceStr:

                    set eax 0x1fb3

                    sshiftNumberReduceStr:
                        uram eax
                            read edx
                        dec eax
                        uram eax
                            save edx
                        inc eax
                        inc eax

                            cmpa eax 0x1fbb
                            jeq esshiftNumberReduceStr
                        jmp sshiftNumberReduceStr
                    esshiftNumberReduceStr:

                    ram 0x1fba
                         set edx 0x0
                         save edx

            jmp loopReduceStrNumber
        eloopReduceStrNumber:

        ret

