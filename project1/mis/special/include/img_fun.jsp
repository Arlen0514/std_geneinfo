<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.google.zxing.*" %>
<%@ page import="com.google.zxing.common.*" %>
<%@ page import="com.google.zxing.oned.Code39Writer" %>
<%@ page import="com.google.zxing.client.j2se.*" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.nio.file.Path" %>
<%!
	public class QRCodeImageGenerator {
		private String url = "";
		private String dir = "";
		private int size = 200;
		private int margin = 1;
		
		QRCodeImageGenerator(String dir){
			this.dir = dir;
			create_directory();
		}
		
		// 建立資料夾
		private void create_directory(){
			File f_dir = new File(dir);
			if(!f_dir.exists()) f_dir.mkdirs();
		}
		
		private boolean check_file_exists(String file_path){
			return new File(file_path).exists();
		}
		
		// 建立 QRCode 圖片
		private void create_qrcode(String barcode_text, String file_path){
			try {
	            // 設定qrcode的參數设置二维码的参数
	            Map<EncodeHintType, Object> hintMap = new HashMap<>();
	            hintMap.put(EncodeHintType.CHARACTER_SET, "UTF-8");
	            hintMap.put(EncodeHintType.MARGIN, margin);

	            // 建立一個舉證表示qrcode
	            BitMatrix matrix = new MultiFormatWriter().encode(barcode_text, BarcodeFormat.QR_CODE, size, size, hintMap);

	            // 將矩陣轉成圖片像
	            BufferedImage image = new BufferedImage(size, size, BufferedImage.TYPE_INT_RGB);
	            for (int y = 0; y < size; y++) {
	                for (int x = 0; x < size; x++) {
	                    int color = matrix.get(x, y) ? Color.BLACK.getRGB() : Color.WHITE.getRGB();
	                    image.setRGB(x, y, color);
	                }
	            }

	            // 保存图像到文件
	            File qrCodeFile = new File(file_path);
	            ImageIO.write(image, "png", qrCodeFile);
	        } catch (Exception e) {
	        	System.out.println("QRCode圖片建立失敗，失敗原因："+e.getMessage());
	        }
		}
		
		public void create_qrcode_image(String barcode_text, String file_name){
			String file_path = dir+"/"+file_name;
			boolean is_exists = check_file_exists(file_path);
			
			// 沒有圖片才會產
			if(!is_exists) create_qrcode(barcode_text, file_path);
		}
		
	}

	public class BarcodeImageGenerator {
		private String dir = "";
		
		BarcodeImageGenerator(String dir){
			this.dir = dir;
			create_directory();
		}
		
		// 建立資料夾
		private void create_directory(){
			File f_dir = new File(dir);
			if(!f_dir.exists()) f_dir.mkdirs();
		}
		
		private boolean check_file_exists(String file_path){
			return new File(file_path).exists();
		}
		
		// 補條碼圖片下方文字
		private void add_text(String barcode_text, String file_path) {
			try {
				BufferedImage barcodeImage = ImageIO.read(new File(file_path));
				
				int fontSize = 10; 			// 字體大小
				int quietZone = 10; 		// 邊距
	            int width = barcodeImage.getWidth();
	            int barcodeHeight = barcodeImage.getHeight();
				
				// 有文字的圖片
	            BufferedImage combinedImage = new BufferedImage(width, barcodeHeight + fontSize + quietZone, BufferedImage.TYPE_INT_RGB);
	            Graphics2D g = combinedImage.createGraphics();

	         	// 白色背景
	            g.setColor(Color.WHITE);
	            g.fillRect(0, 0, width, barcodeHeight + fontSize + quietZone);

	            // 繪製條碼圖片
	            g.drawImage(barcodeImage, 0, 0, null);

	            // 設定字體
	            g.setFont(new Font("Arial", Font.PLAIN, fontSize));
	    		g.setColor(Color.BLACK);

	            // 計算文字寬度且致中
	            FontMetrics fm = g.getFontMetrics();
	            int textWidth = fm.stringWidth(barcode_text);
	            int textX = (width - textWidth) / 2;
	            int textY = barcodeHeight + fontSize + quietZone - 5; // Adjust position slightly to fit in the image

	            g.drawString(barcode_text, textX, textY);
	            g.dispose();
	            
		        ImageIO.write(combinedImage, "png", new File(file_path));
			} catch(Exception e){
				System.out.println("條碼圖片建立失敗，失敗原因："+e.getMessage());
			}
		}
		
		private void create_barcode(String barcode_text, String file_path){
			if(!"".equals(barcode_text)) {
				try{
					
					int charWidth = 15; // 每个字符的宽度 (可以根据需要调整)
			        int barcodeHeight = 25; // 条码高度
		            int width = barcode_text.length() * charWidth; // 根据字元數量計算條碼寬度
 
			        // 設定條碼參數
			        Map<EncodeHintType, Object> hints = new HashMap<>();
			        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
			        hints.put(EncodeHintType.MARGIN, 50); 			// 設定條碼邊距

	             	//  Code39 條碼
	                Code39Writer barcodeWriter = new Code39Writer();
	                BitMatrix bitMatrix = new MultiFormatWriter().encode(barcode_text, BarcodeFormat.CODE_39, width, barcodeHeight, hints);

	             	// Convert BitMatrix to BufferedImage
	                BufferedImage barcodeImage = MatrixToImageWriter.toBufferedImage(bitMatrix, new MatrixToImageConfig());
	             	
	             	// 輸出到文件
	                ImageIO.write(barcodeImage, "png", new File(file_path));
	             	
	                add_text("*"+barcode_text+"*", file_path);
				} catch(Exception e){
					System.out.println("條碼圖片建立失敗，失敗原因："+e.getMessage());
				}
			}
		}
		
		// 建立條碼圖片
		public void create_barcode_image(String barcode_text, String file_name){
			String file_path = dir+"/"+file_name;
			boolean is_exists = check_file_exists(file_path);
			
			// 沒有圖片才會產
			create_barcode(barcode_text, file_path);
			if(!is_exists) create_barcode(barcode_text, file_path);
		}
	}
%>