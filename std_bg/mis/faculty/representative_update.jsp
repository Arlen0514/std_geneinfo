<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 上層基本參數
	String fp_id  = StringTool.validString(request.getParameter("fp_id"));		// 所屬上層資料代號
	String back_code = "faculty"; 												// 上層模組識別碼

	// 基本參數
	String code = "representative"; 											// 模組識別碼
	TableRecord fp = app_sm.select(tblfp,fp_id);  								// 所屬類別資料
	String show_title = fp.getString("fp_title")+"-代表著作";					// 模組標題

	// 相關模組識別碼
	String[] related_codes = new String[]{"education","experience","representative","plan","lab_member" ,"lab_activity"};
	String[] related_titles = new String[]{"學歷","經歷","代表著作","五年內執行計畫","實驗室成員" ,"實驗室活動"};

	// 設定圖檔上傳 MB 數
	Integer fSize = 1;

	// 跳頁參數
	String[] names = new String[] { "npage", "fp_id"};
	String[] values = new String[] { String.valueOf(pageno), fp_id};

	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
%>
<%
try {
	// A:新增,M:修改,D:刪除,S:排序
	String action = StringTool.validString(request.getParameter("action"));
	// 當前類別 ID	
    String fr_id = StringTool.validString(request.getParameter("fr_id"));
	
	// 刪除
	if("D".equals(action)) {
		TableRecord fr = app_sm.select(tblfr, fr_id);
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fr.getString("fr_image"));
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fr.getString("fr_mobile"));
		app_sm.delete(fr);

		// 確認是否有其它資料顯示相同圖片(有其它檔案欄位再新增code)
		if (app_sm.success()) {
			if(app_sm.selectAll(tblfr, "fr_image=?", new Object[] { fr.getString("fr_image") }).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fr.getString("fr_image"));
			}
			if(app_sm.selectAll(tblfr, "fr_file=?", new Object[] { fr.getString("fr_file") }).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fr.getString("fr_file"));
			}
			out.println("<script> alert('刪除成功!!'); listpage.submit(); </script>");
		} else {
			out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}	
		return;
	}

	// 檔案路徑與設置
	String dir = application.getRealPath("/") + "uploads/"+code+"/"+lang+"/"+fp_id;;
	// 建立資料夾(圖片歸類)
	File f_dir = new File(dir);
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
		String chk_dm = "";
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){											//這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); 			//取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		//取得值
				if("selData".equals(fieldName)){chk_dm = fieldvalue.trim();}
			}
		}
		String list[] = chk_dm.split(",");
		for(int j=0;j<list.length;j++){
			if(!"".equals(list[j].trim())){
				TableRecord fr = app_sm.select(tblfr, "fr_id=?",new Object[] { list[j] });
				fr.setValue("fr_showseq", j);
				fr.setUpdate(app_account);
				app_sm.update(fr);
			}
		}

		if(app_sm.success()) {
			out.println("<script> alert('排序完成!!'); listpage.submit(); </script>");
		} else {
			out.println("<script> alert('排序失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}

	// 新增
	if("A".equals(action)) {		
		TableRecord fr = new TableRecord(tblfr);
		fr.setInsert(app_account);
		//---------------------檔案上傳-----------------------------------------------
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
				
				if(fieldName.equals("fr_title")){
					if("".equals(fieldvalue.trim())) {
						out.println("<script> alert('"+show_title+"名稱不可為空白!!'); history.back(); </script>");
						return;
					}
					Vector checks = app_sm.selectAll(tblfr,"fr_title =? and "+"fr_code=? and "+"fr_lang=?",new Object[]{fieldvalue, code, lang});
					if(checks.size()>0){
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}
				}
				fr.setValue(fieldName, fieldvalue.trim());//設定欄位值
				
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
				//fileName_1 = fr.getString("fr_id")+"_"+fileName_1;
				
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
					fr.setValue(fi.getFieldName(), fileName_1);//設定圖
				}
			}
		}
		fr.setValue("fr_code", code);	// 識別碼
		fr.setValue("fr_lang", lang);	// 語系		
		app_sm.insert(fr);

		if(app_sm.success()) {
			out.println("<script> alert('新增成功!!'); listpage.submit(); </script>");
		} else {
			out.println("<script> alert('新增失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
		
	// 修改
	} else if("M".equals(action)) {
		TableRecord fr = app_sm.select(tblfr, "fr_id=?",new Object[] { fr_id });
		fr.setUpdate(app_account);
		while (i.hasNext()) {

			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
				
				if(fieldName.equals("fr_title")){
					fr.setValue(fieldName, fieldvalue.trim());//設定欄位值
					/*
					Vector checks = app_sm.selectAll(tblfr,"fr_title =? and "+"fr_id !=? and "+"fr_code=? and "+"fr_lang=?",new Object[]{fieldvalue, fr_id, code, lang});					
					if(checks.size()>0){
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}else{
						fr.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}
					*/
			    }else if(!fieldName.startsWith("imgradio")){
			    	if("_qtitle".equals(fieldName)){ //解決查詢標題為中文時傳值的問題
						//values[1] = fieldvalue.trim();
					}else{
						fr.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}
			    }else if(fieldName.startsWith("imgradio")){
			    	if (fieldvalue.trim().equals("delete")) {
			    		//確認沒有其它資料使用此圖檔
						if(app_sm.selectAll(tblfr,"fr_file=?",new Object[]{fr.getString("fr_file")}).size()==1){
							FileTool.deleteFile(app_uploadpath + "/" + code + "/" + lang + "/" + fr.getString("fr_file"));
						}
			    		fr.setValue("fr_file", "");//設定欄位值
			    	}
			    }
			} else { //處理文件(file)
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
				//fileName_1 = fr.getString("fr_id")+"_"+fileName_1;
				
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
					if(!"".equals(fr.getString(fi.getFieldName()))) {
						//確認其它資料沒有使用相同檔案
						if(app_sm.selectAll(tblfr, fi.getFieldName()+"=?", new Object[] {fr.getString(fi.getFieldName()) }).size() == 1) {
							FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fr.getString(fi.getFieldName()));
						}
					}
					
					fi.write(new File(dir, fileName_1 ));
					fr.setValue(fi.getFieldName(), fileName_1);//設定圖
				}
			}
		}		
		app_sm.update(fr);

		if(app_sm.success()) {
		    out.println("<script> alert('修改成功!!');listpage.submit(); </script>");
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