package Assembelr.FileUsing;

import Assembelr.Compilator.Types.Character;

import java.io.*;
import java.util.ArrayList;

public class SaveToVer {

    public static void SaveToBin(ArrayList<Character> lista,String fileName) throws IOException{

        OutputStream wri = new FileOutputStream(new File(fileName));

        int n=0;
        for(Character linijki : lista){
            byte cha = linijki.getChar();

            if(n>=8192) wri.write(cha);
             n++;
        }

        wri.close();

    }

    public static void SaveToVerilog(ArrayList<String> lista,String fileName) throws IOException{

        FileWriter wri = new FileWriter(new File(fileName));

        for(String linijki : lista){
            wri.write(linijki+"\n");
        }

        wri.close();

    }

}
