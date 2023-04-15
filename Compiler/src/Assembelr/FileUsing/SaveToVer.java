package Assembelr.FileUsing;

import Assembelr.Compilator.Types.Character;

import java.io.*;
import java.util.ArrayList;

public class SaveToVer {

    public static void SaveToBin(ArrayList<Character> lista,String fileName,int from, int to) throws IOException{

        OutputStream wri = new FileOutputStream(new File(fileName));

        int n=0;
        for(Character linijki : lista){
            byte cha = linijki.getChar();

            if(n>=from && n< to) wri.write(cha);
             n++;
        }

        wri.close();

    }

    public static void SaveToVerilog(ArrayList<String> lista,String fileName,int from, int to) throws IOException{

        FileWriter wri = new FileWriter(new File(fileName));
        int n=0;

        for(String linijki : lista){
            char[] znaki = linijki.toCharArray();

            StringBuilder buildHex = new StringBuilder();

            for(int k=0;k<linijki.length();k+=4){
                StringBuilder builder = new StringBuilder();
                for(int p=0;p<4;p++){
                    builder.append(znaki[k+p]);
                }
                int decimal = Integer.parseInt(builder.toString(),2);
                String hexStr = Integer.toString(decimal,16);

                buildHex.append(hexStr);
            }

            if(n>=from && n< to) wri.write(buildHex.toString()+"\n");

            n++;
        }

        wri.close();

    }

}
