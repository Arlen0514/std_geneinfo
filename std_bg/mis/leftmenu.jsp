<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// Current top function record.
	TableRecord ctmf = (TableRecord)session.getAttribute("current_top");
	Vector <TableRecord> _clmfs = null;
	
	// Current left function records(level 2).
	_clmfs = app_sm.selectAll("mis_function", "mf_status='N' and mf_upfunction=?", new Object[] { ctmf.getValue("mf_id") }, "mf_priority");
	
	String drf_upfunction = StringTool.validString((String)session.getAttribute("upfunction"),"");
	String upfunction = StringTool.validString(request.getParameter("upfunction"),drf_upfunction);
	session.setAttribute("upfunction", upfunction);
	
	/*-- 抓當前頁面(左側選單用) --*/ 
	String new_url = request.getServletPath();
	String left_mffolder = new_url.substring(new_url.lastIndexOf("/mis/")+5, new_url.lastIndexOf("/"));
	String current_page = new_url.substring(new_url.lastIndexOf("/")+1);
	
	// 要特別排除的頁面
	String[] modify_pages = {"password_c.jsp", "websetup_c.jsp", "smtp_c.jsp", "payment_c.jsp"};
	Vector<String> exclude_pages = new Vector<String>(Arrays.asList(modify_pages));
	
	// 設定左側當前模式(可自行新增)
	if(current_page.startsWith("admin_b") || "admin_c.jsp".equals(current_page) || "admin_a.jsp".equals(current_page)){
		current_page = current_page.replace("_1", "").replace("_2", "").replace("_c", "_b");
	} else if(!exclude_pages.contains(current_page)){
		String check_name = current_page.replace(".jsp","");
		// 針對師資之模組修改
		if("education".equals(check_name) || "experience".equals(check_name) ||"representative".equals(check_name) || "plan".equals(check_name) ||
				"lab_member".equals(check_name)|| "lab_activity".equals(check_name)){
			current_page = "faculty.jsp";
		}else if(check_name.contains("_area") || check_name.contains("_class") || check_name.contains("_category")) {
			current_page = current_page.replace("_sort.jsp", ".jsp").replace("_a.jsp", ".jsp").replace("_c.jsp", ".jsp").replace("2.jsp", ".jsp");
		} else {
			current_page = current_page.replace("_a.jsp", ".jsp").replace("_c.jsp", ".jsp").replace("_b2.jsp", ".jsp").replace("_b.jsp", ".jsp")
									   .replace("_pop.jsp", ".jsp").replace("_sort.jsp", ".jsp");
		}
	}
	
// 	System.out.println(new_url+" > "+"/mis/"+left_mffolder+"/"+current_page);
	new_url = "/mis/"+left_mffolder+"/"+current_page;
%>
        
                            <!--左側-->
                            <div class="left_mis">

                                <!-- 分類切換按鈕 -->
                                <div class="category_changeButton">
                                    <a href="javascript:void(0);">
                                        <%=app_ctmf.getString("mf_name") %>
                                    </a>
                                </div>
                                
                                <!--左側選單列表-->	
                                <div class="leftListArea">
<%
	//有第二層 
	for (TableRecord  _clmf: _clmfs) {
		boolean have_first = false;
	 	Vector <TableRecord> amf_lefts = app_sm.selectAll("admin_map_function", "au_id=? and mf_id=?", new Object[] { app_user.getValue("au_id"), _clmf.getString("mf_id") });
		if (amf_lefts.size() > 0 || app_user.getString("au_account").equals("root")) have_first = true;
		if (have_first){ 
			// 確認是否有下一層
			boolean have_second = false;
			Vector <TableRecord> second_lmfs = app_sm.selectAll("mis_function", "mf_status='N' and mf_upfunction=?", new Object[] { _clmf.getString("mf_id") }, "mf_priority");
			if (second_lmfs.size() > 0 ) have_second = true;
			
			boolean onpen_list = _clmf.getString("mf_id").equals(upfunction);
			
			// 確認網址是否為此，為此哲當前模式
			boolean this_fun = false;
			
		if(have_second){ 
		
%>
                                    <div class="leftList<%=onpen_list?" active":"" %>"><!-- 當前模式 class加上active -->
                                        
                                        <!--功能名稱-->
                                        <div class="leftList_title">
                                            
                                            <a href="javascript:void(0);">
                                                 <%=_clmf.getString("mf_name") %>
                                            </a>
                                            <!--方向標誌-->
                                            <div class="leftList_icon direction">
                                                <!--方向標誌_向下展開-->
                                                <i class="material-icons down">keyboard_arrow_down</i>
                                                <!--方向標誌_向上收合-->
                                                <i class="material-icons up">keyboard_arrow_up</i>
                                            </div>
                                        </div>
                                        
                                        <!--展開選單-->
                                        <div class="leftList_open<%=onpen_list?" active":"" %>"><!-- 當前模式 class加上active -->
			<%for(TableRecord second_lmf : second_lmfs){
				Vector check_second_lmfs = app_sm.selectAll("admin_map_function", "au_id=? and mf_id=?",
						new Object[] { app_user.getValue("au_id"), second_lmf.getString("mf_id") });
				
				String conf_url = ctmf.getString("mf_folder") +"/" + second_lmf.getString("mf_url");
				if (check_second_lmfs.size() > 0 || app_user.getString("au_account").equals("root")) {
					this_fun = new_url.indexOf(conf_url)>-1;
			%>    	                            
                                            <div class="leftList_open_list<%=this_fun?" active":"" %>"><!-- 當前模式 class加上active -->
                                                
                                                <div class="leftList_sec_area">
                                                    <div class="leftList_sec_title<%=this_fun?" active":"" %>"><!-- 當前模式 class加上active -->
                                                        <a href="../<%=ctmf.getString("mf_folder") %>/<%=second_lmf.getString("mf_url") %>?upfunction=<%=_clmf.getString("mf_id") %>" >
                                                            <%=second_lmf.getString("mf_name") %>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
				<%} %>
			<%} %>                            
                            

                                        </div>
                                    </div>
			<%
				}else if(!have_second && have_first){
					// 確認網址是否為此，為此哲當前模式
					String conf_url = ctmf.getString("mf_folder") +"/" + _clmf.getString("mf_url");
					this_fun = new_url.indexOf(conf_url)>-1;
			%> 
                                    <div class="leftList<%=this_fun?" active":"" %>">  <%--=onpen_list?" active":"" --%>                                       
                                        <!--功能名稱-->
                                        <div class="leftList_title<%=this_fun?" active":"" %>">                                            
                                            <a href="../<%=ctmf.getString("mf_folder") %>/<%=_clmf.getString("mf_url") %>?upfunction=0">
                            						<%=_clmf.getString("mf_name") %>
                                            </a>
                                        </div>
                                    </div>
			<%}%>
		<%} %>
	<%} %>	
                                    
                                </div>
                            </div>