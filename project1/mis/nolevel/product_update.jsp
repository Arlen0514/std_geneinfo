<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "product"; 					// 模組識別碼
	String show_title = "產品介紹維護";			// 模組標題

	// 設定圖檔上傳 MB 數
	Integer fSize = 1;

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle"};
	String[] values = new String[] { String.valueOf(pageno), qtitle};
%>
<%
try {
	// A:新增,M:修改,D:刪除,S:排序
	String action = StringTool.validString(request.getParameter("action"));
	// 修改資料id
	String pd_id = StringTool.validString(request.getParameter("pd_id"));
	
	// 刪除
	if("D".equals(action)) {
		TableRecord pd = app_sm.select(tblpd, pd_id);
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+pd.getString("pd_image"));
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+pd.getString("pd_mobile"));
		app_sm.delete(pd);

		// 確認是否有其它資料顯示相同圖片(有其它檔案欄位再新增code)
		if(app_sm.success()) {
    		if((app_sm.selectAll(tblpi, "pi_image=?", new Object[] { pd.getString("pd_image") }).size() == 0 ) && (app_sm.selectAll(tblpd, "pd_image=?", new Object[] { pd.getString("pd_image") }).size() == 0 )) {
				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+pd.getString("pd_image"));
			}
			// 檢查輪播產品圖
		    Vector<TableRecord> pi_imgs=app_sm.selectAll(tblpi,"pd_id=? and pi_code=?",new Object[]{pd.getString("pd_id"),"img"},"pi_showseq ASC , pi_createdate DESC");
		    for(int i=1;i<=pi_imgs.size();i++){
            	TableRecord pi=pi_imgs.get(i-1);
            	app_sm.delete(pi);
            	app_sm.close();
            	if (app_sm.success()) {
            		if((app_sm.selectAll(tblpi, "pi_image=?", new Object[] { pi.getString("pi_image") }).size() == 0 ) && (app_sm.selectAll(tblpd, "pd_image=?", new Object[] { pi.getString("pi_image") }).size() == 0 )) {
        				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+pi.getString("pi_image"));
        			}	
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
	File f_dir = new File(dir);
	if(!f_dir.exists()){
		f_dir.mkdirs();
	}
	DiskFileUpload fu = new DiskFileUpload();
	fu.setHeaderEncoding("UTF-8");											// 亂碼關鍵(1)
	//fu.setSizeMax(4194304);												// 設置文件大小
	//fu.setSizeThreshold(4096); 											// 設置緩衝大小
	//fu.setRepositoryPath(application.getRealPath("/") + "uploads/temp");  // 設置臨時目錄
	fu.setRepositoryPath(dir); 												// 設置臨時目錄     
	List fileItems = fu.parseRequest(request);
	Iterator i = fileItems.iterator();

	// 排序
	if("S".equals(action)) {
		String chk_pd = "";
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){											// 這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); 			// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		// 取得值
				if("selData".equals(fieldName)){chk_pd = fieldvalue.trim();}
			}
		}
		String list[] = chk_pd.split(",");
		for(int j = 0; j < list.length; j++) {
			if(!"".equals(list[j].trim())) {
				TableRecord pd = app_sm.select(tblpd, "pd_id=?",new Object[] { list[j] });
				pd.setValue("pd_showseq", j);
				pd.setUpdate(app_account);
				app_sm.update(pd);
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
		TableRecord pd = new TableRecord(tblpd);
		pd.setInsert(app_account);
		int image_showseq=0; 				// 圖檔順序編號
		//---------------------檔案上傳-----------------------------------------------
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();

			// 這是用來確定是否為文件屬性
			if (fi.isFormField()) {
				String fieldName = new String(fi.getFieldName()); 										// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 									// 取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
				
				if(fieldName.equals("pd_title")) {
					Vector checks = app_sm.selectAll(tblpd,"pd_title =? and pd_code=? and pd_lang=?",new Object[]{fieldvalue, code, lang});
					if(checks.size() > 0) {
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					} else {
						pd.setValue(fieldName, fieldvalue.trim());										// 設定欄位值
					}
				
				} else if(fieldName.startsWith("pd_")&& !fieldName.startsWith("pd_s_")) {
					pd.setValue(fieldName, fieldvalue.trim());											// 設定欄位值	
				}

			// 處理文件
			} else {
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g < 0) {
	                fileName = fi.getName();															// 兼容非ie
	                fileName_1 = fi.getName();
	            } else {
	                fileName = fi.getName().substring(g);												// 取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = pd.getString("pd_id")+"_"+fileName_1;

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
					fi.write(new File(dir, fileName_1));
					if(fi.getFieldName().startsWith("pd_newImage")) {									// 其餘圖檔
						image_showseq++;
						TableRecord pi = new TableRecord(tblpi);
						pi.setInsert(app_account);
						pi.setValue("pd_id", pd.getString("pd_id"));
						pi.setValue("pi_code", "img");
						pi.setValue("pi_image", fileName_1);
						pi.setValue("pi_showseq",image_showseq);
						app_sm.insert(pi);
					} else {																			// 代表圖
						pd.setValue(fi.getFieldName(), fileName_1);										// 設定圖
					}
				}
			}
		}
		pd.setValue("pd_code", code);	// 識別碼
		pd.setValue("pd_lang", lang);	// 語系		
		app_sm.insert(pd);

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
		TableRecord pd = app_sm.select(tblpd, "pd_id=?",new Object[] { pd_id });
		pd.setUpdate(app_account);
		String imgradio_id = "";		// 其餘圖檔id
		String imgradio = "";			// 其餘圖檔 選項值(原圖、新圖、刪除)
		int image_showseq = 0; 			// 圖檔順序編號
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();

			// 這是用來確定是否為文件屬性
			if (fi.isFormField()) {
				String fieldName = new String(fi.getFieldName()); 										// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 									// 取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
				
				if(fieldName.equals("pd_title")) {
					Vector checks = app_sm.selectAll(tblpd, "pd_title =? and pd_id <>? and pd_code=? and pd_lang=?", new Object[]{ fieldvalue, pd_id, code, lang });
					if(checks.size() > 0) {
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					} else {
						pd.setValue(fieldName, fieldvalue.trim());										// 設定欄位值
					}
			    } else if(fi.getFieldName().startsWith("pd_Image")) {									// 其餘圖檔(修改)
					image_showseq++;
					TableRecord pi = app_sm.select(tblpi, imgradio_id);
					pi.setUpdate(app_account);
					pi.setValue("pi_image", fieldvalue.trim());
					pi.setValue("pi_showseq",image_showseq);
					app_sm.update(pi);
				} else if(fieldName.startsWith("imgradio")) {											// 產品輪播圖檔刪除
						if (fieldName.startsWith("imgradio_id")) { 										// 圖檔代號
							imgradio_id = fieldvalue.trim();
						} else if(fieldName.startsWith("imgradio")) {
							if (fieldvalue.trim().equals("delete")) {
								TableRecord pi = app_sm.select(tblpi, imgradio_id);
								app_sm.delete(pi);
								imgradio = "";
								//image_showseq--;
								// 確認沒有其它產品使用此圖檔
								if(app_sm.selectAll(tblpi,"pi_image=?",new Object[]{pi.getString("pi_image")}).size()==0 && app_sm.selectAll(tblpd,"pd_image=?", new Object[] {pi.getString("pi_image")}).size() == 0 ){
									FileTool.deleteFile(app_uploadpath + "/" + code + "/" + lang + "/" + pi.getString("pi_image"));
								}
							}
						}					
			    } else if(!fieldName.startsWith("imgradio") && !fieldName.startsWith("pd_s_")) {
			    	if("_qtitle".equals(fieldName)) { 													// 解決查詢標題為中文時傳值的問題
						values[1] = fieldvalue.trim();
					} else {
						pd.setValue(fieldName, fieldvalue.trim());										// 設定欄位值
					}
			    }
				
			// 處理文件(file)
			} else {
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g<0){
	                fileName = fi.getName();															// 兼容非ie
	                fileName_1 = fi.getName();
	            } else {
	                fileName = fi.getName().substring(g);												// 取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = pd.getString("pd_id")+"_"+fileName_1;

				if(fileName != null && !"".equals(fileName)) {
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
					if(fi.getFieldName().startsWith("pd_Image")){										// 其餘圖檔
						TableRecord pi = app_sm.select(tblpi, imgradio_id);
						if(!"".equals(pi.getString("pi_image"))) {
							// 確認其它資料沒有使用相同檔案
							if(app_sm.selectAll(tblpi,"pi_image=?",new Object[]{pi.getString("pi_image")}).size()==1 && app_sm.selectAll(tblpd,"pd_image=?", new Object[] {pi.getString("pi_image")}).size() == 0) {
								FileTool.deleteFile(app_uploadpath + "/" + code + "/" + lang + "/" + pi.getString("pi_image"));
							}
						}
					} else if(fi.getFieldName().startsWith("pd_image")) {
						if(!"".equals(pd.getString(fi.getFieldName()))){								// 代表圖
							// 確認其它資料沒有使用相同檔案
							if(app_sm.selectAll(tblpd, fi.getFieldName()+"=?", new Object[] {pd.getString(fi.getFieldName()) }).size() == 1 && app_sm.selectAll(tblpi,"pi_image=?",new Object[]{pd.getString(fi.getFieldName())}).size()==0) {
								FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+pd.getString(fi.getFieldName()));
							}
						}
					}

					fi.write(new File(dir, fileName_1));
					if(fi.getFieldName().startsWith("pd_Image")) {										// 其餘圖檔(修改)
						image_showseq++;
						TableRecord pi = app_sm.select(tblpi, imgradio_id);
						pi.setUpdate(app_account);
						pi.setValue("pi_image", fileName_1);
						pi.setValue("pi_showseq",image_showseq);
						app_sm.update(pi);
						imgradio_id="";
					} else if(fi.getFieldName().startsWith("pd_newImage")) {							// 其餘圖檔-新增
						image_showseq++;
						TableRecord pi = new TableRecord(tblpi);
						pi.setInsert(app_account);
						pi.setValue("pd_id", pd.getString("pd_id"));
						pi.setValue("pi_code", "img");
						pi.setValue("pi_image", fileName_1);
						pi.setValue("pi_showseq",image_showseq);
						app_sm.insert(pi);
					} else {																			// 代表圖
						pd.setValue(fi.getFieldName(), fileName_1);										// 設定圖
					}
				}
			}
		}		
		app_sm.update(pd);

		// 輪播圖檔順序調整
		if(!pd.getString("pd_id").equals("")) {
			Vector<TableRecord> pis = app_sm.selectAll(tblpi, "pi_code=? and pd_id=?", new Object[]{ "img", pd.getString("pd_id") });
			int j = 0;
			for(TableRecord pi:pis) {
				pi.setValue("pi_showseq", j);
				app_sm.update(pi);
				j++;
			}
		}

		if(app_sm.success()) {
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
		    out.println("<script> alert('修改成功!!');listpage.submit(); </script>");
		} else {
			out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;

	// 複製
	} else if("AC".equals(action)) {
		TableRecord pd = new TableRecord(tblpd);
		pd.setInsert(app_account);
		int image_showseq = 0; 				// 圖檔順序編號

		//---------------------檔案上傳-----------------------------------------------
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			// 這是用來確定是否為文件屬性 
			if (fi.isFormField()) {
				String fieldName = new String(fi.getFieldName()); 								// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 							// 取得值
				//System.out.println("欄位名:" + fieldName + "---" + "欄位值:" + fieldvalue );
				if(fieldName.equals("pd_title")) {
					Vector checks = app_sm.selectAll(tblpd,"pd_title =? and pd_code=? and pd_lang=?",new Object[]{fieldvalue, code, lang});
					if(checks.size() > 0) {
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					} else {
						pd.setValue(fieldName, fieldvalue.trim());								// 設定欄位值
					}
				} else if(fieldName.startsWith("pd_")) {
					if(!fieldName.contains("pd_oldImage")) {
						pd.setValue(fieldName, fieldvalue.trim());								// 設定欄位值
					} else {
						/*-- 複製輪播圖檔資料 - Part1 Start --*/
						// 舊圖不須上傳 故存入檔名
						if(!"".equals(fieldvalue.trim())) {
							TableRecord pi = new TableRecord(tblpi);
							pi.setInsert(app_account);
							pi.setValue("pd_id", pd.getString("pd_id"));
							pi.setValue("pi_code", "img");
							pi.setValue("pi_image", fieldvalue.trim());
							pi.setValue("pi_showseq",image_showseq);
							app_sm.insert(pi);
							image_showseq++;
						}
						/*-- 複製輪播圖檔資料 - Part1 End --*/
					}
				}
				
			// 處理文件
			} else {
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g < 0) {
	                fileName = fi.getName();													// 兼容非ie
	                fileName_1 = fi.getName();
	            } else {
	                fileName = fi.getName().substring(g);										// 取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = pd.getString("pd_id")+"_"+fileName_1;
				
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
					fi.write(new File(dir, fileName_1));
					/*-- 複製輪播圖檔資料 - Part2 Start --*/
					// 新上傳的圖(原欄位為上傳or原欄位有圖但選擇上傳新圖) 對此類產品(利用複製功能新增)都算是新增圖檔
					if(fi.getFieldName().startsWith("pd_newImage") || fi.getFieldName().startsWith("pd_Image")) {	// 其餘圖檔
						image_showseq++;
						TableRecord pi = new TableRecord(tblpi);
						pi.setInsert(app_account);
						pi.setValue("pd_id", pd.getString("pd_id"));
						pi.setValue("pi_code", "img");
						pi.setValue("pi_image", fileName_1);
						pi.setValue("pi_showseq",image_showseq);
						app_sm.insert(pi);
					} else {																	// 代表圖
						pd.setValue(fi.getFieldName(), fileName_1);								// 設定圖
					}
					/*-- 複製輪播圖檔資料 - Part2 End --*/
				}
			}
		}
		pd.setValue("pd_code", code);	// 識別碼
		pd.setValue("pd_lang", lang);	// 語系
		app_sm.insert(pd);
		
		// 輪播圖檔順序調整
		if(!pd.getString("pd_id").equals("")) {
			Vector<TableRecord> pis = app_sm.selectAll(tblpi, "pi_code=? and pd_id=?", new Object[]{ "img", pd.getString("pd_id") });
			int j = 0;
			for(TableRecord pi:pis) {
				pi.setValue("pi_showseq", j);
				app_sm.update(pi);
				j++;
			}
		}

		if(app_sm.success()) {
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
			out.println("<script> alert('新增成功!!');listpage.submit(); </script>");
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