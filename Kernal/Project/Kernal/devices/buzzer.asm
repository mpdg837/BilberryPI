    sendBuzzer: // Wyslanie wiadomosci
        call regcopyn

        // Dodanie identyfikatora
        eora eax 0xf000

        out ebx 0x0 // Wyslanie informacji
        out eax 0x1

        call regback
        ret

    playingsound:
        call regcopy
        ram 0x2010
            read eax

            cmpa eax 0x0 // Czy wgle zainicjowano dziwek
                jeq endstartupsound

                ram 0x212a
                    read edx
                    set ecx 0x3c
                        div edx ecx
                        res edx

                    add eax edx


            uram eax // Odczyt dzwieku
                read eax
            cmpa eax 0xff // Znak konca dzwieku
                jeq endstartupsound
                jmp normalssound

            normalssound:
                mov ebx eax // Odegranie dzwieku
                set eax 0x1
                    call sendBuzzer
            enormalssound:



            ram 0x2011
                savea 0xffff

            jmp endanalysestartupsound
        endstartupsound:
            ram 0x2011 // Koniec odgrywania dzwieku
                set eax 0x0
                save eax
            ram 0x2010
                save eax

            set eax 0x2
            set ebx 0x0
                call sendBuzzer


        endanalysestartupsound:

        call regback
        ret

    buzzerVolume:

        ram 0x1fe0
            read eax
            ram 0x2108
                read ebx

            cmpa eax 0x1
                jeq addBuzzerVolume
            cmpa eax 0x2
                jeq reduceBuzzerVolume
                jmp ebuzzerVolume
        addBuzzerVolume:
            cmpa ebx 0x3
                jeq ebuzzerVolume
            inc ebx
            jmp finaliseBuzzerVolume
        reduceBuzzerVolume:
            cmpa ebx 0x0
               jeq finaliseBuzzerVolume
            dec ebx
        finaliseBuzzerVolume:
            save ebx

        ebuzzerVolume:
        ret