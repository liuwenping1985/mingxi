package com.seeyon.apps.ruian.controller;

import java.awt.Color;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Node;
import org.springframework.web.servlet.ModelAndView;

import www.seeyon.com.utils.UUIDUtil;

import com.lowagie.text.Cell;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Rectangle;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfWriter;
import com.seeyon.apps.ruian.manager.RuianManager;
import com.seeyon.apps.ruian.po.AssetsGb;
import com.seeyon.apps.ruian.po.SubjectTree;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.barCode.manager.BarCodeManager;
import com.seeyon.ctp.common.barCode.vo.BarCodeParamVo;
import com.seeyon.ctp.common.barCode.vo.ResultVO;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.po.FormDefinition;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.json.JSONUtil;

public class RuianController extends BaseController {

    private static Log log = LogFactory.getLog(RuianController.class);
    private RuianManager ruianManager;

    private static String[] big_type = AppContext.getSystemProperty("ruian.big_type").split(",");
    // private static String[] card_formId =
    // AppContext.getSystemProperty("ruian.card_formId").split(",");
    // private static HashMap<String, HashMap<String, String>> hm_form = new
    // HashMap<String, HashMap<String, String>>();

    public void setRuianManager(RuianManager ruianManager) {
        this.ruianManager = ruianManager;
    }

    private static List<SubjectTree> listSub = new ArrayList<SubjectTree>();
    private static List<SubjectTree> backList = new ArrayList<SubjectTree>();
    private static List<String> cateList = new ArrayList<String>();;
    private AttachmentManager attachmentManager;
    private BarCodeManager barCodeManager;

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setBarCodeManager(BarCodeManager barCodeManager) {
        this.barCodeManager = barCodeManager;
    }

    static {
        RuianManager rm = (RuianManager) AppContext.getBean("ruianManager");
        setSubject(rm);
        cateList.add("5");
        cateList.add("7");
        cateList.add("8");
    }

    public ModelAndView selectSubject(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("plugin/ruian/selectSubject");

        backList.clear();
        String category = request.getParameter("category");
        if (StringUtils.isNotBlank(category)) {

            // cateList.add(category);
            for (SubjectTree s : listSub) {
                if (s.getCode().equals(category)) {
                    backList.add(s);
                }
            }
            backList.add(new SubjectTree("100", "其他"));

            for (SubjectTree s : listSub) {
                if (cateList.contains(s.getCode())) {
                    backList.get(1).getList().add(s);
                }
            }

            mav.addObject("listTree", backList);
        } else {
            mav.addObject("listTree", listSub);
        }

        return mav;
    }

    public ModelAndView refreshSubject(HttpServletRequest request, HttpServletResponse response) throws Exception {
        listSub.clear();
        setSubject(ruianManager);
        return null;
    }

    private static void setSubject(RuianManager rm) {
        HashMap<String, SubjectTree> smain = new HashMap<String, SubjectTree>();
        for (String type : big_type) {
            String[] str = type.split(":");
            SubjectTree st = new SubjectTree(str[0], str[1]);
            listSub.add(st);
            smain.put(str[0], st);
        }
        List<AssetsGb> listAssets = rm.getAssetsGbList();
        HashMap<String, SubjectTree> hm = new HashMap<String, SubjectTree>();
        for (AssetsGb ass : listAssets) {
            SubjectTree st = new SubjectTree(ass.getAssets_code(), ass.getAssets_name());
            if (ass.getAssets_code().length() == 9) {
                if (ass.getAssets_code().matches("^[0-9]{3}0{6}$")) {
                    // listSub.add(st);
                    smain.get(ass.getAssets_code().substring(0, 1)).getList().add(st);
                    hm.put(ass.getAssets_code().substring(0, 3), st);
                    continue;
                }
                if (ass.getAssets_code().matches("^[0-9]{5}0{4}$")) {
                    hm.get(ass.getAssets_code().substring(0, 3)).getList().add(st);
                    hm.put(ass.getAssets_code().substring(0, 5), st);
                    continue;
                }
                if (ass.getAssets_code().matches("^[0-9]{7}0{2}$")) {
                    SubjectTree hmSt = hm.get(ass.getAssets_code().substring(0, 5));
                    if (hmSt == null) {
                        hm.get(ass.getAssets_code().substring(0, 3)).getList().add(st);
                    } else {
                        hm.get(ass.getAssets_code().substring(0, 5)).getList().add(st);
                    }
                    hm.put(ass.getAssets_code().substring(0, 7), st);

                    continue;
                }
                if (ass.getAssets_code().matches("^[0-9]{9}$")) {
                    SubjectTree hmSt = hm.get(ass.getAssets_code().substring(0, 7));
                    if (hmSt == null) {
                        hm.get(ass.getAssets_code().substring(0, 5)).getList().add(st);
                    } else {
                        hm.get(ass.getAssets_code().substring(0, 7)).getList().add(st);
                    }
                    continue;
                }
            } else {
                listSub.add(st);
            }
        }
    }

