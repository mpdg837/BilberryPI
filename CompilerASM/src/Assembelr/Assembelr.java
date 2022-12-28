package Assembelr;

import Assembelr.Compilator.BinaryConverter;
import Assembelr.Compilator.Etykiety;
import Assembelr.Compilator.Project.MergedProject;
import Assembelr.Compilator.Project.ProjectLoader;
import Assembelr.Compilator.Project.ProjectMerge;
import Assembelr.Compilator.Tools.DataConverter;
import Assembelr.FileUsing.FileLoader;
import Assembelr.FileUsing.SaveToVer;

import java.io.*;
import java.util.*;

public class Assembelr {

    public Assembelr(String fileIn){
        try {
            MergedProject proj = ProjectMerge.mergeProject(fileIn);
            ArrayList<String> lista = proj.getList();

            DataConverter conver = new DataConverter();

            HashMap<Integer,String> data = conver.getData(lista);

            lista = conver.nlist;

            Etykiety etykiety = new Etykiety(lista);
            lista = etykiety.nlistaLini;

            for(String linia : etykiety.etykiety.keySet()){
                System.out.println("Etykieta o nazwie '" + linia +"' w linii: "+ etykiety.etykiety.get(linia));
            }


            BinaryConverter conv = new BinaryConverter(lista,etykiety,data);

            SaveToVer.SaveToVerilog(conv.linijki,"bios.hex",0,1024);
            SaveToVer.SaveToVerilog(conv.linijki,"charset.hex",1024,1280);
            SaveToVer.SaveToBin(conv.bineries,"program.bin",8192,16384);
        }catch (IOException err){
            System.out.println(err);
        }catch (Exception err){
            System.out.println(err.getMessage());
        }
    }

    public static void main(String[] args){
        if(args.length == 1) {
            new Assembelr(args[0]);
        }else{
            System.out.println("Zła ilość argumentów");
        }
    }
}
