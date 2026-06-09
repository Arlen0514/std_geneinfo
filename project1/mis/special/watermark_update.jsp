<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%@ page import="java.awt.*" %>
<%@ page import="java.awt.event.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.awt.image.*" %>
<%@ page import="org.w3c.dom.*" %>
<%--@ page import="com.sun.image.codec.jpeg.*" JDK 1.7 起將此方法移除 --%>
<%@ page import="javax.imageio.*" %>
<%!
// 原圖壓浮水印、浮水印檔位置、原圖位置
public void composePic(String logosrc, String bgfilesrc, int x, int y) {
	try {
		java.io.File bgfile = new java.io.File(bgfilesrc);							// 讀檔
		java.awt.Image bg_src = javax.imageio.ImageIO.read(bgfile);					// 讀檔
		java.io.File logofile = new java.io.File(logosrc);							// 讀檔
		java.awt.Image logo_src = javax.imageio.ImageIO.read(logofile);
		int bg_width = bg_src.getWidth(null);
		int bg_height = bg_src.getHeight(null);
		int logo_width = logo_src.getWidth(null);
		int logo_height = logo_src.getHeight(null);
		java.awt.image.BufferedImage tag = new java.awt.image.BufferedImage(bg_width, bg_height,
				java.awt.image.BufferedImage.TYPE_INT_RGB);
		java.awt.Graphics2D g2d = tag.createGraphics();								// 宣告java 作畫
		g2d.setColor(Color.WHITE); 													// 20250624riley設背景為白色
		g2d.fillRect(0, 0, bg_width, bg_height);									// 20250624riley填入有色背景(刪掉後默認是黑底)
		g2d.drawImage(bg_src, 0, 0, bg_width, bg_height, null);						// 把原圖放入
		g2d.setComposite(java.awt.AlphaComposite.getInstance(java.awt.AlphaComposite.SRC_ATOP, 1.0f)); // 透明度設置開始,1.0是不透明,0是全透 
		g2d.drawImage(logo_src, x, y, logo_width, logo_height, null);				// 把logo 放入
		g2d.setComposite(java.awt.AlphaComposite.getInstance(java.awt.AlphaComposite.SRC_OVER)); // 透明度設置結束
		/*JDK 1.6寫法(1.7不可用)
		java.io.FileOutputStream out = new java.io.FileOutputStream(bgfilesrc);		// 輸出檔案
		com.sun.image.codec.jpeg.JPEGImageEncoder encoder = com.sun.image.codec.jpeg.JPEGCodec
				.createJPEGEncoder(out);
		encoder.encode(tag);
		out.close();
		*/
		FileOutputStream newimage = new FileOutputStream(bgfilesrc);	//輸出到檔案流
		String formatName = bgfilesrc.substring(bgfilesrc.lastIndexOf(".") + 1);
		ImageIO.write(tag, /*"GIF"*/ formatName /* format desired */ , new File(bgfilesrc) /* target */ );
		newimage.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
}
/* 浮水印後產生新檔案
public void composePic(String logosrc, String bgfilesrc, String outsrc, int x, int y) {
	try {
		java.io.File bgfile = new java.io.File(bgfilesrc);
		java.awt.Image bg_src = javax.imageio.ImageIO.read(bgfile);
		java.io.File logofile = new java.io.File(logosrc);
		java.awt.Image logo_src = javax.imageio.ImageIO.read(logofile);
		int bg_width = bg_src.getWidth(null);
		int bg_height = bg_src.getHeight(null);
		int logo_width = logo_src.getWidth(null);
		int logo_height = logo_src.getHeight(null);
		java.awt.image.BufferedImage tag = new java.awt.image.BufferedImage(bg_width, bg_height,
				java.awt.image.BufferedImage.TYPE_INT_RGB);
		java.awt.Graphics2D g2d = tag.createGraphics();

		g2d.drawImage(bg_src, 0, 0, bg_width, bg_height, null);
		g2d.setComposite(java.awt.AlphaComposite.getInstance(java.awt.AlphaComposite.SRC_ATOP, 1.0f)); // 透明度設置開始,1.0是不透明,0是全透 
		g2d.drawImage(logo_src, x, y, logo_width, logo_height, null);
		g2d.setComposite(java.awt.AlphaComposite.getInstance(java.awt.AlphaComposite.SRC_OVER)); // 透明度設置結束

		java.io.FileOutputStream out = new java.io.FileOutputStream(outsrc);
		com.sun.image.codec.jpeg.JPEGImageEncoder encoder = com.sun.image.codec.jpeg.JPEGCodec
				.createJPEGEncoder(out);
		encoder.encode(tag);
		out.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
}
*/
%>
<%
	// 基本參數
	String code = "watermark"; 			// 模組識別碼
	String upload_code = "image"; 		// 上傳資料夾識別碼
	String show_title = "浮水印"; 		// 模組標題

	// 設定圖檔上傳 MB 數
	Integer fSize = 10;

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle" };
	String[] values = new String[] { String.valueOf(pageno), qtitle};
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
	String dir2= application.getRealPath("/") + "mis/images/";
	File f_dir = new File(dir);
	if(!f_dir.exists()) {
		f_dir.mkdirs();
	}
	DiskFileUpload fu = new DiskFileUpload();
	fu.setHeaderEncoding("UTF-8");											// 亂碼關鍵(1)
	//fu.setSizeMax(4194304); 												// 設置文件大小
	//fu.setSizeThreshold(4096);											// 設置緩衝大小
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
		String imageName = "";	//圖檔名稱
		
		TableRecord cp = app_sm.select(tblcp, "cp_id=?",new Object[] { cp_id });
		cp.setUpdate(app_account);
		while (i.hasNext()) {

			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
			
				if(fieldName.equals("cp_title")){
					Vector checks = app_sm.selectAll(tblcp,"cp_title =? and cp_id <>? and cp_code=? and cp_lang=?",new Object[]{fieldvalue, cp_id, code, lang});
					if(checks.size()>0){
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}else{
						cp.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}
			
			    }else if(!fieldName.startsWith("imgradio")){
			    	if("_qtitle".equals(fieldName)){ //解決查詢標題為中文時傳值的問題
						values[1] = fieldvalue.trim();
					}else{
						cp.setValue(fieldName, fieldvalue.trim());//設定欄位值
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
					// composePic(dir2+"demo_geneinfoLogo.png",dir+fileName_1,dir+name.replace(".","_log."),10,10);		// 浮水印新檔
					composePic(dir2+"demo_geneinfoLogo.png", dir+fileName_1 , 10, 10);    // 原圖壓浮水印
					
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