    private static HashMap<String, String> initFormInfo(Long formId) {
        HashMap<String, String> f_hm = new HashMap<String, String>();
        try {
            FormDefinition fd = DBAgent.get(FormDefinition.class, formId);
            String finfo = fd.getFieldInfo();
            Document f_doc = DocumentHelper.parseText(finfo);

            List<Node> list_tables = f_doc.selectNodes("/TableList/Table");
            for (Node node_table : list_tables) {
                Element table = (Element) node_table;
                if ("master".equals(table.attributeValue("tabletype"))) {
                    f_hm.put("table_name", table.attributeValue("name").trim());
                    break;
                }
            }

            List<Node> list_Fields = f_doc.selectNodes("/TableList/Table/FieldList/Field");
            for (Node node_Field : list_Fields) {
                Element field = (Element) node_Field;
                String barcode = field.attributeValue("barcode").trim();
                if (!"".equals(barcode)) {
                    HashMap<String, String> hm_barcode = JSONUtil.parseJSONString(barcode, HashMap.class);
                    f_hm.putAll(hm_barcode);
                    f_hm.put("fieldName", field.attributeValue("name").trim());
                    break;
                }
            }

            for (Node node_Field : list_Fields) {
                Element field = (Element) node_Field;
                String display = field.attributeValue("display").trim();
                if ("资产代码".equals(display)) {
                    f_hm.put("zc_code", field.attributeValue("name").trim());
                }
                if ("资产名称".equals(display)) {
                    f_hm.put("zc_name", field.attributeValue("name").trim());
                }
            }

            String vinfo = fd.getViewInfo();
            Document v_doc = DocumentHelper.parseText(vinfo);
            List<Node> list_Operation = v_doc.selectNodes("/FormList/Form/OperationList/Operation");
            for (Node node_Operation : list_Operation) {
                Element operation = (Element) node_Operation;
                if ("update".equals(operation.attributeValue("type"))) {
                    f_hm.put("rightId", operation.attributeValue("id".trim()));
                    break;
                }
            }

            f_hm.put("recordId", "0");
            f_hm.put("formType", "2");
            f_hm.put("viewState", "1");
            f_hm.put("contentType", "20");

            log.info("表单参数信息：【" + fd.getName() + "】【" + formId + "】" + f_hm.toString());
        } catch (Exception e) {
            log.error("打印二维码获取表单信息错误：", e);
        }
        return f_hm;
    }

    public ModelAndView subjectManager(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("plugin/ruian/subjectManager");
        return mav;
    }

    public ModelAndView showNewUpdate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("plugin/ruian/showNewUpdate");
        String id = request.getParameter("id");
        if (id != null && !"".equals(id.trim())) {
            AssetsGb agb = ruianManager.getAssetsGbById(Long.valueOf(id));
            mav.addObject("code", agb.getAssets_code());
            mav.addObject("name", agb.getAssets_name());
        }

