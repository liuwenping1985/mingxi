
package com.seeyon.ctp.form.bean;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;

import www.seeyon.com.utils.UUIDUtil;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.lbs.manager.LbsManager;
import com.seeyon.ctp.common.lbs.vo.AttendanceListItem;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.office.MSignaturePicHandler;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.form.modules.engin.field.FormFieldCustomExtendDesignManager;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.ToRelationAttrType;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.ViewSelectType;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationEnums.ViewType;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationManager;
import com.seeyon.ctp.form.modules.engin.relation.FormRelationRecordDAO;
import com.seeyon.ctp.form.po.FormRelation;
import com.seeyon.ctp.form.po.FormRelationRecord;
import com.seeyon.ctp.form.service.FormCacheManager;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.form.util.Enums.BooleanType;
import com.seeyon.ctp.form.util.Enums.FieldAccessType;
import com.seeyon.ctp.form.util.Enums.FieldType;
import com.seeyon.ctp.form.util.Enums.FormAuthorizationType;
import com.seeyon.ctp.form.util.Enums.FormJsFun;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.form.util.Enums.FormatType;
import com.seeyon.ctp.form.util.Enums.InputTypeCategory;
import com.seeyon.ctp.form.util.Enums.MasterTableField;
import com.seeyon.ctp.form.util.Enums.OrgFormatType;
import com.seeyon.ctp.form.util.Enums.RelationDataCreatType;
import com.seeyon.ctp.form.util.FormConstant;
import com.seeyon.ctp.form.util.FormUtil;
import com.seeyon.ctp.form.util.StringUtils;
import com.seeyon.ctp.form.util.html.HTMLUtil;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.rest.resources.vo.FormFieldValue4AttrRestVO;
import com.seeyon.ctp.rest.resources.vo.FormFieldValue4EnumRestVO;
import com.seeyon.ctp.rest.resources.vo.FormFieldValue4HandwriteRestVO;
import com.seeyon.ctp.rest.resources.vo.FormFieldValue4LbsRestVO;
import com.seeyon.ctp.rest.resources.vo.FormFieldValueBaseRestVO;
import com.seeyon.ctp.rest.resources.vo.FormRelationFormRestVO;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;
import com.seeyon.v3x.system.signet.enums.V3xHtmSignatureEnum;
import com.seeyon.v3x.system.signet.manager.V3xHtmDocumentSignatManager;

/**
 * @author weijh
 */
public class FormFieldComBean {

    //必须熟悉id，name
    private static final String HTML_ID_NAME = "@htmlIdName@";
    //标签动态属性，如id=“field_0001” name=“field_0001”
    private static final String HTML_ATTRS = "@htmlAttrs@";
    //包裹控件的span标签的属性
    private static final String SPAN_ATTRS = "@spanAttrs@";
    //
    private static final String HIDDEN_ATTRS = "@hiddenAttrs@";
    //标签之间的值部分
    private static final String HTML_VALUE = "@htmlValue@";

    //用于标记图片枚举html,浏览及编辑状态
    private static final String IMAGE_ENUM_HTML_EDIT_KEY = "image_enum_html_edit_key";

    //用于标记流程处理意见
    private static final String FLOWDEALOPITION_SIGNET_KEY = "flowdealopition_signet_key";

    private static final Log LOGGER = CtpLogFactory.getLog(FormFieldComBean.class);

    private static final String ENUM_SELECT_CLASS = "enumselect";
    private static final String ID = "id";
    private static final String NAME = "name";
    public static final String DOUHAO = ",";
    public static final String DUNHAO = "、";
    public static final int SELECT_LEVEL = 0;
    public static final String SELECTED = "selected";

    //隐藏字段
    private static final String HIDDEN_HTML = "<span " + HIDDEN_ATTRS + " class=\"hide_class\"><span class=\"xdRichTextBox\" " + HTML_ATTRS + ">*</span></span>";
    public static final int EACH_CHAR_SIZE = 3;

