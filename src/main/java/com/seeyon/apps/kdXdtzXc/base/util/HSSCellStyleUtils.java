package com.seeyon.apps.kdXdtzXc.base.util;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFCellUtil;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;

/**
 * @author binge
 * @time 2011-3-20 上午12:29:15
 */

public class HSSCellStyleUtils {

    // 根据字符得到宽度
    public static int getCellWidthByChars(String chars) {
        return (chars.getBytes().length) * 256 + 500;
    }

    // 合并单位元设置边框线
    @SuppressWarnings("deprecation")
    public static void setRegionStyle(HSSFSheet sheet, Region region, HSSFCellStyle cs) {
        for (int i = region.getRowFrom(); i <= region.getRowTo(); i++) {
            HSSFRow row = HSSFCellUtil.getRow(i, sheet);
            for (int j = region.getColumnFrom(); j <= region.getColumnTo(); j++) {
                HSSFCell cell = HSSFCellUtil.getCell(row, (short) j);
                cell.setCellStyle(cs);
            }
        }
    }

    public static HSSFCellStyle getTitleStyle(HSSFWorkbook workbook) {
        // 生成并设置另一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        // 生成另一个字体
        HSSFFont font = workbook.createFont();
        font.setFontHeightInPoints((short) 14);
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        // 把字体应用到当前的样式
        style.setFont(font);
        return style;

    }

    public static HSSFCellStyle getHeaderStyle(HSSFWorkbook workbook) {
        // 生成并设置另一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        // 生成另一个字体
        HSSFFont font = workbook.createFont();
        font.setFontHeightInPoints((short) 10);
        // 把字体应用到当前的样式
        style.setFont(font);
        return style;

    }

    public static HSSFCellStyle getHSSFCellStyle0(HSSFWorkbook workbook) {
        HSSFCellStyle style = workbook.createCellStyle();
        // 自动换行
        style.setWrapText(true);
        return style;
    }

    public static HSSFCellStyle getHSSFCellStyle1(HSSFWorkbook workbook) {
        // 生成一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        // 设置这些样式
        style.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        // 生成一个字体
        HSSFFont font = workbook.createFont();
        font.setColor(HSSFColor.VIOLET.index);
        font.setFontHeightInPoints((short) 12);
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        // 把字体应用到当前的样式
        style.setFont(font);
        return style;
    }

    public static HSSFCellStyle getHSSFCellStyle2(HSSFWorkbook workbook) {
        // 生成并设置另一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        // 生成另一个字体
        HSSFFont font = workbook.createFont();
        font.setFontHeightInPoints((short) 12);
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        // 把字体应用到当前的样式
        style.setFont(font);
        return style;

    }

    public static HSSFCellStyle getHSSFCellStyle3(HSSFWorkbook workbook) {
        // 生成并设置另一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        return style;
    }

    public static HSSFCellStyle getHSSFCellStyle4(HSSFWorkbook workbook) {
        // 生成并设置另一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        // 生成另一个字体
        HSSFFont font = workbook.createFont();
        font.setFontHeightInPoints((short) 12);
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        // 把字体应用到当前的样式
        style.setFont(font);
        return style;

    }

    public static HSSFCellStyle getHSSFCellStyle5(HSSFWorkbook workbook) {
        // 生成并设置另一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        // 生成另一个字体
        HSSFFont font = workbook.createFont();
        font.setFontHeightInPoints((short) 12);
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        // 把字体应用到当前的样式
        style.setFont(font);
        return style;

    }

    // 设置蓝色背景色
    public static HSSFCellStyle getHSSFCellStyle7(HSSFWorkbook workbook) {
        // 生成并设置另一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style.setFillForegroundColor(HSSFColor.LIGHT_BLUE.index);
        return style;
    }

    // 设置红色背景色
    public static HSSFCellStyle getHSSFCellStyle8(HSSFWorkbook workbook) {
        // 生成并设置另一个样式
        HSSFCellStyle style = workbook.createCellStyle();
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style.setFillForegroundColor(HSSFColor.RED.index);
        return style;
    }

    public static HSSFCellStyle setHSSFCellStyle1(HSSFCellStyle style) {
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
        return style;
    }

}
