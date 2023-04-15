
include Project\main\resources\soundstart.dat
include Project\main\resources\logo.dat
include Project\main\image\image.asm
include Project\main\program.asm
include Project\main\image\loadimage.asm
include Project\main\clock.asm
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
            set ebx 0x2
                call sendCopper

            call deltascreen

            ram 0x250b
                savea 0x1600
            ram 0x2503
                savea 0x16fb

            ram 0x250c
                savea 0x40

                call loadimage

            ram 0x250b
                savea 0x1800
            ram 0x2503
                savea 0x191b

            ram 0x250c
                savea 0xb

                call loadimage
            jmp startup


    // Palette
    &data 0x1ea0 < 0000 0000 0000 0011
    &data 0x1ea1 < 0000 0000 0000 0000

    &data 0x1ea2 < 0000 0000 0000 0100
    &data 0x1ea3 < 0000 0000 0000 0000

    &data 0x1ea2 < 0000 0000 0000 1001
    &data 0x1ea3 < 0000 0000 0000 0000

    &data 0x1ea4 < 0000 0000 0001 1101
    &data 0x1ea5 < 0000 0000 0000 0000

