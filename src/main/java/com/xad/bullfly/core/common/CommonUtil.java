package com.xad.bullfly.core.common;

import sun.misc.BASE64Decoder;

import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.plaf.basic.BasicEditorPaneUI;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.UUID;

public class CommonUtil {
    public static int DEFAULT_IMAGE_WIDTH = 1200;
    public static int DEFAULT_IMAGE_HEIGHT = 700;

    public static boolean paintPage(Graphics g, int hPage, int pageIndex, JTextPane panel) {
        Graphics2D g2 = (Graphics2D) g;
        Dimension d = ((BasicEditorPaneUI) panel.getUI()).getPreferredSize(panel);
        double panelHeight = d.height;
        double pageHeight = hPage;
        int totalNumPages = (int) Math.ceil(panelHeight / pageHeight);
        g2.translate(0f, -(pageIndex - 1) * pageHeight);
        panel.paint(g2);
        boolean ret = true;

        if (pageIndex >= totalNumPages) {
            ret = false;
            return ret;
        }
        return ret;
    }

    /**
     * html转换为ｊｐｅｇ文件
     *
     * @param bgColor 图片的背景色
     * @param html    html的文本信息
     * @param width   显示图片的Ｔｅｘｔ容器的宽度
     * @param height  显示图片的Ｔｅｘｔ容器的高度
     * @param eb      設置容器的边框
     * @return
     * @throws Exception
     */
    @SuppressWarnings("restriction")
    public static byte[] html2jpeg(Color bgColor, String html, int width,
                                   int height, EmptyBorder eb) throws Exception {
        String imageName = "/Users/liuwenping/Documents/log/" + UUID.randomUUID().toString() + ".jpg";
        JTextPane tp = new JTextPane();
        tp.setSize(width, height);
        if (eb == null) {
            eb = new EmptyBorder(0, 50, 0, 50);
        }
        if (bgColor != null) {
            tp.setBackground(bgColor);
        }
        if (width <= 0) {
            width = DEFAULT_IMAGE_WIDTH;
        }
        if (height <= 0) {
            height = DEFAULT_IMAGE_HEIGHT;
        }
        tp.setBorder(eb);
        tp.setContentType("text/html");
        tp.setText(html);

        int pageIndex = 1;
        boolean bcontinue = true;
        String resUrl = "";
        byte[] bytes = null;
        while (bcontinue) {
            BufferedImage image = new BufferedImage(width,
                    height, BufferedImage.TYPE_INT_RGB);
            Graphics g = image.getGraphics();
            g.setClip(0, 0, width, height);
            bcontinue = paintPage(g, height, pageIndex, tp);
            g.dispose();
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "jpg", baos);
            baos.flush();
            bytes = baos.toByteArray();
            baos.close();
            //写入阿里云
            pageIndex++;
        }
        return bytes;
    }

//    public static String toImage(){
//
//        ImageRenderer render = new ImageRenderer();
//
//        String url = "file:///Users/liuwenping/Desktop/-3294030565743217903_wd1.html";
//        File file;
//        InputStream inputStream = null;
//        byte[] data = null;
//
//        try {
//            //创建一个临时文件
//            file = File.createTempFile("temp", ".png");
//            //将html转为png
//            FileOutputStream out = new FileOutputStream(file);
//
//            render.renderURL(url, out, ImageRenderer.Type.PNG);
//            //字节流读取png
//            inputStream = new FileInputStream(file);
//            data = new byte[inputStream.available()];
//            inputStream.read(data);
//            out.close();
//            inputStream.close();
//            file.deleteOnExit();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        BASE64Encoder encoder = new BASE64Encoder();
//        //删除所有空格，换行，解决base解码出现中文乱码
//        return encoder.encode(data).replaceAll("\n", "").replaceAll("\r", "");
//
//    }

    public static boolean generateImage(String imgStr) {
        if(imgStr == null){
            return false;
        }

        BASE64Decoder decoder = new BASE64Decoder();
        try{
            byte[] b = decoder.decodeBuffer(imgStr);

            for (int i = 0;i<b.length;++i){
                if(b[i]<0){
                    b[i]+=256;
                }
            }
            OutputStream out = new FileOutputStream(new File("/Users/liuwenping/Documents/log/html.png"));

            out.write(b);
            out.flush();
            out.close();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args){

        try {
            File f = new File("/Users/liuwenping/Desktop/-3294030565743217903_wd1.html");
            FileInputStream ins = new FileInputStream(f);
            byte[] buffer =  new byte[4096];
            int len=0;
            StringBuilder stb = new StringBuilder();
            while((len = ins.read(buffer))>0){
                if(len==4096){
                    stb.append(new String(buffer,"UTF-8"));
                }else{
                    byte[] temp = new byte[len];
                    System.arraycopy(buffer,0,temp,0,len);
                    stb.append(new String(temp,"UTF-8"));
                }

            }
            System.out.println(stb.toString());
            byte[] bytes = html2jpeg(Color.white, stb.toString(),
                    1300, 1200, new EmptyBorder(0, 0,
                            0, 0));
            OutputStream out = new FileOutputStream(new File("/Users/liuwenping/Documents/log/html1.jpg"));
            out.write(bytes);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }



}
