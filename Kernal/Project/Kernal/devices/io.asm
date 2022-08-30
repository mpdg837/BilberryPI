
    include Project\Kernal\devices\timer.asm
    include Project\Kernal\devices\buzzer.asm
    include Project\Kernal\devices\graphics.asm
    include Project\Kernal\devices\keyboard.asm
    include Project\Kernal\devices\sddisk.asm

    sendCopper: // Wyslanie wiadomosci
            call regcopyn

            eora eax 0x4000

            out ebx 0x0 // Wyslanie informacji
            out eax 0x1

            call regback
            ret

    outputcontroller:
            call regcopyinter // Zapis rejestrow

            sot 0x1
                in eax 0x0
                anda eax 0x8000
                    cmpa eax 0x8000
                    jeq gpiooutput

                    in eax 0x0
                        ram 0x211f // UART
                        save eax


                    jmp egpiooutput
                gpiooutput:

                    in eax 0x0
                        ram 0x211e// GPIO
                        save eax

                    egpiooutput:

            call regbackinter // Powrot do stanu pierwotnego
            ret

    keysets:  // Obsługa wyjątku

        call regcopyinter // Zapis rejestrow

        ram 0x2111 // Aby przyspieszyc procesy ladowania
             read eax
             cmpa eax 0xffff
             jeq ignorekeys

        sot 0x2

        in eax 0x0

        // Usuniecie zbednych informacji
        anda eax 0x000f

        ram 0x1fe0
        save eax // Zapis do bufora klawiatury

        call buzzerVolume

        ignorekeys:
        call regbackinter // Powrot do stanu pierwotnego
        ret