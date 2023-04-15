
    singletimer:
        uram edx // Postep czasomierza
                read eax
                cmpa eax 0xffff
                    jeq ignoretimer

                inc eax
                save eax
                jmp eignoretimer
                ignoretimer:

                    set eax 0x0
                    save eax

                eignoretimer:

        ret


    timer:
        call regcopyinter

        ram 0x211c // Informacja o ticku
            savea 0xffff

        set edx 0x212a

        looptimerset: // Aktualizacja wbudowanych timerow
            call singletimer

            cmpa edx 0x212e
                jeq elooptimerset
            inc edx

            jmp looptimerset
        elooptimerset:


        call regbackinter

        ret
