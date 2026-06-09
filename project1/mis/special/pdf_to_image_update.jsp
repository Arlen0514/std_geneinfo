<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="org.apache.pdfbox.pdmodel.*"%>
<%@ page import="org.apache.pdfbox.rendering.*"%>
<%!
/**
 * pdf文件 轉圖片 
 * @param pdfPath 要轉換的pdf文件的絕對路徑
 * @param fileName 要轉換的pdf文件的文件名，帶後綴
 * @param imgExt 要轉換的圖片類型(副檔名) 
 * @param dpi 要轉換的dpi值
 * @return 返回轉換成功後的文件名，帶後綴；注意此時轉換出的圖片與pdf原文件在同級目錄
 */
public static String pdfToImage(String pdfPath, String fileName, String imgExt, int dpi){
	String img_names = "";
	
	try{
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
	String code = "pdf_to_image"; 			// 模組識別碼
	String upload_code = "image"; 		// 上傳資料夾識別碼
	String show_title = "PDF轉圖片維護"; 		// 模組標題

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
		String imageExt = ""; // 轉換結果的圖片副檔名
		
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
			
			    } else if(fieldName.startsWith("imgext")){
			    	imageExt = fieldvalue.trim();
				} else if(!fieldName.startsWith("imgradio")){
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
						//確認其它資料沒有使用相同檔案
						// 舊 pdf 檔案
						if(app_sm.selectAll(tblcp, fi.getFieldName()+"=?", new Object[] { cp.getString(fi.getFieldName()) }).size() == 1) {
							FileTool.deleteFile(app_uploadpath+"/"+upload_code+"/"+lang+"/"+cp.getString(fi.getFieldName()));
						}
						
						// 舊檔案轉出來的所有圖片
						String imgTok[] = cp.getString("cp_image").split(",");
						if(!"".equals(cp.getString("cp_image"))) {
							for(int l = 0; l < imgTok.length; l++) {
								if(app_sm.selectAll(tblcp, "cp_image=?", new Object[] { imgTok[l] }).size() == 1) {
									if(!"".equals(imgTok[l])) {
										FileTool.deleteFile(app_uploadpath+"/"+upload_code+"/"+lang+"/"+imgTok[l]);
									}
								}
							}
						}
					}
					
					fi.write(new File(dir, fileName_1 ));
					imageName = pdfToImage(dir+fileName_1, fileName_1, imageExt, 200); // pdf 轉 img
					
					cp.setValue("cp_image", imageName.subSequence(0, imageName.length() - 1)); // 紀錄所有轉成的圖片名稱
					cp.setValue(fi.getFieldName(), fileName_1);
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