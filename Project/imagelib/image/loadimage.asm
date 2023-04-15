include Project\main\image\paletteman.asm

loadimage:
    call regcopy

    call loadimageprop

    call regback
    ret

loadimageprop:
    call regcopy
    // load address

    call paletteman

    ram 0x250b
        read edx

    adda edx 0x2

    // loadamount
    uram edx
        read ebx
        inc ebx
    ram 0x2553
        save ebx

    ram 0x2110
        inc edx
        save edx



    call loadcharsett

    ram 0x2503
        read eax

    adda eax 0x2
        uram eax

        ram 0x250e
            read ecx
        uram eax
            save ecx

    call regback
    ret




loopchart:

     set eax 0x7
     mov ebx ecx
          call sendGraphics

     uram edx
          read ebx

     set eax 0x8
          call sendGraphics
    set eax 0x9
          call sendGraphics



    inc edx // Adres komorki do przeniesienia
    inc ecx // YLINE

    // Warunek koncowy petli
    cmpa ecx 0x7
          jgt endloopchart

    jmp loopchart

    endloopchart:
    ret

loadcharsett:
        call regcopy

        ram 0x2110
            read edx // Adresowanie komórki tekstury

                ram 0x250c
                    read ebx
                ram 0x2119 // Zerowanie pierwotnej petli
                    save ebx


                looptypechart: // Wybieranie typu znaku

                    ram 0x2119
                        read ebx

                    set eax 0x6
                        call sendGraphics

                        set ecx 0x0
                        call loopchart

                    ram 0x2119 // Wcyztanie licznika znakow
                        read ebx

                    ram 0x2553
                        read ecx
                    ram 0x250c
                        read eax
                        add ecx eax

                    ram 0x2119
                    // Sprawdzenie przekroczenia
                        cmp ebx ecx
                        jgt endlooptypechart // Koniec

                        inc ebx // Postep
                            save ebx
                    jmp looptypechart

                endlooptypechart:

            ram 0x250c
                inc ebx
                save ebx

            ram 0x2119
                set eax 0x0
                save eax

            ram 0x2554
                save edx
            call regback
        ret