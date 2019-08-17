package admin;

import java.io.*;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.Scanner;

public class FileUtility{

    public static long getFileSize(String f){
        File file = new File(f);
        return file.length();
    }

	public static long fileCount(String path) {
		Path dir = Paths.get(path); 
		try {
			return Files.walk(dir)
						.parallel()
						.filter(p -> !p.toFile().isDirectory())
						.count();
		}catch(IOException e){
			e.printStackTrace();
		}
		return 0;
	}

	public static long dirCount(String path) {
		Path dir = Paths.get(path); 
		try {
			return Files.walk(dir)
						.parallel()
						.filter(p -> p.toFile().isDirectory())
						.count();
		}catch(IOException e){
			e.printStackTrace();
		}
		return 0;
	}

	public static boolean fileExists(String path){
		File f = new File(path);
		return f.exists() && !f.isDirectory();
	}

	public static boolean dirExists(String path){
		File f = new File(path);
		return f.exists() && f.isDirectory();
	}
	
	public static void makeDir(String path) {
		File folder = new File(path);
        if(!folder.exists())	folder.mkdirs();
	}
	
	public static void delDir(String path) {
		Path directory = Paths.get(path);
		try{
			Files.walkFileTree(directory, new SimpleFileVisitor<>() {
			   @Override
			   public FileVisitResult visitFile(Path file, BasicFileAttributes attributes) throws IOException {
			       Files.delete(file); // this will work because it's always a File
			       return FileVisitResult.CONTINUE;
			   }
	
			   @Override
			   public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
			       Files.delete(dir); //this will work because Files in the directory are already deleted
			       return FileVisitResult.CONTINUE;
			   }
			});
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	public static String readFile(String path){
		try {
			byte bytes[] = Files.readAllBytes(Paths.get(path));
			return new String(bytes);
		}catch(Exception e) {
			try {
				Scanner obj = new Scanner(new File(path));
				String text = obj.useDelimiter("\\A").next();
				obj.close();
				return text;
			}catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return null;
	}
	
	public static void writeFile(String path, String content){
	    try {
	    	File file = new File(path);
	    	file.setExecutable(true); 
            file.setReadable(true); 
            file.setWritable(true);
          
	    	FileWriter fw	= new FileWriter(file);
		    PrintWriter pw	= new PrintWriter(fw);
		    pw.print(content);
		    
            fw.close();
            pw.close();
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	}
}