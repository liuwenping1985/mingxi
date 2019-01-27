package com.seeyon.apps.nbd.service;

import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.ComThread;
import com.jacob.com.Dispatch;
import com.jacob.com.Variant;

import java.io.File;

/**
 * Created by liuwenping on 2019/1/23.
 */
public class PdfService {

    private PdfService(){


    }

    public static PdfService getInstance(){
        return Holder.ins;
    }

    private static class Holder{

        static PdfService ins = new PdfService();

    }

    public File trasToPdf(String path){


        return null;

    }
    private static final int wdFormatPDF = 17;
    public static void word2pdf(){


        ActiveXComponent app = null;
        Dispatch doc = null;
        try {
            app = new ActiveXComponent("KWPS.Application");
            app.setProperty("Visible", new Variant(false));
            app.setProperty("AutomationSecurity", new Variant(3));
            Dispatch docs = app.getProperty("Documents").toDispatch();

            //转换前的文件路径
            String startFile = "D:\\222.docx";
            //转换后的文件路劲
            String overFile = "D:\\222.pdf";
            doc = Dispatch.call(docs, "Open", startFile, false, true).toDispatch();
            //doc = Dispatch.call(docs, "Open", startFile).toDispatch();
            File tofile = new File(overFile);
            if (tofile.exists()) {
                tofile.delete();
            }
            Dispatch.call(doc, "ExportAsFixedFormat", overFile, wdFormatPDF);// word保存为pdf格式宏，值为17
            // Dispatch.call(doc, "SaveAs", overFile, wdFormatPDF);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            Dispatch.call(doc, "Close", false);
            if (app != null)
                app.invoke("Quit", new Variant[]{});
        }
        //结束后关闭进程
        ComThread.Release();
    }
    public static void wordToPDF() {

        ActiveXComponent app = null;
        Dispatch doc = null;
        try {
            app = new ActiveXComponent("Word.Application");
            app.setProperty("Visible", new Variant(false));
            Dispatch docs = app.getProperty("Documents").toDispatch();

            //转换前的文件路径
            String startFile = "D:\\222.docx";
            //转换后的文件路劲
            String overFile = "D:\\222.pdf";

            doc = Dispatch.call(docs, "Open", startFile).toDispatch();
            File tofile = new File(overFile);
            if (tofile.exists()) {
                tofile.delete();
            }
            Dispatch.call(doc, "SaveAs", overFile, wdFormatPDF);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            Dispatch.call(doc, "Close", false);
            if (app != null)
                app.invoke("Quit", new Variant[]{});
        }
        //结束后关闭进程
        ComThread.Release();
    }

    public static void main(String[] args){
        String startFile = "D:\\222.docx";
        //转换后的文件路劲
        String overFile = "D:\\222.pdf";
        word2pdf();

    }

}
