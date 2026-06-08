<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ include file="/WEB-INF/jspf/mis/check.jspf" %>
<%@ include file="include/function.jsp" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="org.apache.pdfbox.pdmodel.*" %>
<%@ page import="org.apache.pdfbox.rendering.*" %>
<%!
	/**
	 * pdf文件 轉圖片 
	 * @param pdfPath 要轉換的pdf文件的絕對路徑
	 * @param fileName 要轉換的pdf文件的文件名，帶後綴
	 * @param imgExt 要轉換的圖片類型(副檔名) 
	 * @param dpi 要轉換的dpi值
	 * @return 返回轉換成功後的文件名，帶後綴；注意此時轉換出的圖片與pdf原文件在同級目錄
	 */
	public static String pdfToImage(String pdfPath, String fileName, String imgExt, int dpi) {
		String img_names = "";
		
		try {
			// 圖像合併使用參數
			int width = 0; // 總寬度
			int[] singleImgRGB; // 保存一張圖片中的RGB數據
			int shiftHeight = 0;
			BufferedImage imageResult = null;// 保存每張圖片的像素值
			
			// 利用PdfBox生成圖像
			PDDocument pdDocument = PDDocument.load(new File(pdfPath));
			PDFRenderer renderer = new PDFRenderer(pdDocument);
			// 循環每個頁碼
			for (int i = 0, len = pdDocument.getNumberOfPages(); i < len; i++) {
				BufferedImage image = renderer.renderImageWithDPI(i, dpi, ImageType.RGB);
				
				/* 轉成一整張圖
				int imageHeight = image.getHeight();
				int imageWidth = image.getWidth();
				if (i == 0) {// 計算高度和偏移量
					width = imageWidth;// 使用第一張圖片寬度;
					imageResult = new BufferedImage(width, imageHeight * len, BufferedImage.TYPE_INT_RGB); // 保存每頁圖片的像素值
				} else {
					shiftHeight += imageHeight; // 計算偏移高度
				}
				singleImgRGB = image.getRGB(0, 0, width, imageHeight, null, 0, width);
				imageResult.setRGB(0, shiftHeight, width, imageHeight, singleImgRGB, 0, width); // 寫入流中
				*/
				
				/* 使用"轉一整張圖"的方式要把下面三行拿到迴圈外，且第一行的 += 要改成 = */
				img_names += fileName.replace(".pdf", "_"+(i+1)+"."+imgExt)+",";
				File outFile = new File(pdfPath.replace(".pdf", "_"+(i+1)+"."+imgExt));
				ImageIO.write(image, imgExt, outFile);// 寫圖片
			}
			pdDocument.close();
		} catch(Exception e){
			e.printStackTrace();
		}
		
		return img_names;
	}
%>
<%
	// 基本參數
	String code = "ebook"; 					// 模組識別碼
	String show_title = "電子書模組";			// 模組標題

	// 設定圖檔上傳 MB 數
	Integer fSize = 1;

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
	String fd_id = StringTool.validString(request.getParameter("fd_id"));

	// 刪除
	if("D".equals(action)) {
		TableRecord fd = app_sm.select(tblfd, fd_id);
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fd.getString("fd_image"));
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fd.getString("fd_mobile"));
		app_sm.delete(fd);

		// 確認是否有其它資料顯示相同圖片(有其它檔案欄位再新增code)
		if(app_sm.success()) {
			if(app_sm.selectAll(tblfd, "fd_image=?", new Object[] { fd.getString("fd_image") }).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fd.getString("fd_image"));
			}
			if(app_sm.selectAll(tblfd, "fd_file=?", new Object[] { fd.getString("fd_file") }).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fd.getString("fd_file"));
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
		String chk_fd = "";
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){											//這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); 			//取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		//取得值
				if("selData".equals(fieldName)){chk_fd = fieldvalue.trim();}
			}
		}
		String list[] = chk_fd.split(",");
		for(int j=0;j<list.length;j++){
			if(!"".equals(list[j].trim())){
				TableRecord fd = app_sm.select(tblfd, "fd_id=?",new Object[] { list[j] });
				fd.setValue("fd_showseq", j);
				fd.setUpdate(app_account);
				app_sm.update(fd);
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
		String imageName = "";												// 圖檔名稱
		String imageExt = "jpg"; 											// 轉換結果的圖片副檔名
		TableRecord fd = new TableRecord(tblfd);
		fd.setInsert(app_account);

		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); 			// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		// 取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用

				if(fieldName.equals("fd_title")){
					Vector checks = app_sm.selectAll(tblfd,"fd_title =? and fd_code=? and fd_lang=?",new Object[]{fieldvalue, code, lang});
					if(checks.size()>0){
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}
				}
				fd.setValue(fieldName, fieldvalue.trim());//設定欄位值

			// 處理文件
			} else {
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
				//fileName_1 = fd.getString("fd_id")+"_"+fileName_1;
				
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
					
					if(fi.getFieldName().equals("fd_file")) {
						imageName = pdfToImage(dir + fileName_1, fileName_1, imageExt, 200); 			// pdf 轉 img
						fd.setValue("fd_url", imageName.subSequence(0, imageName.length() - 1)); 		// 紀錄所有轉成的圖片名稱
					}
					
					fd.setValue(fi.getFieldName(), fileName_1);//設定圖
				}
			}
		}
		fd.setValue("fd_code", code);	// 識別碼
		fd.setValue("fd_lang", lang);	// 語系		
		app_sm.insert(fd);

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
		String imageName = "";												// 圖檔名稱
		String imageExt = "jpg"; 											// 轉換結果的圖片副檔名
		TableRecord fd = app_sm.select(tblfd, "fd_id=?",new Object[] { fd_id });
		fd.setUpdate(app_account);

		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();

			// 這是用來確定是否為文件屬性
			if (fi.isFormField()) {
				String fieldName = new String(fi.getFieldName()); 			// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		// 取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
			
				if(fieldName.equals("fd_title")) {
					Vector checks = app_sm.selectAll(tblfd,"fd_title =? and fd_id <>? and fd_code=? and fd_lang=?",new Object[]{fieldvalue, fd_id, code, lang});
					if(checks.size() > 0) {
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					} else {
						fd.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}

			    } else if(!fieldName.startsWith("imgradio")) {
			    	if("_qtitle".equals(fieldName)) { //解決查詢標題為中文時傳值的問題
						values[1] = fieldvalue.trim();
					} else {
						fd.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}
			    }

			// 處理文件(file)
			} else {
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g < 0) {
	                fileName = fi.getName();//兼容非ie
	                fileName_1 = fi.getName();
	            } else {
	                fileName = fi.getName().substring(g);					//取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = fd.getString("fd_id")+"_"+fileName_1;

				if (fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()) {
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
					if(!"".equals(fd.getString(fi.getFieldName()))) {
						// 確認其它資料沒有使用相同檔案
						if(app_sm.selectAll(tblfd, fi.getFieldName()+"=?", new Object[] {fd.getString(fi.getFieldName()) }).size() == 1) {
							FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+fd.getString(fi.getFieldName()));
						}
					}

					fi.write(new File(dir, fileName_1));

					if(fi.getFieldName().equals("fd_file")) {
						imageName = pdfToImage(dir + fileName_1, fileName_1, imageExt, 200); 			// pdf 轉 img
						fd.setValue("fd_url", imageName.subSequence(0, imageName.length() - 1)); 		// 紀錄所有轉成的圖片名稱
					}

					fd.setValue(fi.getFieldName(), fileName_1);											// 設定圖
				}
			}
		}
		app_sm.update(fd);

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