        return mav;
    }

    public ModelAndView newUpdate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String id = request.getParameter("id");
        System.out.println("00000000000000000000");
        System.out.println("code:"+code);
        System.out.println("name:"+name);
        if (id != null && !"".equals(id.trim())) {
            AssetsGb agb = ruianManager.getAssetsGbById(Long.valueOf(id));
            agb.setAssets_code(code.trim());
            agb.setAssets_name(name.trim());
            ruianManager.saveOrUpdate(agb);
        } else {
            AssetsGb agb = new AssetsGb();
            agb.setIdIfNew();
            agb.setAssets_code(code.trim());
            agb.setAssets_name(name.trim());
            agb.setStatus("1");
            ruianManager.saveOrUpdate(agb);
        }
        listSub.clear();
        setSubject(ruianManager);
        return null;
    }

    public ModelAndView changeStatus(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String type = request.getParameter("type");
        String[] ids = request.getParameter("ids").split(",");
        String status = "1";
        if ("disable".equals(type)) {
            status = "0";
        }
        List<String> codes = new ArrayList<String>();
        for (String id : ids) {
            AssetsGb agb = ruianManager.getAssetsGbById(Long.valueOf(id));
            codes.add(agb.getAssets_code().replaceFirst("0+$", ""));
        }
        List<AssetsGb> all = new ArrayList<AssetsGb>();
        for (String code : codes) {
            all.addAll(ruianManager.getAssetsGbListByCode(code + "%"));
        }
        for (AssetsGb agb : all) {
            agb.setStatus(status);
            ruianManager.saveOrUpdate(agb);
        }
        listSub.clear();
        setSubject(ruianManager);
        response.getWriter().print("1");

        return null;
    }

    public ModelAndView checkCode(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String code = request.getParameter("code");
        boolean isEx = ruianManager.isExistCode(code);
        response.getWriter().print(isEx ? "1" : "");

        return null;
    }

    public ModelAndView printCode(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("plugin/ruian/printCode");
        String printType = request.getParameter("printType");
        String printFormId = request.getParameter("printFormId");
        String[] printIds = request.getParameter("printIds").split(",");

        List<String[]> listData = new ArrayList<String[]>();
        HashMap<String, String> hm_data = initFormInfo(Long.valueOf(printFormId));
        Connection connOA = JDBCAgent.getConnection();

        for (String id : printIds) {
            String[] data = new String[3];
            StringBuffer sql = new StringBuffer();
            sql.append("select ").append(hm_data.get("fieldName")).append(",").append(hm_data.get("zc_code"))
                    .append(",");
            sql.append(hm_data.get("zc_name")).append(" from ").append(hm_data.get("table_name"))
                    .append(" where id = ?");
            List<String[]> ld = ruianManager.getDataBySql(sql.toString(), connOA, 0, new Object[] { Long.valueOf(id) });
            String[] tt = ld.get(0);
            data[0] = tt[1];
            data[1] = tt[2];

            if (tt[0] != null && !"".equals(tt[0])) {
                List<Attachment> listAtt = attachmentManager.getByReference(Long.valueOf(id), Long.valueOf(tt[0]));
                data[2] = String.valueOf(listAtt.get(0).getFileUrl());
            } else {
                BarCodeParamVo paramVo = new BarCodeParamVo();
                paramVo.setBarcodeFormat(hm_data.get("barcodeType"));
                paramVo.setCategory(ApplicationCategoryEnum.form.ordinal());
                paramVo.setCodeType("form");
                paramVo.setErrorLevel(hm_data.get("correctionOption"));
                int size = Integer.valueOf(hm_data.get("sizeOption")) * 50;
                paramVo.setHeight(size);
                paramVo.setWidth(size);
                paramVo.setReference(Long.valueOf(id));
                Long subref = UUIDUtil.getUUIDLong();
                paramVo.setSubReference(subref);

                Map<String, Object> customParam = new HashMap<String, Object>();
                customParam.put("formId", printFormId);
                customParam.put("recordId", hm_data.get("recordId"));
                customParam.put("formType", Integer.valueOf(hm_data.get("formType")));
                customParam.put("fieldName", hm_data.get("fieldName"));
                customParam.put("dataId", id);
                customParam.put("rightId", hm_data.get("rightId"));
                customParam.put("viewState", hm_data.get("viewState"));
                customParam.put("moduleId", id);
                customParam.put("contentType", Integer.valueOf(hm_data.get("contentType")));

                FormDataMasterBean fdmb = FormService.findDataById(Long.valueOf(id), Long.valueOf(printFormId));
                AppContext.putThreadContext(AppContext.getCurrentUser().getId() + "_" + id, fdmb);

                ResultVO vo = barCodeManager.getBarCodeAttachment(paramVo, customParam);
                Attachment att = vo.getAttachment();

                data[2] = String.valueOf(att.getFileUrl());

                String upsql = "update " + hm_data.get("table_name") + " set " + hm_data.get("fieldName")
                        + " = ? where id = ?";
                ruianManager.updateBySql(upsql, connOA, new Object[] { String.valueOf(subref), Long.valueOf(id) });
            }
            listData.add(data);
        }

        try {
            connOA.close();
        } catch (SQLException e) {
        }

        StringBuffer content = new StringBuffer("");
        if ("1".equals(printType)) {
            content.append("<div style='width:82mm;'>");
            for (int i = 0; i < listData.size();) {
                String[] dd = listData.get(i);
                String[] dd2 = new String[3];
                dd2[0] = "";
                dd2[1] = "";
                dd2[2] = "";
                if (i + 1 < listData.size()) {
                    dd2 = listData.get(i + 1);
                }

                content.append("<div style='width:40mm;height:15mm;float:left;'>");
                content.append("<div style='width:25mm;height:13mm;float:left;'>");
                content.append("<div style='border-bottom:1px solid #000000;font-size:8px;'>")
                        .append("资&nbsp;&nbsp;产&nbsp;&nbsp;编&nbsp;&nbsp;码").append("</div>");
                content.append("<div style='border-bottom:1px solid #000000;font-size:7px;'>")
                        .append("".equals(dd[0]) ? "无" : dd[0]).append("</div>");
                content.append("<div style='border-bottom:1px solid #000000;font-size:8px;'>")
                        .append("资&nbsp;&nbsp;产&nbsp;&nbsp;名&nbsp;&nbsp;称").append("</div>");
                content.append("<div style='border-bottom:1px solid #000000;font-size:7px;'>")
                        .append("".equals(dd[1]) ? "无" : dd[1]).append("</div>");
                content.append("</div>");
                content.append("<div style='width:13mm;height:13mm;float:left;'>");
                content.append("<img style='width:13mm;height:13mm;' src='/seeyon/fileUpload.do?method=showRTE&fileId="
                        + dd[2] + "&type=image' />");
                content.append("</div>");
                content.append("</div>");

                content.append("<div style='width:2mm;height:15mm;float:left;'></div>");

                content.append("<div style='width:40mm;height:15mm;float:left;'>");
                if (!"".equals(dd2[2])) {
                    content.append("<div style='width:25mm;height:13mm;float:left;'>");
                    content.append("<div style='border-bottom:1px solid #000000;font-size:8px;'>")
                            .append("资&nbsp;&nbsp;产&nbsp;&nbsp;编&nbsp;&nbsp;码").append("</div>");
                    content.append("<div style='border-bottom:1px solid #000000;font-size:7px;'>")
                            .append("".equals(dd2[0]) ? "无" : dd2[0]).append("</div>");
                    content.append("<div style='border-bottom:1px solid #000000;font-size:8px;'>")
                            .append("资&nbsp;&nbsp;产&nbsp;&nbsp;名&nbsp;&nbsp;称").append("</div>");
                    content.append("<div style='border-bottom:1px solid #000000;font-size:7px;'>")
                            .append("".equals(dd2[1]) ? "无" : dd2[1]).append("</div>");
                    content.append("</div>");
                    content.append("<div style='width:13mm;height:13mm;float:left;'>");
                    content.append(
                            "<img style='width:13mm;height:13mm;' src='/seeyon/fileUpload.do?method=showRTE&fileId="
                                    + dd2[2] + "&type=image' />");
                    content.append("</div>");
                }
                content.append("</div>");

                i = i + 2;
            }
            content.append("</div>");
        }
        if ("2".equals(printType)) {
            content.append("<div style='width:80mm;'>");
            for (int i = 0; i < listData.size(); i++) {
                String[] dd = listData.get(i);

                content.append("<div style='width:55mm;height:24mm;float:left;margin-left:1mm;'>");
                content.append("<div style='border-bottom:1px solid #000000;font-size:15px;'>")
                        .append("资&nbsp;&nbsp;产&nbsp;&nbsp;编&nbsp;&nbsp;码").append("</div>");
                content.append("<div style='border-bottom:1px solid #000000;font-size:14px;'>")
                        .append("".equals(dd[0]) ? "无" : dd[0]).append("</div>");
                content.append("<div style='border-bottom:1px solid #000000;font-size:15px;'>")
                        .append("资&nbsp;&nbsp;产&nbsp;&nbsp;名&nbsp;&nbsp;称").append("</div>");
                content.append("<div style='border-bottom:1px solid #000000;font-size:14px;'>")
                        .append("".equals(dd[1]) ? "无" : dd[1]).append("</div>");
                content.append("</div>");

                content.append("<div style='width:23mm;height:23mm;float:left;'>");
                content.append("<img style='width:23mm;height:23mm;' src='/seeyon/fileUpload.do?method=showRTE&fileId="
                        + dd[2] + "&type=image' />");
                content.append("</div>");
            }
            content.append("</div>");
        }
        mav.addObject("content", content);

        return mav;
    }

    public ModelAndView selectPrintType(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("plugin/ruian/selectPrintType");

        return mav;
    }

    public ModelAndView printCodePDF(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String printType = request.getParameter("printType");
        String printFormId = request.getParameter("printFormId");
        String[] printIds = request.getParameter("printIds").split(",");

        List<String[]> listData = new ArrayList<String[]>();
        HashMap<String, String> hm_data = initFormInfo(Long.valueOf(printFormId));
        Connection connOA = JDBCAgent.getConnection();

        for (String id : printIds) {
            String[] data = new String[3];
            StringBuffer sql = new StringBuffer();
            sql.append("select ").append(hm_data.get("fieldName")).append(",").append(hm_data.get("zc_code"))
                    .append(",");
            sql.append(hm_data.get("zc_name")).append(" from ").append(hm_data.get("table_name"))
                    .append(" where id = ?");
            List<String[]> ld = ruianManager.getDataBySql(sql.toString(), connOA, 0, new Object[] { Long.valueOf(id) });
            String[] tt = ld.get(0);
            data[0] = tt[1];
            data[1] = tt[2];

            if (tt[0] != null && !"".equals(tt[0])) {
                List<Attachment> listAtt = attachmentManager.getByReference(Long.valueOf(id), Long.valueOf(tt[0]));
                data[2] = String.valueOf(listAtt.get(0).getFileUrl());
            } else {
                BarCodeParamVo paramVo = new BarCodeParamVo();
                paramVo.setBarcodeFormat(hm_data.get("barcodeType"));
                paramVo.setCategory(ApplicationCategoryEnum.form.ordinal());
                paramVo.setCodeType("form");
                paramVo.setErrorLevel(hm_data.get("correctionOption"));
                int size = Integer.valueOf(hm_data.get("sizeOption")) * 50;
                paramVo.setHeight(size);
                paramVo.setWidth(size);
                paramVo.setReference(Long.valueOf(id));
                Long subref = UUIDUtil.getUUIDLong();
                paramVo.setSubReference(subref);

                Map<String, Object> customParam = new HashMap<String, Object>();
                customParam.put("formId", printFormId);
                customParam.put("recordId", hm_data.get("recordId"));
                customParam.put("formType", Integer.valueOf(hm_data.get("formType")));
                customParam.put("fieldName", hm_data.get("fieldName"));
                customParam.put("dataId", id);
                customParam.put("rightId", hm_data.get("rightId"));
                customParam.put("viewState", hm_data.get("viewState"));
                customParam.put("moduleId", id);
                customParam.put("contentType", Integer.valueOf(hm_data.get("contentType")));

                FormDataMasterBean fdmb = FormService.findDataById(Long.valueOf(id), Long.valueOf(printFormId));
                AppContext.putThreadContext(AppContext.getCurrentUser().getId() + "_" + id, fdmb);

                ResultVO vo = barCodeManager.getBarCodeAttachment(paramVo, customParam);
                Attachment att = vo.getAttachment();

                data[2] = String.valueOf(att.getFileUrl());

                String upsql = "update " + hm_data.get("table_name") + " set " + hm_data.get("fieldName")
                        + " = ? where id = ?";
                ruianManager.updateBySql(upsql, connOA, new Object[] { String.valueOf(subref), Long.valueOf(id) });
            }
            listData.add(data);
        }

        try {
            connOA.close();
        } catch (SQLException e) {
        }

        com.lowagie.text.Document document = new com.lowagie.text.Document(PageSize.A4, 0, 0, 0, 0);
        Rectangle rec = document.getPageSize();

        BaseFont baseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        FileManager fm = (FileManager) AppContext.getBean("fileManager");
        String pdfPath = SystemEnvironment.getApplicationFolder() + "/pdfshow";
        File pdfFile = new File(pdfPath);
        pdfFile.mkdirs();

        File[] files = pdfFile.listFiles();
        if (files != null && files.length > 0) {
            for (File f : files) {
                long sub = (new Date()).getTime() - f.lastModified();
                if (sub > 600000) {
                    f.delete();
                }
            }
        }

        Table tb = new Table(2);

        if ("1".equals(printType)) {
            Rectangle recn = new Rectangle(rec.width() * 82 / 210, rec.height());
            document = new com.lowagie.text.Document(recn, 0, 0, 0, 0);

            tb = new Table(5);
            tb.setPadding(0.5f);
            tb.setSpacing(0);
            tb.setAlignment(0);
            tb.setBorderWidth(0);

            Font font = new Font(baseFont, 6, Font.NORMAL);
            float w1 = rec.width() * 25 / 210;
            float w2 = rec.width() * 15 / 210;
            float w3 = rec.width() * 2 / 210;

            tb.setWidths(new float[] { w1, w2, w3, w1, w2 });
            tb.setWidth(100);

            for (int i = 0; i < listData.size();) {
                String[] dd = listData.get(i);
                String[] dd2 = new String[3];
                dd2[0] = "";
                dd2[1] = "";
                dd2[2] = "";
                if (i + 1 < listData.size()) {
                    dd2 = listData.get(i + 1);
                }

                Paragraph pr = new Paragraph("资   产   编   码", font);
                Cell cell = new Cell(pr);
                cell.setColspan(1);
                cell.setBorderWidthBottom(0.2f);
                cell.setBorderColorBottom(new Color(0, 0, 0));
                tb.addCell(cell);

                String imgPath = pdfPath + "/" + dd[2] + ".png";
                FileUtils.copyFile(fm.getFile(Long.valueOf(dd[2])), new File(imgPath));
                Image png = Image.getInstance(imgPath);
                png.scaleAbsolute(w2, w2);
                cell = new Cell(png);
                cell.setRowspan(4);
                cell.setBorder(0);
                tb.addCell(cell);

                cell = new Cell("");
                cell.setRowspan(4);
                cell.setBorder(0);
                tb.addCell(cell);

                if (!"".equals(dd2[2])) {
                    pr = new Paragraph("资   产   编   码", font);
                    cell = new Cell(pr);
                    cell.setColspan(1);
                    cell.setBorderWidthBottom(0.2f);
                    cell.setBorderColorBottom(new Color(0, 0, 0));
                    tb.addCell(cell);

                    imgPath = pdfPath + "/" + dd2[2] + ".png";
                    FileUtils.copyFile(fm.getFile(Long.valueOf(dd2[2])), new File(imgPath));
                    png = Image.getInstance(imgPath);
                    png.scaleAbsolute(w2, w2);
                    cell = new Cell(png);
                    cell.setRowspan(4);
                    cell.setBorder(0);
                    tb.addCell(cell);
                } else {
                    cell = new Cell("");
                    cell.setColspan(1);
                    cell.setBorder(0);
                    tb.addCell(cell);

                    cell = new Cell("");
                    cell.setRowspan(4);
                    cell.setBorder(0);
                    tb.addCell(cell);
                }

                pr = new Paragraph("".equals(dd[0]) ? "无" : dd[0], font);
                cell = new Cell(pr);
                cell.setColspan(1);
                cell.setBorderWidthBottom(0.2f);
                cell.setBorderColorBottom(new Color(0, 0, 0));
                tb.addCell(cell);

                if (!"".equals(dd2[2])) {
                    pr = new Paragraph("".equals(dd2[0]) ? "无" : dd2[0], font);
                    cell = new Cell(pr);
                    cell.setColspan(1);
                    cell.setBorderWidthBottom(0.2f);
                    cell.setBorderColorBottom(new Color(0, 0, 0));
                    tb.addCell(cell);
                } else {
                    cell = new Cell("");
                    cell.setColspan(1);
                    cell.setBorder(0);
                    tb.addCell(cell);
                }

                pr = new Paragraph("资   产   名   称", font);
                cell = new Cell(pr);
                cell.setColspan(1);
                cell.setBorderWidthBottom(0.2f);
                cell.setBorderColorBottom(new Color(0, 0, 0));
                tb.addCell(cell);

                if (!"".equals(dd2[2])) {
                    pr = new Paragraph("资   产   名   称", font);
                    cell = new Cell(pr);
                    cell.setColspan(1);
                    cell.setBorderWidthBottom(0.2f);
                    cell.setBorderColorBottom(new Color(0, 0, 0));
                    tb.addCell(cell);
                } else {
                    cell = new Cell("");
                    cell.setColspan(1);
                    cell.setBorder(0);
                    tb.addCell(cell);
                }

                pr = new Paragraph("".equals(dd[1]) ? "无" : dd[1], font);
                cell = new Cell(pr);
                cell.setColspan(1);
                cell.setBorderWidthBottom(0.2f);
                cell.setBorderColorBottom(new Color(0, 0, 0));
                tb.addCell(cell);

                if (!"".equals(dd2[2])) {
                    pr = new Paragraph("".equals(dd2[1]) ? "无" : dd2[1], font);
                    cell = new Cell(pr);
                    cell.setColspan(1);
                    cell.setBorderWidthBottom(0.2f);
                    cell.setBorderColorBottom(new Color(0, 0, 0));
                    tb.addCell(cell);
                } else {
                    cell = new Cell("");
                    cell.setColspan(1);
                    cell.setBorder(0);
                    tb.addCell(cell);
                }

                i = i + 2;
            }
        }

        if ("2".equals(printType)) {
            Rectangle recn = new Rectangle(rec.width() * 80 / 210, rec.height());
            document = new com.lowagie.text.Document(recn, 0, 0, 0, 0);

            tb = new Table(2);
            tb.setPadding(1f);
            tb.setSpacing(0);
            tb.setAlignment(0);
            tb.setBorderWidth(0);

            Font font = new Font(baseFont, 10, Font.NORMAL);
            float w1 = rec.width() * 55 / 210;
            float w2 = rec.width() * 25 / 210;

            tb.setWidths(new float[] { w1, w2 });
            tb.setWidth(100);

            for (int i = 0; i < listData.size(); i++) {
                String[] dd = listData.get(i);

                Paragraph pr = new Paragraph("资   产   编   码", font);
                Cell cell = new Cell(pr);
                cell.setColspan(1);
                cell.setBorderWidthBottom(0.2f);
                cell.setBorderColorBottom(new Color(0, 0, 0));
                tb.addCell(cell);

                String imgPath = pdfPath + "/" + dd[2] + ".png";
                FileUtils.copyFile(fm.getFile(Long.valueOf(dd[2])), new File(imgPath));
                Image png = Image.getInstance(imgPath);
                png.scaleAbsolute(w2, w2);
                cell = new Cell(png);
                cell.setRowspan(4);
                cell.setBorder(0);
                tb.addCell(cell);

                pr = new Paragraph("".equals(dd[0]) ? "无" : dd[0], font);
                cell = new Cell(pr);
                cell.setColspan(1);
                cell.setBorderWidthBottom(0.2f);
                cell.setBorderColorBottom(new Color(0, 0, 0));
                tb.addCell(cell);

                pr = new Paragraph("资   产   名   称", font);
                cell = new Cell(pr);
                cell.setColspan(1);
                cell.setBorderWidthBottom(0.2f);
                cell.setBorderColorBottom(new Color(0, 0, 0));
                tb.addCell(cell);

                pr = new Paragraph("".equals(dd[1]) ? "无" : dd[1], font);
                cell = new Cell(pr);
                cell.setColspan(1);
                cell.setBorderWidthBottom(0.2f);
                cell.setBorderColorBottom(new Color(0, 0, 0));
                tb.addCell(cell);
            }
        }

        String fileId = UUIDUtil.getUUIDString();

        try {
            PdfWriter pw = PdfWriter.getInstance(document, new FileOutputStream(pdfPath + "/" + fileId + ".pdf"));
            pw.setEncryption(null, null, PdfWriter.AllowPrinting, PdfWriter.STRENGTH128BITS);
            pw.setViewerPreferences(1);
            document.open();
            document.add(tb);
            document.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (DocumentException e) {
            e.printStackTrace();
        }

        return new ModelAndView("redirect:/pdfshow/" + fileId + ".pdf");
    }

    public static void main(String[] args){
        System.out.println("999");
    }
}