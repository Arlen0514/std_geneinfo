<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="./include/img_fun.jsp"%>
<%
	String dir = application.getRealPath("/") + "uploads/barcode/"+lang+"/";
	BarcodeImageGenerator barcodeimg = new BarcodeImageGenerator(dir);
	QRCodeImageGenerator qrcig = new QRCodeImageGenerator(dir);
	
	String qrcode = "要做成 qrcode 的字串";
	String fi_qrcode = "file_name.jpg"; //  請用 jpg 如果要換其他的副檔名要確認上面的程式
	qrcig.create_qrcode_image(qrcode, fi_qrcode); 
%>