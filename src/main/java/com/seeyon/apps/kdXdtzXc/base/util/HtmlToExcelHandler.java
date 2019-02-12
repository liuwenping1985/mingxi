package com.seeyon.apps.kdXdtzXc.base.util;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;

public class HtmlToExcelHandler {
    public HSSFWorkbook tableToExcel(HttpServletRequest request) {
        // 获得页面table元素里面的数据
        // 存入的格式0,0,1,2,产品★☆★0,1,2,1,产品2
        // *第一个参数是当前行，第二个参数是当前列，第三个参数是当前行所跨的行数，第四个参数是当前行所跨的列数，第五个参数是当前单元格的值
        String dataInfo = request.getParameter("dataInfo");

        if (dataInfo != null && !"".equals(dataInfo)) {
            if (dataInfo.endsWith("㊣")) {
                dataInfo = dataInfo.substring(0, dataInfo.length() - 1);
            }
        }

        String[] list = dataInfo.split("㊣", -1);

        // 创建hssfWorkbook工作簿
        HSSFWorkbook hssfworkbook = new HSSFWorkbook();
        HSSFSheet hssfSheet = hssfworkbook.createSheet();

        // 求最大行与最大列
        int col = 0;
        int temp = 55; // 零时变量只是为了比较好判断读到几行了
        int tempMaxCell = 0; // table中的最大列数

        int maxCell = 0; // 最大列数
        int maxRow = 0; // 总共的行数

        // 求出总行数与最大的列数
        for (int i = 0; i < list.length; i++) {
            String zhi = list[i];
            String[] value = zhi.split("¤", -1);
            int rowNumber = Integer.parseInt(value[0]); // 当前所处列的编号
            int colspan = Integer.parseInt(value[3]); // 跨的列数

            if (rowNumber != temp) {
                maxRow++;
                temp = rowNumber;
                if (maxCell < tempMaxCell) {
                    maxCell = tempMaxCell;
                }
                tempMaxCell = 0;
            }
            tempMaxCell += colspan;
        }

        // 值数据数组
        String[][] database = new String[maxRow][maxCell];
        // 值的分布数组，为null则为需要填充
        Integer[][] rowsInfo = new Integer[maxRow][maxCell];

        int countNum = 0;
        for (int i = 0; i < list.length; i++) {
            String zhi = list[i];
            String[] value = zhi.split("¤", -1);
            int rowNumber = Integer.parseInt(value[0]); // 行编号
            int colNumber = Integer.parseInt(value[1]); // 列编号
            int rowspan = Integer.parseInt(value[2]); // 所跨的行数
            int colspan = Integer.parseInt(value[3]); // 所跨的列数

            if (rowNumber != temp) {
                temp = rowNumber;
                col = 0;
                countNum = 0;
            }

            // 既跨行也跨列的合并方法
            if (rowspan != 1 && colspan != 1) {
                hssfSheet.addMergedRegion(new CellRangeAddress(rowNumber, rowNumber + rowspan - 1, colNumber, colNumber + colspan - 1));
                for (int j = 0; j < rowspan; j++) {
                    for (int k = 0; k < colspan; k++) {
                        rowsInfo[rowNumber + j][col + k] = 1111;
                    }
                }
                rowsInfo[rowNumber][col] = null;
            }
            // 只跨行的单元格合并方法
            else if (rowspan != 1) {
                hssfSheet.addMergedRegion(new CellRangeAddress(rowNumber, rowNumber + rowspan - 1, col, col));
                for (int j = 1; j < rowspan; j++) {
                    rowsInfo[rowNumber + j][col] = 1111;
                }
            }
            // 只跨列的单元格合并方法
            else if (colspan != 1) {
                if (rowsInfo[rowNumber][col] != null && rowsInfo[rowNumber][col] == 1111) {
                    col = col + 1;
                    hssfSheet.addMergedRegion(new CellRangeAddress(rowNumber, rowNumber, col, col + colspan - 1));
                    for (int k = 1; k < colspan; k++) {
                        rowsInfo[rowNumber][col + k] = 2222;
                    }
                } else {
                    hssfSheet.addMergedRegion(new CellRangeAddress(rowNumber, rowNumber, col, col + colspan - 1));
                    for (int k = 1; k < colspan; k++) {
                        rowsInfo[rowNumber][col + k] = 2222;
                    }
                }
            }

            database[rowNumber][countNum] = zhi.substring(zhi.lastIndexOf("¤") + 1);

            col = col + colspan;// 将当前位置往后移动colspan数量
            countNum++;
        }

        // 填充值
        for (int i = 0; i < maxRow; i++) {
            HSSFRow hssfRow = hssfSheet.createRow(i);
            hssfRow.setHeight((short) (15.625 * 20));
            int count = 0;
            for (int j = 0; j < maxCell; j++) {
                if (rowsInfo[i][j] == null) {
                    HSSFCell cell = hssfRow.createCell(j);
                    cell.setCellStyle(HSSCellStyleUtils.getHeaderStyle(hssfworkbook));
                    cell.setCellValue(database[i][count]);
                    count++;
                } else {
                    HSSFCell cell = hssfRow.createCell(j);
                    cell.setCellStyle(HSSCellStyleUtils.getHeaderStyle(hssfworkbook));
                }
            }
        }
        return hssfworkbook;
    }

    /**
     * 把excel写入到流里面
     *
     * @param out
     */
    public void writeExcelFile(OutputStream out, HSSFWorkbook hssfworkbook) {
        try {
            out.flush();
            hssfworkbook.write(out);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                out.close();
                hssfworkbook = null;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void exportExcelToExplorer(HttpServletRequest request, HttpServletResponse response, String fileName) throws Exception {
        String newFileName = new String(fileName.getBytes("GBK"), "ISO8859-1");
        response.resetBuffer();
        response.addHeader("Content-disposition", "attachment; filename=" + newFileName);
        response.setHeader("Cache-Control", "max-age=0"); // 加了jsp编码过滤器UTF-8，如果没有此处，客户端找不到下载文件

        HSSFWorkbook hssfworkbook = tableToExcel(request);
        writeExcelFile(response.getOutputStream(), hssfworkbook);
    }
}
