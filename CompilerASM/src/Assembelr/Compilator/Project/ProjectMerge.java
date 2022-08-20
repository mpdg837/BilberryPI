package Assembelr.Compilator.Project;

import Assembelr.FileUsing.FileLoader;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class ProjectMerge {
    public static MergedProject mergeProject(String file) throws IOException, Exception {
        ProjectLoader loader = new ProjectLoader(file);
        Project project = loader.getProject();

        FileLoader load = new FileLoader();
        ArrayList<String> lista;
        ArrayList<String> names = new ArrayList<>();

        for(int n=0;n<project.getLength();n++) {
            File pro = project.next();
            names.add(pro.getName());
            load.ladujPlik(pro);

        }

        for(String pro : names){
            System.out.println("P: "+pro);
        }

        System.out.println(project.getLength());
        lista = load.getLista();

        return new MergedProject(lista);
    }
}
