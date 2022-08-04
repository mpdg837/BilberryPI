

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
                               set ecx 0xff // Wybranie najmłodszego bajtu rejestru
                               and ebx ecx

                               cmpa ebx 0x1f
                               jeq newLineWriter

                          // Sprawdzenie czy to nie koniec stringa
                          cmpa ebx 0xf
                              jeq finishWriter


                          call sendGraphics
                          call colorMyBlock

                    ram 0x1fc0 // Wczytanie z rejestru pozycji pisarza dla Y
                        read ebx

                        cmpa ebx 0x20

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

                        cmpa edx 0x3a // Porownanie
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