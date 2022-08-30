
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
                savea 0x1ba0
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
                savea 0x1b80
            ram 0x212a
                set eax 0x0
                save eax


            jmp startup


    // Palette
    &data 0x1ba0 < 0000 0000 0000 1100
    &data 0x1ba1 < 0000 0000 0000 0000

    &data 0x1ba2 < 0000 0000 0000 0100
    &data 0x1ba3 < 0000 0000 0000 0000

    &data 0x1ba2 < 0000 0000 0000 1001
    &data 0x1ba3 < 0000 0000 0000 0000

    &data 0x1ba4 < 0000 0000 0001 1101
    &data 0x1ba5 < 0000 0000 0000 0000

    &data 0x1ba6 < 0000 0000 0001 0000
    &data 0x1ba7 < 0000 0000 0000 0000

    &data 0x1baa < 0000 0000 0001 0011
    &data 0x1bab < 0000 0000 0000 0000

    &data 0x1bac < 0000 0000 0001 1010
    &data 0x1bad < 0000 0000 0000 0000

    &data 0x1bae < 0000 0000 0001 1001
    &data 0x1baf < 0000 0000 0000 0000
