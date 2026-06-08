<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%!
public static String toChineseUpper(int num) {
    String[] nums = {"零", "壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖"};
    String[] units = {"", "拾", "佰", "仟"};

    if (num == 0) return "零";

    StringBuilder sb = new StringBuilder();
    int unitPos = 0;

    while (num > 0) {
        int digit = num % 10;
        if (digit != 0) {
            sb.insert(0, nums[digit] + units[unitPos]);
        } else {
            // 避免連續零
            if (sb.length() > 0 && sb.charAt(0) != '零') {
                sb.insert(0, "零");
            }
        }
        num /= 10;
        unitPos++;
    }

    // 去掉最後可能的零
    String result = sb.toString();
    if (result.endsWith("零")) {
        result = result.substring(0, result.length() - 1);
    }
    return result;
}

%>
<%
String page_code = "admission_info";
String code = "admission_info";

String data_id = StringTool.validString(request.getParameter("data_id"),"");

TableRecord as = new TableRecord(tblas);


if(!"".equals(data_id.trim())) as = app_sm.select(tblas,data_id);
boolean has_as = !"".equals(as.getString("as_id"));

if(!"".equals(data_id.trim()) && !has_as){
	out.print("<script>alert('無此准考證!');window.close();</script>");
}
TableRecord aa = app_sm.select(tblaa,as.getString("aa_id"));
int aa_total = aa.getInt("aa_total");
String aa_total_chns = toChineseUpper(aa_total);
String paydate = aa.getString("aa_checkdate");
String pay_year = "";
String pay_month = "";
String pay_day = "";

if(!"".equals(paydate)){
// 	 paydate = aa.getString("aa_checkdate");
	 
	 String[] parts = paydate.split("/");
// 	 int adYear = Integer.parseInt(parts[0]); // 西元年
// 	 int rocYear = adYear - 1911;              // 民國年
	 
	 pay_year = paydate.split("/")[0]; 
	 pay_month = paydate.split("/")[1];
	 pay_day = paydate.split("/")[2];
	
}

// System.out.println("qno :"+qno);
// System.out.println("aa_id :"+aa.getString("aa_id"));
// System.out.println("has_aa :"+has_aa);
//准考證資訊
TableRecord cp = app_sm.select(tblcp, "cp_code=? and cp_lang=?", new Object[]{ code, lang });

//考試日期
String testdate = cp.getString("cp_emitdate"); // 例如 "2025/11/12"
SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd");
Date date = sdf.parse(testdate);

// 取出年月日
Calendar cal = java.util.Calendar.getInstance();
cal.setTime(date);

int year = cal.get(java.util.Calendar.YEAR) - 1911; // 轉民國年
int month = cal.get(java.util.Calendar.MONTH) + 1;
int day = cal.get(java.util.Calendar.DAY_OF_MONTH);

// 取得星期幾
String[] weekDays = {"日", "一", "二", "三", "四", "五", "六"};
String week = weekDays[cal.get(java.util.Calendar.DAY_OF_WEEK) - 1];

// 組出字串
String displayDate = year + "年" + month + "月" + day + "日 (" + week + ")";

%>
<html lang="en">

<head>
    <meta content="IE=edge" http-equiv="X-UA-Compatible" />
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <meta content="none" name="Robots" />

    <!-- 新增 版本更新jQuery modify by Judy 20230926 start -->
    <!-- jQuery版本3.7.1 -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" type="text/javascript"></script>
    <!-- <script src="../js/jquery/jquery-3.7.1.min.js" type="text/javascript"></script> --> <!-- 為了弱掃留原始檔案 -->
    <!-- jQuery 遷移插件_簡化從舊版本jQuery的轉換3.4.0-->
    <script src="https://code.jquery.com/jquery-migrate-3.4.0.min.js" type="text/javascript"></script>
    <!-- <script src="../js/jquery/jquery-migrate-3.4.0.min.js" type="text/javascript"></script> --> <!-- 為了弱掃留原始檔案 -->
    <!-- 新增 版本更新jQuery modify by Judy 20230926 end -->
<%-- 	<link rel="stylesheet" href="<%=request.getContextPath()%>/web/css/style_receipt.css"> --%>
	
    <link rel="stylesheet" href="<%=request.getContextPath() %>/web/css/style_nav/style_receipt/style_reg_form_receipt.css">

<%  
// System.out.println("**"+request.getContextPath()+"/web/css/style_receipt.css" );

// System.out.println("**"+request.getContextPath()+"/web/css/style_nav/style_receipt/style_reg_form_receipt.css" );

%>
</head>

