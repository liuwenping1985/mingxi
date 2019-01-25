package com.esa2000.apcore.unit;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * 采用SHAA加密
 * 
 * @author Xingxing,Xie
 * @datetime 2014-6-1
 */
public class SHAUtil {
	/***
	 * SHA加密 生成40位SHA码
	 * 
	 * @param 待加密字符串
	 * @return 返回40位SHA码
	 */
	 static String name ="11";
     static String OUTPUT_PATH= "/Users/liuwenping/Documents/"+name+"_sign.pdf" ;
     static String INPUT_PATH= "/Users/liuwenping/Documents/"+name+".pdf" ;
	public static String shaEncode(String inStr) throws Exception {
		MessageDigest sha = null;
		try {
			sha = MessageDigest.getInstance("SHA-1");
		} catch (Exception e) {
			System.out.println(e.toString());
			e.printStackTrace();
			return "";
		}

		byte[] byteArray = inStr.getBytes("UTF-8");
		byte[] md5Bytes = sha.digest(byteArray);
		StringBuffer hexValue = new StringBuffer();
		for (int i = 0; i < md5Bytes.length; i++) {
			int val = (md5Bytes[i]) & 0xff;
			if (val < 16) {
				hexValue.append("0");
			}
			hexValue.append(Integer.toHexString(val));
		}
		return hexValue.toString();
	}

	/**
	 * 适用于上G大的文件
	 */
	public static String getFileSha1(String path) throws OutOfMemoryError,
			IOException {
		File file = new File(path);
		FileInputStream in = new FileInputStream(file);
		MessageDigest messagedigest;
		try {
			messagedigest = MessageDigest.getInstance("SHA-1");

			byte[] buffer = new byte[1024 * 1024 * 10];
			int len = 0;

			while ((len = in.read(buffer)) > 0) {
				// 该对象通过使用 update（）方法处理数据
				messagedigest.update(buffer, 0, len);
			}

			// 对于给定数量的更新数据，digest 方法只能被调用一次。在调用 digest 之后，MessageDigest
			// 对象被重新设置成其初始状态。
			return byte2hex(messagedigest.digest());
		} catch (NoSuchAlgorithmException e) {
			// NQLog.e("getFileSha1->NoSuchAlgorithmException###",
			// e.toString());
			e.printStackTrace();
		} catch (OutOfMemoryError e) {

			// NQLog.e("getFileSha1->OutOfMemoryError###", e.toString());
			e.printStackTrace();
			throw e;
		} finally {
			in.close();
		}
		return null;
	}

	 /** 
     * java字节码转字符串 
     * @param b 
     * @return 
     */
    public static String byte2hex(byte[] b) { //一个字节的数，
 
        // 转成16进制字符串
 
        String hs = "";
        String tmp = "";
        for (int n = 0; n < b.length; n++) {
            //整数转成十六进制表示
 
            tmp = (java.lang.Integer.toHexString(b[n] & 0XFF));
            if (tmp.length() == 1) {
                hs = hs + "0" + tmp;
            } else {
                hs = hs + tmp;
            }
        }
        tmp = null;
        return hs.toUpperCase(); //转成大写
 
    }


	/**
	 * 测试主函数
	 * 
	 * @param args
	 * @throws Exception
	 */
	public static void main(String args[]) throws Exception {
		String str = new String("amigoxiexiexingxing");
		//str = getFileSha1("D:\\pdf\\33.pdf");
		str = getFileSha1(INPUT_PATH);
		System.out.println("原始：" + str);
		//System.out.println("SHA后：" + shaEncode(str));
	}
}