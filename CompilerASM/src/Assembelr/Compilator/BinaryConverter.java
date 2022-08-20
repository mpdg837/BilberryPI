package Assembelr.Compilator;

import Assembelr.Compilator.Tools.Starter;
import Assembelr.Compilator.Tools.Szum;
import Assembelr.Compilator.Types.Character;

import java.util.ArrayList;
import java.util.HashMap;

public class BinaryConverter {


    public int index = 0;
    boolean loop = false;

    public ArrayList<String> linijki;
    public ArrayList<Character> bineries = new ArrayList<>();

    public String nullMe(){
        StringBuilder build = new StringBuilder();
        for(int k=0;k<32;k++){
            build.append("0");
        }

        return build.toString();
    }

    public boolean status = false;

    public void changestatus(){
        status = !status;

    }

    Character znak(String str){
        if(str.length()<=8) {
            int liczba = 0;
            char[] znaki = str.toCharArray();

            for (int n = 0; n < str.length(); n++) {
                int k = str.length() -1 - n;
                if (znaki[k] == '1') liczba = liczba + (1 << (n));
            }

            return new Character((byte) liczba);
        }else{
            return  new Character((byte)255);
        }
    }
    public void printLine(String str){

        int nindex = index;

        linijki.add("11'd"+index+": out <= 32'b"+str+";");
        char[] znaki = str.toCharArray();


        for(int n=2;n<4;n++){
            StringBuilder build = new StringBuilder();
            for(int k=0;k<8;k++){
                int index = n*8 + k;
                build.append(znaki[index]);
            }
            bineries.add(znak(build.toString()));
        }

        for(int n=0;n<2;n++){
            StringBuilder build = new StringBuilder();
            for(int k=0;k<8;k++){
                int index = n*8 + k;
                build.append(znaki[index]);
            }
            bineries.add(znak(build.toString()));
        }

        index ++;

    }


