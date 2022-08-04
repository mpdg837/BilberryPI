    sendBuzzer: // Wyslanie wiadomosci
        call regcopyn

        // Dodanie identyfikatora
        eora eax 0xf000

        out ebx 0x0 // Wyslanie informacji
        out eax 0x1

        call regback
        ret

    playingsound:

        ram 0x2010
            read eax

            cmpa eax 0x0 // Czy wgle zainicjowano dziwek
                jeq endstartupsound

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

            ram 0x2010 // Postep dzwieku
                read eax
                inc eax
                save eax

            ram 0x2011
                savea 0xffff

            jmp endanalysestartupsound
        endstartupsound:
            ram 0x2011 // Koniec odgrywania dzwieku
                savea 0x0

            set eax 0x2
            set ebx 0x0
                call sendBuzzer
        endanalysestartupsound:

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