<body>

    <!--按鍵區-->
    <div class="btn_area one">
        <input type="submit" value="列印" class="printBtn" onclick="exportPDF()"/>
    </div>

    <!--列印範圍-->
    <div class="overPrint" id="overPrint">
        <!--一頁A4大小-->
        <div class="printPage reg_form_Page">

            <div class="print_pageIn" style="width: 100%; margin: auto;padding-top: 63px;">

                <div class="reg_form_Page_top">
                    <table class="table1" border="0" cellspacing="0" cellpadding="2" style=" border-collapse: collapse; ">
                        <thead>
                            <tr>
                                <th  colspan="2">
                                    <%=cp.getString("cp_title") %>
                                </th>
                            </tr>                            
                        </thead>
                        <tbody>
                            <tr>
                                <td  colspan="2">
                                    <%=cp.getString("cp_desc") %>准考證
                                </td>
                            </tr>
                            <tr>
                                <td  colspan="2">
                                    <div class="photo">
                                        <span>                                       
                                         <img src="<%=app_fetchpath+"/apply/"+lang+"/"+aa.getString("aa_image")%>" alt="" style="width: 100%;height: auto;display: block;">
										</span>
										<div class="photo_stamp">
                                            <img src="<%=request.getContextPath() %>/web/receipt/images/stamp.webp">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td  colspan="2" style="text-align:left;">
                                    &emsp;&emsp;准考證號碼： <%=as.getString("aa_adno") %>
                                </td>
                            </tr>
                            <tr>
                                <td  colspan="2" style="text-align:left;">
                                    &emsp;&emsp;姓　　　名：<%=as.getString("aa_name") %>
                                </td>
                            </tr>

                        </tbody>
                        <tfoot>
                            <tr>
                                <td >
                                    <span>
                                        地址：350苗栗縣竹南鎮公義路245號
                                    </span>
                                    <span>
                                        電話：(637)622009
                                    </span>
                                </td>
                                <td>
                                    <div class="qr">
                                        <img src="<%=request.getContextPath() %>/web/receipt/images/qrcode.jpg" style="">
                                    </div>
                                </td>
                                
                            </tr>
                        </tfoot>
                    </table>

                    <table class="table2" border="0" cellspacing="0" cellpadding="2" style=" border-collapse: collapse; ">
                        <thead>
                            <tr>
                                <th colspan="2">
                                   <%=displayDate %>
                                </th>
                            </tr>                            
                        </thead>
                        <tbody>
                        <%for(int i =1;i<=5;i++){ %>
                            <tr>
                                <td align="center"><%=cp.getString("cp_course"+i)%></td>
                                <td align="center"><%=cp.getString("cp_time"+i)%></td>
                            </tr>
                        <%} %>
                            <tr>
                                <td colspan="2" style="position:relative;">
								    <%=cp.getString("cp_content")%>
								
<!-- 								    <p style="color:red; position:absolute; bottom:0; left:0; right:0;"> -->
<!-- 								         &nbsp; &nbsp;本考試採電腦閱卷，請自備2B鉛筆、橡皮擦 -->
<!-- 								    </p> -->
								</td>
                            </tr>

                        </tbody>
                        
                    </table>

                </div>
<%--收據部分 --%>
                <div class="reg_form_Page_bottom">

                    <table class="table3" border="0" cellspacing="0" cellpadding="0" style=" border-collapse: collapse; width: 100%;table-layout: fixed;line-height: 1;">
                        <tbody>
                                
                            <tr>                            
                                <td width="" style="vertical-align:middle; border: 0px;font-weight: 600;" >
                                    <br>苗栗縣私立君毅高級中學「<%=cp.getString("cp_desc") %>報名費」收據
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <table class="table4" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                                
                            <tr>                            
                                <td>
                                    准考證號碼：<%=as.getString("aa_adno") %>
                                </td>
                                <td align="right">
                                    學生留存聯
                                </td>
                            </tr>

                            <!-- <tr>                            
                                <td>
                                    茲收到 苗栗縣后庄國小
                                </td>
                                <td>
                                    姓名：陳思穎
                                </td>
                                <td>
                                    報名費用 伍佰元整
                                </td>
                            </tr> -->
                        </tbody>
                    </table>

                    <table class="table5" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                                
                            <!-- <tr>                            
                                <td>
                                    准考證號碼：4192
                                </td>
                                <td align="right">
                                    學生留存聯
                                </td>
                            </tr> -->

                            <tr>                            
                                <td width="35%">
                                    茲收到 <%=aa.getString("aa_attendschool") %>
                                </td>
                                <td width="23.5%">
                                    姓名：<%=as.getString("aa_name") %>
                                </td>
                                <td>
                                    報名費用 <%=aa_total_chns %>元整
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <table class="table6" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                                
                            <tr>                            
                                <td width="" colspan="2">
                                    主辦單位：苗栗縣私立君毅高級中學
                                </td>
                                <td>
                                    <div class="stamp">
                                        <img src="<%=request.getContextPath() %>/web/receipt/images/stamp.webp" >
                                    </div>
                                </td>
                            </tr>
                            
                            <tr>                            
                                <td colspan="3">
                                    <br>
                                    中&emsp;&emsp;華&emsp;&emsp;民&emsp;&emsp;國&emsp;&emsp;<%=pay_year %>&emsp;&emsp;年&emsp;&emsp;<%=pay_month %>&emsp;&emsp;月&emsp;&emsp;<%=pay_day %>&emsp;&emsp;日
                                </td>
                            </tr>
                            
                        </tbody>
                    </table>

                </div>
                
            </div>
        </div>
    </div>

<!--     <button onclick="exportPDF()">匯出 PDF</button> -->
<!-- 先載入 html2pdf -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>
<script>
window.onload = function() {
    autoExportPDF();
};

function autoExportPDF() {
    const element = document.getElementById('overPrint');

    const opt = {
        margin: 0,
        filename: 'report.pdf',
        image: { type: 'jpeg', quality: 1.0 },
        html2canvas: {
        	scale: 2,           // 固定
            useCORS: true,
            windowWidth: 794,   // A4 寬（px）
            windowHeight: element.scrollHeight
        	},
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' },
        pagebreak: { mode: ['css','legacy'] }
    };

    // 生成 PDF 並返回 Blob
    html2pdf().set(opt).from(element).outputPdf('blob').then(function(pdfBlob) {
        // 建立隱藏 a 標籤，自動下載
        const link = document.createElement('a');
        link.href = URL.createObjectURL(pdfBlob);
        link.download = 'report.pdf';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        // 可選：釋放 URL
        URL.revokeObjectURL(link.href);
    });
}

</script>

</body>

</html>