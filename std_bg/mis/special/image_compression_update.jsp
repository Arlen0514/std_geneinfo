<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="java.io.*" %>
<%@ page language="java" import="java.awt.*" %>
<%@ page language="java" import="java.awt.image.*" %>
<%--@ page import="com.sun.image.codec.jpeg.*" JDK 1.7 起將此方法移除 --%>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>
<%
	// 基本參數
	String code = "image_compression"; 			// 模組識別碼
	String upload_code = "image"; 				// 上傳資料夾識別碼
	String show_title = "圖檔壓縮維護"; 		// 模組標題

	// 設定圖檔上傳 MB 數
	Integer fSize = 10;

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle" };
	String[] values = new String[] { String.valueOf(pageno), qtitle};
%>
<%!
// 						檔案		  縮圖		  		原圖位置	  原圖位置
public void composePic(String file , String bgfilesrc, int imgWidth, int imgHight) {
	try {
		java.io.File bigfile = new java.io.File(file);//saveurl); //讀入剛才上傳的檔案
		String newurl= bgfilesrc;//request.getRealPath("/")+url+filename+"_min."+ext; //新的縮圖儲存地址
		Image src = javax.imageio.ImageIO.read(bigfile); //構造Image物件
		float tagsize=287;
		int old_w=src.getWidth(null); //得到源圖寬
		int old_h=src.getHeight(null);

		int new_w=0;
		int new_h=0; //得到源圖長
		int tempsize;
		//out.print("<br/>the old width is :"+old_w+" the old height is "+old_h+"<br/>");
		float tempdouble;
		if(old_w>old_h) {
			tempdouble=old_w/tagsize;
		} else {
			tempdouble=old_h/tagsize;
		}
		/*  等比壓縮
		new_w=Math.round(old_w/tempdouble);
		new_h=Math.round(old_h/tempdouble);//計算新圖長寬
		*/
		new_w = imgWidth;
		new_h = imgHight;
		//out.print("the new width is :"+new_w+" the new height is "+new_h+"<br/>");
		BufferedImage tag = new BufferedImage(new_w,new_h,BufferedImage.TYPE_INT_RGB);
		tag.getGraphics().drawImage(src,0,0,new_w,new_h,null); //繪製縮小後的圖
		FileOutputStream newimage=new FileOutputStream(newurl); //輸出到檔案流
		/*JDK 1.7 起將此方法移除 1.7 前可以使用此方法 
			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(newimage);
			encoder.encode(tag); //近JPEG編碼
		*/
		String formatName = bgfilesrc.substring(bgfilesrc.lastIndexOf(".") + 1);
		ImageIO.write(tag, /*"GIF"*/ formatName /* format desired */ , new File(bgfilesrc) /* target */ );
		
		newimage.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
}
%>
<%
try{
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

		//確認是否有其它資料顯示相同圖片(有其它檔案欄位再新增code)
		if(app_sm.success()) {
			if(app_sm.selectAll(tblcp, "cp_image=?", new Object[] { cp.getString("cp_image") }).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+upload_code+"/"+lang+"/"+cp.getString("cp_image"));
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
	String dir = application.getRealPath("/") + "uploads/"+upload_code+"/"+lang+"/";
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
		String chk_cp = "";
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){											// 這是用來確定是否為文件屬性 
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
		//---------------------檔案上傳-----------------------------------------------
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
				
				if(fieldName.equals("cp_title")){
					Vector checks = app_sm.selectAll(tblcp,"cp_title =? and cp_code=? and cp_lang=?",new Object[]{fieldvalue, code, lang});
					if(checks.size()>0){
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}
				}
				cp.setValue(fieldName, fieldvalue.trim());//設定欄位值
				
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
					cp.setValue(fi.getFieldName(), fileName_1);//設定圖
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
		int imageWidth = 800, imageHight = 600;    //圖片寬高預設
		String imageName = "";	//圖檔名稱
		
		TableRecord cp = app_sm.select(tblcp, "cp_id=?",new Object[] { cp_id });
		cp.setUpdate(app_account);
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
				
				if(fieldName.equals("cp_title")) {
					Vector checks = app_sm.selectAll(tblcp,"cp_title =? and cp_id <>? and cp_code=? and cp_lang=?",new Object[]{fieldvalue, cp_id, code, lang});
					if(checks.size()>0) {
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					} else {
						cp.setValue(fieldName, fieldvalue.trim());			//設定欄位值
					}
			    } else if(!fieldName.startsWith("imgradio")) {
			    	if("_qtitle".equals(fieldName)){ 						//解決查詢標題為中文時傳值的問題
						values[1] = fieldvalue.trim();
					} else if("_width".equals(fieldName)) {
						imageWidth = Integer.valueOf(fieldvalue.trim());    //壓縮寬度設定
					} else if("_hight".equals(fieldName)) {
						imageHight = Integer.valueOf(fieldvalue.trim());	//壓縮高度設定
					} else {
						cp.setValue(fieldName, fieldvalue.trim());			//設定欄位值	
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
					if(!"".equals(cp.getString(fi.getFieldName()))) {
						//確認其它資料沒有使用相同檔案(多檔上傳刪除)
						String imgTok[] = cp.getString("cp_image").split(",");
						
						if(!"".equals(cp.getString("cp_image"))) {
							for(int l = 0; l < imgTok.length; l++) {
								if(app_sm.selectAll(tblcp, fi.getFieldName()+" like ?", new Object[] { "%"+imgTok[l]+"%" }).size() == 1) {
									if(!"".equals(imgTok[l])) {
										FileTool.deleteFile(app_uploadpath+"/"+upload_code+"/"+lang+"/"+imgTok[l]);
									}
								}
							}
						}
					}
					
					fi.write(new File(dir, fileName_1 ));
					composePic(dir+fileName_1 ,dir+fileName_1, imageWidth, imageHight);	   //圖片處理
					
					imageName += fileName_1 +",";
					cp.setValue(fi.getFieldName(), imageName.subSequence(0, imageName.length() - 1));//設定圖
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