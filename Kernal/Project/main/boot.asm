
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
                savea 0x13a0
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

            ram 0x2010 // Dzwiek poczatkowy
                savea 0x1380
            ram 0x212a
                set eax 0x0
                save eax


            jmp startup


    // Palette
    &data 0x13a0 < 0000 0000 0000 1100
    &data 0x13a1 < 0000 0000 0000 0000

    &data 0x13a2 < 0000 0000 0000 0100
    &data 0x13a3 < 0000 0000 0000 0000

    &data 0x13a2 < 0000 0000 0000 1001
    &data 0x13a3 < 0000 0000 0000 0000

    &data 0x13a4 < 0000 0000 0001 1101
    &data 0x13a5 < 0000 0000 0000 0000

    &data 0x13a6 < 0000 0000 0001 0000
    &data 0x13a7 < 0000 0000 0000 0000

    &data 0x13aa < 0000 0000 0001 0011
    &data 0x13ab < 0000 0000 0000 0000

    &data 0x13ac < 0000 0000 0001 1010
    &data 0x13ad < 0000 0000 0000 0000

    &data 0x13ae < 0000 0000 0001 1001
    &data 0x13af < 0000 0000 0000 0000
