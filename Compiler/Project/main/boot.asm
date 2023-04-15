
include Project\main\resources\soundstart.dat
include Project\main\resources\logo.dat
include Project\main\program.asm

    nop
    set eax 0xdddd // identyfikator

    start:
            ram 0x1faf // Wartosc konwertowana
                    set edx 0x0
                    save edx

            ram 0x2107
                savea 0x1ea0
            call loadPalette

            call clearreg

             ram 0x210d // Delta screen
                        savea 0x0
                    ram 0x210e
                        savea 0x0
            ram 0x2108
                savea 0x3

            set eax 0x5 // LED Display
            set ebx 0x1
                call sendCopper

            call deltascreen

            set eax 0x4
            set ebx 0x1600
                call sendBuzzer
            set eax 0x5
            set ebx 0x040
                 call sendBuzzer
            set eax 0x9
            set ebx 0x1
                call sendBuzzer


            jmp startup


    // Palette
    &data 0x1ea0 < 0000 0000 0000 1100
    &data 0x1ea1 < 0000 0000 0000 0000

    &data 0x1ea2 < 0000 0000 0000 0100
    &data 0x1ea3 < 0000 0000 0000 0000

    &data 0x1ea2 < 0000 0000 0000 1001
    &data 0x1ea3 < 0000 0000 0000 0000

    &data 0x1ea4 < 0000 0000 0001 1101
    &data 0x1ea5 < 0000 0000 0000 0000

    &data 0x1ea6 < 0000 0000 0001 0000
    &data 0x1ea7 < 0000 0000 0000 0000

    &data 0x1eaa < 0000 0000 0001 0011
    &data 0x1eab < 0000 0000 0000 0000

    &data 0x1eac < 0000 0000 0001 1010
    &data 0x1ead < 0000 0000 0000 0000

    &data 0x1eae < 0000 0000 0001 1001
    &data 0x1eaf < 0000 0000 0000 0000
