
    timer:
        call regcopyinter

        ram 0x211c // Informacja o ticku
            savea 0xffff

        ram 0x211d // Postep czasomierza
            read eax
            cmpa eax 0x7530
                jeq ignoretimer

            inc eax
            save eax
            ignoretimer:



        call regbackinter
        ret

    resettimer:
        call regcopy

        ram 0x211d // Zerowanie delaya
            savea 0x0

        call regback
        ret