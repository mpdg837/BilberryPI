
    enableinput:
        call regcopy

            ram 0x2125 // Pole tekstowe
                read eax // adres

            activeinputloop:
                uram eax
                    read ebx

                    cmpa ebx 0xf
                        jeq finishactiveinputloop

                inc eax
                jmp activeinputloop
            finishactiveinputloop:

                savea 0x90
            inc eax // add cursor
                uram eax
                savea 0xf

        call regback
        ret

    waitingforloopgrphandinput:
        call regcopy
            ram 0x1fc2 // Sprawdzanie zgloszenia przerwania przez uklad graficzny
                set eax 0x0
                save eax

            inputwaitForGraphics:
                loopreadkeyinpause:
                    call getfromstackkey

                    ram 0x213f
                        read edx
                            cmpa edx 0xffff
                            jeq eloopreadkeyinpause

                            call stdinput

                    jmp loopreadkeyinpause
                eloopreadkeyinpause:



                ram 0x1fc2
                    read eax
                // Wartosc oczekiwana
                cmpa eax 0xffff
                    jeq inputrenderGraphics // Przekierowanie wrazie wykrycia rozpoczecia nowej klatki
                jmp inputwaitForGraphics

            inputrenderGraphics: // Render nowej klatki

        call loadBuffer

        set ebx 0x0 // Czysczenie wartosci rejestru detekotora
        save ebx

        call regback
        ret


    saveoneinput:
       uram eax
            read ebx
       ram 0x2121
            save ebx
       ret

    savetwoinput:
        uram eax
            read ebx
        ram 0x2122
            save ebx
        ret

    backoneinput:
        ram 0x2121
            read ebx
        uram eax
            save ebx

        ret

    backtwoinput:
        ram 0x2122
            read ebx
        uram eax
            save ebx
        ret

    countleninput:
        call regcopy
        ram 0x2125
            read eax

            set edx 0x1

            countleninputx:

                uram eax
                    read ebx
                    cmpa ebx 0xf
                    jeq ecountleninputx

                inc edx
                inc eax

                jmp countleninputx
            ecountleninputx:

            ram 0x2127
                save edx

            call regback
        ret

    finishstdinput:
        call regcopy
        ram 0x2125
            read eax

        loopfinishstdinput: // Sprawdzenie pozycji kursora

            uram eax
                read ebx

                cmpa ebx 0x90
                    jeq eloopfinishstdinput

            inc eax
            jmp loopfinishstdinput
        eloopfinishstdinput:

            inc eax
                uram eax
                read edx

                set ebx 0x0
                    save ebx

            dec eax
                uram eax
                save edx

                cmpa edx 0xf // EOL
                    jeq eeloopfinishstdinput

            inc eax

            jmp eloopfinishstdinput
        eeloopfinishstdinput:

            ram 0x2125 // Pole tekstowe
                savea 0x1
            ram 0x2126
                savea 0x1
        call regback
        ret



    stdinput:
        call regcopy

        ram 0x213f
            read eax
            cmpa eax 0xffff
                jeq inputnopresskeykeyboard

                jmp inputpresskeykeyboard
            inputpresskeykeyboard:
                // Add key

                ram 0x2125
                    read eax

                inputloopdetectendkey:

                        uram eax
                            read ebx
                            cmpa ebx 0x90 // CURSOR
                                jeq inputeloopdetectendkey

                            inc eax
                    jmp inputloopdetectendkey
                inputeloopdetectendkey:

                ram 0x2140
                    read ebx

                    cmpa 0x10 ebx
                        jeq inputenterpresskey
                    cmpa 0x11 ebx // up
                        jeq inputnopresskeykeyboard
                    cmpa 0x12 ebx // down
                        jeq inputnopresskeykeyboard
                    cmpa 0x13 ebx //left
                        jeq inputleftmovecursor
                    cmpa 0x14 ebx //right
                        jeq inputrightmovecursor
                    cmpa 0xf ebx
                        jeq inputbackspace
                        jmp inputaddcharacter

                inputenterpresskey:
                    call finishstdinput
                    jmp einputnopresskeykeyboard
                inputleftmovecursor:

                    ram 0x2123
                        read ebx
                        cmpa ebx 0xffff
                            jeq pressinputleftmovecursor
                        savea 0xffff
                            jmp einputnopresskeykeyboard

                    pressinputleftmovecursor:
                        set ebx 0x0
                        save ebx

                        ram 0x2125
                            read ecx
                            cmp eax ecx // Aby nie wyjsc poza zakres wyświetlania
                                jeq einputnopresskeykeyboard

                    call saveoneinput

                    dec eax

                    call savetwoinput
                    call backoneinput
                    inc eax

                    call backtwoinput


                    jmp einputnopresskeykeyboard
                inputrightmovecursor:
                    ram 0x2123
                        read ebx
                        cmpa ebx 0xffff
                            jeq pressinputrightmovecursor
                        savea 0xffff
                            jmp einputnopresskeykeyboard

                    pressinputrightmovecursor:
                        set ebx 0x0
                        save ebx

                        inc eax
                            uram eax
                            read ebx
                                cmpa ebx 0xf
                                jeq einputnopresskeykeyboard // Nie mozna przesunac poza zakres
                        dec eax


                    call saveoneinput

                    inc eax

                    call savetwoinput
                    call backoneinput

                    dec eax

                    call backtwoinput

                    jmp einputnopresskeykeyboard
                inputbackspace:

                    dec eax
                    ram 0x2125
                        read ecx
                            cmp eax ecx
                            jlt eloopinputbackspace // Aby nie wyjsc poza zakres wyswietlania
                        uram eax
                        savea 0x90

                    adda eax 0x2

                    loopinputbackspace:
                        uram eax
                            read ecx

                            set ebx 0x0
                                save ebx

                        dec eax
                            uram eax
                                save ecx

                        cmpa ecx 0xf // EOL
                            jeq eloopinputbackspace

                        adda eax 0x2
                    jmp loopinputbackspace
                        eloopinputbackspace:
                    jmp einputnopresskeykeyboard
                inputaddcharacter:
                        ram 0x2124
                            save eax

                        call countleninput // Aby nie wykroczyc poza zakres
                        ram 0x2127
                            read ebx
                        ram 0x2126
                            read ecx
                            cmp ebx ecx
                                jegt einputnopresskeykeyboard

                        loopinputaddcharacterfinish: // Szukanie konca linii
                                uram eax
                                    read ebx
                                    cmpa ebx 0xf // EOL
                                        jeq eloopinputaddcharacterfinish
                                    inc eax
                            jmp loopinputaddcharacterfinish

                        eloopinputaddcharacterfinish:
                        // Przesuniecie

                        nop

//
                        loopinputcharactershift:
                            uram eax
                                read ecx
                                read ebx

                                cmpa ebx 0x90 // Kursor
                                    jeq eloopinputcharactershift

                                inc eax
                                    uram eax
                                        save ecx

                            suba eax 0x2

                            jmp loopinputcharactershift
                        eloopinputcharactershift:
//

                    ram 0x2140
                        read ebx
                        cmpa ebx 0x16 // obsluga spacji
                            jeq inputspacesolution
                            jmp einputspacesolution

                    inputspacesolution:
                        set ebx 0x0
                    einputspacesolution:

                    // Dodanie
                    ram 0x2124
                        read eax
                    uram eax
                        save ebx
                        inc eax
                            uram eax
                            savea 0x90 // nast kon

                einputnopresskeykeyboard:
                    nop
            inputnopresskeykeyboard:

        call regback
        ret