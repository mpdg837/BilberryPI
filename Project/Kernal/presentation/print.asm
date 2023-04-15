
            setposchar:
                   set eax 0x0a // Wybor pozycji w X

                         ram 0x1fc0 // Wczytanie z rejestru pozycji pisarza dla X
                            read ebx

                         set ecx 0x2 // Odstęp

                         shl ebx ecx // Przesuniecie aby byl odstep miedzy znakami
                            res ebx

                          // Wyslanie prosby do karty
                         call sendGraphics

                    set eax 0x0b // Wybor pozycji Y
                          ram 0x1fc1 // Wczytanie z rejestru pozycji pisarza dla Y
                              read ebx

                          set ecx 0x2 // Odstęp

                          shl ebx ecx // Przesuniecie aby byl odstep miedzy znakami
                          res ebx

                           // Wyslanie prosby do karty
                          call sendGraphics



                    set eax 0x0c // Wybor znaku


        ret


        print:
            call clearreg
            set edx 0x0

                loopWriter:

                    call setposchar

                          ram 0x1fc3 // Wczytanie wskaznika ciagu
                              read ebx
                              mov ecx ebx

                              inc ecx // Przeskok do nastepnego

                              save ecx

                          uram ebx // Wczytanie znaku ciagu
                               read ebx

                                ram 0x2116
                                    read eax
                                    cmpa eax 0xffff
                                        jeq loopWriterSecondByteAnalyse

                                        // Wybranie najmłodszego bajtu rejestru
                                        anda ebx 0xff

                                    jmp eloopWriterSecondByteAnalyse
                                    loopWriterSecondByteAnalyse:

                                        set eax 0x7
                                            shr ebx eax
                                            res ebx

                                    eloopWriterSecondByteAnalyse:
                                        set eax 0x0c

                               cmpa ebx 0x10
                                jeq newLineWriter

                              // Sprawdzenie czy to nie koniec stringa
                              cmpa ebx 0xf
                                  jeq finishWriter


                          call sendGraphics
                          call colorMyBlock

                    ram 0x1fc0 // Wczytanie z rejestru pozycji pisarza dla Y
                        read ebx

                        cmpa ebx 0x24

                        jgt newLineWriter
                        jmp finalAnalyseWriter

                    newLineWriter:

                    ram 0x1fc0 // Nowa linia
                        savea 0x4

                    ram 0x1fc1
                        read ebx

                        inc ebx

                        save ebx

                    finalAnalyseWriter:
                        ram 0x1fc0 // postep
                          read ebx

                          inc ebx

                          save ebx

                        inc edx // Liczenie znakow wpisanych

                        cmpa edx 0x200 // Porownanie
                            jeq finishWriter
                            jgt finishWriter

                        jmp loopWriter

                    finishWriter:

        ret

  prints:
        call regcopy
        call print // tekst
        call regback
        ret

    putnum:
         call regcopy
         call intToStr

         ram 0x1fc3 // Wskzanik strigna do wartosci konwertowaej
             set ebx 0x1fb1
             save ebx
             call print

        call regback
        ret