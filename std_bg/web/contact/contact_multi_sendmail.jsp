<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ page import="javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="javax.activation.*"%>
<%@ page import="java.net.URL" %>
<%@ page import="javax.net.ssl.*" %>
<%!
public static String SSLreturnContent(String strURL) throws Exception{
	String content = "";
	String line = "";
	URL l_url = new URL(strURL);
	HttpsURLConnection l_connection = (HttpsURLConnection)l_url.openConnection();
	// for 智邦 20240123 Miles start
	/*宣告使用1.2*/
    TrustManager[] trustAllCerts = new TrustManager[] {
			new X509TrustManager() {
				public java.security.cert.X509Certificate[] getAcceptedIssuers() {
					return null;
				}
				public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
				}
				public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
				}
			}
	};
	HostnameVerifier hv = new HostnameVerifier(){
		public boolean verify(String urlHostName, SSLSession session){
			return true;
		}
	};
	HttpsURLConnection.setDefaultHostnameVerifier(hv);
	
	// 建立設定TLSv1.2 (Java 7)
	SSLContext sc = SSLContext.getInstance("TLSv1.2"); 
	sc.init(null, trustAllCerts, new java.security.SecureRandom());
	
	// for 智邦 20240123 Miles end 
	l_connection.setSSLSocketFactory(sc.getSocketFactory());
	
	l_connection.connect();
	StringBuffer buffer = new StringBuffer();
	InputStream l_urlStream = l_connection.getInputStream();
	BufferedReader l_reader = new BufferedReader(new InputStreamReader(l_urlStream, "UTF-8"));
	while ((line = l_reader.readLine()) != null) {
		buffer.append(line);
	}
	
	l_reader.close();
	l_urlStream.close();
	l_connection.disconnect();
	
	content = buffer.toString();
	
	return content;
}
%>
<%
	String page_code = "contact";											// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String cu_id = StringTool.validString(request.getParameter("cu_id"));	// 聯絡資料主鍵
	Vector<TableRecord> cus = app_sm.selectAll(tblcu, cu_id);				// 聯絡資料內容
	String sendStatus = "N";												// 信件寄送狀態(Y:成功寄送，N：尚未寄送，E：寄送失敗，F：寄送次數已用盡)
	int smtpIndex = 0;														// 使用第幾組SMTP設定寄送信件

	// Server name.
	String servername = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
	if (request.getServerPort() == 80) {
		servername = request.getScheme() + "://" + request.getServerName();
	}
	String localname = request.getScheme() + "://" + request.getLocalName() + ":" + request.getLocalPort();
	String url = servername + request.getContextPath();

	// SMTP寄送次數歸零
	Vector<TableRecord> sts = app_sm.selectAll(tblst, "st_code=?", new Object[]{ "multi_smtp" }, "st_showseq ASC, st_createdate DESC");
	for(TableRecord st : sts) {
		if(!(st.getString("st_modifydate").substring(0, 10)).equals(app_today)) {
			st.setValue("st_status", "Y");
			st.setValue("st_send_times", "0");
			st.setUpdate("System");
		    app_sm.update(st);
		}
	}

	if(cus.size() <= 0) {
		out.println("<script> location='" + page_code + ".jsp'; </script>");
	} else {
		for(TableRecord cu : cus) {
			TableRecord st = app_sm.select(tblst, "st_code=? and st_status=? and (st_times - st_send_times) > ?",
					new Object[]{ "multi_smtp", "Y", 0 }, "st_showseq ASC, st_createdate DESC");

			// SMTP寄送次數已用盡
			if("".equals(st.getString("st_id"))) {
				sendStatus = "F";
				break;

			// 信件寄送
			} else if(!"".equals(st.getString("st_id"))) {
				// 利用 JavaMail 元件寄送信件
				final String uid = st.getString("st_authaccount"); 									// 設定 Smtp 認證帳號
				final String upw = st.getString("st_authpassword"); 								// 設定 Smtp 密碼
				String mailhost = st.getString("st_hostname"); 										// 設定 Smtp Server 名稱
				String smtpport = st.getString("st_authport"); 										// 設定 Smtp Server 的 Port 值
				String smtpauth = st.getString("st_authstatus"); 									// 設定 Smtp Server 是否需要認證, 或是使用 GMail 465 Port
				String us_email = st.getString("st_serviceemail"); 									// 設定寄件人 e-Mail
				String us_name = st.getString("st_serviceemailname"); 								// 設定寄件人 名稱
				String ssluseauth = st.getString("st_ssluse"); 										// 是否使用 SSL 
				String servmailto = cu.getString("cu_email"); 										// 設定正本收件人 e-Mail, 多人請用逗點分開
				String servmailcc = "";														 		// 設定副本收件人 e-Mail, 多人請用逗點分開
				String servmailbcc = SiteSetup.getValue("original." + page_code + "." + lang);		// 設定密件副本收件人 e-Mail, 多人請用逗點分開
				String subject = SiteSetup.getText("cp.company." + lang) + " 聯絡我們通知信"; 			// 設定信件主旨內容
				sendStatus = "Y";

				// 設定信件內容
				StringBuffer sb = new StringBuffer();
				String content = "";

				if(url.indexOf("https://") > -1) {
					content = SSLreturnContent(url + "/web/mail/contact_mail.jsp?cu_id=" + cu_id + "&lang=" + lang);					// 信件內容產生的 JSP 檔
				} else {
					Vector urlcontent = HttpURL.returnContent(url + "/web/mail/contact_mail.jsp?cu_id=" + cu_id + "&lang=" + lang); 	// 信件內容產生的 JSP 檔
					for(int i = 0; i < urlcontent.size(); i++) {
						String line = (String) urlcontent.get(i);
						sb.append(line);
					}
					content = sb.toString();
				}

				request.setCharacterEncoding("UTF-8"); 	// 設定信件使用字集
				boolean sessionDebug = false; 			// 設定是否啟用除錯模式 true 為開啟 , false 為關閉
				String userName = uid; 					// your id
				String password = upw; 					// your password		

				try {
					java.util.Properties props = System.getProperties();
					props.put("mail.smtp.host", mailhost);
					props.put("mail.smtp.port", smtpport);

					// 使用 Gmail SMTP Server 465 port 寄信，注意需先至 https://www.google.com/settings/security/lesssecureapps 將帳號開啟允許低安全登錄
					 if ("G".equals(smtpauth)) {
						props.put("mail.smtp.auth", true);
						props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
						props.setProperty("mail.smtp.socketFactory.fallback", "false");
						props.setProperty("mail.smtp.socketFactory.port", smtpport);
						props.put("mail.smtp.ssl.enable", true);
						props.put("mail.smtp.starttls.enable", true);
						props.put("mail.smtp.auth.plain.disable", true);
						props.put("mail.smtp.ssl.trust", "*");
						props.put("mail.smtp.ssl.enable", true);

					// 使用Office 365 smtp 寄信
					} else if ("O".equals(smtpauth)) {
						props.put("mail.smtp.auth", true);
						props.put("mail.smtp.ssl.enable", false);
						props.put("mail.smtp.tls.enable", true);
						props.put("mail.smtp.starttls.enable", true);

					// 使用一般 SMTP Sever 寄信
					} else {
					 	 props.put("mail.smtp.auth", "N".equals(smtpauth) ? false : true);
						 props.setProperty("mail.smtp.socketFactory.class", "");
						 props.setProperty("mail.smtp.socketFactory.fallback", "false");
						 props.setProperty("mail.smtp.socketFactory.port", smtpport);
						 if("Y".equals(ssluseauth)){
							 // For SSL use 
							 props.put("mail.smtp.ssl.trust", "*");
							 props.put("mail.smtp.ssl.enable", true);
							 props.put("mail.smtp.starttls.enable", true);
							 props.put("mail.smtp.auth.plain.disable", true);
						 }else{
							 props.put("mail.smtp.ssl.enable", false);
							 props.put("mail.smtp.starttls.enable", false);
							 props.put("mail.smtp.auth.plain.disable", false);				 
						 }
					}

					Authenticator auth = new javax.mail.Authenticator() {
						String userName = uid;																// your id
						String password = upw;																// your password

						protected PasswordAuthentication getPasswordAuthentication() {
							return new PasswordAuthentication(userName, password);
						}
					};

					//javax.mail.Session mailSession = javax.mail.Session.getDefaultInstance(props,auth);	// 在linux下用下列getInstance
					javax.mail.Session mailSession = javax.mail.Session.getInstance(props, auth);
					mailSession.setDebug(sessionDebug);
					MimeMessage msg = new MimeMessage(mailSession); 										// 需使用 MimeMessage 型態 , 信件主題才不會有亂碼
					msg.setFrom(new InternetAddress(us_email, us_name)); 									// set mail from

					/*-- set to email --*/
					// 正本
					InternetAddress[] address = InternetAddress.parse(servmailto);
					msg.setRecipients(Message.RecipientType.TO, address);
					// 副本
					InternetAddress[] ccAddress = InternetAddress.parse(servmailcc);
					msg.setRecipients(Message.RecipientType.CC, ccAddress);
					msg.setSubject(subject,"UTF-8");
					// 密件副本
					InternetAddress[] bccAddress = InternetAddress.parse(servmailbcc);
					msg.setRecipients(Message.RecipientType.BCC, bccAddress);
					msg.setSubject(subject,"UTF-8");	
					
					// set send date
					msg.setSentDate(new Date());
					// set content
					msg.setContent(content, "text/html; charset=UTF-8");
					// Get Transport use userName and password
					Transport trans = mailSession.getTransport("smtp");
					trans.connect(mailhost, userName, password);
					trans.send(msg);
					trans.close();

					// 每寄一次st_send_time + 1
					st.setValue("st_send_times", st.getInt("st_send_times")+1);
					st.setUpdate("System");
					app_sm.update(st);
					
					// 可寄次數 - 寄過 <= 0
					if(st.getInt("st_times") - st.getInt("st_send_times") <= 0) {
						st.setValue("st_status", "N");
						st.setUpdate("System");
					    app_sm.update(st);
					}
				} catch (Exception ex) {
					sendStatus = "E";
					System.out.println("Project:" + projectName + ", Error info:" + ex + ", File:web/contact/contact_multi_sendmail.jsp, Time:" + DateTimeTool.dateTimeString());
					break;
				}
			}
		}

		// 信件寄送成功
		if("Y".equals(sendStatus)) {
			out.println("<script> alert('感謝您的來信！'); location='contact.jsp'; </script>");

		// 信件寄送失敗
		} else if("E".equals(sendStatus)) {
			out.println("<script> alert('已完成您訊息的登錄，但系統發生通知信件發送失敗！');location='contact.jsp'; </script>");

		// SMTP寄送次數已用盡
		} else if("F".equals(sendStatus)) {
			out.println("<script> alert('已完成您訊息的登錄，但系統發生通知信件發送失敗！');location='contact.jsp'; </script>");
		}
	}
	return;
%>