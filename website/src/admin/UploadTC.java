package admin;

import link.Link;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

public class UploadTC extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private Connection link = Link.getConnection();
    
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
	}

	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkSession(session)) return;
		String filePath = "", storage = "";
        try{
            File file;
            int maxFileSize 	   = 5 * 1024 * 1024;
            int maxMemSize 		   = 5 * 1024 * 1024;
            ServletContext context = request.getServletContext();
            String username        = session.getAttribute("username").toString().toLowerCase();
            filePath 			   = context.getInitParameter("temp") + username + "/";
            String io			   = context.getInitParameter("io");
            String qid			   = "";
            
            FileUtility.makeDir(filePath);
            
            // Verify the content type
            String contentType = request.getContentType();
            
            if ((contentType.contains("multipart/form-data"))){
                DiskFileItemFactory factory = new DiskFileItemFactory();
                // maximum size that will be stored in memory
                factory.setSizeThreshold(maxMemSize);

                // Location to save data that is larger than maxMemSize.
                factory.setRepository(new File(filePath));

                // Create a new file upload handler
                ServletFileUpload upload = new ServletFileUpload(factory);

                // maximum file size to be uploaded.
                upload.setSizeMax(maxFileSize);

                // Parse the request to get file items.
                List<FileItem> fileItems = upload.parseRequest(request);

                // Process the uploaded file items
                Iterator<FileItem> i = fileItems.iterator();

                while(i.hasNext()){
                    FileItem fi = i.next();
                    if(!fi.isFormField()){
                        // Get the uploaded file parameters
                        String fileName = fi.getName();

                        // Write the file
                        if(fileName.lastIndexOf("\\") >= 0) file = new File(filePath + fileName.substring(fileName.lastIndexOf("\\")));
                        else                                    file = new File(filePath + fileName.substring(fileName.lastIndexOf("\\") + 1));
                        fi.write(file) ;
                    }else {
                    	String name = fi.getFieldName();
                        if(name.equals("qid"))  qid = fi.getString();
                    }
                }
            }

            QData qd   = ValidateField.getQData(qid);
            TQData tqd = ValidateField.getTQData(qid);
            if(qd.isValid() || tqd.isValid()){
                storage = io + "q" + qid + "/";
                FileUtility.makeDir(storage);
                UnzipUtility.unzip(filePath + "public.zip", storage);
                UnzipUtility.unzip(filePath + "private.zip", storage);

                int id         = qd.isValid() ? qd.getId() : tqd.getId();
                int tc_public  = qd.isValid() ? qd.getTc_public() : tqd.getTc_public();
                int tc_private = qd.isValid() ? qd.getTc_private() : tqd.getTc_private();
                resetUploadStatus(id);
                deleteTC(id);
                if(checkStorage(tc_public, tc_private, storage)) {
                    String public_in   = storage + "public/input/";
                    String public_out  = storage + "public/output/";
                    String private_in  = storage + "private/input/";
                    String private_out = storage + "private/output/";

                    toDB(id, "public", tc_public, public_in, public_out);
                    toDB(id, "private", tc_private, private_in, private_out);
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally {
        	FileUtility.delDir(filePath);
            FileUtility.delDir(storage);
        }
    }

    private void resetUploadStatus(int qid) throws SQLException {
        PreparedStatement stmt = link.prepareStatement("UPDATE questions SET uploaded=0 WHERE qid=?");
        stmt.setInt(1, qid);
        stmt.executeUpdate();
        stmt.close();
    }

    private void deleteTC(int qid) throws SQLException {
        PreparedStatement stmt = link.prepareStatement("DELETE FROM testcases WHERE qid=?");
        stmt.setInt(1, qid);
        stmt.executeUpdate();
        stmt.close();
    }

    private boolean checkStorage(long no_public, long no_private, String path) {
        long dirs 	= FileUtility.dirCount(path) - 1;
        long files	= FileUtility.fileCount(path);

        boolean flag = (files == no_public * 2 + no_private * 2) && (dirs == 6);

        flag = flag && FileUtility.dirExists(path + "public/input/")
                    && FileUtility.dirExists(path + "public/output/")
                    && FileUtility.dirExists(path + "private/input/")
                    && FileUtility.dirExists(path + "private/output/");

        for(int i = 1; i <= no_public; i++) {
            String in = path + "public/input/" + i + ".txt";
            String out = path + "public/output/" + i + ".txt";
            flag = flag && (
                               FileUtility.fileExists(in)
                            && FileUtility.fileExists(out)
                            && FileUtility.getFileSize(in) <= 1024
                            && FileUtility.getFileSize(out) <= 1024
            );
            if(!flag)	break;
        }

        for(int i = 1; i <= no_private; i++) {
            String in = path + "private/input/" + i + ".txt";
            String out = path + "private/output/" + i + ".txt";
            flag = flag && (
                               FileUtility.fileExists(in)
                            && FileUtility.fileExists(out)
                            && FileUtility.getFileSize(in) <= 1024 * 1024
                            && FileUtility.getFileSize(out) <= 1024 * 1024
            );
            if(!flag)	break;
        }

        return flag;
    }

    private void toDB(int qid, String type, int count, String in, String out) throws SQLException {
        for(int i = 1; i <= count; i++){
            String stdin  = FileUtility.readFile(in + i + ".txt");
            String stdout = FileUtility.readFile(out + i + ".txt");

            String query = "INSERT INTO testcases (qid, tc_no, tc_type, tc_in, tc_out) VALUES(?,?,?,?,?)";
            PreparedStatement stmt = link.prepareStatement(query);
            stmt.setInt(1, qid);
            stmt.setInt(2, i);
            stmt.setString(3, type);
            stmt.setString(4, stdin);
            stmt.setString(5, stdout);
            stmt.executeUpdate();
            stmt.close();
        }
    }
}