    public enum FormFieldComEnum {
        /*---------------------------------------------------------------基础控件------------------------------------------------------------------*/
        TEXT("text", "form.input.inputtype.text.label", InputTypeCategory.BASE, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4URLPAGE, BooleanType.TRUE, BooleanType.TRUE), new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DECIMALOPTION, BooleanType.TRUE, BooleanType.TRUE)},
                "<span " + SPAN_ATTRS + "><input " + HTML_ATTRS + " onblur=\"" + FormJsFun.calc + "\" />" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox validate\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly type=\"text\" class=\"xdTextBox\" " + HTML_ATTRS + " /></span>"),

        TEXTAREA("textarea", "form.input.inputtype.textarea.label", InputTypeCategory.BASE, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR, FieldType.LONGTEXT},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4URLPAGE, BooleanType.TRUE, BooleanType.TRUE), new FieldRelationObj(FieldType.LONGTEXT, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><textarea onblur=\"" + FormJsFun.calc + "\" class=\"xdRichTextBox text_justify validate\" " + HTML_ATTRS + " >" + HTML_VALUE + "</textarea></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " " + HTML_ID_NAME + " class=\"xdRichTextBox text_justify\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><textarea readOnly class=\"xdRichTextBox text_justify validate\" " + HTML_ATTRS + "></textarea></span>"),

        CHECKBOX("checkbox", "form.input.inputtype.checkbox.label", InputTypeCategory.BASE, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 5, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.DECIMAL, 5, FormatType.FORMAT4DEFAULT, BooleanType.TRUE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"checkbox\" class=\"xdBehavior_Boolean radio_com validate\" " + HTML_ATTRS + " onclick=\"this.value=this.checked?1:0;" + FormJsFun.calc + "\"/></span>",
                "<span " + SPAN_ATTRS + "><input type=\"checkbox\" class=\"xdBehavior_Boolean radio_com\" disabled=\"true\" " + HTML_ATTRS + " /></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input  type=\"checkbox\" class=\"xdBehavior_Boolean validate\" " + HTML_ATTRS + "/></span>"),

        RADIO("radio", "form.input.inputtype.radio.label", InputTypeCategory.BASE, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DEFAULT, BooleanType.TRUE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\" >" + HTML_VALUE + "</span>"),

        SELECT("select", "form.input.inputtype.select.label", InputTypeCategory.BASE, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DEFAULT, BooleanType.TRUE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><select level=\"" + SELECT_LEVEL + "\" " + HTML_ID_NAME + " class=\"validate comp " + ENUM_SELECT_CLASS + " common_drop_down\" comp=\"type:'autocomplete',valueChange:" + FormJsFun.selectValueChangeCallBack.name() + ",autoSize:true\" " + HTML_ATTRS + ">" + HTML_VALUE + "</select></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><select " + HTML_ID_NAME + ">" + HTML_VALUE + "</select></span>"),

        EXTEND_DATE("date", "form.bind.datemodule.label", InputTypeCategory.BASE, BooleanType.TRUE, true,
                new FieldType[]{FieldType.TIMESTAMP},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.TIMESTAMP, -1, FormatType.FORMAT4TIMESTAMPOPTION, BooleanType.TRUE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly style=\"\" type=\"text\" " + HTML_ATTRS + " class=\"xdTextBox comp\" comp=\"type:'calendar',cache:false,isOutShow:true,isJustShowIcon:true,ifFormat:'%Y-%m-%d'\" /></span>"),

        EXTEND_DATETIME("datetime", "form.bind.date.label", InputTypeCategory.BASE, BooleanType.TRUE, true,
                new FieldType[]{FieldType.DATETIME},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.DATETIME, -1, FormatType.FORMAT4DEFAULT, BooleanType.TRUE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\"  " + HTML_ATTRS + " class=\"validate xdRichTextBox comp\"/></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly style=\"\" type=\"text\" " + HTML_ATTRS + " class=\"xdTextBox comp\" comp=\"type:'calendar',cache:false,isOutShow:true,isJustShowIcon:true,ifFormat:'%Y-%m-%d %H:%M'\" /></span>"),

        FLOWDEALOPITION("flowdealoption", "form.input.inputtype.flowdealoption.label", InputTypeCategory.BASE, BooleanType.FALSE, false,
                new FieldType[]{FieldType.VARCHAR, FieldType.LONGTEXT},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 4000, FormatType.FORMAT4FLOWDEALOPTION, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.LONGTEXT, -1, FormatType.FORMAT4FLOWDEALOPTION, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><span " + HTML_ID_NAME + " class=\"xdRichTextBox validate\" " + HTML_ATTRS + " >" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ID_NAME + " class=\"xdRichTextBox\" style=\"border-color:#cccccc;\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><textarea readOnly class=\"xdRichTextBox validate\" " + HTML_ATTRS + "></textarea></span>"),

        LABLE("lable", "form.input.inputtype.lable.label", InputTypeCategory.BASE, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.TRUE, BooleanType.TRUE), new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DECIMALOPTION, BooleanType.TRUE, BooleanType.TRUE)},
                "<span " + SPAN_ATTRS + "><span " + HTML_ID_NAME + " class=\"xdRichTextBox input-noborder1\" style=\"border-color:#cccccc;color:#000FFF;\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ID_NAME + " " + HTML_ATTRS + " class=\"xdRichTextBox input-noborder1\" style=\"border-color:#cccccc;color:#000FFF;\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly type=\"text\" class=\"xdTextBox validate input-noborder1\" " + HTML_ATTRS + " /></span>"),

        HANDWRITE("handwrite", "form.input.inputtype.handwrite.label", InputTypeCategory.BASE, BooleanType.FALSE, false,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><div style=\"display:inline-block;\"><input class=\"comp\" type=\"hidden\" " + HTML_ATTRS + "/></div></span>",
                "<span " + SPAN_ATTRS + "><div style=\"display:inline-block;\"><input class=\"comp\" type=\"hidden\" " + HTML_ATTRS + "/></div></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><div style=\"display:inline-block;\"><input class=\"comp\" type=\"hidden\" " + HTML_ATTRS + "/></div></span>"),
        BARCODE("barcode", "form.input.inputtype.barcode.label", InputTypeCategory.BASE, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4BARCODE, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly class=\"\" " + HTML_ATTRS + "/>" + HTML_VALUE + "<span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\"  disabled=\"true\" class=\"ico16 two_dimensional_code_scanning_16\"></span></span>"),
        LINE_NUMBER("linenumber", "form.input.extend.linenumber.label", InputTypeCategory.BASE, BooleanType.FALSE, false,
                new FieldType[]{FieldType.DECIMAL},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input " + HTML_ATTRS + " onblur=\"" + FormJsFun.calc + "\" />" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox validate\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><span " + HTML_ATTRS + " class=\"xdRichTextBox validate\">" + HTML_VALUE + "</span></span>"),
        /*---------------------------------------------------------------关联控件------------------------------------------------------------------*/
        RELATIONFORM("relationform", "form.create.input.select.relation.label", InputTypeCategory.RELATION, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL, FieldType.TIMESTAMP, FieldType.DATETIME, FieldType.LONGTEXT},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DECIMALOPTION, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.TIMESTAMP, -1, FormatType.FORMAT4TIMESTAMPOPTION, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.DATETIME, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.LONGTEXT, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input tyle=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" disabled=\"true\" class=\"ico16 correlation_form_16\" /></span></span>"),

        RELATION("relation", "form.input.inputtype.relation.label", InputTypeCategory.RELATION, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL, FieldType.TIMESTAMP, FieldType.DATETIME, FieldType.LONGTEXT},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.LONGTEXT, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DECIMALOPTION, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.TIMESTAMP, -1, FormatType.FORMAT4TIMESTAMPOPTION, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.DATETIME, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/></span>"),

        EXTEND_PROJECT("project", "form.input.inputtype.project.label", InputTypeCategory.RELATION, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.TRUE)},
                "<span " + SPAN_ATTRS + "><input " + HTML_ATTRS + " class=\"xdTextBox validate comp\" readonly type=\"text\"/></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly " + HTML_ATTRS + " class=\"xdTextBox\"/><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" disabled=\"true\" class=\"ico16 correlation_project_16\" /></span></span>"),

        /*---------------------------------------------------------------组织控件------------------------------------------------------------------*/
        EXTEND_MEMBER("member", "form.create.input.extendinput.selectuser.label", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4ORGOPTION, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\" onblur=\"" + FormJsFun.calc + "\" class=\"xdTextBox validate comp\" " + HTML_ATTRS + " readonly=\"true\" /></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input type=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span class=\"ico16 radio_people_16 _autoBtn\"></span></span>"),

        EXTEND_MULTI_MEMBER("multimember", "form.create.input.extendinput.multimember.label", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.LONGTEXT},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 4000, FormatType.FORMAT4ORGOPTION, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.LONGTEXT, -1, FormatType.FORMAT4ORGOPTION, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><textarea onblur=\"" + FormJsFun.calc + "\" class=\"comp validate\" " + HTML_ATTRS + " readonly=\"true\">" + HTML_VALUE + "</textarea></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><textarea readOnly " + HTML_ATTRS + "></textarea><span class=\"ico16 check_people_16 _autoBtn\"></span></span>"),

        EXTEND_ACCOUNT("account", "form.input.extend.selectaccount.label", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\" onblur=\"" + FormJsFun.calc + "\" class=\"xdTextBox validate comp\" " + HTML_ATTRS + " readonly=\"true\" /></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input type=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span class=\"ico16 radio_account_16 _autoBtn\"></span></span>"),

        EXTEND_MULTI_ACCOUNT("multiaccount", "form.input.extend.multiaccount.label", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.LONGTEXT},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 4000, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.LONGTEXT, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><textarea onblur=\"" + FormJsFun.calc + "\" class=\"comp validate\" " + HTML_ATTRS + " readonly=\"true\">" + HTML_VALUE + "</textarea></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><textarea readOnly " + HTML_ATTRS + "></textarea><span class=\"ico16 check_account_16 _autoBtn\"></span></span>"),

        EXTEND_DEPARTMENT("department", "form.input.extend.selectdepartment.label", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4ORGOPTION, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\" onblur=\"" + FormJsFun.calc + "\" class=\"comp validate\" " + HTML_ATTRS + " readonly=\"true\" /></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input type=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span class=\"ico16 radio_dept_16 _autoBtn\"></span></span>"),

        EXTEND_MULTI_DEPARTMENT("multidepartment", "form.input.extend.multidepartment.label", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.LONGTEXT},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 4000, FormatType.FORMAT4ORGOPTION, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.LONGTEXT, -1, FormatType.FORMAT4ORGOPTION, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><textarea onblur=\"" + FormJsFun.calc + "\" class=\"comp validate\" " + HTML_ATTRS + " readonly=\"true\">" + HTML_VALUE + "</textarea></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><textarea readOnly " + HTML_ATTRS + "></textarea><span class=\"ico16 check_dept_16 _autoBtn\"></span></span>"),

        EXTEND_POST("post", "form.input.extend.selectpost.label", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\" onblur=\"" + FormJsFun.calc + "\" class=\"xdTextBox validate comp\" " + HTML_ATTRS + " readonly=\"true\" /></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input type=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span class=\"ico16 radio_post_16 _autoBtn\"></span></span>"),

        EXTEND_MULTI_POST("multipost", "form.input.extend.multipost.label", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.LONGTEXT},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 4000, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.LONGTEXT, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><textarea onblur=\"" + FormJsFun.calc + "\" class=\"comp validate\" " + HTML_ATTRS + " readonly=\"true\">" + HTML_VALUE + "</textarea></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><textarea readOnly " + HTML_ATTRS + "></textarea><span class=\"ico16 check_post_16 _autoBtn\"></span></span>"),

        EXTEND_LEVEL("level", "form.input.extend.selectlevel.label", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\" onblur=\"" + FormJsFun.calc + "\" class=\"xdTextBox validate comp\" " + HTML_ATTRS + " readonly=\"true\" /></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input type=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span class=\"ico16 radio_level_16 _autoBtn\"></span></span>"),

        EXTEND_MULTI_LEVEL("multilevel", "form.input.extend.multilevel.label", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.LONGTEXT},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 4000, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.LONGTEXT, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><textarea onblur=\"" + FormJsFun.calc + "\" class=\"comp validate\" " + HTML_ATTRS + " readonly=\"true\">" + HTML_VALUE + "</textarea></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><textarea readOnly " + HTML_ATTRS + "></textarea><span class=\"ico16 check_level_16 _autoBtn\"></span></span>"),
        // 客开 start
        EXTEND_TEAM("team", "选择自定义组", InputTypeCategory.ORG, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\" onblur=\"" + FormJsFun.calc + "\" class=\"xdTextBox validate comp\" " + HTML_ATTRS + " readonly=\"true\" /></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input type=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span class=\"ico16 radio_team_16 _autoBtn\"></span></span>"),
        // 客开 end

        /*---------------------------------------------------------------扩展控件------------------------------------------------------------------*/
        EXTEND_ATTACHMENT("attachment", "form.input.extend.selectfile.label", InputTypeCategory.EXTEND, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + " >" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + " >" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly class=\"\" " + HTML_ATTRS + "/>" + HTML_VALUE + "<span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" disabled=\"true\" class=\"ico16 affix_16\" /></span></span>"),

        EXTEND_IMAGE("image", "form.input.extend.selectimage.label", InputTypeCategory.EXTEND, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly class=\"\" " + HTML_ATTRS + "/><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\"  disabled=\"true\" class=\"ico16 insert_pic_16\"></span>" + HTML_VALUE + "</span>"),

        EXTEND_DOCUMENT("document", "form.input.extend.document.label", InputTypeCategory.EXTEND, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly " + HTML_ATTRS + " class=\"xdTextBox\"/><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" disabled=\"true\" class=\"ico16 associated_document_16\" ></span></span>"),

        OUTWRITE("outwrite", "form.input.inputtype.externalwrite.label", InputTypeCategory.EXTEND, BooleanType.TRUE, true,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL, FieldType.TIMESTAMP, FieldType.DATETIME},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4OUTWRITEOPTION, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DECIMALOPTION, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.TIMESTAMP, -1, FormatType.FORMAT4TIMESTAMPOPTION, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.DATETIME, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\" class=\"xdTextBox validate\" " + HTML_ATTRS + " readonly='true' /></span>",
                "<span " + SPAN_ATTRS + "><span class=\"xdRichTextBox\" " + HTML_ATTRS + ">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly type=\"text\" class=\"xdTextBox\" " + HTML_ATTRS + "/></span>"),

        PREPAREWRITE("externalwrite-ahead", "form.input.inputtype.externalwrite_ahead.label", InputTypeCategory.EXTEND, BooleanType.TRUE, false,
                new FieldType[]{FieldType.DECIMAL},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DECIMALOPTION, BooleanType.FALSE, BooleanType.TRUE)},
                "<span " + SPAN_ATTRS + "><span " + HTML_ID_NAME + " class=\"xdRichTextBox\" style=\"word-wrap:break-word\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ID_NAME + " class=\"xdRichTextBox\" style=\"word-wrap:break-word\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly type=\"text\" class=\"xdTextBox\" " + HTML_ATTRS + "/></span>"),

        EXTEND_EXCHANGETASK("exchangetask", "form.input.extend.selectdeetask.label", InputTypeCategory.EXTEND, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL, FieldType.TIMESTAMP, FieldType.DATETIME},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.TIMESTAMP, -1, FormatType.FORMAT4TIMESTAMPOPTION, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.DATETIME, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input onblur=\"" + FormJsFun.calc + "\" readOnly class=\"xdTextBox validate\" " + HTML_ATTRS + "  /><span onmouseover=\"this.style.cursor='pointer'\" onclick=\"" + FormJsFun.extendEvent + "\" class=\"ico16 data_task_16\"></span></span>",
                "<span " + SPAN_ATTRS + "><span class=\"xdRichTextBox\" " + HTML_ATTRS + ">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span onmouseover=\"this.style.cursor='pointer'\" disabled=\"true\"  class=\"ico16 data_task_16\"></span></span>"),

        EXTEND_QUERYTASK("querytask", "form.input.extend.searchdeetask.label", InputTypeCategory.EXTEND, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL, FieldType.TIMESTAMP, FieldType.DATETIME},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.DECIMAL, 20, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.TIMESTAMP, -1, FormatType.FORMAT4TIMESTAMPOPTION, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.DATETIME, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input onblur=\"" + FormJsFun.calc + "\" class=\"xdTextBox validate\" " + HTML_ATTRS + " readonly=\"true\" /><span onmouseover=\"this.style.cursor='pointer'\" onclick=\"" + FormJsFun.extendEvent + "\" class=\"ico16 search_16\"></span></span>",
                "<span " + SPAN_ATTRS + "><span class=\"xdRichTextBox\" " + HTML_ATTRS + ">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span onmouseover=\"this.style.cursor='pointer'\" disabled=\"true\" class=\"ico16 search_16\"></span></span>"),

        /*---------------------------------------------------------------地图位置控件------------------------------------------------------------------*/
        MAP_MARKED("mapmarked", "form.input.map.mapmarked.label", InputTypeCategory.MAP, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 20, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\" onblur=\"" + FormJsFun.calc + "\" class=\"xdTextBox validate comp\" " + HTML_ATTRS + " readonly=\"true\" /></span>",
                "<span " + SPAN_ATTRS + "><input type=\"text\" class=\"xdTextBox comp\" " + HTML_ATTRS + " readonly=\"true\" /></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input tyle=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" disabled=\"true\" class=\"ico16 mapMarked_16\" /></span></span>"),

        MAP_LOCATE("maplocate", "form.input.map.maplocate.label", InputTypeCategory.MAP, BooleanType.FALSE, false,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 20, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\" onblur=\"" + FormJsFun.calc + "\" class=\"xdTextBox validate comp\" " + HTML_ATTRS + " readonly=\"true\" /></span>",
                "<span " + SPAN_ATTRS + "><input type=\"text\" class=\"xdTextBox comp\" " + HTML_ATTRS + " readonly=\"true\"/></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input tyle=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" disabled=\"true\" class=\"ico16 location_16\" /></span></span>"),

        MAP_PHOTO("mapphoto", "form.input.map.mapphoto.label", InputTypeCategory.MAP, BooleanType.FALSE, false,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 20, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><input type=\"text\" class=\"comp\" " + HTML_ATTRS + " readonly=\"true\" /></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox\">" + HTML_VALUE + "</span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input tyle=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" disabled=\"true\" class=\"ico16 cameraPosition_16\" /></span></span>"),

        /*---------------------------------------------------------------自定义控件------------------------------------------------------------------*/
        CUSTOM_CONTROL("customcontrol", "form.input.extend.customcontrol.label", InputTypeCategory.CUSTOM, BooleanType.TRUE, false,
                new FieldType[]{FieldType.VARCHAR, FieldType.DECIMAL, FieldType.TIMESTAMP, FieldType.DATETIME, FieldType.LONGTEXT},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.DECIMAL, 15, FormatType.FORMAT4DECIMALOPTION, BooleanType.FALSE, BooleanType.TRUE), new FieldRelationObj(FieldType.TIMESTAMP, -1, FormatType.FORMAT4TIMESTAMPOPTION, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.DATETIME, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE), new FieldRelationObj(FieldType.LONGTEXT, -1, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + ">" + HTML_VALUE + "</span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input tyle=\"text\" readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" disabled=\"true\" class=\"ico16 correlation_form_16\" /></span></span>"),

        CUSTOM_PLAN("customplan", "form.input.extend.customplan.label", InputTypeCategory.CUSTOM, BooleanType.FALSE, false,
                new FieldType[]{FieldType.VARCHAR},
                new FieldRelationObj[]{new FieldRelationObj(FieldType.VARCHAR, 255, FormatType.FORMAT4DEFAULT, BooleanType.FALSE, BooleanType.FALSE)},
                "<span " + SPAN_ATTRS + "><textarea class=\"xdRichTextBox text_justify validate\" " + HTML_ATTRS + " onblur=\"" + FormJsFun.calc + "\">" + HTML_VALUE + "</textarea><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" class=\"ico16 correlation_form_16\" onclick=\"selectPlan(this)\"></span></span>",
                "<span " + SPAN_ATTRS + "><span " + HTML_ATTRS + " class=\"xdRichTextBox text_justify validate\">" + HTML_VALUE + "</span><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" class=\"ico16 correlation_form_16\" onclick=\"selectPlan(this)\"></span></span>",
                "<span " + SPAN_ATTRS + " onClick=\"" + FormJsFun.designLinkageList + "\"><input readOnly class=\"xdTextBox\" " + HTML_ATTRS + "/><span style=\"CURSOR: pointer\" onmouseover=\"this.style.cursor='pointer'\" class=\"ico16 correlation_form_16\"></span></span>");

        //控件类型名称
        private String key;
        //控件显示名称
        private String text;
        //控件类别
        private InputTypeCategory category;
        //是否可以被关联
        private BooleanType canRelation;
        //是否有extend函数
        private boolean canExtend;
        //该控件能显示那种类型的数据，可能是多种，所以用数组表示
        private FieldType[] fieldType;
        //控件、字段相关联的一些属性，比如是否需要显示计算式输入框，是否有显示格式
        private FieldRelationObj[] fieldRelationObjArray;
        //编辑状态html
        private String editHtml;
        //浏览状态html
        private String browseHtml;
        //表单编辑状态控件html
        private String designHtml;

        /**
         * 构造方法
         *
         * @param key                   控件类型名称
         * @param text                  控件显示名称
         * @param category              控件类别
         * @param canRelation           是否可以被关联
         * @param fieldType             该控件能显示那种类型的数据，可能是多种，所以用数组表示
         * @param fieldRelationObjArray 录入及字段类型相关联的一些弱属性，比如：是否可以设置计算表达式
         * @param editHtml              编辑状态html
         * @param browseHtml            浏览状态html
         */
        private FormFieldComEnum(String key, String text, InputTypeCategory category, BooleanType canRelation, boolean canExtend, FieldType[] fieldType, FieldRelationObj[] fieldRelationObjArray, String editHtml, String browseHtml, String designHtml) {
            this.key = key;
            this.text = text;
            this.category = category;
            this.canRelation = canRelation;
            this.canExtend = canExtend;
            this.fieldType = fieldType;
            this.fieldRelationObjArray = fieldRelationObjArray;
            this.editHtml = editHtml;
            this.browseHtml = browseHtml;
            this.designHtml = designHtml;
        }

        /**
         * 表单单元格控件html字符串获取方法
         *
         * @param form
         * @param fieldBean
         * @param auth
         * @param data      单元格所属动态表的数据对象（主表字段必须是传递FormDataMasterBean，子表字段必须传递FormDataSubBean）
         * @return
         * @throws NumberFormatException
         * @throws BusinessException
         */
        public static String getHTML(FormBean form, FormFieldBean fieldBean, FormAuthViewFieldBean auth, FormDataBean data) throws NumberFormatException, BusinessException {
            return getHTML(form, fieldBean, auth, data, true);
        }

        /**
         * 用于获取控件对应的样式
         *
         * @param form      表单bean
         * @param fieldBean 字段bean
         * @param value     单元格值
         * @return
         * @throws NumberFormatException
         * @throws BusinessException
         */
        public static String getHTML(FormBean form, FormFieldBean fieldBean, Object value) throws NumberFormatException, BusinessException {
            String html = getHTML(form, fieldBean, new FormAuthViewFieldBean(fieldBean), value, false);
            if (fieldBean.getFormRelation() != null && !fieldBean.getFormRelation().isFormRelationFlow()) {//测试要求,取样式的时候，只有流程标题才显示关联表单图标
                html = html.replace("ico16 correlation_form_16", "");//去掉关联表单查看来源按钮
            }
            return html;
        }

        /**
         * 表单控件输出HTML
         * 包括：ID、名称、样式（class、style）、显示格式化、数据校验规则、事件、权限
         *
         * @param form      表单bean
         * @param fieldBean 字段bean
         * @param auth      单元格权限bean
         * @param value     单元格值
         * @param bizModel  是表是表单业务查看模式： 如果不是 需要清除一些事件onblur与onchange，和执行一些单独逻辑
         * @param valMap    可选参数 某些控件特殊参数
         * @return 该单元格填好值的html字符串
         * @throws NumberFormatException
         * @throws BusinessException
         */
        public static String getHTML(FormBean form, FormFieldBean fieldBean, FormAuthViewFieldBean auth, Object value, boolean bizModel) throws NumberFormatException, BusinessException {
            return getHTML(form, fieldBean, auth, null, value, null, bizModel);
        }

        public static String getHTML(FormBean form, FormFieldBean fieldBean, FormAuthViewFieldBean auth, Object value, FormDataBean dataBean, boolean bizModel) throws NumberFormatException, BusinessException {
            if (dataBean == null) {
                return getHTML(form, fieldBean, auth, null, value, null, bizModel);
            } else {
                return getHTML(form, fieldBean, auth, null, dataBean, null, bizModel);
            }
        }

        /**
         * 表单控件输出HTML
         * 包括：ID、名称、样式（class、style）、显示格式化、数据校验规则、事件、权限
         *
         * @param form      表单bean
         * @param fieldBean 字段bean
         * @param auth      单元格权限bean
         * @param before    前面部分所加值
         * @param obj     单元格值
         * @param after     后面部分所加值
         * @param bizModel  是表是表单业务查看模式： 如果不是 需要清除一些事件onblur与onchange，和执行一些单独逻辑
         * @return 该单元格填好值的html字符串
         * @throws NumberFormatException
         * @throws BusinessException
         */
        private static String getHTML(FormBean form, FormFieldBean fieldBean, FormAuthViewFieldBean auth, String before, Object obj, String after, boolean bizModel) throws NumberFormatException, BusinessException {
            /******************************************************数据构造部分start**************************************************************/
            Long recordId = 0l;//主表数据无行号
            //自定义控件第二次调用该方法的时候没有传FormDataBean，导致recordId为0，如果自定义控件在重复行里面，
            // 就会导致M3端增加行有问题,返回给前端的是两行，而且Id为0的哪一行字段不全，导致报错
            if(!StringUtil.checkNull(String.valueOf(fieldBean.getExtraAttr("CUSTOM_CONTROL_RECORDID")))){
                recordId = Long.valueOf(String.valueOf(fieldBean.getExtraAttr("CUSTOM_CONTROL_RECORDID")));
            }
            FormDataBean data = null;
            FormDataMasterBean masterData = null;
            Object value = obj;
            //如果VALUE是表单动态表对象
            if (value instanceof FormDataBean) {
                data = (FormDataBean) value;
                if (data instanceof FormDataSubBean) {//从表数据对应的行号
                    masterData = ((FormDataSubBean) data).getMasterData();
                    recordId = data.getId();
                } else if (data instanceof FormDataMasterBean) {
                    masterData = (FormDataMasterBean) data;
                    if (data.getExtraAttr("recordId") != null) {
                        recordId = (Long) data.getExtraAttr("recordId");
                        data.getExtraMap().remove("recordId");
                    }
                }
                value = data.getFieldValue(fieldBean.getName());
            }
            /******************************************************数据构造部分end**************************************************************/

            if (auth == null) {
                return "";
            }
            boolean isNotNull = auth.getIsNotNull() == 1 ? true : false;
            boolean isSerialNumber = fieldBean.isSn();
            //如果是流水号，不用必填校验
            if (isSerialNumber) {
                isNotNull = false;
            }
            String access = auth.getAccess();//单元格权限
            //编辑权限下，如果单元格是计算结果字段，需要将权限强制转换成浏览权限
            if (bizModel && (fieldBean.isCalcField() || form.checkFieldIsSubResult(fieldBean.getName(), fieldBean.getOwnerTableName())) && (access.equals(FieldAccessType.edit.getKey()) || access.equals(FieldAccessType.add.getKey()))) {
                access = FieldAccessType.browse.getKey();
            }
            Map<String, String> htmlAttrData = new HashMap<String, String>();
            String htmlStr = null;

            //-----------------------------第一步：处理数据---------------------------------------------
            //枚举名称在H5端不用tohtml，前端统一处理。
            boolean needToHtml = true;
            if(FormUtil.isH5() && FormFieldComEnum.SELECT == fieldBean.getInputTypeEnum()){
                needToHtml = false;
            }
            Object[] valuesWithDisplay = fieldBean.getDisplayValue(value, needToHtml, false);
            // 客开 start
            String tt = String.valueOf(valuesWithDisplay[1]);
            if (tt != null && tt.matches("^Team\\|-?[0-9]+$")) {
            	String[] vdteam = tt.split("\\|");
        		tt = Functions.getTeamName(Long.valueOf(vdteam[1]));
        		valuesWithDisplay[1] = tt;
            }
            // 客开 end
            String value4Db = valuesWithDisplay[0] == null ? "" : String.valueOf(valuesWithDisplay[0]);
            String value4Display = String.valueOf(valuesWithDisplay[1]);
            String value4Bussiness = String.valueOf(valuesWithDisplay[2]);
            FormFieldComEnum itEnum = null;
            //
            if (!FieldAccessType.hide.getKey().equals(access)) {
                htmlAttrData.put(ID, fieldBean.getName());
                htmlAttrData.put(NAME, fieldBean.getName());
            }
            //当前单元格是否参与计算判断条件
            htmlAttrData.put("inCalculate", "" + fieldBean.isInCalculate());
            //在无流程表单情况（基础数据和信息管理）下,设置当前单元格是否是其他单元格系统关联的条件
            htmlAttrData.put("inCondition", "" + fieldBean.isInCondition());
            //在无流程表单情况（基础数据和信息管理）下,设置当前单元格是否是设置了数据唯一
            htmlAttrData.put("unique", "" + fieldBean.isUnique());
            FieldType fieldType = FieldType.getEnumByKey(fieldBean.getFieldType().toUpperCase());
            itEnum = fieldBean.getInputTypeEnum();

            if (Strings.isNotEmpty(fieldBean.getFieldStyle())) { //控件值样式
                Map<String, Object> fieldStyleMap = (Map<String, Object>) JSONUtil.parseJSONString(fieldBean.getFieldStyle());
                if (fieldStyleMap != null) {
                    htmlAttrData.put("style", (String) fieldStyleMap.get("fieldFontStyle"));
                }
            }
            /*****************************start,H5化，在此处将改变的字段放入线程变量***********************/
            boolean h5Tag = FormUtil.isH5();
            FormFieldValueBaseRestVO restVo = null;
            String fieldKey;
            if(fieldBean.isMasterField()){
                fieldKey = fieldBean.getName();
            }else{
                fieldKey = fieldBean.getName() + FormConstant.DOWNLINE + recordId;
            }
            if(h5Tag){
	            Map<String,FormFieldValueBaseRestVO> restFieldList = (Map<String,FormFieldValueBaseRestVO>)AppContext.getThreadContext(FormConstant.REST_FORM_CHANGE_FIELD_INFO);
	            if(restFieldList == null){
	                restFieldList = new HashMap<String,FormFieldValueBaseRestVO>();
	                AppContext.putThreadContext(FormConstant.REST_FORM_CHANGE_FIELD_INFO, restFieldList);
	            }
	            restVo = FormFieldValueBaseRestVO.getInstance(itEnum);
                restVo.setFieldName(fieldBean.getName());
                restVo.setOwnerTableName(fieldBean.getOwnerTableName());
                restVo.setValue(value4Db);
                restVo.setDisplay(value4Display);
	            restVo.setAuth(access);//当前单元格权限
	            restVo.setNotNull(isNotNull);//是否必填
                if(FieldAccessType.browse.getKey().equals(access)){
                    //计算结果字段如果为必填的，强制做成false
                    if(fieldBean.isCalcField() || form.checkFieldIsSubResult(fieldBean.getName(), fieldBean.getOwnerTableName())) {
                        restVo.setNotNull(false);
                    }
                }
	            restFieldList.put(fieldKey,restVo);
            }
            /*****************************end***********************/

            /*-----------------------------第二步：表单单元格校验属性设置---------------------------------------------*/
            switch (fieldType) {
                case DECIMAL:
                    if (access.equals(FieldAccessType.edit.getKey())) {
                        //如果包含小数位
                        if (!StringUtil.checkNull(fieldBean.getDigitNum())) {
                            //maxLength 校验会把小数点和小数部分都加入验证
                            //使用max最大值验证吧。
                            /*Double max = Math.pow(10d, Double.parseDouble((Integer.parseInt(fieldBean.getFieldLength())-Integer.parseInt(fieldBean.getDigitNum())+"")));
                        	DecimalFormat df = new DecimalFormat("#");
                        	String maxStr = df.format(max);*/
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",isNumber:true,decimalDigits:" + fieldBean.getDigitNum() + ",maxLength:" + fieldBean.getFieldLength() + ",integerDigits:" + (Integer.parseInt(fieldBean.getFieldLength()) - Integer.parseInt(fieldBean.getDigitNum())) + ",maxEqual:false,minEqual:false,notNull:" + (isNotNull) + "");
                        } else {
                            htmlAttrData.put("validate", "isInteger:true,notNull:" + isNotNull + ",maxLength:" + fieldBean.getFieldLength());
                        }
                        if (!StringUtil.checkNull(fieldBean.getDigitNum()) && !"0".equals(fieldBean.getDigitNum())) {
                            htmlAttrData.put("comp", "type:\"onlyNumber\",numberType:\"float\",decimalDigit:" + fieldBean.getDigitNum() + "");
                        } else {
                            htmlAttrData.put("comp", "type:\"onlyNumber\"");
                        }
                    } else if (access.equals(FieldAccessType.browse.getKey())) {
                        //如果包含小数位
                        if (!StringUtil.checkNull(fieldBean.getDigitNum())) {
                            //maxLength 校验会把小数点和小数部分都加入验证
                            //使用max最大值验证吧。
                            /*Double max = Math.pow(10d, Double.parseDouble((Integer.parseInt(fieldBean.getFieldLength())-Integer.parseInt(fieldBean.getDigitNum())+"")));
                            DecimalFormat df = new DecimalFormat("#");
                            String maxStr = df.format(max);*/
                            if (fieldBean.getFormRelation() != null && fieldBean.getFormRelation().isFormRelation()) {
                                htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",isNumber:true,decimalDigits:" + fieldBean.getDigitNum() + ",maxLength:" + fieldBean.getFieldLength() + ",integerDigits:" + (Integer.parseInt(fieldBean.getFieldLength()) - Integer.parseInt(fieldBean.getDigitNum())) + ",maxEqual:false,minEqual:false,notNull:" + isNotNull);
                            } else {
                                htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",isNumber:true,decimalDigits:" + fieldBean.getDigitNum() + ",maxLength:" + fieldBean.getFieldLength() + ",integerDigits:" + (Integer.parseInt(fieldBean.getFieldLength()) - Integer.parseInt(fieldBean.getDigitNum())) + ",maxEqual:false,minEqual:false");
                            }
                        } else {
                            if (fieldBean.getFormRelation() != null && fieldBean.getFormRelation().isFormRelation()) {
                                htmlAttrData.put("validate", "isInteger:true,maxLength:" + fieldBean.getFieldLength() + ",notNull:" + isNotNull);
                            } else {
                                htmlAttrData.put("validate", "isInteger:true,maxLength:" + fieldBean.getFieldLength());
                            }
                        }
                    }
                    break;
                case TIMESTAMP:
                    if (access.equals(FieldAccessType.edit.getKey())) {
                        htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldType.getKey() + "\",notNull:" + (isNotNull) + ",errorMsg:\"" + fieldBean.getDisplay() + ResourceUtil.getString("form.base.timeStamp.alert") + "\",errorAlert:true,errorIcon:false,func:validateDataTime");
                    } else {
                        if (fieldBean.getFormRelation() != null && fieldBean.getFormRelation().isFormRelation()) {
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldType.getKey() + "\",errorMsg:\"" + fieldBean.getDisplay() + ResourceUtil.getString("form.base.timeStamp.alert") + "\",errorAlert:true,errorIcon:false,func:validateDataTime,notNull:" + isNotNull);
                        } else {
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldType.getKey() + "\",errorMsg:\"" + fieldBean.getDisplay() + ResourceUtil.getString("form.base.timeStamp.alert") + "\",errorAlert:true,errorIcon:false,func:validateDataTime");
                        }
                    }
                    break;
                case DATETIME:
                    if (access.equals(FieldAccessType.edit.getKey())) {
                        htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldType.getKey() + "\",notNull:" + (isNotNull) + ",errorMsg:\"" + fieldBean.getDisplay() + ResourceUtil.getString("form.base.dateTime.alert") + "\",errorAlert:true,errorIcon:false,func:validateDataTime");
                    } else {
                        if (fieldBean.getFormRelation() != null && fieldBean.getFormRelation().isFormRelation()) {
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldType.getKey() + "\",notNull:" + (isNotNull) + ",errorMsg:\"" + fieldBean.getDisplay() + ResourceUtil.getString("form.base.dateTime.alert") + "\",errorAlert:true,errorIcon:false,func:validateDataTime");
                        } else {
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldType.getKey() + "\",errorMsg:\"" + fieldBean.getDisplay() + ResourceUtil.getString("form.base.dateTime.alert") + "\",errorAlert:true,errorIcon:false,func:validateDataTime");
                        }
                    }
                    break;
                case VARCHAR:
                    if (access.equals(FieldAccessType.edit.getKey()) || access.equals(FieldAccessType.add.getKey())) {
                        if (itEnum.isOrg()||itEnum.getKey().equals(EXTEND_PROJECT.getKey())) {
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",type:\"string\",china3char:true,notNull:" + (isNotNull) + "");
                        } else {
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",type:\"string\",china3char:true,maxLength:" + fieldBean.getMaxLength() + ",notNull:" + (isNotNull) + "");
                        }
                    } else {
                        //BUG_普通_V5_V5.6SP1_上海驿联商务咨询服务有限公司_关联表单-用户选择，选择关联表单的控件设置必填后，不关联任何内容也能发送_20160803023447
                        if (fieldBean.getFormRelation() != null && fieldBean.getFormRelation().getToRelationAttrType() != null) {
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",type:\"string\",china3char:true,maxLength:" + fieldBean.getMaxLength() + ",notNull:" + (isNotNull) + "");
                        } else {
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",type:\"string\",china3char:true,maxLength:" + fieldBean.getMaxLength());
                        }
                    }
                    break;
                case LONGTEXT:
                    if (access.equals(FieldAccessType.edit.getKey()) || access.equals(FieldAccessType.add.getKey())) {
                        htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",type:\"string\",notNull:" + (isNotNull) + "");
                    } else {
                        if (fieldBean.getFormRelation() != null && fieldBean.getFormRelation().isFormRelation()) {
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",type:\"string\",notNull:" + (isNotNull) + "");
                        } else {
                            htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",type:\"string\"");
                        }
                    }
                    break;
            }
            /*-----------------------------第三步：根据不同枚举类型获取控件html展示字符串---------------------------------------------*/
            //if(formFieldExtend==null){
            switch (itEnum) {
                case LINE_NUMBER:
                    if (bizModel) {
                        if (FieldAccessType.edit.getKey().equals(access)) {
                            FormAuthViewFieldBean cloneAuth = null;//关联表单只能使用被关联单元格控件的浏览权限的样式
                            try {
                                cloneAuth = (FormAuthViewFieldBean) auth.clone();
                                cloneAuth.setAccess(FieldAccessType.browse.getKey());
                            } catch (CloneNotSupportedException e) {
                                LOGGER.error(e.getMessage(), e);
                            }
                            return getHTML(form, fieldBean, cloneAuth, value, bizModel);
                        }
                    } else {
                        try {
                            FormFieldBean cloneFieldBean4outwrite = (FormFieldBean) fieldBean.clone();
                            cloneFieldBean4outwrite.setInputType(FormFieldComEnum.TEXT.getKey());
                            return getHTML(form, cloneFieldBean4outwrite, auth, value, bizModel);
                        } catch (CloneNotSupportedException e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                    }
                    break;
                case TEXT://InputType.TEXT 文本框
                    if (isSerialNumber && (FieldAccessType.edit.getKey().equals(access) || FieldAccessType.add.getKey().equals(access))) {//权限中初始值-流水号使用span
                        access = FieldAccessType.browse.getKey();
                        if (h5Tag) {
                            restVo.setAuth(access);
                        }
                    }
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        if (isSerialNumber && bizModel) {
                            htmlAttrData.put("readonly", "readonly");
                            htmlAttrData.put("disabled", "disabled");
                            htmlAttrData.put("title", value4Bussiness == null ? "" : value4Bussiness);
                        }
                        if (FieldType.getEnumByKey(fieldBean.getFieldType().toUpperCase()) == FieldType.DECIMAL) {
                            if (!bizModel) {//数字类型 并且是非业务数据下 默认0去掉
                                value4Display = value4Db = String.valueOf(value == null ? "" : value);
                            }
                            //数据关联-一个设置有显示格式的单元格（比如显示格式为天-时-分的字段），需要将value字段设置为数据库中存储的值，否则提交的时候会校验不通过
                            if (fieldBean.getFormatType() != null) {
                                htmlAttrData.put("value", value4Db);
                            } else {
                                htmlAttrData.put("value", value4Bussiness);
                            }
                            htmlAttrData.put("class", "xdTextBox comp validate");
                            //htmlAttrData.put("style", "border-color:black;") ;
                        } else {
                            htmlAttrData.put("value", value4Display.replaceAll("\'", "&#039;"));//文本编辑态其中如果有单引号的话 放在value=''的单引号中会引起错误
                            htmlAttrData.put("class", "xdTextBox validate");
                            //htmlAttrData.put("style", "line-height:150%;border-color:black;") ;
                        }
                        if (!StringUtil.checkNull(fieldBean.getFormatType())) {
                            value4Display = fieldBean.getFormatHtmlStr(htmlAttrData, value4Display);
                        } else {
                            htmlAttrData.put("value", value4Display.replaceAll("\'", "&#039;"));
                            htmlAttrData.put("type", "text");
                            value4Display = "";
                        }
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        if (value4Display == null) {
                            value4Display = "";
                        }
                        //关联流程名称如果勾选了显示流程 不需要调用Strings.toHTML进行转换html特殊字符
                        if (value4Display.indexOf("<span class=\"ico16 process_max_16\">") == -1) {
                            value4Display = Strings.toHTML(value4Display, false);
                        }
                        if (before != null) {
                            value4Display = before + value4Display;
                        }
                        if (after != null) {
                            value4Display = value4Display + after;
                        }
                        if (FormConstant.URL_PAGE.equals(fieldBean.getFormatType())) {
                        	if(!h5Tag){
                        		value4Display = HTMLUtil.parseURL2Page(value4Display);
                        	}
                        } else if (fieldType != FieldType.DECIMAL) {
                            value4Display = HTMLUtil.parseURL(value4Display);
                        }
                        //替换部分空格为&nbsp;
                        if(!FormConstant.URL_PAGE.equals(fieldBean.getFormatType()) && fieldType != FieldType.DECIMAL){
                            value4Display = replaceMutiSpace(value4Display);
                        }
                    }
                    break;
                case LABLE://InputType.LABLE 标签
                    if (bizModel) {
                        if (FieldAccessType.edit.getKey().equals(access)) {
                            if (StringUtil.checkNull(value4Bussiness)) {
                                value4Bussiness = "";
                            }
                        }
                        value4Display = Strings.toHTML(value4Display);
                    } else {
                        try {
                            FormFieldBean cloneFieldBean4outwrite = (FormFieldBean) fieldBean.clone();
                            cloneFieldBean4outwrite.setInputType(FormFieldComEnum.TEXT.getKey());
                            return getHTML(form, cloneFieldBean4outwrite, auth, Strings.toHTML(String.valueOf(value)), bizModel);
                        } catch (CloneNotSupportedException e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                    }

                    break;
                case TEXTAREA://InputType.TEXTAREA 文本域
                    	/*List<FormViewBean> formViewBeans = form.getFormViewList();
                    	boolean isAdd = false;
                    	for(FormViewBean formViewBean : formViewBeans){
                    		if(formViewBean!=null){
                    			List<FormAuthViewBean> formAuths = formViewBean.getAllOperations();
                    			for(FormAuthViewBean formAuth:formAuths){
                    				if(formAuth!=null){
                    					FormAuthViewFieldBean fieldAuth = formAuth.getFormAuthorizationField(fieldBean.getName());
                    					if(fieldAuth!=null){
                    						if(FieldAccessType.add.getKey().equals(fieldAuth.getAccess())){
                    							isAdd = true;
                    	                    	break;
                    						}
                    					}
                    				}
                    			}
                    			if(isAdd){
                    				break;
                    			}
                    		}
                    	}
                    	if(isAdd){
                    		//不知道是什么环境下会出现不换行的数据，此处兼容处理下，强制加上换行符
	                    	if(value4Display!=null&&value4Display.indexOf("[")!=-1&&value4Display.indexOf("]")!=-1){
	                    		value4Display = value4Display.replaceAll("([^\\[\\]\\s]*)([\\s]*)(\\[[^\\[\\]]*\\])([\\s]*)", "$1\n\t$3\n\n");
	                    		value4Display = StringUtils.replaceLast(value4Display, "\n\n", "");
	                    	}
                    	}*/
                    if (FieldAccessType.add.getKey().equals(access)) {
                        htmlAttrData.put("onClick", FormJsFun.addarea.toString());
                        htmlAttrData.put("readonly", "true");
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        //BUG_紧急_V5_V5.6_嘉里置业中国（投资）有限公司_文本域中填写单词，一行的最后一个单词如果显示不下并且是自动换行的，发出后，最后一个单词会分成两行显示。如果手动换行填写单词，发出后就没问题
                        //经过反复试验，发现是由于文本中的空格被转行为&nbsp;之后导致的，由于这个原因，所以将空格不做转换，所以将此处的参数true改为false
                        //问题2：如果不替换空格，打印的时候如果前面有空格，在ie下不会体现首行缩进的效果,BUG_普通_V5_V5.6SP1_中国国际贸易中心有限公司_文本域首行空两格，打印后没有缩进
                        value4Display = Strings.toHTML(value4Display,false);//由于替换了空格为&nbsp;，导致英文单词没有自动换行，这里将英文单词中间的&nbsp;替换回来为空格
                        if(Strings.isNotBlank(value4Display)){
                            value4Display = replaceMutiSpace(value4Display);
                        }
                        if (FormConstant.URL_PAGE.equals(fieldBean.getFormatType())) {
                        	if(!h5Tag){
                        		value4Display = HTMLUtil.parseURL2Page(value4Display);
                        	}
                        } else {
                            value4Display = HTMLUtil.parseURL(value4Display);
                        }
                        //编辑权限，且显示格式为url时才校验
                    } else if (FieldAccessType.edit.getKey().equals(access) && FormConstant.URL_PAGE.equals(fieldBean.getFormatType())) {
                        htmlAttrData.put("validate", htmlAttrData.get("validate") + ",func:validateUrl,errorMsg:\"" + fieldBean.getDisplay() + ResourceUtil.getString("form.designauth.defaultvalue.url") + "\",errorAlert:true,errorIcon:false");
                    }
                    break;
                case FLOWDEALOPITION://流程处理意见控件
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        htmlAttrData.put("readonly", "false");
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        value4Display = value4Bussiness;
                    } else if (FieldAccessType.add.getKey().equals(access)) {
                        htmlAttrData.put("readonly", "false");
                    }
                    Map<String, Object> resMap = FormUtil.getFlowDealSignetHtml(Strings.toHTML(value4Db, false));
                    String html = (String) resMap.get("html");
                    boolean hasSignet = (Boolean) resMap.get("hasSignet");
                    if (hasSignet) {
                        String fieldName = fieldBean.getName();
                        //OA-105487签名为印章的流程意见字体颜色与权限一样
                        String startSpanStr = "<span id=\"" + fieldName + "_span\" fieldVal=\"{name:'" + fieldName + "'," + "isMasterFiled:" + fieldBean.isMasterField() + ",displayName:'" + fieldBean.getDisplay() + "',inputType:'" + fieldBean.getInputType() + "'" + "}\" class=\""+access+"_class\" name=\"" + fieldName + "_span\"><span class=\"xdRichTextBox\" id=\"" + fieldName + "\">";
                        String endSpanStr = "</span></span>";
                        value4Display = startSpanStr + html + endSpanStr;
                        htmlAttrData.put(FLOWDEALOPITION_SIGNET_KEY, value4Display);
                    } else {
                        value4Display = Strings.toHTML(value4Display, false);
                    }
                    if(Strings.isNotBlank(value4Display)){
                        value4Display = replaceMutiSpace(value4Display);
                    }
                    if(h5Tag){
                        //TODO 设置移动端签章显示格式
                        restVo.setDisplay(value4Display);
                    }
                    break;
                case CHECKBOX://复选框控件
                    String fowardStr = String.valueOf(AppContext.getThreadContext("isFoward"));
                    boolean isFoward = "true".equals(fowardStr);
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        if ("on".equals(value4Db) || "1".equals(value4Db) || "1.0".equals(value4Db)) {
                            htmlAttrData.put("checked", "true");
                            htmlAttrData.put("value", "1");
                        } else {
                            htmlAttrData.put("value", "0");
                        }
                        if(!bizModel){
                            //批量修改的时候如果复选框未勾选，组件没有返回这种空值，这里给个标识，针对这种情况需要返回
                            htmlAttrData.put("returnunchecked","1");
                        }
                        htmlAttrData.put("style", "border-color:#000000;width:16px;height:16px;");
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        if ("on".equals(value4Db) || "1".equals(value4Db) || "1.0".equals(value4Db)) {
                            if (isFoward) {
                                htmlAttrData.put("checked", "true");
                                htmlAttrData.put("value", "1");
                                htmlAttrData.put("style", "border-color:#000000;width:14px;height:14px;");
                            } else {
                                //原生的复选框打印的时候某些打印机打印出来是黑块，某些彩打打印机打印不出来勾选状态，所以换成图片背景
                                return "<span class=\"browse_class\" id=\"" + fieldBean.getName() + "_span\"" + " fieldVal='{name:\"" + fieldBean.getName() + "\",value:\""+1+"\",isMasterFiled:\"" + fieldBean.isMasterField() + "\",displayName:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldBean.getFieldType() + "\",inputType:\"" + fieldBean.getInputType() + "\",formatType:\"" + fieldBean.getFormatType() + "\"}'><span style=\"vertical-align:bottom;margin-top:2px\" class=\"ico16 examine_checkbox\"></span></span>";
                            }
                        } else {
                            if (isFoward) {
                                htmlAttrData.put("value", "0");
                                htmlAttrData.put("style", "border-color:#000000;width:16px;height:16px;");
                            } else {
                                return "<span class=\"browse_class\" id=\"" + fieldBean.getName() + "_span\"" + " fieldVal='{name:\"" + fieldBean.getName() + "\",value:\""+0+"\",isMasterFiled:\"" + fieldBean.isMasterField() + "\",displayName:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldBean.getFieldType() + "\",inputType:\"" + fieldBean.getInputType() + "\",formatType:\"" + fieldBean.getFormatType() + "\"}'><span style=\"vertical-align:bottom;margin-top:2px\" class=\"ico16 examine_checkbox_unchecked\"></span></span>";
                            }
                        }
                    } else if (FieldAccessType.hide.getKey().equals(access)) {
                        htmlAttrData.put("style", "border-color:#000000;width:16px;height:16px");
                    }
                    break;
                case RADIO://InputType.RADIO 单选按钮
                    EnumManager radioManager = (EnumManager) AppContext.getBean("enumManagerNew");
                    //是否是单选图片枚举
                    boolean isRadioImageEnum = false;
                    Object isRadioExtendObj = fieldBean.getExtraAttr(FormConstant.IS_EXTEND_GET_HTML);
                    boolean isRaidoExtendGetHtml = (isRadioExtendObj != null ? Boolean.valueOf(isRadioExtendObj.toString()) : false);
                    if (!FormUtil.isMobileLogin() && !isRaidoExtendGetHtml) {
                        //移动端登陆，所有枚举都按照普通枚举处理。
                        isRadioImageEnum = radioManager.isUserImageEnum(fieldBean.getEnumId());
                    }
                    List<CtpEnumItem> radioEnumList = radioManager.getFormRadioEnumItemList(fieldBean.getEnumId(),
                            0, fieldBean.getEnumId(), StringUtil.checkNull(value4Db) ? 0L : Long.parseLong(value4Db), false, bizModel);
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        htmlAttrData.remove("id");
                        htmlAttrData.remove("name");
                        htmlAttrData.remove("validate");
                        value4Display = getRadioHtmlStr(true, fieldBean, radioEnumList, value4Db, isRadioImageEnum, bizModel);
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        value4Display = getRadioHtmlStr(false, fieldBean, radioEnumList, value4Db, isRadioImageEnum, bizModel);
                    } else if (FieldAccessType.hide.getKey().equals(access)) {
                        htmlAttrData.put("style", "style=\"border:0px;width:auto;height:auto;border-color:#cccccc;\"");
                    } else if (FieldAccessType.design.getKey().equals(access)) {
                        value4Display = getRadioHtmlStr(false, fieldBean, radioEnumList, value4Db, false, bizModel);
                    }
                    if(h5Tag){
                        FormFieldValue4EnumRestVO vo = (FormFieldValue4EnumRestVO) restVo;
                        vo.setItems(radioEnumList);
                    }
                    break;
                case SELECT://InputType.SELECT 下拉列表框      
                    EnumManager selectManager = (EnumManager) AppContext.getBean("enumManagerNew");
                    Object isExtendObj = fieldBean.getExtraAttr(FormConstant.IS_EXTEND_GET_HTML);
                    boolean isExtendGetHtml = (isExtendObj != null ? Boolean.valueOf(isExtendObj.toString()) : false);
                    boolean isFieldRelImageEnum = fieldBean.isFieldRelImageEnum();
                    htmlAttrData.put("inCalculate", "" + fieldBean.isInCalculate());
                    htmlAttrData.put("inCondition", "" + fieldBean.isInCondition());
                    htmlAttrData.put("unique", "" + fieldBean.isUnique());
                    htmlAttrData.put("validate", "name:\"" + fieldBean.getDisplay() + "\",type:\"string\",maxLength:" + fieldBean.getFieldLength() + ",notNull:" + (isNotNull) + ",errorMsg:\"" + fieldBean.getDisplay() + ResourceUtil.getString("form.app.notnull.label") + "\",func:validateSelect");
                    //数据关联--图片枚举--start
                    if (!isExtendGetHtml && isFieldRelImageEnum && (FieldAccessType.edit.getKey().equals(access) || FieldAccessType.browse.getKey().equals(access))) {
                        String fromFieldName = fieldBean.getExtraAttr(FormConstant.FIELD_REL_IMAGE_ENUM_FROM_NAME).toString();
                        CtpEnumItem item = ((value == null || "".equals(value.toString())) ? null : selectManager.getCtpEnumItem(Long.parseLong(String.valueOf(value))));
                        String startSpanStr = "<span id=\"" + fromFieldName + "_span\" fieldVal='" + "{inputType:\"relation\",toRelationType:\"data_relation_imageEnum\",formatType:\"" + fieldBean.getFormatType() + "\"}" + "'" + "name=\"" + fromFieldName + "_span\">";
                        String endSpanStr = "</span>";
                        String hiddenInputStr = "<input type=\"hidden\" name=\"" + fromFieldName + "\" id=\"" + fromFieldName + "\" value=\"" + (item == null ? "" : item.getId()) + "\"/>";
                        if (!FormUtil.isMobileLogin() && (FormConstant.DISPLAY_NAME.equals(fieldBean.getFormatType()) || FormConstant.NAME_TO_NAME.equals(fieldBean.getFormatType()))) {
                            value4Display = (item == null || item.getImageId() == null) ? (startSpanStr + hiddenInputStr + endSpanStr)
                                    : (startSpanStr + hiddenInputStr + "<img style=\"height:15px;\" src='" + SystemEnvironment.getContextPath() + "/fileUpload.do?method=showRTE&fileId=" + item.getImageId() + "&expand=0&type=image'>" + endSpanStr);
                        } else {
                            value4Display = (item == null) ? (startSpanStr + hiddenInputStr + endSpanStr) : (startSpanStr + "<label class=\"margin_r_10 hand\" id=\"" + fromFieldName + "_txt" + "\">" + hiddenInputStr + Strings.toHTML(item.getShowvalue()) + "</label>" + endSpanStr);
                        }
                        if (FieldAccessType.edit.getKey().equals(access)) {
                            htmlAttrData.put(IMAGE_ENUM_HTML_EDIT_KEY, value4Display);
                        }
                        if(h5Tag){
                            restVo.setAuth(FieldAccessType.browse.getKey());
                            if(item != null){
                                restVo.setDisplay(item.getShowvalue());
                            }
                        }
                        break;
                    }
                    //数据关联--图片枚举--end

                    //是否是下拉框图片枚举
                    boolean isSelectImageEnum = false;
                    if (!FormUtil.isMobileLogin() && (FieldAccessType.edit.getKey().equals(access)
                            || FieldAccessType.browse.getKey().equals(access))) {
                        //移动端登陆，所有枚举都按照普通枚举处理。
                        isSelectImageEnum = selectManager.isUserImageEnum(fieldBean.getEnumId());
                    }
                    //构造参数，以便获取枚举项列表
                    Map<String, Object> selectParams = new HashMap<String, Object>();
                    selectParams.put("bizModel", bizModel);
                    selectParams.put("isFinalChild", fieldBean.getIsFinalChild());
                    selectParams.put("enumId", fieldBean.getEnumId());
                    selectParams.put("enumLevel", fieldBean.getEnumLevel());
                    selectParams.put("value", value);
                    selectParams.put("value4Db", value4Db);
                    boolean isDataRelMulenum = false;
                    Long parentId = 0L;
                    if (fieldBean.getEnumLevel() > 0 && bizModel && !fieldBean.getIsFinalChild()) {
                        if (fieldBean.getExtraAttr(FormConstant.toFieldIsMultiEnum) != null) {
                            isDataRelMulenum = true;
                        } else {
                            String temppid = HTMLUtil.getMultiEnumParentVal(fieldBean.getEnumId(), fieldBean.getEnumLevel(), recordId, masterData, form, fieldBean);
                            parentId = temppid == null ? 0L : Long.parseLong(temppid);
                        }
                    }
                    selectParams.put("isDataRelMulEnum", isDataRelMulenum);
                    selectParams.put("parentId", parentId);
                    List<CtpEnumItem> enumList = selectManager.getFormSelectEnumItemList(selectParams);
                    /***************H5,下拉框如果选项不为空，则将选项放入restVo的扩展属性中****************************/
                    if(h5Tag){
                        if(!enumList.isEmpty()){
                            FormFieldValue4EnumRestVO vo = (FormFieldValue4EnumRestVO) restVo;
                            vo.setItems(enumList);
                        }
                    }
                    /***********************end**************************************************************/
                    if (FieldAccessType.edit.getKey().equals(access)) {

                        //如果是多级枚举需要加上此select下拉框变化之后所要做的发送ajax请求函数调用
                        if (bizModel) {
                            if (form.isParentmultiEnum(fieldBean) || form.isParentImageEnum(fieldBean)) {
                                htmlAttrData.put("onchange", FormJsFun.changeReflocation.toString());
                                if(h5Tag){
                                    FormFieldValue4EnumRestVO vo = (FormFieldValue4EnumRestVO) restVo;
                                    vo.setEvent("refresh");
                                }
                            } else {
                                htmlAttrData.put("onchange", FormJsFun.calc.toString());
                                if(h5Tag){
                                    FormFieldValue4EnumRestVO vo = (FormFieldValue4EnumRestVO) restVo;
                                    vo.setEvent("calc");
                                }
                            }
                        }
                        //被关联的表单是否设置了计算公式，当是图片枚举时，如果被关联的字段设置了计算公式，则当前的字段按照显示名称处理
                        Boolean relFieldIsCalc = false;
                        if (fieldBean.getExtraAttr(FormConstant.FIELD_REL_FORM_FIELD_IS_CALC) != null) {
                            relFieldIsCalc = (Boolean) fieldBean.getExtraAttr(FormConstant.FIELD_REL_FORM_FIELD_IS_CALC);
                        }
                        if (!isExtendGetHtml && isSelectImageEnum && (FormConstant.IMAGE_TO_IMAGE.equals(fieldBean.getFormatType()) || FormConstant.DISPLAY_IMAGE.equals(fieldBean.getFormatType())) && !relFieldIsCalc) {
                            htmlAttrData.put("validate", "name:'" + fieldBean.getDisplay() + "',type:'string',maxLength:" + fieldBean.getFieldLength() + ",notNull:" + (isNotNull) + ",errorMsg:'" + fieldBean.getDisplay() + ResourceUtil.getString("form.app.notnull.label") + "',func:validateSelect");
                            String changeEventStr = form.isParentImageEnum(fieldBean) ? FormJsFun.changeReflocation.name() : FormJsFun.calc.name();
                            if (!bizModel) {
                                changeEventStr = "";
                            }
                            //如果是图片枚举去掉onchange,放到枚举组件实现
                            htmlAttrData.remove("onchange");
                            Long random = UUIDUtil.getUUIDLong();
                            htmlAttrData.put(IMAGE_ENUM_HTML_EDIT_KEY, "<span " + SPAN_ATTRS + " spanUniqueId=\"" + random + "\"><span id=\"" + fieldBean.getName() + "_imgspan\" name=\"" + fieldBean.getName() + "_imgspan\" class=\"comp validate\""
                                    + " comp=\"type:'select',mode:'dropdown',change:'" + changeEventStr + "',name:'" + fieldBean.getName() + "',id:'" + fieldBean.getName() + "',height:15,spanUniqueId:'" + random + "'"
                                    + ",value:'" + (value == null ? "" : value) + "',inCalculate:'" + fieldBean.isInCalculate() + "',inCondition:'" + fieldBean.isInCondition() + "',validate:{" + htmlAttrData.get("validate") + "},unique:'" + htmlAttrData.get("unique") + "',data:" + HTML_VALUE + "\" " + HTML_ATTRS + "></span></span>");
                            value4Display = getMultRelationHtmlStr(enumList, true);
                        } else {
                            value4Display = getMultRelationHtmlStr(enumList, false);
                        }
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        htmlAttrData.put("val4cal", value4Bussiness);
                        if (isSelectImageEnum && (FormConstant.NAME_TO_IMAGE.equals(fieldBean.getFormatType())
                                || FormConstant.IMAGE_TO_IMAGE.equals(fieldBean.getFormatType()) || FormConstant.DISPLAY_IMAGE.equals(fieldBean.getFormatType()))) {
                            CtpEnumItem item = (value == null ? null : selectManager.getCtpEnumItem(Long.parseLong(String.valueOf(value))));
                            value4Display = (item == null || item.getImageId() == null) ? ""
                                    : "<img style=\"height:15px;\" src='" + SystemEnvironment.getContextPath() + "/fileUpload.do?method=showRTE&fileId=" + item.getImageId() + "&expand=0&type=image'>";
                        }
                    }
                    break;
                case HANDWRITE://InputType.HANDWRITE 签章
                    boolean isOldHandWriteVal = false;
                    String tempStrVal = String.valueOf(value);
                    String modify = "_modify";
                    if (!StringUtil.checkNull(tempStrVal) && (tempStrVal.indexOf(FormConstant.DOWNLINE) == -1 || tempStrVal.toLowerCase().indexOf(modify) != -1)) {//升级上来的数据value不做处理
                        isOldHandWriteVal = true;
                    } else if (!StringUtil.checkNull(tempStrVal) && tempStrVal.indexOf(FormConstant.DOWNLINE) != -1) {//5.0中的数据value取下划线后部分id
                        value = tempStrVal.split(FormConstant.DOWNLINE)[1];
                    } else if (data != null) {//如果前一个分支没有走到，判断data是否为空，不为空取data的id
                        value = data.getId();
                    }
                    if (StringUtil.checkNull(tempStrVal) && data != null) {//最后再防护一下
                        value = data.getId();
                    }
                    String handWriteStrVal = null;
                    if (!isOldHandWriteVal) {
                        handWriteStrVal = fieldBean.getName() + FormConstant.DOWNLINE + value;
                        htmlAttrData.put("value", handWriteStrVal);
                    } else {
                        //老签章数据分两种情况，一种是值里面有_modify
                        if (tempStrVal.toLowerCase().indexOf(modify) != -1) {
                            handWriteStrVal = "my:" + fieldBean.getDisplay();
                            htmlAttrData.put("value", tempStrVal.substring(0, tempStrVal.indexOf(FormConstant.DOWNLINE)));
                            value = tempStrVal.substring(0, tempStrVal.indexOf(FormConstant.DOWNLINE));
                        } else {
                            handWriteStrVal = "my:" + fieldBean.getDisplay();
                            htmlAttrData.put("value", tempStrVal);
                        }
                    }
                    String handStr = null;
                    String userName = Strings.escapeJavascript(AppContext.getCurrentUser().getName());
                    if (h5Tag) {
                        FormFieldValue4HandwriteRestVO handwriteRestVO = (FormFieldValue4HandwriteRestVO) restVo;
                        V3xHtmDocumentSignatManager htmSignetManager = (V3xHtmDocumentSignatManager) AppContext.getBean("htmSignetManager");
                        List<V3xHtmDocumentSignature> signatures = htmSignetManager.findBySummaryIdPolicyAndType(Long.valueOf(value.toString()), handWriteStrVal, V3xHtmSignatureEnum.HTML_SIGNATURE_DOCUMENT.getKey());
                        if (Strings.isNotEmpty(signatures)) {
                            try {
                                V3xHtmDocumentSignature signature = signatures.get(0);
                                signature = (V3xHtmDocumentSignature) signature.clone();
                                signature.setFieldValue(MSignaturePicHandler.encodeSignatureDataForStandard(signature.getFieldValue()));
                                handwriteRestVO.setSignature(signature);
                            } catch (Exception e) {
                                LOGGER.error("解密签章数据异常", e);
                            }
                        }
                    }
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        handStr = "type:\"htmlSignature\",recordId:\"" + value + "\",objName:\"" + handWriteStrVal + "\",userName:\"" + userName + "\",signObj:this,enabled:1,showButton:true,isNotNull:" + isNotNull + ",displayName:\"" + fieldBean.getDisplay() + "\"";
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        handStr = "type:\"htmlSignature\",recordId:\"" + value + "\",objName:\"" + handWriteStrVal + "\",userName:\"" + userName + "\",signObj:this,enabled:0,isNotNull:" + isNotNull + ",displayName:\"" + fieldBean.getDisplay() + "\"";
                    } else {
                        handStr = "type:\"htmlSignature\",recordId:\"" + value + "\",objName:\"" + handWriteStrVal + "\",userName:\"" + userName + "\",signObj:this,enabled:0,showButton:true,isNotNull:" + isNotNull + ",displayName:\"" + fieldBean.getDisplay() + "\"";
                    }
                    htmlAttrData.put("comp", handStr);
                    break;
                case EXTEND_MEMBER://InputType.EXTEND_MEMBER 选择人员
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        String personValue = StringUtil.checkNull(value4Db) || "0".equals(value4Db) ? "" : ",value:\"" + Strings.escapeJson(value4Bussiness) + "\",text:\"" + Strings.escapeJson(value4Display) + "\"";
                        //V-Join外部人员不支持快速选人
                        if (bizModel || fieldBean.getExternalType() == OrgConstants.ExternalType.Interconnect1.ordinal()) {
                            //如果htmlValue不为‘’，则查询htmlValue所代表的人所属部门id以及其名字等信息，拼接value字符串
                            //判断当前选人控件是否被其他单元格数据关联了，如果是，则需要添加选人回调函数
                            List<FormRelation> relationList = form.getRelationList();
                            String callBackStr = "";
                            boolean hasRelationField = false;
                            for (FormRelation rel : relationList) {
                                if (bizModel && rel.getToRelationAttr().equals(fieldBean.getName()) && rel.getToRelationAttrType().intValue() == ToRelationAttrType.data_relation_member.getKey()) {
                                    hasRelationField = true;
                                    break;
                                }
                            }

                            Long deptId = AppContext.getCurrentUser().getDepartmentId();
                            String formatType = fieldBean.getFormatType();
                            if (!StringUtil.checkNull(formatType)) {
                                OrgFormatType formatTypeEnum = OrgFormatType.getEnumItemByKey(formatType);
                                if (formatTypeEnum != null) {
                                    deptId = formatTypeEnum.getFormatOrgId();
                                }
                            }
                            callBackStr = ",preCallback:" + FormJsFun.selectOrgPreCallBack.name() + ",callback:" + FormJsFun.selectOrgCallBack.name() + ",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",hasRelationField:" + hasRelationField + ",departmentId:" + deptId;
                            String panels = "Department,Team,Post,Level,Outworker,RelatePeople";
                            if (fieldBean.getName().equals(MasterTableField.start_member_id.getKey())) {
                                panels = "Department,Team,Post,Level,Outworker,RelatePeople,JoinOrganization";
                            }
                            if (fieldBean.getExternalType() == OrgConstants.ExternalType.Interconnect1.ordinal()) {//V-Join外部人员
                                panels = "JoinOrganization";
                            }
                            String str = "type:\"selectPeople\",showOriginalElement:false,isNeedCheckLevelScope:false,showAllOuterDepartment:true,showBtn:true,extendWidth:true,panels:\"" + panels + "\",selectType:\"Member\"" + personValue + ",minSize:0,maxSize:1" + callBackStr + ",isMasterField:" + fieldBean.isMasterField() + ",fieldName:\"" + fieldBean.getName() + "\"";
                            htmlAttrData.put("comp", str);
                        }else{
                            String panels = "Department,Team,Post,Level,Outworker";
                            if (fieldBean.getName().equals(MasterTableField.start_member_id.getKey())) {
                                panels = "Department,Team,Post,Level,Outworker,JoinOrganization";
                            }
                            String spanId = fieldBean.getName() + "_span";
                            String fastPerson = "<span class=\"edit_class\" fieldVal='{name:\"" + fieldBean.getName() + "\",isMasterFiled:\"" + fieldBean.isMasterField() + "\",displayName:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldBean.getFieldType() + "\",inputType:\"" + fieldBean.getInputType() + "\",formatType:\"" + fieldBean.getFormatType() + "\"}'" + "id=\""+spanId +"\" name=\""+spanId+"\">" +
                                    "<select id=\""+fieldBean.getName()+"_s\" class=\"comp\" comp='extendWidth:true"+personValue+",isNeedCheckLevelScope:false,minSize:0,maxSize:1,outBtn:true,panels:\"" + panels + "\",id:\""+fieldBean.getName()+"\",type:\"fastSelect\",mode:\"open\",selectType:\"Member\",extendWidth:true' style=\"width:100%\" multiple=\"multiple\"><select></span>";
                            return fastPerson;
                        }
                    }
                    break;
                case EXTEND_MULTI_MEMBER://InputType.EXTEND_MULTI_MEMBER 选择多人
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        Long deptId = AppContext.getCurrentUser().getDepartmentId();
                        String formatType = fieldBean.getFormatType();
                        if (!StringUtil.checkNull(formatType)) {
                            OrgFormatType formatTypeEnum = OrgFormatType.getEnumItemByKey(formatType);
                            if (formatTypeEnum != null) {
                                deptId = formatTypeEnum.getFormatOrgId();
                            }
                        }
                        String personValue = StringUtil.checkNull(value4Db) || "0".equals(value4Db) ? "" : ",value:\"" + Strings.escapeJson(value4Bussiness) + "\",text:\"" + Strings.escapeJson(value4Display) + "\"";
                        String str = "type:\"selectPeople\"" + ",departmentId:" + deptId + ",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",isNeedCheckLevelScope:false,showAllOuterDepartment:true,showBtn:true,extendWidth:true,mode:\"open\",panels:\"Department,Team,Post,Level,Outworker,RelatePeople\",minSize:0," + "maxSize:" + getMaxOrgSize(fieldBean) + ",selectType:\"Member\"" + personValue;
                        htmlAttrData.put("comp", str);
                    }
                    break;
                case EXTEND_DATE://InputType.EXTEND_DATE 日期控件
                    Object v = valuesWithDisplay[0];
                    if (h5Tag && v instanceof Date) {
                        restVo.setValue(Datetimes.formatNoTimeZone((Date) v,Datetimes.dateStyle));
                    }
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        String showValue = value4Display;
                        String formatType = fieldBean.getFormatType();
                        boolean formatIsNull = StringUtil.checkNull(formatType);
                        if (!formatIsNull) {//有显示格式，添加一个显示的input
                            if (bizModel) {
                                value4Display = "<input id=\"" + fieldBean.getName() + "_txt\" name=\"" + fieldBean.getName() + "_txt\" class=\"xdRichTextBox\" type=\"text\" onfocus=\"dispDateInputOnfocus(this);\" value=\"" + showValue + "\">";
                            } else {
                                value4Display = "";
                            }
                            value4Display = value4Display + "<input validate='"+htmlAttrData.get("validate")+"' id=\"" + fieldBean.getName() + "\" name=\"" + fieldBean.getName() + "\" " + (bizModel ? "onblur=\"valueDateInputOnblur(this);\"" : "") + " type=\"text\" "
                                    + "value=\"" + value4Bussiness + "\" comp='type:\"calendar\",cache:false,isOutShow:" + (bizModel ? "true" : "false") + ",ifFormat:\"%Y-%m-%d\"" + (bizModel ? (",onClose:valueDateInputOnclose") : "") + "' "
                                    + "class=\"validate xdRichTextBox comp\" style=\" " + (bizModel ? "display:none" : "") + "\" "
                                    + "inCalculate=\"" + fieldBean.isInCalculate() + "\" inCondition=\"" + fieldBean.isInCondition() + "\" unique=\"" + fieldBean.isUnique() + "\" >";
                        } else {//无显示格式，不需要添加显示input
                            value4Display = "<input validate='"+htmlAttrData.get("validate")+"' id=\"" + fieldBean.getName() + "\" name=\"" + fieldBean.getName() + "\" " + (bizModel ? "onblur=\"" + FormJsFun.calc.toString() + "\"" : "") + " type=\"text\" "
                                    + "value=\"" + value4Bussiness + "\" comp='type:\"calendar\",cache:false,isOutShow:" + (bizModel ? "true" : "false") + ",ifFormat:\"%Y-%m-%d\"" + (bizModel ? (",onClose:calc") : "") + "' "
                                    + "class=\"validate xdRichTextBox comp\" "
                                    + "inCalculate=\"" + fieldBean.isInCalculate() + "\" inCondition=\"" + fieldBean.isInCondition() + "\" unique=\"" + fieldBean.isUnique() + "\" >";
                        }
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        htmlAttrData.put("value", value4Display);
                        if (StringUtil.checkNull(value4Display)) {
                            value4Display = "&nbsp;";
                        }
                        htmlAttrData.put("style", "min-height:12px;overflow-y:hidden");
                    }
                    break;
                case EXTEND_DATETIME://InputType.EXTEND_DATETIME 日期时间控件
                    Object vl = valuesWithDisplay[0];
                    if (h5Tag && vl instanceof Date) {
                        restVo.setValue(Datetimes.formatNoTimeZone((Date) vl, Datetimes.datetimeWithoutSecondStyle));
                    }
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        htmlAttrData.put("value", value4Display);
                        if (bizModel) {
                            htmlAttrData.put("onblur", "" + FormJsFun.calc + "");
                        }
                        htmlAttrData.put("comp", "type:\"calendar\",showsTime:true,cache:false,minuteStep:1,isOutShow:" + (bizModel ? "true" : "false") + ",ifFormat:\"%Y-%m-%d %H:%M\"" + (bizModel ? (",onClose:" + FormJsFun.calc.name()) : "''"));
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        htmlAttrData.put("value", value4Display);
                        if (StringUtil.checkNull(value4Display)) {
                            value4Display = "&nbsp;";
                        }
                        htmlAttrData.put("style", "min-height:12px;overflow-y:hidden");
                    }
                    break;
                case EXTEND_ACCOUNT://InputType.EXTEND_ACCOUNT 选择单位
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        String str = "type:\"selectPeople\",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",showBtn:true,extendWidth:true,mode:\"open\",panels:\"Account\",selectType:\"Account\"" + getOrgVal(value4Db, value4Bussiness, value4Display) + ",maxSize:1,minSize:0";
                        htmlAttrData.put("comp", str);
                    }
                    break;
                case EXTEND_MULTI_ACCOUNT://InputType.EXTEND_MULTI_ACCOUNT  择多单位
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        String str = "type:\"selectPeople\",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",showBtn:true,extendWidth:true,mode:\"open\",panels:\"Account\",minSize:0," + "maxSize:" + getMaxOrgSize(fieldBean) + ",selectType:\"Account\"" + getOrgVal(value4Db, value4Bussiness, value4Display);
                        htmlAttrData.put("comp", str);
                    }
                    break;
                case EXTEND_DEPARTMENT://InputType.EXTEND_DEPARTMENT 选择部门
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        List<FormRelation> relationList = form.getRelationList();
                        String callBackStr = "";
                        boolean hasRelationField = false;
                        for (FormRelation rel : relationList) {
                            if (bizModel && rel.getToRelationAttr().equals(fieldBean.getName()) && rel.getToRelationAttrType().intValue() == ToRelationAttrType.data_relation_department.getKey()) {
                                hasRelationField = true;
                                break;
                            }
                        }
                        Long deptId = AppContext.getCurrentUser().getDepartmentId();
                        String formatType = fieldBean.getFormatType();
                        if (!StringUtil.checkNull(formatType)) {
                            OrgFormatType formatTypeEnum = OrgFormatType.getEnumItemByKey(formatType);
                            if (formatTypeEnum != null) {
                                deptId = formatTypeEnum.getFormatOrgId();
                            }
                        }
                        callBackStr = ",preCallback:" + FormJsFun.selectOrgPreCallBack.name() + ",callback:" + FormJsFun.selectOrgCallBack.name() + ",hasRelationField:" + hasRelationField + ",departmentId:" + deptId;
                        String panels = "Department";
                        String showExternalType = "";
                        if (fieldBean.getExternalType() == OrgConstants.ExternalType.Interconnect1.ordinal()) {//V-Join外部机构
                            panels = "JoinOrganization";
                            showExternalType = ",showExternalType: \"1\"";
                        } else if (fieldBean.getExternalType() == OrgConstants.ExternalType.Interconnect2.ordinal()) {//V-Join外部单位
                            panels = "JoinAccount";
                        }
                        String str = "type:\"selectPeople\",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",showBtn:true,extendWidth:true,mode:\"open\",panels:\"" + panels + "\"" + showExternalType + ",isAllowContainsChildDept:true,isConfirmExcludeSubDepartment:false,selectType:\"Department\"" + getOrgVal(value4Db, value4Bussiness, value4Display) + ",minSize:0,maxSize:1" + callBackStr + ",isMasterField:" + fieldBean.isMasterField() + ",fieldName:\"" + fieldBean.getName() + "\"";
                        htmlAttrData.put("comp", str);
                    }
                    //OA-99391表单协同 字段内容有特殊字符，打开报错
                    if(FieldAccessType.browse.getKey().equals(access)){
                        value4Display = Strings.toHTML(value4Display);
                    }
                    break;
                case EXTEND_MULTI_DEPARTMENT://InputType.EXTEND_MULTI_DEPARTMENT 选择多部门
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        Long deptId = AppContext.getCurrentUser().getDepartmentId();
                        String formatType = fieldBean.getFormatType();
                        if (!StringUtil.checkNull(formatType)) {
                            OrgFormatType formatTypeEnum = OrgFormatType.getEnumItemByKey(formatType);
                            if (formatTypeEnum != null) {
                                deptId = formatTypeEnum.getFormatOrgId();
                            }
                        }
                        String callBackStr = ",preCallback:" + FormJsFun.selectOrgPreCallBack.name() + ",callback:" + FormJsFun.selectOrgCallBack.name() + ",hasRelationField:" + false + ",departmentId:" + deptId;
                        String str = "type:\"selectPeople\",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",showBtn:true,extendWidth:true,mode:\"open\",panels:\"Department\",isAllowContainsChildDept:true,isConfirmExcludeSubDepartment:false,selectType:\"Department\"" + getOrgVal(value4Db, value4Bussiness, value4Display) + ",minSize:0,maxSize:" + getMaxOrgSize(fieldBean) + callBackStr;
                        htmlAttrData.put("comp", str);
                    }
                    break;
                case EXTEND_POST://InputType.EXTEND_POST 选择岗位
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        String panels = "Post";
                        if (fieldBean.getExternalType() == OrgConstants.ExternalType.Interconnect1.ordinal()) {//V-Join外部人员岗位
                            panels = "JoinPost";
                        }
                        String str = "type:\"selectPeople\",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",showBtn:true,extendWidth:true,mode:\"open\",panels:\"" + panels + "\",selectType:\"Post\"" + getOrgVal(value4Db, value4Bussiness, value4Display) + ",minSize:0,maxSize:1";
                        htmlAttrData.put("comp", str);
                    }
                    break;
                case EXTEND_MULTI_POST://InputType.EXTEND_MULTI_POST 选择多岗位
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        String str = "type:\"selectPeople\",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",showBtn:true,extendWidth:true,mode:\"open\",panels:\"Post\",minSize:0," + "maxSize:" + getMaxOrgSize(fieldBean) + ",selectType:\"Post\"" + getOrgVal(value4Db, value4Bussiness, value4Display);
                        htmlAttrData.put("comp", str);
                    }
                    break;
                case EXTEND_LEVEL://InputType.EXTEND_LEVEL  择职务级别
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        String str = "type:\"selectPeople\",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",showBtn:true,extendWidth:true,mode:\"open\",panels:\"Level\",selectType:\"Level\"" + getOrgVal(value4Db, value4Bussiness, value4Display) + ",minSize:0,maxSize:1";
                        htmlAttrData.put("comp", str);
                    }
                    break;
                case EXTEND_MULTI_LEVEL: //InputType.EXTEND_MULTI_LEVEL 选择多职务级别
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        String str = "type:\"selectPeople\",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",showBtn:true,extendWidth:true,mode:\"open\",panels:\"Level\",minSize:0," + "maxSize:" + getMaxOrgSize(fieldBean) + ",selectType:\"Level\"" + getOrgVal(value4Db, value4Bussiness, value4Display);
                        htmlAttrData.put("comp", str);
                    }
                    break;
                // 客开 start
                case EXTEND_TEAM:
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        String str = "type:\"selectPeople\",valueChange:" + FormJsFun.orgFieldOnChange.name() + ",showBtn:true,extendWidth:true,mode:\"open\",panels:\"Team\",selectType:\"Team\"" + getOrgVal(value4Db, value4Bussiness, value4Display) + ",maxSize:1,minSize:1";
                        htmlAttrData.put("comp", str);
                    }
                    if(FieldAccessType.browse.getKey().equals(access)){
                    	value4Display = Strings.toHTML(value4Display);
                    }
                    break;
                // 客开 end
                case EXTEND_ATTACHMENT://InputType.EXTEND_ATTACHMENT 插入附件
                    List<Attachment> atts = new ArrayList<Attachment>();
                    String initValue4Att = "{}";
                    if (FieldAccessType.edit.getKey().equals(access) && fieldBean.getFormRelation() != null && fieldBean.getFormRelation().isFormRelationField()) {
                        access = FieldAccessType.browse.getKey();
                    }
                    if (!StringUtil.checkNull(value4Db)) {
                        if (masterData != null && masterData.getExtraAttr(FormConstant.attachments) != null) {
                            atts = (List<Attachment>) masterData.getExtraAttr(FormConstant.attachments);
                            initValue4Att = getJsonAttStr(atts, Long.valueOf(value4Db));
                            if(h5Tag){
                                FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                                vo.setAttData(filterAttrBySubRef(atts, Long.valueOf(value4Db)));
                            }
                        }
                    } else {
                        value4Db = "" + UUIDUtil.getUUIDLong();//表单动态表中存储的是uuid对应附件组建中是subReferenceID
                        if (h5Tag) {
                            restVo.setValue(value4Db);
                        }
                    }
                    List<Attachment> assdocList = new ArrayList<Attachment>();
                    if (atts != null && atts.size() != 0) {
                        Attachment att4Field = null;
                        for (Attachment att : atts) {
                            if (Long.valueOf(value4Db).equals(att.getSubReference())) {
                                att4Field = att;
                                if (att4Field.getType() == 2) {
                                    assdocList.add(att4Field);
                                }
                            }
                        }
                    }
                    //********************增加附件收藏的权限判断开始*********************
                    String collectFlag = SystemProperties.getInstance().getProperty("doc.collectFlag");
                    String systemVer = AppContext.getSystemProperty("system.ProductId");
                    //A6没有收藏功能。相对就没有权限
                    boolean isA6 = false;
                    if ("0".equals(systemVer) || "7".equals(systemVer) || "12".equals(systemVer)) {
                        isA6 = true;
                    }
                    String canFavourite = "false";
                    if("true".equals(collectFlag) && !isA6){
                        canFavourite = "true";
                    }
                    //********************增加附件收藏的权限判断结束*********************
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        if (assdocList.size() <= 0) {//只有附件
                            value4Display = "<div class=\"comp\" comp=\"type:'fileupload',callMethod:'" + FormJsFun.fileValueChangeCallBack.name() +
                                    "',delCallMethod:'" + FormJsFun.fileDelCallBack.name() +
                                    "',takeOver:false,isBR:true,canDeleteOriginalAtts:true,canFavourite:'"+canFavourite+"',notNull:'" + isNotNull +
                                    "',displayMode:'visible',autoHeight:true,applicationCategory:'" + ApplicationCategoryEnum.form.getKey()
                                    + "',embedInput:'" + fieldBean.getName() + "',attachmentTrId:'" + value4Db +
                                    "'\" attsdata='" + initValue4Att +
                                    "'></div><span class=\"ico16 affix_16\" onclick=\"insertAttachmentPoi('" + value4Db + "')\">"
                                    + "<input type='hidden' id='" + getAttKey(fieldBean.getName(), String.valueOf(recordId)) + "' value=\"true\">" //用来证明是否可以编辑
                                    + "</span>";
                        } else {//既有附件，又有关联文档
                            value4Display = "<div class=\"comp\" comp=\"type:'fileupload',callMethod:'" + FormJsFun.fileValueChangeCallBack.name() + "',delCallMethod:'"
                                    + FormJsFun.fileDelCallBack.name() + "',takeOver:false,isBR:true,canDeleteOriginalAtts:true,canFavourite:'"+canFavourite+"',notNull:'" + isNotNull
                                    + "',displayMode:'visible',autoHeight:true,applicationCategory:'" + ApplicationCategoryEnum.form.getKey() + "',embedInput:'"
                                    + fieldBean.getName() + "',attachmentTrId:'" + value4Db + "'\" attsdata='" + initValue4Att + "'></div>"
                                    + "<div class=\"comp\" comp=\"type:'assdoc',callMethod:'" + FormJsFun.assdocValueChangeCallBack.name() + "',delCallMethod:'"
                                    + FormJsFun.assdocDelCallBack.name() + "',isBR:true,displayMode:'visible',autoHeight:true,attachmentTrId:'" + value4Db
                                    + "', modids:'1,3',canDeleteOriginalAtts:false\" attsdata='" + initValue4Att + "'></div>"
                                    + "<span class=\"ico16 affix_16\" onclick=\"insertAttachmentPoi('" + value4Db + "')\">"
                                    + "<input type='hidden' id='" + getAttKey(fieldBean.getName(), String.valueOf(recordId)) + "' value=\"true\">" //用来证明是否可以编辑
                                    + "</span>";
                        }
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        if (assdocList.size() <= 0) {//只有附件
                            value4Display = "<div class=\"comp\" comp=\"type:'fileupload',isBR:true,displayMode:'visible',autoHeight:true,applicationCategory:'"
                                    + ApplicationCategoryEnum.form.getKey() + "',embedInput:'" + fieldBean.getName() + "',attachmentTrId:'" + value4Db
                                    + "',canDeleteOriginalAtts:false,canFavourite:'" + canFavourite + "' \" attsdata='" + initValue4Att + "'></div>";
                        } else {//附件和关联文档；
                            value4Display = "<div class=\"comp\" comp=\"type:'fileupload',isBR:true,displayMode:'visible',autoHeight:true,applicationCategory:'"
                                    + ApplicationCategoryEnum.form.getKey() + "',embedInput:'" + fieldBean.getName() + "',attachmentTrId:'" + value4Db
                                    + "',canDeleteOriginalAtts:false,canFavourite:'" + canFavourite + "' \" attsdata='" + initValue4Att + "'></div>"
                                    + "<div class=\"comp\" comp=\"type:'assdoc',isBR:true,displayMode:'visible',autoHeight:true,attachmentTrId:'" + value4Db + "', modids:'1,3',canDeleteOriginalAtts:false\" attsdata='" + initValue4Att + "'></div>";
                        }
                    }
                    /**********************H5*****************************/
                    if(h5Tag){
                        FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                        vo.setAuth(access);
                        vo.setHasAssDoc(assdocList.size() > 0);
                    }
                    break;
                case EXTEND_DOCUMENT://InputType.EXTEND_DOCUMENT 关联文档
                    List<Attachment> atts1 = new ArrayList<Attachment>();
                    String initValue = "{}";
                    if (FieldAccessType.edit.getKey().equals(access) && fieldBean.getFormRelation() != null && fieldBean.getFormRelation().isFormRelationField()) {
                        access = FieldAccessType.browse.getKey();
                    }
                    if (!StringUtil.checkNull(value4Db)) {
                        if (masterData != null && masterData.getExtraAttr(FormConstant.attachments) != null) {
                            atts1 = (List<Attachment>) masterData.getExtraAttr(FormConstant.attachments);
                            initValue = getJsonAttStr(atts1, Long.valueOf(value4Db));
                            if(h5Tag){
                                FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                                vo.setAttData(filterAttrBySubRef(atts1, Long.valueOf(value4Db)));
                            }
                        }
                    } else {
                        value4Db = "" + UUIDUtil.getUUIDLong();//表单动态表中存储的是uuid对应附件组建中是subReferenceID
                        if (h5Tag) {
                            restVo.setValue(value4Db);
                        }
                    }
                    List<Attachment> fieldAttList = new ArrayList<Attachment>();
                    if (atts1 != null && atts1.size() != 0) {
                        Attachment att4Field = null;
                        for (Attachment att : atts1) {
                            if (Long.valueOf(value4Db).equals(att.getSubReference())) {
                                att4Field = att;
                                if (att4Field.getType() == 0) {
                                    fieldAttList.add(att4Field);
                                }
                            }
                        }
                    }
                    //********************增加附件收藏的权限判断开始*********************
                    String collectFlag1 = SystemProperties.getInstance().getProperty("doc.collectFlag");
                    String systemVer1 = AppContext.getSystemProperty("system.ProductId");
                    //A6没有收藏功能。相对就没有权限
                    boolean isA61 = false;
                    if ("0".equals(systemVer1) || "7".equals(systemVer1) || "12".equals(systemVer1)) {
                        isA6 = true;
                    }
                    String canFavourite1 = "false";
                    if("true".equals(collectFlag1) && !isA61){
                        canFavourite1 = "true";
                    }
                    //********************增加附件收藏的权限判断结束*********************
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        if (fieldAttList.size() <= 0) {//只有关联文档
                            value4Display = "<div class=\"comp\" comp=\"type:'assdoc',isBR:true,callMethod:'" + FormJsFun.assdocValueChangeCallBack.name() + "',delCallMethod:'" + FormJsFun.assdocDelCallBack.name() + "',canFavourite:'"+canFavourite1+"',notNull:'" + isNotNull
                                    + "',displayMode:'visible',attachmentTrId:'" + value4Db + "', modids:'1,3',embedInput:'" + fieldBean.getName()
                                    + "'\" attsdata='" + initValue + "'></div><span class=\"left ico16 associated_document_16\" onclick=\"quoteDocument('"
                                    + value4Db + "')\">"
                                    + "<input type='hidden' id='" + getAttKey(fieldBean.getName(), String.valueOf(recordId)) + "' value=\"true\">" //用来证明是否可以编辑
                                    + "</span>";
                        } else {//既有附件又有关联文档
                            value4Display = "<div class=\"comp\" comp=\"type:'fileupload',callMethod:'" + FormJsFun.fileValueChangeCallBack.name()
                                    + "',delCallMethod:'" + FormJsFun.fileDelCallBack.name() + "',takeOver:false,isBR:true,displayMode:'visible',autoHeight:true,applicationCategory:'"
                                    + ApplicationCategoryEnum.form.getKey() + "',attachmentTrId:'" + value4Db + "',canDeleteOriginalAtts:false,canFavourite:'" + canFavourite1
                                    + "' \" attsdata='" + initValue + "'></div>"
                                    + "<div class=\"comp\" comp=\"type:'assdoc',isBR:true,callMethod:'" + FormJsFun.assdocValueChangeCallBack.name() + "',delCallMethod:'" + FormJsFun.assdocDelCallBack.name() + "',notNull:'" + isNotNull + "',displayMode:'visible',attachmentTrId:'" + value4Db + "', modids:'1,3',embedInput:'" + fieldBean.getName() + "'\" attsdata='" + initValue + "'></div><span class=\"ico16 associated_document_16\" onclick=\"quoteDocument('" + value4Db + "')\">"
                                    + "<input type='hidden' id='" + getAttKey(fieldBean.getName(), String.valueOf(recordId)) + "' value=\"true\">" //用来证明是否可以编辑
                                    + "</span>";
                        }
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        if (fieldAttList.size() <= 0) {//只有关联文档
                            value4Display = "<div class=\"comp\" comp=\"type:'assdoc',isBR:true,displayMode:'visible',attachmentTrId:'" + value4Db + "', modids:'1,3',embedInput:'" + fieldBean.getName() + "',canDeleteOriginalAtts:false,canFavourite:'" + canFavourite1 + "',notNull:'"+isNotNull+"'\" attsdata='" + initValue + "'></div>";
                        } else {//既有附件又有关联文档
                            value4Display = "<div class=\"comp\" comp=\"type:'fileupload',isBR:true,displayMode:'visible',autoHeight:true,applicationCategory:'" + ApplicationCategoryEnum.form.getKey() + "',attachmentTrId:'" + value4Db + "',canDeleteOriginalAtts:false,canFavourite:'" + canFavourite1 + "' \" attsdata='" + initValue + "'></div>"
                                    + "<div class=\"comp\" comp=\"type:'assdoc',isBR:true,displayMode:'visible',attachmentTrId:'" + value4Db + "', modids:'1,3',embedInput:'" + fieldBean.getName() + "',canDeleteOriginalAtts:false\" attsdata='" + initValue + "'></div>";
                        }
                    }
                    /**********************H5*****************************/
                    if(h5Tag){
                        FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                        vo.setAuth(access);
                        vo.setHasAssDoc(fieldAttList.size() > 0);
                    }
                    break;
                case EXTEND_IMAGE://InputType.EXTEND_IMAGE 插入图片
                	String initValue4Img = "{}";
                    if (FieldAccessType.edit.getKey().equals(access) && fieldBean.getFormRelation() != null && fieldBean.getFormRelation().isFormRelationField()) {
                        access = FieldAccessType.browse.getKey();
                    }
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        if (!StringUtil.checkNull(value4Db)) {
                            if (masterData != null && masterData.getExtraAttr(FormConstant.attachments) != null) {
                                atts = (List<Attachment>) masterData.getExtraAttr(FormConstant.attachments);
                                initValue4Img = getJsonAttStr(atts, Long.valueOf(value4Db));
                                if(h5Tag){
                                    FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                                    vo.setAttData(filterAttrBySubRef(atts, Long.valueOf(value4Db)));
                                }
                            }
                        } else {
                            value4Db = "" + UUIDUtil.getUUIDLong();//表单动态表中存储的是uuid对应附件组建中是subReferenceID
                            if (h5Tag) {
                                restVo.setValue(value4Db);
                            }
                        }
                        value4Display = "<div class=\"comp\" comp=\"type:'fileupload',callMethod:'" + FormJsFun.fileValueChangeCallBack.name() + "',delCallMethod:'" + FormJsFun.fileDelCallBack.name() + "',takeOver:false,notNull:'" + isNotNull + "',quantity:1,extensions:'gif,jpg,jpeg,bmp,png',applicationCategory:'" + ApplicationCategoryEnum.form.getKey() + "',embedInput:'" + fieldBean.getName() + "',isShowImg:true,attachmentTrId:'" + value4Db + "'\" attsdata='" + initValue4Img + "'></div>" + "<span class=\"ico16 insert_pic_16\" onclick=\"insertImage($(this.parentNode),'" + value4Db + "');\"></span>" + "<input type='hidden' id='" + getAttKey(fieldBean.getName(), String.valueOf(recordId)) + "' value=\"true\">"; //用来证明是否可以编辑
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        if (!StringUtil.checkNull(value4Db)) {
                            if (masterData != null && masterData.getExtraAttr(FormConstant.attachments) != null) {
                                atts = (List<Attachment>) masterData.getExtraAttr(FormConstant.attachments);
                                initValue4Img = getJsonAttStr(atts, Long.valueOf(value4Db));
                                if(h5Tag){
                                    FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                                    vo.setAttData(filterAttrBySubRef(atts, Long.valueOf(value4Db)));
                                }
                            }
                        }
                        value4Display = "<div class=\"comp\" comp=\"type:'fileupload',applicationCategory:'" + ApplicationCategoryEnum.form.getKey() + "',embedInput:'" + fieldBean.getName() + "',isShowImg:true,attachmentTrId:'" + value4Db + "',canDeleteOriginalAtts:false\" attsdata='" + initValue4Img + "'></div>";
                    }
                    /**********************H5*****************************/
                    if(h5Tag){
                        restVo.setAuth(access);
                    }
                    break;
                case BARCODE:
                    String initOneBarcode = "{}";//用于二维码的初始化
                    boolean isForward = "true".equals(String.valueOf(AppContext.getThreadContext("isFoward")));
                    boolean hasFindOne = false;
                    if (FieldAccessType.edit.getKey().equals(access) && fieldBean.getFormRelation() != null && fieldBean.getFormRelation().isFormRelationField()) {
                        access = FieldAccessType.browse.getKey();
                    }
                    if (!StringUtil.checkNull(value4Db)) {
                        AttachmentManager attachmentManager = (AttachmentManager) AppContext.getBean("attachmentManager");
                        if (masterData != null && masterData.getExtraAttr(FormConstant.attachments) != null) {
                            atts = (List<Attachment>) masterData.getExtraAttr(FormConstant.attachments);
                            List<Attachment> oneList = new ArrayList<Attachment>();
                            for (Attachment one : atts) {
                                if (value4Db.equals(String.valueOf(one.getSubReference().longValue()))) {
                                    hasFindOne = true;
                                    if(isForward){//转发的时候，要复制一份二维码出来,防止后续结点处理之后，原始的二维码被删除了
                                        Long newSubId4Forward = UUIDLong.longUUID();
                                        attachmentManager.copy(one.getReference(), one.getSubReference(), newSubId4Forward, newSubId4Forward, ApplicationCategoryEnum.form.getKey());
                                        oneList.addAll(attachmentManager.getByReference(newSubId4Forward, newSubId4Forward));
                                        initOneBarcode = getJsonAttStr(oneList, newSubId4Forward);
                                    }else{
                                        oneList.add(one);
                                        initOneBarcode = getJsonAttStr(oneList, one.getSubReference());
                                    }
                                    initOneBarcode = initOneBarcode.substring(1, initOneBarcode.length() - 1);
                                    break;
                                }
                            }
                            if (h5Tag) {
                                FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                                vo.setAttData(filterAttrBySubRef(atts, Long.valueOf(value4Db)));
                            }
                        }
                        //缓存里面没有找到二维码的时候，再从数据库查一下，M1轻原表单切换的时候缓存里面没有切换前生成的二维码（新建的时候）
                        if(!hasFindOne){
                            String moduleIdStr = String.valueOf(masterData.getExtraAttr("moduleId"));
                            if(!StringUtil.checkNull(moduleIdStr)){
                                Long moduleId = Long.valueOf(moduleIdStr);
                                atts  = attachmentManager.getByReference(moduleId, Long.valueOf(value4Db));
                                //新建表单的时候，生成二维码之后切换到原样表单，传过来的moduleId是templateId，这里需要取协同id
                                if(atts == null || atts.size() == 0){
                                    Long summaryId = (Long)AppContext.getThreadContext("_summaryId");
                                    if(summaryId != null){
                                        atts  = attachmentManager.getByReference(summaryId, Long.valueOf(value4Db));
                                    }
                                }
                                if(atts != null && atts.size() > 0){
                                    List<Attachment> oneList = new ArrayList<Attachment>();
                                    for (Attachment one : atts) {
                                        if (value4Db.equals(String.valueOf(one.getSubReference().longValue()))) {
                                            hasFindOne = true;
                                            oneList.add(one);
                                            initOneBarcode = getJsonAttStr(oneList, one.getSubReference());
                                            initOneBarcode = initOneBarcode.substring(1, initOneBarcode.length() - 1);
                                            break;
                                        }
                                    }
                                    if (h5Tag) {
                                        FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                                        vo.setAttData(filterAttrBySubRef(atts, Long.valueOf(value4Db)));
                                    }
                                }
                            }

                        }
                    }
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        String onlyShowDel = String.valueOf(auth.getExtraAttr("onlyShowDel"));
                        isNotNull = false;
                        if ("true".equals(onlyShowDel)) {
                            value4Display = "<input id=\"" + fieldBean.getName() + "\" name=\"" + fieldBean.getName() + "\" class=\"comp\" comp=\"type:'barCode',showBtnDel:true,category:'" + ApplicationCategoryEnum.form.getKey() + "',notNull:'" + isNotNull + "'\" " + (hasFindOne ? ("attr='" + initOneBarcode + "'") : "") + "/>" + "<input type='hidden' id='" + getAttKey(fieldBean.getName(), String.valueOf(recordId)) + "' value=\"true\">";
                        } else {
                            value4Display = "<input id=\"" + fieldBean.getName() + "\" name=\"" + fieldBean.getName() + "\" class=\"comp\" comp=\"type:'barCode',showBtnAdd:true,showBtnDel:true,preCallback:preToBarcode,callback:newBarcodeBack,category:'" + ApplicationCategoryEnum.form.getKey() + "',notNull:'" + isNotNull + "'\" " + (hasFindOne ? ("attr='" + initOneBarcode + "'") : "") + "/>" + "<input type='hidden' id='" + getAttKey(fieldBean.getName(), String.valueOf(recordId)) + "' value=\"true\">";
                        }

                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        value4Display = "<input id=\"" + fieldBean.getName() + "\" name=\"" + fieldBean.getName() + "\" class=\"comp\" comp=\"type:'barCode',category:'" + ApplicationCategoryEnum.form.getKey() + "'\" " + (hasFindOne ? ("attr='" + initOneBarcode + "'") : "") + "/>";
                    }
                    /**********************H5*****************************/
                    if(h5Tag){
                        restVo.setAuth(access);
                        restVo.setNotNull(isNotNull);
                    }
                    break;
                case EXTEND_PROJECT://InputType.EXTEND_PROJECT 选择关联项目
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        htmlAttrData.put("comp", "type:\"chooseProject\",value:\"" + value4Db + "\",text:\"" + Strings.escapeJson(value4Display) + "\"" + (bizModel ? ",resetCallback:chooseProjectCallBack,okCallback:chooseProjectCallBack" : ""));
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        htmlAttrData.put("value", value4Db);
                        value4Display = Strings.toHTML(value4Display);
                    }
                    break;
                case RELATIONFORM://InputType.EXTEND_RELATIONFORM 选择关联表单
                    Map<String, FormRelationRecord> relationDataMap = null;
                    FormRelationRecord record = null;
                    if (masterData != null) {
                        relationDataMap = masterData.getFormRelationRecordMap();
                        if (relationDataMap != null) {
                            String relationRecordKey = masterData.getId() + FormConstant.DOWNLINE + fieldBean.getName() + FormConstant.DOWNLINE + recordId;
                            record = relationDataMap.get(relationRecordKey);
                        }
                    }
                    FormRelation formRelation = fieldBean.getFormRelation();
                    FormRelation cloneRelation = null;
                    try {
                        if (formRelation != null) {
                            cloneRelation = (FormRelation) formRelation.clone();
                            cloneRelation.putExtraAttr("formulaStr", "");
                        }
                    } catch (CloneNotSupportedException e) {
                        LOGGER.error(e.getMessage(), e);
                    }
                    FormFieldBean cloneFieldBean = fieldBean.findRealFieldBean();//关联表单要使用被关联的单元格控件类型作为显示样式
                    FormCacheManager formCacheManager = (FormCacheManager) AppContext.getBean("formCacheManager");
                    List<FormRelationFormRestVO> relationVoList = new ArrayList<FormRelationFormRestVO>();
                    boolean through = false;
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        if (!bizModel) {
                            return getHTML(form, cloneFieldBean, null);
                        }
                        FormAuthViewFieldBean cloneAuth = null;//关联表单只能使用被关联单元格控件的浏览权限的样式
                        try {
                            cloneAuth = (FormAuthViewFieldBean) auth.clone();
                            if (!h5Tag || FormUtil.isPcForm()) {
                                cloneAuth.setAccess(FieldAccessType.browse.getKey());
                            }
                        } catch (CloneNotSupportedException e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                        //无流程表单的关联表单字段分手动选择和系统判断条件自动选择
                        if (formRelation.getViewSelectType() == ViewSelectType.system.getKey()) {
                            return getHTML(form, cloneFieldBean, cloneAuth, value, data, bizModel);
                        } else {//已经关联了表单的，关联控件再最后追加选择按钮，允许重新选择关联表单
                            //判断cloneFieldBean是否是关联多级枚举，如果是需要预处理value
                            AppContext.putThreadContext("setColor","true");
                            String toFieldStr = "";
                            //在编辑的时候如果设置处勾选了显示关联表单流程，则需要点击标题就可以查看被关联表单
                            if (formRelation.getViewType() != null && formRelation.getViewType().intValue() == ViewType.viewForm.getKey() && record != null) {//插入单据显示
                                toFieldStr = getHTML(form, cloneFieldBean, cloneAuth, value, data, bizModel);
                                if(!fieldBean.isAttachment(true,true)){
                                    through = true;
                                }
                            } else if (formRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_flow.getKey() && record != null) {//关联流程名称一定是要显示关联表单来源的
                                StringBuffer colSb = new StringBuffer();
                                if (formRelation.getViewType() != null && formRelation.getViewType().intValue() == ViewType.viewFlowForm.getKey() && record != null) {
                                    Long toModuleId = record.getToMasterDataId();
                                    FormRelationManager formRelationManager = (FormRelationManager) AppContext.getBean("formRelationManager");
                                    List<CtpContentAll> contents = formRelationManager.getFormMasterDataIdByToModyleId(masterData.getId(), toModuleId);
                                    for (CtpContentAll content : contents) {
                                        Long tempLateId = content.getModuleTemplateId();
                                        TemplateManager templateManager = (TemplateManager) AppContext.getBean("templateManager");
                                        CtpTemplate template = templateManager.getCtpTemplate(tempLateId);
                                        if (template == null) {
                                            continue;
                                        }
                                        if (content.getModuleId() != null) {
                                            AffairManager affairManager = (AffairManager) AppContext.getBean("affairManager");
                                            CtpAffair affair = affairManager.getSenderAffair(content.getModuleId());
                                            if (affair != null && affair.getState() == 1) {//待发状态不显示
                                                continue;
                                            }
                                        }
                                        if (template.isDelete()) {
                                            colSb.append("<span style=\"margin-left:16px;display:block;color:red\">已关联表单流程模板被删除，将不再显示已关联表单流程。</span>");
                                        } else {
                                            WorkflowApiManager wapi = (WorkflowApiManager) AppContext.getBean("wapi");
                                            if(template.getWorkflowId()==0l){
                                            	continue;
                                            }
                                            String formOpeName = wapi.getNodeFormOperationName(template.getWorkflowId(), null);
                                            FormBean tempFormBean = formCacheManager.getForm(content.getContentTemplateId());
                                            FormAuthViewBean tempOperation = tempFormBean.getAuthViewBeanById(Long.parseLong(formOpeName));
                                            String title = content.getTitle() == null ? "" : content.getTitle();
                                            String showTitle = title.length() > 10 ? (title.substring(0, 10) + "...") : title;
                                            colSb.append("<span title=\"" + title + "\" style=\"margin-left:16px;display:block;\" onmouseover=\"this.style.cursor='pointer'\" onclick=\"showSummayDialog(null,'" + content.getModuleId() + "',null,'formRelation','" + tempOperation.getFormViewId() + "." + tempOperation.getId() + "','" + title + "',null,null,$('#moduleId').eq(0).val())\" >" + showTitle + "</span>");
                                            FormRelationFormRestVO vo = new FormRelationFormRestVO(tempFormBean.getFormType(), content.getModuleId(), tempOperation.getFormViewId() + "." + tempOperation.getId(), title);
                                            relationVoList.add(vo);
                                        }
                                    }
                                }
                                String bef = "<span onclick=\"" + FormJsFun.showFormRelationRecord.toString() + "\" showType=\"" + ViewType.viewFlowForm.getKey() + "\" fname=\"" + fieldBean.getName() + "\" style=\"cursor:pointer;\">" + FormConstant.colHead;
                                String af = "</span>" + colSb.toString();
                                if(!h5Tag || FormUtil.isPcForm()){//这里可以把value替换为data也是同样的效果
                                    toFieldStr = getHTML(form, cloneFieldBean, cloneAuth, bef, value, af, bizModel);
                                }
                                through = true;
                            } else if (formRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_formContent.getKey() && record != null) {
                                //关联表单正文
                                toFieldStr = getHTML(form, cloneFieldBean, cloneAuth, null, data, null, bizModel);
                            } else {
                                toFieldStr = getHTML(form, cloneFieldBean, cloneAuth, value, data, bizModel);
                            }
                            FormBean toFormBean = formCacheManager.getForm(formRelation.getToRelationObj());
                            int bindSize = 0;
                            if (formCacheManager.isEnabled(toFormBean)) {
                                if (toFormBean.getFormType() == FormType.processesForm.getKey() || toFormBean.getFormType() == FormType.planForm.getKey()) {
                                    List<CtpTemplate> templateList = FormService.getFormSystemTemplate(toFormBean.getId());
                                    bindSize += templateList.size();
                                } else if (toFormBean.getFormType() == FormType.manageInfo.getKey()) {
                                    bindSize = toFormBean.getBind().getUnflowFormBindAuthByUserId(AppContext.currentUserId()).size();
                                } else if (toFormBean.getFormType() == FormType.baseInfo.getKey()) {
                                    bindSize = toFormBean.getBind().getUnFlowTemplateMap().size();
                                }
                                if(auth.getAccess().equals(FieldAccessType.edit.getKey())&&isNotNull){
                                    toFieldStr = toFieldStr.replaceFirst("browse_class", "browse_class editableSpan");
                                }
                                toFieldStr = StringUtils.replaceLast(toFieldStr, "</span>", "<span onmouseover=\"this.style.cursor='pointer'\" onclick=\"" + FormJsFun.showRelationList + "\" class=\"ico16 correlation_form_16\" name=\"" + fieldBean.getName() + "\" isNull=\"" + isNotNull + "\" hasRelatied=\"" + (record != null ? "true" : "false") + "\" relation='" + cloneRelation.toJSON() + "' formType=\"" + toFormBean.getFormType() + "\" formName=\"" + toFormBean.getFormName() + "\" templateSize=\"" + bindSize + "\"></span></span>");
                            } else {
                                toFieldStr = StringUtils.replaceLast(toFieldStr, "</span>", "<span onmouseover=\"this.style.cursor='pointer'\" onclick=\"" + FormJsFun.showRelationList + "\" class=\"ico16 correlation_form_16\" name=\"" + fieldBean.getName() + "\" isNull=\"" + isNotNull + "\" hasRelatied=\"" + (record != null ? "true" : "false") + "\" relation='" + cloneRelation.toJSON() + "' toFormDel=\"true\" templateSize=\"" + bindSize + "\"></span></span>");
                            }
                            if (h5Tag) {
                                FormFieldValueBaseRestVO restVO = getRestVO(fieldKey);
                                if (restVO != null) {
                                    restVO.setRelationList(relationVoList);
                                    restVO.setThrough(through);
                                    restVO.setAuth(access);
                                    restVO.addExtAttr("templateSize",bindSize);
                                    restVO.addExtAttr("formName",toFormBean == null?"":toFormBean.getFormName());
                                }
                            }
                            return toFieldStr;
                        }
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        //无流程表单的关联表单字段分手动选择和系统判断条件自动选择
                        if (formRelation.getViewSelectType() == ViewSelectType.system.getKey()) {
                            return getHTML(form, cloneFieldBean, auth, value, data, bizModel);
                        } else {
                            String toFieldStr = "";
                            if (formRelation.getViewType() != null && formRelation.getViewType().intValue() == ViewType.viewForm.getKey() && record != null) {//插入单据显示
                                toFieldStr = getHTML(form, cloneFieldBean, auth, value, data, bizModel);
                                //非系统停用的，才能穿透
                                FormBean fb = formRelation.findToFormBean();
                                if (!formCacheManager.isSystemDisabledForm(fb) && FormType.canUse(fb.getFormType())) {
                                    toFieldStr = StringUtils.replaceLast(toFieldStr, "</span>", "<span class=\"margin_l_5 ico16 documents_penetration_16\" title=\"" + ResourceUtil.getString("form.base.showResurce.title") + "\" onclick=\"" + FormJsFun.showFormRelationRecord.toString() + "\" fname=\"" + fieldBean.getName() + "\" showType=\"" + String.valueOf(formRelation.getViewType()) + "\"></span></span>");
                                    through = true;
                                }
                            } else if (formRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_flow.getKey() && record != null) {//关联流程名称一定是要显示关联表单来源的
                                StringBuffer colSb = new StringBuffer();
                                if (formRelation.getViewType() != null && formRelation.getViewType().intValue() == ViewType.viewFlowForm.getKey()) {
                                    Long toModuleId = record.getToMasterDataId();
                                    FormRelationManager formRelationManager = (FormRelationManager) AppContext.getBean("formRelationManager");
                                    List<CtpContentAll> contents = formRelationManager.getFormMasterDataIdByToModyleId(masterData.getId(), toModuleId);
                                    for (CtpContentAll content : contents) {
                                        Long tempLateId = content.getModuleTemplateId();
                                        TemplateManager templateManager = (TemplateManager) AppContext.getBean("templateManager");
                                        CtpTemplate template = templateManager.getCtpTemplate(tempLateId);
                                        if (template == null) {
                                            continue;
                                        }
                                        if (content.getModuleId() != null) {
                                            AffairManager affairManager = (AffairManager) AppContext.getBean("affairManager");
                                            CtpAffair affair = affairManager.getSenderAffair(content.getModuleId());
                                            if (affair != null && affair.getState() == 1) {//待发状态不显示
                                                continue;
                                            }
                                        }
                                        WorkflowApiManager wapi = (WorkflowApiManager) AppContext.getBean("wapi");
                                        if(template.getWorkflowId()==0l){
                                            continue;
                                        }
                                        String formOpeName = wapi.getNodeFormOperationName(template.getWorkflowId(), null);
                                        FormBean tempFormBean = formCacheManager.getForm(content.getContentTemplateId());
                                        FormAuthViewBean tempOperation = tempFormBean.getAuthViewBeanById(Long.parseLong(formOpeName));
                                        String title = content.getTitle() == null ? "" : content.getTitle();
                                        String showTitle = title.length() > 10 ? (title.substring(0, 10) + "...") : title;
                                        colSb.append("<span title=\"" + title + "\" style=\"margin-left:16px;display:block;\" onmouseover=\"this.style.cursor='pointer'\" onclick=\"showSummayDialog(null,'" + content.getModuleId() + "',null,'formRelation','" + tempOperation.getFormViewId() + "." + tempOperation.getId() + "','" + title + "',null,null,$('#moduleId').eq(0).val())\">" + showTitle + "</span>");
                                        FormRelationFormRestVO vo = new FormRelationFormRestVO(tempFormBean.getFormType(), content.getModuleId(), tempOperation.getFormViewId() + "." + tempOperation.getId(), title);
                                        relationVoList.add(vo);
                                    }
                                }
                                String bef = "<span onclick=\"" + FormJsFun.showFormRelationRecord.toString() + "\" showType=\"" + ViewType.viewFlowForm.getKey() + "\" fname=\"" + fieldBean.getName() + "\" style=\"cursor:pointer;\">" + FormConstant.colHead;
                                through = true;
                                String af = "</span>" + colSb.toString();
                                toFieldStr = getHTML(form, cloneFieldBean, auth, bef, value, af, bizModel);
                            } else if (formRelation.getToRelationAttrType().intValue() == ToRelationAttrType.form_relation_formContent.getKey() && record != null) {
                                //关联表单正文
                                toFieldStr = getHTML(form, cloneFieldBean, auth, null, data, null, bizModel);
                            } else {
                                toFieldStr = getHTML(form, cloneFieldBean, auth, value, data, bizModel);
                            }
                            if (h5Tag) {
                                FormFieldValueBaseRestVO restVO = getRestVO(fieldKey);
                                if (restVO != null) {
                                    restVO.setRelationList(relationVoList);
                                    restVO.setThrough(through);
                                    restVO.setAuth(access);
                                }
                            }
                            return toFieldStr;
                        }
                    }
                    break;
                case RELATION://InputType.RELATION 数据关联
                    FormFieldBean clonedField = fieldBean.findRealFieldBean();
                    //做一下relation为null的日志信息,同时防护下死循环
                    if (RELATION.getKey().equals(clonedField.getInputType()) && clonedField.getFormRelation() == null) {
                        LOGGER.error(form.getId() + "表单字段数据关联丢失了：" + fieldBean.getDisplay());
                    }
                    FormAuthViewFieldBean browseAuth = null;//关联表单只能使用被关联单元格控件的浏览权限的样式
                    boolean isBarCode = false;
                    //关联的二维码如果为编辑权限， 则只能出现删除图标
                    if (FieldAccessType.edit.getKey().equals(access) && fieldBean.getFinalInputType().equals(BARCODE.getKey())) {
                        try {
                            browseAuth = (FormAuthViewFieldBean) auth.clone();
                            browseAuth.putExtraAttr("onlyShowDel", "true");
                            isBarCode = true;
                            if(h5Tag){
                                browseAuth.setAccess(FieldAccessType.browse.getKey());
                            }
                        } catch (CloneNotSupportedException e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                    }
                    //关联图片枚举,单独处理
                    return getHTML(form, clonedField, isBarCode ? browseAuth : auth, value, data, bizModel);
                case OUTWRITE://InputType.OUTWRITE 外部写入
                    if (FieldAccessType.edit.getKey().equals(access) || FieldAccessType.browse.getKey().equals(access)) {
                        try {
                            FormFieldBean cloneFieldBean4outwrite = (FormFieldBean) fieldBean.clone();
                            cloneFieldBean4outwrite.putExtraAttr("isOutwriteField", "isOutwrite");
                            FormFieldComEnum fieldEnumFormat = FormFieldComEnum.getEnumByKey(fieldBean.getFormatType());
                            //附件回写支持添加 add by chenxb 2016-02-23
                            if(Strings.isNotBlank(fieldBean.getFormatType()) && FormConstant.MULTI_ATTACHMENT.equals(fieldBean.getFormatType())){
                                fieldEnumFormat = FormFieldComEnum.EXTEND_ATTACHMENT;
                            }
                            if (!bizModel) {
                                if (Strings.isNotBlank(fieldBean.getFormatType()) && fieldEnumFormat != null) {
                                    cloneFieldBean4outwrite.setFieldTypeEnum(fieldEnumFormat);
                                    return getHTML(form, cloneFieldBean4outwrite, auth, value, bizModel);
                                } else if (Strings.isNotBlank(fieldBean.getFormatType()) && "flowTitle".equals(fieldBean.getFormatType())) {
                                    cloneFieldBean4outwrite.setInputType(FormFieldComEnum.TEXT.getKey());
                                    return getHTML(form, cloneFieldBean4outwrite, auth, value, data, bizModel);
                                } else {
                                    if (fieldBean.getFieldType().equals(FieldType.DATETIME.getKey())) {
                                        cloneFieldBean4outwrite.setInputType(FormFieldComEnum.EXTEND_DATETIME.getKey());
                                        return getHTML(form, cloneFieldBean4outwrite, auth, value, data, bizModel);
                                    } else if (fieldBean.getFieldType().equals(FieldType.TIMESTAMP.getKey())) {
                                        cloneFieldBean4outwrite.setInputType(FormFieldComEnum.EXTEND_DATE.getKey());
                                        return getHTML(form, cloneFieldBean4outwrite, auth, value, data, bizModel);
                                    } else {
                                        cloneFieldBean4outwrite.setInputType(FormFieldComEnum.TEXT.getKey());
                                        return getHTML(form, cloneFieldBean4outwrite, auth, value, data, bizModel);
                                    }
                                }
                            } else {
                                FormAuthViewFieldBean authClone = (FormAuthViewFieldBean) auth.clone();
                                if (Strings.isNotBlank(fieldBean.getFormatType()) && fieldEnumFormat != null) {
                                    if (!fieldBean.isMatchFieldTypeAndValue4OutwriteField(value)) {
                                        cloneFieldBean4outwrite.setFieldTypeEnum(FormFieldComEnum.TEXT);
                                        return getHTML(form, cloneFieldBean4outwrite, authClone, value, data, bizModel);
                                    }
                                    cloneFieldBean4outwrite.setFieldTypeEnum(fieldEnumFormat);
                                    if (fieldEnumFormat.ordinal() == FormFieldComEnum.SELECT.ordinal()) {
                                        long formatEnumId = cloneFieldBean4outwrite.getFormatEnumId();
                                        int formatEnumLevel = cloneFieldBean4outwrite.getFormatEnumLevel();
                                        cloneFieldBean4outwrite.setFormatType(cloneFieldBean4outwrite.getImageEnumFormat());
                                        if (formatEnumId != 0L) {
                                            FormRelation relation = fieldBean.getFormRelation();
                                            boolean isDataRel = relation != null && relation.isDataRelation();
                                            //如果是数据关联的外部写入字段时，并且外部写入字段的类型是枚举时，数据关联字段默认显示枚举(下拉列表)
                                            if (StringUtil.checkNull(String.valueOf(valuesWithDisplay[0])) && !isDataRel) {
                                                value4Display = "";
                                            } else {
                                                cloneFieldBean4outwrite.setEnumId(formatEnumId);
                                                cloneFieldBean4outwrite.setInputType(FormFieldComEnum.SELECT.getKey());
                                                cloneFieldBean4outwrite.setEnumLevel(formatEnumLevel);
                                                cloneFieldBean4outwrite.setIsFinalChild(cloneFieldBean4outwrite.isFormatEnumIsFinalChild());
                                                if (formatEnumLevel != 0) {
                                                    cloneFieldBean4outwrite.putExtraAttr(FormConstant.toFieldIsMultiEnum, "true");
                                                }
                                                return getHTML(form, cloneFieldBean4outwrite, authClone, data, bizModel);
                                            }
                                        } else {
                                            EnumManager enumManager = (EnumManager) AppContext.getBean("enumManagerNew");
                                            CtpEnumItem item = null;
                                            if (!StringUtil.checkNull(String.valueOf(valuesWithDisplay[0]))) {
                                                item = enumManager.getCtpEnumItem(Long.valueOf(String.valueOf(valuesWithDisplay[0])));
                                            } else {
                                                value4Display = "";
                                            }
                                            if (item != null) {
                                                cloneFieldBean4outwrite.setEnumId(item.getRefEnumid());
                                                cloneFieldBean4outwrite.setInputType(FormFieldComEnum.SELECT.getKey());
                                                cloneFieldBean4outwrite.setEnumLevel(item.getLevelNum());
                                                cloneFieldBean4outwrite.setIsFinalChild(Boolean.FALSE);
                                                cloneFieldBean4outwrite.setEnumParent(String.valueOf(item.getParentId()));
                                                return getHTML(form, cloneFieldBean4outwrite, authClone, data, bizModel);
                                            } else {
                                                value4Display = StringUtil.checkNull(String.valueOf(valuesWithDisplay[0])) ? "" : String.valueOf(valuesWithDisplay[0]);
                                            }
                                        }
                                    } else if (data != null && (fieldEnumFormat.ordinal() == FormFieldComEnum.EXTEND_IMAGE.ordinal() || fieldEnumFormat.ordinal() == FormFieldComEnum.EXTEND_ATTACHMENT.ordinal() || fieldEnumFormat.ordinal() == FormFieldComEnum.EXTEND_DOCUMENT.ordinal())) {//附件，图片，文档
                                        //OA-94443	主表数据关联字段，关联属性为图片，新建数据时显示只有图标没有控件框，重复表显示就正常
                                        cloneFieldBean4outwrite.setInputType(fieldEnumFormat.getKey());
                                        return getHTML(form, cloneFieldBean4outwrite, authClone, data, bizModel);
                                    } else {
                                        return getHTML(form, cloneFieldBean4outwrite, authClone, value, data, bizModel);
                                    }
                                } else if (Strings.isNotBlank(fieldBean.getFormatType()) && "flowTitle".equals(fieldBean.getFormatType())) {
                                    cloneFieldBean4outwrite.setFieldTypeEnum(FormFieldComEnum.TEXT);
                                    String toFieldStr = getHTML(form, cloneFieldBean4outwrite, authClone, value, data, bizModel);
                                    FormRelationRecordDAO dao = (FormRelationRecordDAO) AppContext.getBean("formRelationRecordDAO");
                                    if (data != null) {
                                        long formMasterDataId = 0l;
                                        long fromSubDataId = 0l;
                                        Map<String, FormRelationRecord> cacheRelationRecord = new HashMap<String, FormRelationRecord>();
                                        if (data instanceof FormDataSubBean) {//从表数据对应的行号
                                            formMasterDataId = ((FormDataSubBean) data).getFormmainId();
                                            fromSubDataId = ((FormDataSubBean) data).getId();
                                            cacheRelationRecord = masterData.getFormRelationRecordMap();
                                        } else if (data instanceof FormDataMasterBean) {
                                            formMasterDataId = masterData.getId();
                                            cacheRelationRecord = masterData.getFormRelationRecordMap();
                                        }
                                        FormRelationRecord fillBackRecord = dao.selectByDataAndFieldName(formMasterDataId, RelationDataCreatType.writeBack.getKey(), fieldBean.getName(), fromSubDataId);
                                        //通过赋值行得来的外部写入流程名称的关联记录还没有入库，从缓存里取一下。
                                        if(fillBackRecord == null && cacheRelationRecord != null){
                                            fillBackRecord = cacheRelationRecord.get(formMasterDataId+"_"+fieldBean.getName()+"_"+fromSubDataId);
                                        }
                                        if (fillBackRecord != null) {
                                            Map contentParam = new HashMap();
                                            contentParam.put("moduleType", ModuleType.collaboration.getKey());
                                            contentParam.put("moduleId", fillBackRecord.getToMasterDataId());
                                            //List<CtpContentAll> contentAllBeans = DBAgent.findByNamedQuery("ctp_common_content_findContentByModule", contentParam);
                                            List<CtpContentAll> contentAllBeans = MainbodyService.getInstance().getContentList(contentParam);
                                            if (contentAllBeans != null && contentAllBeans.size() > 0) {
                                                TemplateManager templateManager = (TemplateManager) AppContext.getBean("templateManager");
                                                WorkflowApiManager wapi = (WorkflowApiManager) AppContext.getBean("wapi");
                                                Long tempLateId = contentAllBeans.get(0).getModuleTemplateId();
                                                CtpTemplate template = templateManager.getCtpTemplate(tempLateId);
                                                if (!template.isSystem()) {
                                                    template = templateManager.getCtpTemplate(template.getFormParentid());
                                                }
                                                //根据工作流ID去获取节点绑定的权限ID，第二个参数如果是空的话，取的就是发起者节点的权限
                                                String formOpeName = wapi.getNodeFormOperationName(template.getWorkflowId(), null);
                                                FormAuthViewBean tempOperation = FormService.getAuth(Long.parseLong(formOpeName));//toFormBean.getAuthViewBeanById(Long.parseLong(formOpeName));
                                                //如果没有取到权限，则在现有模板中找第一个显示权限
                                                if(tempOperation == null){
                                                    FormCacheManager cacheManager = (FormCacheManager) AppContext.getBean("FormCacheManager");
                                                    FormBean toFormBean = cacheManager.getForm(fillBackRecord.getToFormId());
                                                    List<FormAuthViewBean> auths = toFormBean.getAllFormAuthViewBeans();
                                                    for (FormAuthViewBean authView : auths) {
                                                        if (authView.getType().equalsIgnoreCase(FormAuthorizationType.show.getKey())) {
                                                            tempOperation = authView;
                                                            break;
                                                        }
                                                    }
                                                }
                                                //OA-108461 被回写流程名称，人员a不在该流程，穿透查看提示无权，之前版本就可以 回写的流程标题穿透的时候增加参数，保持和form.js里面的一致
                                                toFieldStr = toFieldStr.replaceFirst("<span", "<span style=\"cursor:pointer;\" onclick=\"showSummayDialog(null,'" + fillBackRecord.getToMasterDataId() + "',null,'formRelation','" + tempOperation.getFormViewId() + "." + tempOperation.getId() + "','" + Strings.toHTML(contentAllBeans.get(0).getTitle()) + "',null,null,'" + fillBackRecord.getFromMasterDataId() + "')\"");
                                                if(h5Tag){
                                                    FormFieldValueBaseRestVO restVO = getRestVO(fieldKey);
                                                    if(restVO != null){
                                                        restVO.addExtAttr("dataId",fillBackRecord.getToMasterDataId());
                                                        //restVO.addExtAttr("rightId",tempOperation.getFormViewId() + "." + tempOperation.getId());
                                                        restVO.addExtAttr("formType",FormType.processesForm.getKey());
                                                        restVO.setThrough(true);
                                                    }
                                                }
                                            }
                                        }
                                        return toFieldStr;
                                    }
                                } else {
                                    if (fieldBean.getFieldType().equals(FieldType.DATETIME.getKey())) {
                                        cloneFieldBean4outwrite.setInputType(FormFieldComEnum.EXTEND_DATETIME.getKey());
                                        return getHTML(form, cloneFieldBean4outwrite, authClone, value, data, bizModel);
                                    } else if (fieldBean.getFieldType().equals(FieldType.TIMESTAMP.getKey())) {
                                        cloneFieldBean4outwrite.setInputType(FormFieldComEnum.EXTEND_DATE.getKey());
                                        return getHTML(form, cloneFieldBean4outwrite, authClone, value, data, bizModel);
                                    } else {
                                        cloneFieldBean4outwrite.setInputType(FormFieldComEnum.TEXT.getKey());
                                        return getHTML(form, cloneFieldBean4outwrite, authClone, value, data, bizModel);
                                    }
                                }
                            }
                        } catch (Exception e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                        htmlAttrData.put("value", value4Display);
                    }
                    break;
                case PREPAREWRITE://InputType.PREPAREWRITE 外部预写
                    try {//被关联的时候可以编辑
                        FormFieldBean cloneFieldBean4outwrite = (FormFieldBean) fieldBean.clone();
                        cloneFieldBean4outwrite.setInputType(FormFieldComEnum.TEXT.getKey());
                        FormAuthViewFieldBean authClone = (FormAuthViewFieldBean) auth.clone();
                        return getHTML(form, cloneFieldBean4outwrite, authClone, StringUtil.checkNull(String.valueOf(value)) ? null : ((BigDecimal) value).abs(), data, bizModel);
                    } catch (Exception e) {
                        LOGGER.error(e.getMessage(), e);
                    }
						
/*                        if(FieldAccessType.edit.getKey().equals(access)){
                            htmlAttrData.put("value", bizModel?value4Display:String.valueOf(value==null?"":value));
                        }
*/
                case EXTEND_EXCHANGETASK://InputType.EXTEND_EXCHANGETASK 选择数据交换任务
                    if (bizModel) {
                        if (FieldAccessType.edit.getKey().equals(access)) {
                            htmlAttrData.put("value", value4Display);
                            htmlAttrData.put("default", value4Display);
                            //h5这边需要把日期时间格式化一下
                            if (h5Tag && valuesWithDisplay[0] instanceof Date) {
                                if(fieldBean.getFieldType().equals(FieldType.DATETIME.getKey())){
                                    restVo.setValue(Datetimes.formatNoTimeZone((Date) valuesWithDisplay[0], Datetimes.datetimeWithoutSecondStyle));
                                }else if(fieldBean.getFieldType().equals(FieldType.TIMESTAMP.getKey())){
                                    restVo.setValue(Datetimes.formatNoTimeZone((Date) valuesWithDisplay[0], Datetimes.dateStyle));
                                }
                            }
                        } else if (FieldAccessType.browse.getKey().equals(access)) {
                            htmlAttrData.put("value", value4Display);
                            htmlAttrData.put("default", value4Display);
                        }
                    } else {
                        try {
                            FormFieldBean cloneFieldBean4outwrite = (FormFieldBean) fieldBean.clone();
                            // bug OA-95652 dee日期字段没有日期图标
                            if (fieldBean.getFieldType().equals(FieldType.TIMESTAMP.getKey())) {
                                cloneFieldBean4outwrite.setInputType(FormFieldComEnum.EXTEND_DATE.getKey());
                            } else if (fieldBean.getFieldType().equals(FieldType.DATETIME.getKey())) {
                                cloneFieldBean4outwrite.setInputType(FormFieldComEnum.EXTEND_DATETIME.getKey());
                            } else {
                                cloneFieldBean4outwrite.setInputType(FormFieldComEnum.TEXT.getKey());
                            }
                            return getHTML(form, cloneFieldBean4outwrite, auth, value, data, bizModel);
                        } catch (CloneNotSupportedException e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                    }
                    break;
                case EXTEND_QUERYTASK://InputType.EXTEND_QUERYTASK 查询控件交换引擎任务
                    if (bizModel) {
                        if (FieldAccessType.edit.getKey().equals(access)) {
                            htmlAttrData.put("value", value4Display);
                            htmlAttrData.put("default", value4Display);
                        } else if (FieldAccessType.browse.getKey().equals(access)) {
                            htmlAttrData.put("value", value4Display);
                            htmlAttrData.put("default", value4Display);
                        }
                    } else {
                        try {
                            FormFieldBean cloneFieldBean4outwrite = (FormFieldBean) fieldBean.clone();
                            // bug OA-95652 dee日期字段没有日期图标
                            if (fieldBean.getFieldType().equals(FieldType.TIMESTAMP.getKey())) {
                                cloneFieldBean4outwrite.setInputType(FormFieldComEnum.EXTEND_DATE.getKey());
                            } else if (fieldBean.getFieldType().equals(FieldType.DATETIME.getKey())) {
                                cloneFieldBean4outwrite.setInputType(FormFieldComEnum.EXTEND_DATETIME.getKey());
                            } else {
                                cloneFieldBean4outwrite.setInputType(FormFieldComEnum.TEXT.getKey());
                            }
                            return getHTML(form, cloneFieldBean4outwrite, auth, value, data, bizModel);
                        } catch (CloneNotSupportedException e) {
                            LOGGER.error(e.getMessage(), e);
                        }
                    }
                    break;
                case CUSTOM_PLAN://计划控件
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        htmlAttrData.put("value", value4Display);
                        htmlAttrData.put("subTableName", fieldBean.getOwnerTableName());
                    }
                    if (FieldAccessType.browse.getKey().equals(access)) {
                        value4Display = Strings.toHTML(value4Display, true);
                        htmlAttrData.put("value", value4Display);
                        htmlAttrData.put("subTableName", fieldBean.getOwnerTableName());
                    }
                    break;
                case MAP_MARKED://地图标注
                    Long markedDataId = masterData == null ? 0l : masterData.getId();
                    String dateStr = "";
                    String addr = "";
                    if (!StringUtil.checkNull(value4Db)) {
                        LbsManager lbsm = (LbsManager) AppContext.getBean("lbsManager");
                        AttendanceListItem lbsItem = lbsm.getAttendanceInfoById(Long.parseLong(value4Db));
                        if (lbsItem != null) {
                            Date createDate = lbsItem.getCreateDate();
                            dateStr = Datetimes.formatNoTimeZone(createDate,Datetimes.dateStyle);
                            addr = lbsItem.getLbsAddr();
                            if(h5Tag){
                                FormFieldValue4LbsRestVO vo = (FormFieldValue4LbsRestVO) restVo;
                                vo.setMapVal(lbsItem);
                            }
                        }
                    }
                    if (FieldAccessType.edit.getKey().equals(access)) {
                        value4Display = addr;
                        String valdate = htmlAttrData.get("validate");
                        valdate = valdate.replace("maxLength:" + fieldBean.getMaxLength(), "maxLength:" + 200);
                        htmlAttrData.put("validate", valdate);
                        List<FormRelation> relationList = form.getRelationList();
                        String callBackStr = ",valueChange:" + FormJsFun.mapPointValueChangeCallBack.name();
                        for (FormRelation rel : relationList) {
                            if (bizModel && rel.getToRelationAttr().equals(fieldBean.getName()) && rel.getToRelationAttrType().intValue() == ToRelationAttrType.data_relation_map.getKey()) {
                                callBackStr += ",callback:" + FormJsFun.mapPointCallBack.name() + "";
                                break;
                            }
                        }
                        String mapValue = StringUtil.checkNull(value4Db) || "0".equals(value4Db) ? "" : ",value:\"" + value4Db + "\",text:\"" + Strings.escapeJson(value4Display) + "\"";
                        String str = "type:\"map\",miniType:\"1\",canEdit:\"true\",fieldName:\"" + fieldBean.getName() + "\"" + mapValue + callBackStr + ",isMasterField:" + fieldBean.isMasterField() + ",referenceRecordId:\"" + recordId + "\",referenceFormId:\"" + form.getId() + "\",referenceFormMasterDataId:\"" + markedDataId + "\"";
                        htmlAttrData.put("comp", str);
                    } else if (FieldAccessType.browse.getKey().equals(access)) {
                        value4Display = dateStr + " " + addr;
                        if (Strings.isBlank(value4Display)) {
                            value4Display = "";
                        }
                        htmlAttrData.remove("validate");
                        String mapValue = StringUtil.checkNull(value4Db) || "0".equals(value4Db) ? "" : ",value:\"" + value4Db + "\",text:\"" + Strings.escapeJson(value4Display) + "\"";
                        String str = "type:\"map\",miniType:\"1\",canEdit:\"false\",fieldName:\"" + fieldBean.getName() + "\"" + mapValue + ",isMasterField:" + fieldBean.isMasterField() + ",referenceRecordId:\"" + recordId + "\",referenceFormId:\"" + form.getId() + "\",referenceFormMasterDataId:\"" + markedDataId + "\"";
                        htmlAttrData.put("comp", str);
                    }
                    if(h5Tag){
                        restVo.setDisplay(value4Display);
                    }
                    break;
                case MAP_LOCATE://地图定位
                    Long locateDataId = masterData == null ? 0l : masterData.getId();
                    if (!StringUtil.checkNull(value4Db)) {
                        LbsManager lbsm = (LbsManager) AppContext.getBean("lbsManager");
                        AttendanceListItem lbsItem = lbsm.getAttendanceInfoById(Long.parseLong(value4Db));
                        if (lbsItem != null) {
                            Date createDate = lbsItem.getCreateDate();
                            String date = Datetimes.formatNoTimeZone(createDate,Datetimes.datetimeWithoutSecondStyle);
                            value4Display = date + " " + lbsItem.getLbsAddr();
                            if(h5Tag){
                                FormFieldValue4LbsRestVO vo = (FormFieldValue4LbsRestVO) restVo;
                                vo.setMapVal(lbsItem);
                                vo.setDisplay(value4Display);
                            }
                        }
                    }
                    //移动端登录
                    if (FormUtil.isMobileLogin()) {
                        if (FieldAccessType.edit.getKey().equals(access)) {
                            String valdate = htmlAttrData.get("validate");
                            valdate = valdate.replace("maxLength:" + fieldBean.getMaxLength(), "maxLength:" + 200);
                            htmlAttrData.put("validate", valdate);
                            String mapValue = StringUtil.checkNull(value4Db) || "0".equals(value4Db) ? "" : ",value:\"" + value4Db + "\",text:\"" + Strings.escapeJson(value4Display) + "\"";
                            String str = "type:\"map\",miniType:\"3\",canEdit:\"true\",fieldName:\"" + fieldBean.getName() + "\"" + mapValue + ",isMasterField:" + fieldBean.isMasterField() + ",referenceRecordId:\"" + recordId + "\",referenceFormId:\"" + form.getId() + "\",referenceFormMasterDataId:\"" + locateDataId + "\"";
                            htmlAttrData.put("comp", str);
                        } else if (FieldAccessType.browse.getKey().equals(access)) {
                            htmlAttrData.remove("validate");
                            String mapValue = StringUtil.checkNull(value4Db) || "0".equals(value4Db) ? "" : ",value:\"" + value4Db + "\",text:\"" + Strings.escapeJson(value4Display) + "\"";
                            String str = "type:\"map\",miniType:\"3\",canEdit:\"false\",fieldName:\"" + fieldBean.getName() + "\"" + mapValue + ",isMasterField:" + fieldBean.isMasterField() + ",referenceRecordId:\"" + recordId + "\",referenceFormId:\"" + form.getId() + "\",referenceFormMasterDataId:\"" + locateDataId + "\"";
                            htmlAttrData.put("comp", str);
                        }
                    } else {//pc端登录
                        if (FieldAccessType.edit.getKey().equals(access)) {
                            htmlAttrData.remove("validate");
                            String mapValue = StringUtil.checkNull(value4Db) || "0".equals(value4Db) ? "" : ",value:\"" + value4Db + "\",text:\"" + Strings.escapeJson(value4Display) + "\"";
                            String str = "type:\"map\",miniType:\"3\",canEdit:\"true\",fieldName:\"" + fieldBean.getName() + "\"" + mapValue + ",isMasterField:" + fieldBean.isMasterField() + ",referenceRecordId:\"" + recordId + "\",referenceFormId:\"" + form.getId() + "\"";
                            htmlAttrData.put("comp", str);
                        } else if (FieldAccessType.browse.getKey().equals(access)) {//显示地址并给个按钮，点击按钮提示PC不支持。
                            htmlAttrData.remove("validate");
                            String mapValue = StringUtil.checkNull(value4Db) || "0".equals(value4Db) ? "" : ",value:\"" + value4Db + "\",text:\"" + Strings.escapeJson(value4Display) + "\"";
                            String str = "type:\"map\",miniType:\"3\",canEdit:\"false\",fieldName:\"" + fieldBean.getName() + "\"" + mapValue + ",isMasterField:" + fieldBean.isMasterField() + ",referenceRecordId:\"" + recordId + "\",referenceFormId:\"" + form.getId() + "\"";
                            htmlAttrData.put("comp", str);
                        }
                    }
                    break;
                case MAP_PHOTO://拍照定位
                    Long photoDataId = masterData == null ? 0l : masterData.getId();
                    //移动端登录
                    if (FormUtil.isMobileLogin() || h5Tag) {
                        if (FieldAccessType.edit.getKey().equals(access)) {
                            //htmlAttrData.remove("validate");
                            String mapValue = "";
                            if (!StringUtil.checkNull(value4Db)) {
                                mapValue = StringUtil.checkNull(value4Db) || "0".equals(value4Db) ? "" : ",value:\"" + value4Db + "\",text:\"" + Strings.escapeJson(value4Display) + "\"";
                                Long attRefId = Long.parseLong(value4Db);
                                AttachmentManager attachmentManager = (AttachmentManager) AppContext.getBean("attachmentManager");
                                List<Attachment> lbsAtts = attachmentManager.getByReference(attRefId, attRefId);
                                if (lbsAtts.size() > 0) {
                                	String attJson = getJsonAttStr(lbsAtts, attRefId);
                                    mapValue += ",attData:" + attJson + "";
                                    if(h5Tag){
                                        FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                                        vo.setAttData(lbsAtts);
                                    }
                                }
                            }
                            String str = "type:\"map\",miniType:\"4\",canEdit:\"true\",fieldName:\"" + fieldBean.getName() + "\"" + mapValue + ",isMasterField:" + fieldBean.isMasterField() + ",referenceRecordId:\"" + recordId + "\",referenceFormId:\"" + form.getId() + "\",referenceFormMasterDataId:\"" + photoDataId + "\"";
                            htmlAttrData.put("comp", str);
                        } else if (FieldAccessType.browse.getKey().equals(access)) {
                            if (!StringUtil.checkNull(value4Db)) {
                                Long attRefId = Long.parseLong(value4Db);
                                AttachmentManager attachmentManager = (AttachmentManager) AppContext.getBean("attachmentManager");
                                List<Attachment> lbsAtts = attachmentManager.getByReference(attRefId, attRefId);
                                if (lbsAtts.size() > 0) {
                                    Attachment lbsAtt = lbsAtts.get(0);
                                    if(h5Tag){
                                        FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                                        vo.setAttData(lbsAtts);
                                    }
                                    value4Bussiness = value4Display = "<img style=\"cursor: pointer;\" onclick=\"window.open($(this).attr('src'))\" src=\"/seeyon/fileUpload.do?method=showRTE&fileId=" + lbsAtt.getFileUrl() + "&createDate=" + DateUtil.getDate(lbsAtt.getCreatedate(), DateUtil.YEAR_MONTH_DAY_PATTERN) + "&type=image" + "&v=" + lbsAtt.getV() + "\">";
                                } else {
                                    value4Bussiness = value4Display = " ";
                                }
                            } else {
                                value4Bussiness = value4Display = " ";
                            }
                        }

                    } else {//pc端登录
                        if (FieldAccessType.edit.getKey().equals(access)) {
                            FormAuthViewFieldBean cloneAuth = null;
                            try {
                                cloneAuth = (FormAuthViewFieldBean) auth.clone(form);
                                cloneAuth.setAccess(FieldAccessType.browse.getKey());
                                String s = getHTML(form, fieldBean, cloneAuth, value4Db, bizModel);
                                s = StringUtils.replaceLast(s, "</span>", "<span class=\"ico16 cameraPosition_16\" onclick=\"$.alert('" + ResourceUtil.getString("form.display.map.cannotphoto") + "')\"></span></span>");
                                return s;
                            } catch (CloneNotSupportedException e) {
                                LOGGER.error(e.getMessage(), e);
                            }
                        } else if (FieldAccessType.browse.getKey().equals(access)) {
                            if (!StringUtil.checkNull(value4Db)) {
                                Long attRefId = Long.parseLong(value4Db);
                                AttachmentManager attachmentManager = (AttachmentManager) AppContext.getBean("attachmentManager");
                                List<Attachment> lbsAtts = attachmentManager.getByReference(attRefId, attRefId);
                                if (lbsAtts.size() > 0) {
                                	if(h5Tag){
                                        FormFieldValue4AttrRestVO vo = (FormFieldValue4AttrRestVO) restVo;
                                        vo.setAttData(lbsAtts);
                                    }
                                    Attachment lbsAtt = lbsAtts.get(0);
                                    value4Bussiness = value4Display = "<img style=\"cursor: pointer;\" onclick=\"window.open($(this).attr('src'))\" src=\"/seeyon/fileUpload.do?method=showRTE&fileId=" + lbsAtt.getFileUrl() + "&createDate=" + DateUtil.getDate(lbsAtt.getCreatedate(), DateUtil.YEAR_MONTH_DAY_PATTERN) + "&type=image\">";
                                } else {
                                    value4Bussiness = value4Display = " ";
                                }
                            } else {
                                value4Bussiness = value4Display = " ";
                            }
                        }
                    }
                    break;
                case CUSTOM_CONTROL://自定义控件
                    try {
                        FormFieldBean tempField = (FormFieldBean) fieldBean.clone();
                        FormFieldExtendBean tempExtendBean = fieldBean.getFormFieldExtend();
                        tempField.setInputType(tempExtendBean == null ? FormFieldComEnum.TEXT.getKey()
                                : tempExtendBean.getValueType());
                        String tempHtml = "";
                        boolean needShowVal = false;
                        String showVal = "";
                        if(tempExtendBean != null){
                            FormFieldCustomExtendDesignManager manager = tempExtendBean.getCustomManager();
                            needShowVal = manager.needShowVal();
                            if(needShowVal){
                                showVal = manager.getShowVal(value==null?"":String.valueOf(value));
                            }
                        }
                        tempField.putExtraAttr("CUSTOM_CONTROL_RECORDID",recordId);
                        tempHtml = getHTML(form, tempField, auth, (needShowVal?showVal:value), null, bizModel);
                        tempHtml = tempHtml.replaceFirst("<input ", "<input readonly=\"readonly\" ");//不允许手工输入
                        if(needShowVal){
                        	tempHtml = tempHtml.replace("'"+tempField.getName()+"'", "'"+tempField.getName()+"_txt"+"'");
                        }
                        if (tempExtendBean == null) return tempHtml;
                        String customClickEvent = tempExtendBean.getOnClickEvent();
                        customClickEvent = StringUtil.checkNull(customClickEvent)?FormJsFun.showCustomControlWindow.toString():customClickEvent+"(this);";
                        String clickEvent = FieldAccessType.edit.getKey().equals(access) ? customClickEvent : "";
                        //非空，且非业务模式（自定义查询/统计）
                        if (Strings.isNotBlank(clickEvent) && !bizModel) {
                            clickEvent = clickEvent.replace("this", "this,true");
                        }
                        if(h5Tag){
                            FormFieldValueBaseRestVO vo = getRestVO(fieldKey);
                            if(vo != null){
                                vo.addExtAttr("extendParam",tempExtendBean.toJSON());
                            }
                        }
                        
                        //下面在加一个自定义控件图标，单击事件
                        String url = tempExtendBean.getJsFileURL();
                        if (Strings.isNotBlank(tempExtendBean.getExtendParam())) {
                            url = url + "&extendParam=" + tempExtendBean.getExtendParam();
                        }
                        String bef = "<span ftype=\"" + tempField.getFieldType() + "\" fname=\"" + tempField.getName() + "\" onclick=\"" + clickEvent
                                + "\" clickUrl=\"" + url + "\" winHeight=\"" + tempExtendBean.getWindowHeight()
                                + "\" recordId=\"" + recordId + "\" winWidth=\"" + tempExtendBean.getWindowWidth() + "\" valueType=\""
                                + tempExtendBean.getValueType() + "\" style=\"cursor:pointer;\">" + (needShowVal?"<input inCondition=\""+fieldBean.isInCondition()+"\" inCalculate=\""+fieldBean.isInCalculate()+"\" type=\"hidden\" name=\""+tempField.getName()+"\" id=\""+tempField.getName()+"\" value=\"" + String.valueOf(value==null?"":value) + "\">":"");
                        String imgSrc = FieldAccessType.edit.getKey().equals(access)||FieldAccessType.design.getKey().equals(access) ? "<img src=\"" + tempExtendBean.getImage() + "\"/>" : "";
                        String afg = "</span></span>";
                        return StringUtils.replaceLast(tempHtml, "</span>", bef + imgSrc + afg);
                    } catch (Exception e) {
                        LOGGER.error(e.getMessage(), e);
                    }
                    break;
                default:
                    break;
            }
            //}else{
            //     itEnum = FormFieldComEnum.RELATIONFORM;
            //}
            if (FieldAccessType.browse.getKey().equals(access)) {
                htmlStr = itEnum.getBrowseHtml();
            } else if (FieldAccessType.hide.getKey().equals(access)) {
                htmlStr = HIDDEN_HTML;
                htmlStr = htmlStr.replace(HTML_ATTRS, "id=\"" + fieldBean.getName() + "\" " + "name=\"" + fieldBean.getName() + "\"");
            } else if (FieldAccessType.design.getKey().equals(access)) {
                htmlStr = itEnum.getDesignHtml();
            } else {
                //只要是hi编辑权限并且不允许为空，就添加背景颜色
                if (isNotNull) {
                    htmlAttrData.put("editAndNotNull", "true");
                }
                if (htmlAttrData.get(IMAGE_ENUM_HTML_EDIT_KEY) != null && SELECT.getKey().equals(fieldBean.getInputType())) {
                    htmlStr = htmlAttrData.get(IMAGE_ENUM_HTML_EDIT_KEY);//图片枚举才使用，使用完成删除！
                    htmlAttrData.remove(IMAGE_ENUM_HTML_EDIT_KEY);
                } else {
                    htmlStr = itEnum.getEditHtml();
                }
            }
            if (htmlAttrData.get(FLOWDEALOPITION_SIGNET_KEY) != null) {
                htmlStr = htmlAttrData.get(FLOWDEALOPITION_SIGNET_KEY);//图片枚举才使用，使用完成删除！
                htmlAttrData.remove(FLOWDEALOPITION_SIGNET_KEY);
            }
            htmlAttrData.put("editTag", access + "_class");
            htmlAttrData.put("data-role", "none");
            htmlStr = replaceHTML(htmlStr, htmlAttrData, value4Display, valuesWithDisplay, fieldBean);
            if (!bizModel) {
                htmlStr = htmlStr.replace("onblur=\"" + FormJsFun.calc + "\"", "");
                htmlStr = htmlStr.replaceAll("onclick\\s*=\\s*(\"|')[^\"']*(\"|')", "");//去掉里面的JS事件
            }
            return htmlStr;
        }

        private static FormFieldValueBaseRestVO getRestVO(String key) {
            if (FormUtil.isH5()) {
                Map<String,FormFieldValueBaseRestVO> restFieldList = (Map<String,FormFieldValueBaseRestVO>)AppContext.getThreadContext(FormConstant.REST_FORM_CHANGE_FIELD_INFO);
                return restFieldList.get(key);
            }
            return null;
        }

        /**
         * 替换文本域或者文本框浏览态时候的空格，当有n个空格的时候，替换n-1个空格为&nbsp;，保留一个空格
         * 这样既能解决打印的时候缺空格的情况，也能解决英文单词断行的问题
         * @param str
         * @return
         */
        private static String replaceMutiSpace(String str){
            char[] content = new char[str.length()];
            str.getChars(0, str.length(), content, 0);
            StringBuilder result = new StringBuilder();
            int len = content.length;
            for (int i = 0; i < len; i++) {
                if(content[i] == ' ' && i != len - 1){
                    if(content[i+1] == ' '){
                        result.append("&nbsp;");
                    }else{
                        result.append(content[i]);
                    }
                }else{
                    result.append(content[i]);
                }
            }
            return result.toString();
        }

        /**
         * 组装组织机构的String值
         *
         * @param value4Db
         * @param value4Bussiness
         * @param value4Display
         * @return
         */
        public static String getOrgVal(String value4Db, String value4Bussiness, String value4Display) {
            String retVal = (StringUtil.checkNull(value4Db) || "0".equals(value4Db)) ? "" : ",value:\"" + Strings.escapeJson(value4Bussiness) + "\",text:\"" + Strings.escapeJson(value4Display) + "\"";
            return retVal;
        }

        public static String getJsonAttStr(List<Attachment> atts, Long subRef) {
            List<Attachment> cloneAtts = filterAttrBySubRef(atts, subRef);
            return JSONUtil.toJSONString(cloneAtts);
        }

        public static List<Attachment> filterAttrBySubRef(List<Attachment> atts, Long subRef) {
            List<Attachment> cloneAtts = new ArrayList<Attachment>();
            for (Attachment att : atts) {
                try {
                    if(subRef == null || !subRef.equals(att.getSubReference())){
                        continue;
                    }
                    Attachment a = (Attachment) att.clone();
                    a.setId(att.getId());
                    //处理特殊字符，为了不影响缓存，此处克隆一份
                    //需要toHTML两次，第二次是把& 替换为&amp;
                    a.setFilename(Strings.toHTML(a.getFilename(),false).replaceAll("&quot;", "\\\""));
                    cloneAtts.add(a);
                } catch (CloneNotSupportedException e) {
                    LOGGER.error(e.getMessage(), e);
                }
            }
            return cloneAtts;
        }

        /**
         * 获取关联文档、附件、图片控件提交是否可编辑的tag的input的name
         *
         * @param fieldName
         * @param recordId
         * @return
         */
        public static String getAttKey(String fieldName, String recordId) {
            return fieldName + FormConstant.DOWNLINE + recordId + FormConstant.DOWNLINE + "editAtt";
        }

        private static String getRadioHtmlStr(final boolean canEdit, final FormFieldBean fieldBean, final List<CtpEnumItem> radioEnumList, final Object value, final boolean isImage, final boolean bizModule) {
            Long uuid = UUIDUtil.getUUIDLong();
            String addStr = "";
            if (fieldBean.isMasterField()) {
                if (canEdit) {
                    addStr = "";
                } else {
                    addStr = String.valueOf(uuid);
                }
            } else {
                addStr = String.valueOf(uuid);
            }
            StringBuilder result = new StringBuilder();
            for (CtpEnumItem enumObj : radioEnumList) {
                //处理label样式
                StringBuilder lableStr = new StringBuilder();
                lableStr.append("<label class=\"margin_r_10 hand\" id=\"" + fieldBean.getName() + "_txt" + "\" style=\"width:auto;margin-right:auto;margin-left: auto;white-space: pre-wrap;word-wrap:break-word;word-break:keep-all;\">");
                //=========处理Input样式=====开始=====
                StringBuilder inputStr = new StringBuilder();
                inputStr.append("<input type=\"radio\" style=\"margin-top:0px;width:auto;height:auto;\" data-role=\"none\" class=\"radio_com validate\" name=\"" + fieldBean.getName() + addStr + "\" id=\"" + fieldBean.getName() + (canEdit ? "" : uuid) + "\" val4cal=\"" + enumObj.getEnumvalue() + "\" value=\"" + enumObj.getId() + "\"");
                if (String.valueOf(value).equals(String.valueOf(enumObj.getId()))) {
                    inputStr.append(" checked=\"true\"");
                }
                if (canEdit) {
                    if (fieldBean.isInCalculate()) {
                        inputStr.append(" inCalculate=\"true\"");
                    }
                    if (fieldBean.isInCondition()) {
                        inputStr.append(" inCondition=\"true\"");
                    }
                    if (fieldBean.isUnique()) {
                        inputStr.append(" unique=\"true\"");
                    }
                    inputStr.append(" onclick=\"" + FormJsFun.calc + "\" ");
                } else {
                    inputStr.append(" disabled=\"true\"");
                }

                //非表单业务展现用时，设置图片高度
                if (!bizModule) {
                    inputStr.append(" showvalue=\"" + Strings.toHTML(enumObj.getShowvalue()) + "\" returnunchecked=\"1\"");
                }
                inputStr.append(" />");
                //=========处理Input样式=====开始=====
                boolean isShowImage = isImage && !FormConstant.NAME_TO_NAME.equals(fieldBean.getFormatType()) && (FormConstant.IMAGE_TO_IMAGE.equals(fieldBean.getFormatType()) || !canEdit);
                // ====处理radio显示名称部分======
                StringBuilder radioShowName = new StringBuilder();
                if (isShowImage) {
                    //图片枚举处理，显示格式为选择图显示图，浏览状态下
                    radioShowName.append("<img style=\"height:25px;width:35px;\" src='" + SystemEnvironment.getContextPath() + "/fileUpload.do?method=showRTE&fileId=" + enumObj.getImageId() + "&expand=0&type=image'>");
                } else {
                    radioShowName.append(Strings.toHTML(enumObj.getShowvalue()));
                }
                //处理最终返回的样式
                if (isShowImage) {
                    result.append("<div style=\"float:left; padding:5px 0 0 5px;text-align:center;\">");
                    result.append(lableStr);
                    result.append(radioShowName);
                    result.append("</br>");
                    result.append(inputStr);
                    result.append("</label></div>");
                } else {
                    //result.append("<div style=\"float:left; margin:5px 0 0 5px; text-align:center;\">");
                    result.append(lableStr);
                    result.append(inputStr);
                    result.append(radioShowName);
                    result.append("</label>");
                    //result.append("</div>");
                }
            }
            return result.toString();
        }

        public static String getMultRelationHtmlStr(List<CtpEnumItem> enumList, boolean isImageEnum) {
            StringBuffer sb = new StringBuffer();
            if (isImageEnum) {
                //由于用json会造成乱码问题，这里用字符串拼接
                sb.append("[");
            }
            for (CtpEnumItem enumObj : enumList) {
                if (isImageEnum) {
                    if (enumObj.getImageId() == null) {
                        sb.append("{image:undefined,value:'',val4cal:''},");
                    } else {
                        sb.append("{image:'" + SystemEnvironment.getContextPath() + "/fileUpload.do?method=showRTE&fileId=" + enumObj.getImageId() + "&expand=0&type=image',value:'" + enumObj.getId() + "',val4cal:'" + enumObj.getEnumvalue() + "'},");
                    }
                } else {
                    String selected = "";
                    if (!StringUtil.checkNull(String.valueOf(enumObj.getExtraAttr(SELECTED))) && String.valueOf(enumObj.getExtraAttr(SELECTED)).endsWith(SELECTED)) {
                        enumObj.putExtraAttr(SELECTED, "");
                        selected = "selected";
                    } else {
                        selected = "";
                    }
                    String val = (enumObj.getId() == null || enumObj.getId() == 0l) ? "" : String.valueOf(enumObj.getId());
                    sb.append("<option val4cal=\"" + enumObj.getEnumvalue() + "\" value=\"").append(val).append("\" ").append(selected).append(">").append(Strings.toHTML(enumObj.getShowvalue())).append("</option>");
                }
            }
            if (isImageEnum) {
                //由于用json会造成乱码问题，这里用字符串拼接
                String sbStr = sb.toString();
                String newStr = sbStr.endsWith(",") ? sbStr.substring(0, sbStr.length() - 1) : sbStr;
                newStr = newStr + "]";
                return newStr;
            }
            return sb.toString();
        }

        private static String replaceHTML(String str, Map<String, String> htmlAttrData, String htmlValue, Object[] val, FormFieldBean fieldBean) {
            String editAndNotNull = htmlAttrData.remove("editAndNotNull");
            String editTag = htmlAttrData.remove("editTag");
            StringBuilder attrSb = new StringBuilder(" ");
            for (Map.Entry<String, String> entry : htmlAttrData.entrySet()) {
                attrSb.append(entry.getKey());
                attrSb.append("=\'");
                attrSb.append(entry.getValue());
                attrSb.append("\' ");
            }
            String htmlStr = str;
            htmlStr = htmlStr.replace(HTML_VALUE, htmlValue == null ? "" : htmlValue);
            String idAndNameAttr = " id=\"" + fieldBean.getName() + "\" name=\"" + fieldBean.getName() + "\" ";
            String relationType = "";
            if (fieldBean.getFormRelation() != null) {
                relationType = ",toRelationType:\"" + ToRelationAttrType.getEnumByKey(fieldBean.getFormRelation().getToRelationAttrType()).name() + "\"";
                //关联表单字段在编辑态的时候前面的文本框不要显示灰色，以免引起误解，以为不可编辑
                String setColor = (String)AppContext.getThreadContext("setColor");
                if("true".equals(setColor)){
                    relationType += ",setColor:\"true\"";
                    AppContext.removeThreadContext("setColor");
                }
            }
            Object dbVal = val[0];
            if (val[0] instanceof Date) {
                dbVal = Datetimes.formatNoTimeZone((Date) dbVal,Datetimes.datetimeWithoutSecondStyle);
            }
            if (htmlStr.indexOf(SPAN_ATTRS) != -1) {//给非隐藏的控件外的SPAN添加ID,fieldValue等属性，方便前台JS获取单元格的值
                if (dbVal == null) {
                    dbVal = "";
                }
                if ((!org.apache.commons.lang.StringUtils.isBlank(editAndNotNull)) && "true".equalsIgnoreCase(editAndNotNull)) {
                    htmlStr = htmlStr.replace(SPAN_ATTRS, " id=\"" + fieldBean.getName() + "_span\" class=\"editableSpan " + editTag + "\" fieldVal='" + "{name:\"" + fieldBean.getName() + "\",isMasterFiled:\"" + fieldBean.isMasterField() + "\",displayName:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldBean.getFieldType() + "\",inputType:\"" + fieldBean.getInputType() + "\",formatType:\"" + fieldBean.getFormatType() + "\",value:\"" + Strings.escapeJson(String.valueOf(dbVal)) + "\"" + relationType + "}" + "'");
                } else {
                    htmlStr = htmlStr.replace(SPAN_ATTRS, " id=\"" + fieldBean.getName() + "_span\" class=\"" + editTag + "\" fieldVal='" + "{name:\"" + fieldBean.getName() + "\",isMasterFiled:\"" + fieldBean.isMasterField() + "\",displayName:\"" + fieldBean.getDisplay() + "\",fieldType:\"" + fieldBean.getFieldType() + "\",inputType:\"" + fieldBean.getInputType() + "\",formatType:\"" + fieldBean.getFormatType() + "\",value:\"" + Strings.escapeJson(String.valueOf(dbVal)) + "\"" + relationType + "}" + "'");
                }
            }
            if (htmlStr.indexOf(HIDDEN_ATTRS) != -1) {//给隐藏的控件外的SPAN添加ID属性
                htmlStr = htmlStr.replace(HIDDEN_ATTRS, " id=\"" + fieldBean.getName() + "_span\" ");
            }
            if (htmlStr.indexOf(HTML_ID_NAME) != -1) {//给所有控件添加属性
                htmlStr = htmlStr.replace(HTML_ID_NAME, idAndNameAttr);
            }
            htmlStr = htmlStr.replace(HTML_ATTRS, attrSb.toString());
            return htmlStr;
        }

        /**
         * 根据字段长度获取多组织机构最多能选择多少个节点
         *
         * @param field
         * @return
         */
        public static int getMaxOrgSize(FormFieldBean field) {
            int maxSize = 0;
            if (field.getInputTypeEnum().isSingleOrg()) {//单组织机构控件
                if (!StringUtil.checkNull(field.getFieldLength())) {
                    maxSize = 1;
                }
            } else if (FormFieldComEnum.getEnumByKey(field.getFinalInputType()).isMultiOrg()) {//多组织机构控件
                if (field.getFieldType() != null) {
                    if (field.getFieldType().equalsIgnoreCase(FieldType.VARCHAR.getKey())) {//多组织机构控件-文本
                        int tempSize = Integer.parseInt(field.getFieldLength());
                        maxSize = tempSize / 21;
                    } else if (field.getFieldType().equalsIgnoreCase(FieldType.LONGTEXT.getKey())) {//多组织机构控件-大文本
                        maxSize = (int) (4294967295l / 21);
                    }
                }
            } else if (field.getOutwriteFieldInputType().isOrg()) {
                int tempSize = Integer.parseInt(field.getFieldLength());
                maxSize = tempSize / 21;
            }
            return maxSize;
        }

        //是否是多组织机构控件
        public boolean isMultiOrg() {
            String[] ss = "multimember multiaccount multidepartment multipost multilevel".split(" ");
            for (String s : ss) {
                if (s.equalsIgnoreCase(getKey())) {
                    return true;
                }
            }
            return false;
        }

        //是否是单组织机构控件
        public boolean isSingleOrg() {
            String[] ss = "member account department post level".split(" ");
            for (String s : ss) {
                if (s.equalsIgnoreCase(getKey())) {
                    return true;
                }
            }
            return false;
        }

        //是否是组织机构控件
        public boolean isOrg() {
            return isMultiOrg() || isSingleOrg();
        }

        public boolean isLbs() {
            return (this == MAP_LOCATE || this == MAP_MARKED || this == MAP_PHOTO);
        }

        /**
         * 判断控件类型在当前系统中是否可用
         * 比如某字段需要某些插件支持，在此作插件判断
         *
         * @return 可用true
         */
        public boolean canUse() {
            switch (this) {
                case FLOWDEALOPITION:
                case RELATIONFORM:
                case EXTEND_MULTI_MEMBER:
                case EXTEND_MULTI_DEPARTMENT:
                case EXTEND_MULTI_POST:
                case EXTEND_MULTI_LEVEL:
                case OUTWRITE:
                case PREPAREWRITE:
                    return (Boolean)AppContext.hasPlugin("formAdvanced");
                case CUSTOM_CONTROL:
                    //A6s SysFlag.valueOf("form_showCustom_control")返回true
                    return (Boolean) SysFlag.valueOf("form_showCustom_control").getFlag() || AppContext.hasPlugin("formAdvanced");
                case HANDWRITE:
                    return AppContext.hasPlugin("advanceOffice");
                case EXTEND_ACCOUNT:
                    return Boolean.valueOf(SystemProperties.getInstance().getProperty("org.isGroupVer"));
                case EXTEND_MULTI_ACCOUNT:
                    return AppContext.hasPlugin("formAdvanced") && Boolean.valueOf(SystemProperties.getInstance().getProperty("org.isGroupVer"));
                case EXTEND_EXCHANGETASK:
                case EXTEND_QUERYTASK:
                    return AppContext.hasPlugin("formAdvanced") && AppContext.hasPlugin("dee");
                case MAP_MARKED:
                case MAP_LOCATE:
                case MAP_PHOTO:
                    return AppContext.hasPlugin("formAdvanced") && AppContext.hasPlugin("lbs");
                case EXTEND_PROJECT:
                    return AppContext.hasPlugin("formAdvanced") && AppContext.hasPlugin("project");
                default:
                    return true;
            }
        }

        /**
         * 判断控件在给定表单类型下是否可用
         *
         * @param formType 表单类型
         * @return
         */
        public boolean canUse(FormType formType) {

            if (canUse()) {
                switch (this) {
                    case FLOWDEALOPITION:
                        return FormType.processesForm == formType;
                    case CUSTOM_PLAN:
                        return FormType.planForm == formType;
                    case OUTWRITE:
                    case PREPAREWRITE:
                        return FormType.baseInfo == formType || FormType.manageInfo == formType;
                    case BARCODE:
                        return FormType.planForm != formType;
                    default:
                        return true;
                }
            }
            return false;
        }

        /**
         * 获取当前单元格所绑定枚举的枚举id以及所属枚举中第几层
         *
         * @param fieldBean
         * @return
         */
        public static Map<String, Object> getEnumInfoByCurrentField(FormFieldBean fieldBean) {
            Map<String, Object> returnValMap = new HashMap<String, Object>();
            FormFieldBean formFieldBean = fieldBean;
            int enumLevel = FormFieldComBean.SELECT_LEVEL;
            FormRelation tempRelation = formFieldBean.getFormRelation();
            FormCacheManager formCacheManager = (FormCacheManager) AppContext.getBean("formCacheManager");
            FormBean form = formCacheManager.getForm(formCacheManager.getTable(formFieldBean.getOwnerTableName()).getFormId());
            while (tempRelation != null) {
                enumLevel++;
                formFieldBean = form.getFieldBeanByName(tempRelation.getToRelationAttr());
                tempRelation = formFieldBean.getFormRelation();
            }
            returnValMap.put("enumId", formFieldBean.getEnumId());
            returnValMap.put("level", enumLevel);
            return returnValMap;
        }

        public static FormFieldComEnum getEnumByKey(String key) {
            for (FormFieldComEnum e : FormFieldComEnum.values()) {
                if (e.getKey().equals(key)) {
                    return e;
                }
            }
            return null;
        }

        public static FormFieldComEnum getEnumByText(String text) {
            for (FormFieldComEnum e : FormFieldComEnum.values()) {
                if (e.getText().equals(text)) {
                    return e;
                }
            }
            return null;
        }

        /**
         * 获取所有可用控件类型
         * 只判断此控件所需要的插件是否存在
         *
         * @return 控件类型列表
         */
        public static List<FormFieldComEnum> getAllInputType() {
            List<FormFieldComEnum> inputTypeList = new ArrayList<FormFieldComEnum>();
            for (FormFieldComEnum e : FormFieldComEnum.values()) {
                if (e.canUse()) {
                    inputTypeList.add(e);
                }
            }
            return inputTypeList;
        }

        /**
         * 获取某种表单类型可以使用的控件列表
         *
         * @param type 表单类型
         * @return 控件列表
         */
        public static List<FormFieldComEnum> getAllInputType(int type) {
            FormType formType = FormType.getEnumByKey(type);
            return getAllInputType(formType);
        }

        public static List<FormFieldComEnum> getAllInputType(FormType type) {
            List<FormFieldComEnum> inputTypeList = new ArrayList<FormFieldComEnum>();
            for (FormFieldComEnum e : FormFieldComEnum.values()) {
                if (e.canUse(type)) {
                    inputTypeList.add(e);
                }
            }
            return inputTypeList;
        }

        /**
         * @return the key
         */
        public String getKey() {
            return key;
        }

        /**
         * @param key the key to set
         */
        public void setKey(String key) {
            this.key = key;
        }

        /**
         * @return the text
         */
        public String getText() {
            return ResourceUtil.getString(text, "");
        }

        public String getText(FormFieldBean fieldBean) {
            FormFieldComEnum itEnum = fieldBean.getInputTypeEnum();
            switch (itEnum) {
                case EXTEND_MEMBER:
                    if (fieldBean.getExternalType() == OrgConstants.ExternalType.Interconnect1.ordinal()) {
                        return ResourceUtil.getString("vjoin.form.input.extend.selectJoinMember.label");
                    }
                    break;
                case EXTEND_DEPARTMENT:
                    if (fieldBean.getExternalType() == OrgConstants.ExternalType.Interconnect1.ordinal()) {
                        return ResourceUtil.getString("vjoin.form.input.extend.selectJoinOrganization.label");
                    } else if (fieldBean.getExternalType() == OrgConstants.ExternalType.Interconnect2.ordinal()) {
                        return ResourceUtil.getString("vjoin.form.input.extend.selectJoinAccount.label");
                    }
                    break;
                case EXTEND_POST:
                    if (fieldBean.getExternalType() == OrgConstants.ExternalType.Interconnect1.ordinal()) {
                        return ResourceUtil.getString("vjoin.form.input.extend.selectJoinPost.label");
                    }
                    break;
                default:
                    break;
            }
            return this.getText();
        }

        /**
         * @param text the text to set
         */
        public void setText(String text) {
            this.text = text;
        }

        /**
         * @return the category
         */
        public InputTypeCategory getCategory() {
            return category;
        }

        /**
         * @param category the category to set
         */
        public void setCategory(InputTypeCategory category) {
            this.category = category;
        }

        /**
         * @return the canRelation
         */
        public BooleanType getCanRelation() {
            return canRelation;
        }

        /**
         * @param canRelation the canRelation to set
         */
        public void setCanRelation(BooleanType canRelation) {
            this.canRelation = canRelation;
        }

        /**
         * @return the canExtend
         */
        public boolean getCanExtend() {
            return canExtend;
        }

        /**
         * @param canExtend the canExtend to set
         */
        public void setCanExtend(boolean canExtend) {
            this.canExtend = canExtend;
        }

        /**
         * @return the fieldType
         */
        public FieldType[] getFieldType() {
            return fieldType;
        }

        /**
         * @param fieldType the fieldType to set
         */
        public void setFieldType(FieldType[] fieldType) {
            this.fieldType = fieldType;
        }

        public FieldRelationObj[] getFieldRelationObjArray() {
            return fieldRelationObjArray;
        }

        public void setFieldRelationObjArray(FieldRelationObj[] fieldRelationObjArray) {
            this.fieldRelationObjArray = fieldRelationObjArray;
        }

        /**
         * @return the editHtml
         */
        public String getEditHtml() {
            return editHtml;
        }

        /**
         * @param editHtml the editHtml to set
         */
        public void setEditHtml(String editHtml) {
            this.editHtml = editHtml;
        }

        /**
         * @return the browseHtml
         */
        public String getBrowseHtml() {
            return browseHtml;
        }

        /**
         * @param browseHtml the browseHtml to set
         */
        public void setBrowseHtml(String browseHtml) {
            this.browseHtml = browseHtml;
        }

        /**
         * @return the designHtml
         */
        public String getDesignHtml() {
            return designHtml;
        }

        /**
         * @param designHtml the designHtml to set
         */
        public void setDesignHtml(String designHtml) {
            this.designHtml = designHtml;
        }

    }

    /*
     * 该私有类描述和控件、字段类型相关联的一些弱属性
     * @author dengxj
     */
    public static class FieldRelationObj {
        //字段类型
        private FieldType fieldType;
        //字段长度默认显示值
        private int fieldLength;
        //显示格式
        private FormatType formatType;
        //是否可以设置计算表达式
        private BooleanType isFormula;
        //字段长度是否可以输入
        private BooleanType isCanInput;

        FieldRelationObj(FieldType fieldType, int fieldLength, FormatType formatType, BooleanType isFormula, BooleanType isCanInput) {
            this.fieldType = fieldType;
            this.fieldLength = fieldLength;
            this.formatType = formatType;
            this.isFormula = isFormula;
            this.isCanInput = isCanInput;
        }

        public FieldType getFieldType() {
            return fieldType;
        }

        public void setFieldType(FieldType fieldType) {
            this.fieldType = fieldType;
        }

        public int getFieldLength() {
            return fieldLength;
        }

        public void setFieldLength(int fieldLength) {
            this.fieldLength = fieldLength;
        }

        public FormatType getFormatType() {
            return formatType;
        }

        public void setFormatType(FormatType formatType) {
            this.formatType = formatType;
        }

        public BooleanType getIsFormula() {
            return isFormula;
        }

        public void setIsFormula(BooleanType isFormula) {
            this.isFormula = isFormula;
        }

        public BooleanType getIsCanInput() {
            return isCanInput;
        }

        public void setIsCanInput(BooleanType isCanInput) {
            this.isCanInput = isCanInput;
        }
    }
}
