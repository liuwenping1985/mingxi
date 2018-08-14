//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.casso;

import com.seeyon.ctp.common.constants.LoginResult;
import com.seeyon.ctp.login.LoginAuthenticationException;
import com.seeyon.ctp.login.controller.MainController;
import com.seeyon.ctp.portal.sso.SSOLoginContext;
import com.seeyon.ctp.portal.sso.SSOLoginHandshakeInterface;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.codec.binary.Base64;
import sun.security.provider.MD5;
import www.seeyon.com.utils.MD5Util;

public class CassoLoginImpl implements SSOLoginHandshakeInterface {
    public CassoLoginImpl() {
    }

    public String handshake(String token) {
        String ticket = "";
        try {
            String pwd = "Pwd@2018@~!@#$%^&*(";
            String md5 = MD5Util.MD5(pwd);
            String password = md5.substring(0, 16);
            //向量
            String v16 = md5.substring(16, 32);
            // byte[] deBase64 = com.seeyon.ctp.util.Base64.decodeBase64(token.getBytes());
            ticket =  decrypt(token,password,v16);
        } catch (Exception var5) {
            var5.printStackTrace();
        }

        System.out.println("1 ticket=" + ticket);
        return ticket;
    }

    public void logoutNotify(String s) {
        System.out.println("exist");
    }

    public LoginResult dogCheck(String arg0, String arg1, HttpServletRequest arg2) throws LoginAuthenticationException {
        System.out.print("dog");


        return null;
    }

    public  String getToUrl(HttpServletRequest paramHttpServletRequest, SSOLoginContext paramSSOLoginContext, String paramString){
        System.out.print("paramString");
        return "main.do?method=main";

    }
    /**
     * 解密
     * @param sSrc 接收到的加密过后的字符串（带解密密文）
     * @param sKey 秘钥
     * @return
     * @throws Exception
     */
    public static String decrypt(String sSrc, String sKey,String iv) throws Exception {
        try {
            if (sKey == null) {
                System.out.print("Key不能为空null");
                return null;
            }
            if (sKey.length() != 16) {
                System.out.print("Key的长度不是16位");
                return null;
            }
            if (iv.length() != 16) {
                System.out.print("iv的长度不是16位");
                return null;
            }
            byte[] byte1 = com.seeyon.ctp.util.Base64.decodeBase64(sSrc.getBytes());//先用Base64解码
            IvParameterSpec ivSpec = new IvParameterSpec(iv.getBytes());
            SecretKeySpec key = new SecretKeySpec(sKey.getBytes(), "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, key, ivSpec);
            //与加密时不同MODE:Cipher.DECRYPT_MODE
            byte[] ret = cipher.doFinal(byte1);
            return new String(ret, "utf-8");
        } catch (Exception ex) {
            System.out.println(ex.toString());
            return null;
        }
    }
    /**
     * 加密
     *
     * @param sSrc 加密的明文
     * @param sKey 秘钥
     * @param iv 向量  16 bytes
     * @return
     * @throws Exception
     */
    public static String encrypt(String sSrc, String sKey,String iv) throws Exception {
        if (sKey == null) {
            System.out.print("Key不能为空null");
            return null;
        }
        if (sKey.length() != 16) {
            System.out.print("Key的长度不是16位");
            return null;
        }
        if (iv.length() != 16) {
            System.out.print("iv的长度不是16位");
            return null;
        }
        byte[] raw = sKey.getBytes();
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        IvParameterSpec iv1 = new IvParameterSpec(iv.getBytes());
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, iv1);
        byte[] encrypted = cipher.doFinal(sSrc.getBytes());
         byte[] bytes =   com.seeyon.ctp.util.Base64.encodeBase64(encrypted,false);//decodeBase64(encrypted);
        return new String(bytes);
    }
    public static void main(String[] args) throws Exception {

        String pwd = "Pwd@2018@~!@#$%^&*(";
        String md5 = MD5Util.MD5(pwd);
        String password = md5.substring(0, 16);
        //向量
        String v16 = md5.substring(16, 32);
        String userName = "王元哇哈哈哈哈哈哈哈哈";
        //encrypt(userName,password,v16);
        String ppp = encrypt(userName,password,v16);
        System.out.println(ppp);
        System.out.println(decrypt(ppp,password,v16));
    }
}
