package com.seeyon.apps.pdfbox;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.PDFRenderer;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

/**
 * Created by liuwenping on 2021/6/9.
 */
public class PdfDemo {

    public static void main(String[] args) {
        File file = new File("/Users/liuwenping/Documents/wmm/mingxi/src/main/java/com/seeyon/apps/pdfbox/SpringBoot.pdf");
        try {
            PDDocument doc = PDDocument.load(file);
            PDFRenderer renderer = new PDFRenderer(doc);
            int pageCount = doc.getNumberOfPages();

            for (int i = 0; i < pageCount; i++) {
                BufferedImage image = renderer.renderImageWithDPI(i, 296);
//          BufferedImage image = renderer.renderImage(i, 2.5f);
                ImageIO.write(image, "PNG", new File("/Users/liuwenping/Documents/wmm/pdfbox/pdfbox_image.png"));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }


    }
}
