package com.seeyon.apps.nbd.service;

import java.io.File;

import java.io.File;
import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.ComThread;
import com.jacob.com.Dispatch;
import com.jacob.com.Variant;

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
    public static void wordToPDF() {

        ActiveXComponent app = null;
        Dispatch doc = null;
        try {
            app = new ActiveXComponent("Word.Application");
            app.setProperty("Visible", new Variant(false));
            Dispatch docs = app.getProperty("Documents").toDispatch();

            //转换前的文件路径
            String startFile = "F:\\新建文件夹\\我是word版本" + ".doc";
            //转换后的文件路劲
            String overFile = "F:\\新建文件夹\\我是转换后的pdf文件" + ".pdf";

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


}
