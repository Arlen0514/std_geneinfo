package com.genesis.schedule;

import java.io.IOException;
import javax.net.ssl.*;
import java.net.ProtocolException;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.util.TimerTask;

class Execution extends TimerTask {
	private URL url;
	private HttpsURLConnection connection;
	private String url_str;
	
	protected Execution(String path)  {		
		url_str=path;
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		clock5(url_str);
	}
	private void clock5(String s) {
		try {
			url=new URL(url_str);
			connection=(HttpsURLConnection) url.openConnection();
			
			/*宣告使用1.2*/
			TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
				public java.security.cert.X509Certificate[] getAcceptedIssuers() {
					return null;
				}

				public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
				}

				public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
				}
			} };
			HostnameVerifier hv = new HostnameVerifier() {
				public boolean verify(String urlHostName, SSLSession session) {
					return true;
				}
			};
			HttpsURLConnection.setDefaultHostnameVerifier(hv);
			
			SSLContext sc = SSLContext.getInstance("TLSv1.2");
			// Init the SSLContext with a TrustManager[] and SecureRandom()
			sc.init(null, trustAllCerts, new java.security.SecureRandom());
			
			connection.setSSLSocketFactory(sc.getSocketFactory());
			connection.setRequestMethod("POST");
			connection.setDoOutput(true);
			connection.connect();
			System.out.println("connection.getResponseMessage()="+connection.getResponseMessage());
			connection.disconnect();
			System.out.println("connection.getResponseMessage()="+connection.getResponseMessage());
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (KeyManagementException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
