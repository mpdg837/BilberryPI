package Assembelr.Compilator.Project;

import Assembelr.FileUsing.FileLoader;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class ProjectMerge {
    public static MergedProject mergeProject(String file) throws IOException {
        ProjectLoader loader = new ProjectLoader(file);
        Project project = loader.getProject();

        FileLoader load = new FileLoader();
        ArrayList<String> lista;

        for(int n=0;n<project.getLength();n++) {
            File pro = project.next();
            load.ladujPlik(pro);
        }


        System.out.println(project.getLength());
        lista = load.getLista();

        return new MergedProject(lista);
    }
}
