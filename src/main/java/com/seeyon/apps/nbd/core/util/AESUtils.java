package com.seeyon.apps.nbd.core.util;

import www.seeyon.com.utils.MD5Util;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class AESUtils{

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
        System.out.println(md5.length());
        String password = md5.substring(0, 16);
        //向量

        String v16 = md5.substring(16, 32);
        String userId="10990293";
        String tokenSource = userId+":"+System.currentTimeMillis();
        String token = encrypt(tokenSource,password,v16);
        System.out.println(token);
        //System.out.println(decrypt(ppp,password,v16));
    }
}