    public BinaryConverter(ArrayList<String> lista, Etykiety etykiety, HashMap<Integer,String> data) throws Exception{

        linijki = new ArrayList<>();

        linijki = Starter.start(linijki);

        Szum szum1 = new Szum(index,data);
        int n = 0;
        for(String linia : lista) {

            if(linia.length()>0) {

                Instruction nrozkaz = new Instruction(linia, etykiety.etykiety);
                Translator trns = new Translator();

                switch (nrozkaz.instrukcja){
                    case "random" ->{
                        printLine(szum1.makeNewLine(n));

                    }
                    case "sot" ->{ printLine(trns.makeLineRegArg("00000","edx",nrozkaz.num)); }
                    case "hlt" ->{ printLine(trns.makeLineArg("00000",true,false,"0")); }
                    case "addr" ->{ printLine(trns.makeLineArg("00000",false,true,"0"));  }
                    case "set" ->{ printLine(trns.makeLineRegArg("00001",nrozkaz.regs.get(0),nrozkaz.num));}
                    case "in" ->{ printLine(trns.makeLineRegArg("00010",nrozkaz.regs.get(0),nrozkaz.num));}
                    case "out" ->{ printLine(trns.makeLineRegArg("00011",nrozkaz.regs.get(0),nrozkaz.num));}

                    case "inc" ->{ printLine(trns.makeLineOneReg("00100",nrozkaz.regs.get(0),false));}
                    case "jmp" ->{    printLine(trns.makeLineArg("00101",false,false,nrozkaz.num));}
                    case "jmpr" ->{printLine(trns.makeLineTwoReg("00101",nrozkaz.regs.get(0),"eax",false));}
                    case "save" ->{ printLine(trns.makeLineOneReg("00110",nrozkaz.regs.get(0),false));}
                    case "savea" ->{ printLine(trns.makeLineRegArg("00110","eax",nrozkaz.num));}
                    case "ram" ->{ printLine(trns.makeLineArg("00111",false,false,nrozkaz.num));}
                    case "off" ->{ printLine(trns.makeTwoLineRegArg("00111", "eax", nrozkaz.regs.get(0), nrozkaz.num));}
                    case "exp" ->{ printLine(trns.makeLineOneReg("01000",nrozkaz.regs.get(0),false)); }
                    case "rexp" ->{ printLine(trns.makeLineOneReg("01000","ebx",true));}
                    case "uram" ->{ printLine(trns.makeLineOneReg("01001",nrozkaz.regs.get(0),false));}
                    case "uoff" ->{ printLine(trns.makeTwoLineRegArg("01001",nrozkaz.regs.get(1),nrozkaz.regs.get(0),"0"));}
                    case "not" -> { printLine(trns.makeLineRegArg("01010",nrozkaz.regs.get(0),"0"));}

                    case "add" -> { printLine(trns.makeLineTwoReg("01011",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false));}
                    case "sub" -> { printLine(trns.makeLineTwoReg("01100",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false));}
                    case "and" -> { printLine(trns.makeLineTwoReg("01101",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false));}
                    case "eor" -> { printLine(trns.makeLineTwoReg("01110",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false));}
                    case "xor" ->{ printLine(trns.makeLineTwoReg("10001",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false));}

                    case "adda" -> { printLine(trns.makeLineRegArg("01011",nrozkaz.regs.get(0),nrozkaz.num));}
                    case "suba" -> { printLine(trns.makeLineRegArg("01100",nrozkaz.regs.get(0),nrozkaz.num));}
                    case "anda" -> { printLine(trns.makeLineRegArg("01101",nrozkaz.regs.get(0),nrozkaz.num));}
                    case "eora" -> { printLine(trns.makeLineRegArg("01110",nrozkaz.regs.get(0),nrozkaz.num));}
                    case "xora" ->{ printLine(trns.makeLineRegArg("10001",nrozkaz.regs.get(0),nrozkaz.num));}

                    case "shl" ->{ printLine(trns.makeLineTwoReg("01111",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false));}
                    case "shr" ->{ printLine(trns.makeLineTwoReg("10000",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false));}

                    case "jeq" ->{ printLine(trns.makeLineArg("10010",false,false,nrozkaz.num)); }
                    case "jeeq"->{ printLine(trns.makeLineArg("10010",true,false,nrozkaz.num));}

                    case "res"->{ printLine(trns.makeLineOneReg("10011",nrozkaz.regs.get(0),false));}

                    case "jgt" ->{ printLine(trns.makeLineArg("10100",false,false,nrozkaz.num)); }
                    case "jegt" ->{ printLine(trns.makeLineArg("10100",true,false,nrozkaz.num)); }

                    case "jlt" ->{ printLine(trns.makeLineArg("10101",false,false,nrozkaz.num)); }
                    case "jelt" ->{ printLine(trns.makeLineArg("10101",true,false,nrozkaz.num));}

                    case "dec" ->{ printLine(trns.makeLineOneReg("10110",nrozkaz.regs.get(0),false));}
                    case "cmp" ->{ printLine(trns.makeLineTwoReg("10111",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false)); }
                    case "cmpa" ->{printLine(trns.makeLineRegDoubleArg("10111",nrozkaz.regs.get(0),nrozkaz.num));}
                    case "read" ->{ printLine(trns.makeLineOneReg("11000",nrozkaz.regs.get(0),false));}
                    case "mov" ->{ printLine(trns.makeLineTwoReg("11001",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false)); }
                    case "pop" ->{ printLine(trns.makeLineOneReg("11010",nrozkaz.regs.get(0),false));}
                    case "push" ->{ printLine(trns.makeLineOneReg("11011",nrozkaz.regs.get(0),false));}
                    case "mul" ->{ printLine(trns.makeLineTwoReg("11100",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false));}
                    case "div" ->{ printLine(trns.makeLineTwoReg("11101",nrozkaz.regs.get(0),nrozkaz.regs.get(1),false));}
                    case "emul" ->{ printLine(trns.makeLineTwoReg("11100",nrozkaz.regs.get(0),nrozkaz.regs.get(1),true));}
                    case "rem" ->{ printLine(trns.makeLineTwoReg("11101",nrozkaz.regs.get(0),nrozkaz.regs.get(1),true));}
                    case "call" ->{ printLine(trns.makeLineArg("11110",false,false,nrozkaz.num));}
                    case "callr" -> {printLine(trns.makeLineTwoReg("11110",nrozkaz.regs.get(0),"eax",false));}
                    case "ret" ->{ printLine(trns.makeLineArg("11111",false,false,"0")); }
                    case "retr" ->{ printLine(trns.makeLineRegArg("11111",nrozkaz.regs.get(0),"3")); }
                    case "int" ->{ printLine(trns.makeLineArg("11111",false,false,"1")); }
                    case "nint" ->{ printLine(trns.makeLineArg("11111",false,false,"2")); }
                    default ->{printLine(nullMe());}
                }
            }else{
                printLine(nullMe());
            }
            n++;

        }
        Szum szum = new Szum(index,data);

        szum.szumMe(this);
        linijki = Starter.end(linijki);
    }
}
