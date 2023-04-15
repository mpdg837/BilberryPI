
    memoryerror:

        finishmemoryerror:
        jmp finishmemoryerror

    setandtestcellram:

                 uram eax // Czyszczenie komorki
                    save edx

                 ram 0x1000
                 uram eax
                    read ebx

                    cmp ebx edx // Sprawdzenie poprawnosci zapisu
                        jeq nexloopramclear

                        jmp memoryerror
                 nexloopramclear:
        ret

    ramclear: // Czyszczenie pamieci
        set eax 0x1000 // Adres startowy

        loopram:

             set edx 0x0 // Zawartosc pustej komorki pamieci
             call setandtestcellram



             inc eax // Przejscie do następnego adresu
                 // Maksymalny adres

             cmpa eax 0x3000 // Sprawdzenie czy osiagniento maksymalny adres
                 jeq endloopram // Jezeli osiagnieto koncze operacje

             jmp loopram

        endloopram: // Koniec czyszczenia

        call clearreg

        ret
