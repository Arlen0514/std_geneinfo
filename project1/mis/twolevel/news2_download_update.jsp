<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%	
	// 基本參數
	String code 		= "news2_download"; 		// 模組識別碼
	String show_title 	= "文件下載維護";			// 模組標題

	// 設定圖檔上傳 MB 數
	Integer fSize = 1;
	
	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
	String qcategory = StringTool.validString(request.getParameter("_qcategory"),"%");
	
	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qcategory" };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qcategory };
%>	
<%
try {
	// A:新增,M:修改,D:刪除,S:排序
	String action = StringTool.validString(request.getParameter("action"));
	// 修改資料id
	String cp_id = StringTool.validString(request.getParameter("cp_id"));

	// 刪除
	if("D".equals(action)) {
		TableRecord cp = app_sm.select(tblcp, cp_id);
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+cp.getString("cp_image"));
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+cp.getString("cp_mobile"));
		app_sm.delete(cp);

		// 確認是否有其它資料顯示相同圖片(有其它檔案欄位再新增code)
		if (app_sm.success()) {
			if(app_sm.selectAll(tblcp, "cp_image=?", new Object[] { cp.getString("cp_image") }).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+cp.getString("cp_image"));
			}
			if(app_sm.selectAll(tblcp, "cp_file=?", new Object[] { cp.getString("cp_file") }).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+cp.getString("cp_fi;e"));
			}
			// 檔案下載
	        Vector<TableRecord> fd_files=app_sm.selectAll(tblfd,"fk_id=? and fd_code=?",new Object[]{cp.getString("cp_id"),"file"},"fd_showseq ASC , fd_createdate DESC");		   	
	    	for(int i=0;i<fd_files.size();i++){
	         	TableRecord fd = fd_files.get(i);
	         	app_sm.delete(fd);
	         	if(app_sm.selectAll(tblcp, "cp_file=?", new Object[] { fd.getString("fd_file") }).size() == 0 && app_sm.selectAll(tblfd,"fd_file=?",new Object[]{fd.getString("fd_file")}).size()==0 ) {
					FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fd.getString("fd_file"));
				}
	    	}
	    	
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
			out.println("<script> alert('刪除成功!!'); listpage.submit(); </script>");
		} else {
			out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}	
		return;
	}
	
	// 檔案路徑與設置
	String dir = application.getRealPath("/") + "uploads/"+code+"/"+lang+"/";
	File f_dir  = new File(dir);
	if(!f_dir.exists()){
		f_dir.mkdirs();
	}
	DiskFileUpload fu = new DiskFileUpload();
	fu.setHeaderEncoding("UTF-8");											// 亂碼關鍵(1)
	//fu.setSizeMax(4194304); 												// 設置文件大小
	//fu.setSizeThreshold(4096); 											// 設置緩衝大小
	//fu.setRepositoryPath(application.getRealPath("/") + "uploads/temp");  // 設置臨時目錄
	fu.setRepositoryPath(dir); 												// 設置臨時目錄     
	List fileItems = fu.parseRequest(request);
	Iterator i = fileItems.iterator();

	// 排序
	if("S".equals(action)) {
		String chk_cp = "";
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()) {											// 這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); 			// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		// 取得值
				if("selData".equals(fieldName)){chk_cp = fieldvalue.trim();}
			}
		}
		String list[] = chk_cp.split(",");
		for(int j=0;j<list.length;j++){
			if(!"".equals(list[j].trim())){
				TableRecord cp = app_sm.select(tblcp, "cp_id=?",new Object[] { list[j] });
				cp.setValue("cp_showseq", j);
				cp.setUpdate(app_account);
				app_sm.update(cp);
			}
		}

		if(app_sm.success()) {
			// 回排序頁
			out.write(HtmlCoder.getForm("sortpage", code + "_sort.jsp", names, values));
			out.println("<script> alert('排序完成!!');sortpage.submit(); </script>");
		} else {
			out.println("<script> alert('排序失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}

	// 新增
	if("A".equals(action)) {		
		TableRecord cp = new TableRecord(tblcp);
		cp.setInsert(app_account);
		int file_showseq=0; 												//  檔案下載順序編號
		String fd_filetype = ""; 											// 相關檔案下載類型
		String fileradio_id = ""; 											// 相關檔案下載資料代號
		//---------------------檔案上傳-----------------------------------------------
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
				
				/*if(fieldName.equals("cp_title")){
					Vector checks = app_sm.selectAll(tblcp,"cp_title =? and cp_code=? and cp_lang=?",new Object[]{fieldvalue, code, lang});
					if(checks.size()>0){
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}else{
						cp.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}
				}else */if(fi.getFieldName().startsWith("cp_newFileType")){ // 相關檔案下載類型
					fd_filetype = fieldvalue.trim();
				}else if(fi.getFieldName().startsWith("cp_NewFileid")){ // 相關檔案下載新增
					if(fieldvalue.trim().equals("add")){
						file_showseq++;
						TableRecord fd = new TableRecord(tblfd);
						fd.setInsert(app_account);
						fd.setValue("fk_id", cp.getString("cp_id"));
						fd.setValue("fd_code","file");
						fd.setValue("fd_file_type",  fd_filetype);
						fd.setValue("fd_showseq",file_showseq);
						app_sm.insert(fd);
						fileradio_id = fd.getString("fd_id");
					}
				}else if(fieldName.startsWith("cp_")){
					cp.setValue(fieldName, fieldvalue.trim());//設定欄位值
				}
				
				
			} else { //處理文件
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g<0){
	                fileName = fi.getName();//兼容非ie
	                fileName_1 = fi.getName();
	            }else{
	                fileName = fi.getName().substring(g);//取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = cp.getString("cp_id")+"_"+fileName_1;
				
				if (fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()){
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
			        if(inValidFileExtension(fileName)) {
			        	out.println("<script> alert('上傳副檔名不正當!!');  history.back(); </script>");
			        	return;
			        }
					if((fSize * 1024 * 1024) < fi.getSize()) {
						out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
						return;
					}
					fi.write(new File(dir, fileName_1 ));
					if(fi.getFieldName().startsWith("cp_newFile")){// 檔案下載
						TableRecord fd = app_sm.select(tblfd,fileradio_id);
						fd.setUpdate(app_account);
						fd.setValue("fd_file", fileName_1);
						app_sm.update(fd);
					}else{ // 其他檔案
						cp.setValue(fi.getFieldName(), fileName_1);//設定圖
					}
					
				}
			}
		}
		cp.setValue("cp_code", code);	// 識別碼
		cp.setValue("cp_lang", lang);	// 語系		
		app_sm.insert(cp);

		if(app_sm.success()) {
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
			out.println("<script> alert('新增成功!!');listpage.submit(); </script>");
		} else {
			out.println("<script> alert('新增失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;

	// 修改
	} else if("M".equals(action)) {
		TableRecord cp = app_sm.select(tblcp, "cp_id=?",new Object[] { cp_id });
		cp.setUpdate(app_account);
		int file_showseq=0; //  檔案下載順序編號
		String fd_filetype = ""; // 相關檔案下載類型
		String fileradio_id = ""; // 相關檔案下載資料代號
		while (i.hasNext()) {

			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
			
				/*if(fieldName.equals("cp_title")){
					Vector checks = app_sm.selectAll(tblcp,"cp_title =? and cp_id <>? and cp_code=? and cp_lang=?",new Object[]{fieldvalue, cp_id, code, lang});
					if(checks.size()>0){
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}else{
						cp.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}
				}else */if(fi.getFieldName().startsWith("cp_newFileType")){ // 相關檔案下載類型
					fd_filetype = fieldvalue.trim();
				}else if(fi.getFieldName().startsWith("cp_NewFileid")){ // 相關檔案下載新增
					if(fieldvalue.trim().equals("add")){
						file_showseq++;
						TableRecord fd = new TableRecord(tblfd);
						fd.setInsert(app_account);
						fd.setValue("fk_id", cp.getString("cp_id"));
						fd.setValue("fd_code","file");
						fd.setValue("fd_file_type",  fd_filetype);
						fd.setValue("fd_showseq",file_showseq);
						app_sm.insert(fd);
						fileradio_id = fd.getString("fd_id");
					}
				}else if(fi.getFieldName().startsWith("cp_FileType")){ // 檔案下載類型(修改)
					file_showseq++;
					TableRecord fd = app_sm.select(tblfd, fileradio_id);
					fd.setUpdate(app_account);
					fd.setValue("fk_id", cp.getString("cp_id"));
					fd.setValue("fd_file_type", fieldvalue.trim());
					fd.setValue("fd_showseq",file_showseq);
					app_sm.update(fd);
				}else if(fi.getFieldName().startsWith("cp_File")){// 檔案下載(修改)
					//file_showseq++;
					TableRecord fd = app_sm.select(tblfd, fileradio_id);
					fd.setUpdate(app_account);
					fd.setValue("fk_id", cp.getString("cp_id"));
					fd.setValue("fd_file", fieldvalue.trim());
					fd.setValue("fd_showseq",file_showseq);
					app_sm.update(fd);
			    }else if(fieldName.startsWith("fileradio")){// 下載檔案刪除
			    	if (fieldName.startsWith("fileradio_id")) { // 檔案下載代號
						fileradio_id = fieldvalue.trim();
					}else if(fieldName.startsWith("fileradio")) {
						if (fieldvalue.trim().equals("delete")) {
							TableRecord fd = app_sm.select(tblfd, fileradio_id);
							//確認沒有其它資料使用此檔
							if(app_sm.selectAll(tblfd,"fd_file=?",new Object[]{fd.getString("fd_file")}).size()==1 ){
								FileTool.deleteFile(app_uploadpath + "/" + code + "/" + lang + "/" + fd.getString("fd_file"));
							}
							fd.setValue("fd_file", "");
							// 若資料均清空則刪除 反之更新
							if(fd.getString("fd_file").isEmpty() && fd.getString("fd_file_type").isEmpty()){
								app_sm.delete(fd);
								file_showseq--;
							}else{	
								fd.setUpdate(app_account);
								app_sm.update(fd);
							}
							
						}
					}
			    }else if(!fieldName.startsWith("imgradio") && !fieldName.startsWith("fileradio")){
			    	if("_qtitle".equals(fieldName)){ //解決查詢標題為中文時傳值的問題
						values[1] = fieldvalue.trim();
					}else{
						cp.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}
			    }
			}else { //處理文件(file)
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g<0){
	                fileName = fi.getName();//兼容非ie
	                fileName_1 = fi.getName();
	            }
	            else{
	                fileName = fi.getName().substring(g);					//取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = cp.getString("cp_id")+"_"+fileName_1;
				
				if (fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()){
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
			        if(inValidFileExtension(fileName)) {
			        	out.println("<script> alert('上傳副檔名不正當!!');  history.back(); </script>");
			        	return;
			        }
					if((fSize * 1024 * 1024) < fi.getSize()) {
						out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
						return;
					}
					// Delete 原來的 image file.
					if(fi.getFieldName().startsWith("cp_File")){ // 檔案下載
						TableRecord fd = app_sm.select(tblfd, fileradio_id);
						if(!"".equals(fd.getString("fd_file"))){
							//確認其它資料沒有使用相同檔案
							if(app_sm.selectAll(tblfd,"fd_file=?",new Object[]{fd.getString("fd_file")}).size()==1  && app_sm.selectAll(tblcp,"cp_file=?", new Object[] {fd.getString("fd_file")}).size() == 0){
								FileTool.deleteFile(app_uploadpath + "/" + code + "/" + lang + "/" + fd.getString("fd_file"));
							}
						}
					}else if(fi.getFieldName().startsWith("cp_file")){
						if(!"".equals(cp.getString(fi.getFieldName()))){//代表圖
							//確認其它資料沒有使用相同檔案
							if(app_sm.selectAll(tblfd, fi.getFieldName()+"=?", new Object[] {cp.getString(fi.getFieldName()) }).size() == 1 && app_sm.selectAll(tblfd,"fd_file=?",new Object[]{cp.getString(fi.getFieldName())}).size()==0) {
								FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+cp.getString(fi.getFieldName()));
							}
						}
					}
					
					fi.write(new File(dir, fileName_1 ));
					if(fi.getFieldName().startsWith("cp_File")){//檔案下載(修改)
						//file_showseq++;
						TableRecord fd = app_sm.select(tblfd, fileradio_id);
						fd.setUpdate(app_account);
						fd.setValue("fk_id", cp.getString("cp_id"));
						fd.setValue("fd_file", fileName_1);
						fd.setValue("fd_showseq",file_showseq);
						app_sm.update(fd);
					}else if(fi.getFieldName().startsWith("cp_newFile")){//檔案下載-新增
						TableRecord fd = app_sm.select(tblfd,fileradio_id);
						fd.setUpdate(app_account);
						fd.setValue("fd_file", fileName_1);
						app_sm.update(fd);
					}else{//代表圖
						cp.setValue(fi.getFieldName(), fileName_1);//設定圖
					}
				}
			}
		}		
		app_sm.update(cp);

		if(app_sm.success()) {
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
		    out.println("<script> alert('修改成功!!'); listpage.submit(); </script>");
		} else {
			out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
} catch(Exception e) {
	System.out.println("Project:" + projectName + ", Error info:["+e+"]File name edit.jsp for ["+code+"]Time:["+DateTimeTool.dateTimeString()+"]");
	out.println("<script> alert('處理失敗'); history.back(); </script>");
} finally {
	app_sm.close();
}
%>