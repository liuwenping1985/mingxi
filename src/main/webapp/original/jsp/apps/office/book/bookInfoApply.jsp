<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.book.bookSet.ptszldjtszldj.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoInfoEdit.js"></script>
</head>
<body class="h100b over_hidden" >
    <div class="stadic_layout h100b font_size12">
        <div class="stadic_layout_head stadic_head_height">
            <!--上边区域-->
            <div class="clearfix bg_color_gray">
                <span class="left margin_5 font_bold color_blue">${ctp:i18n('office.book.bookSet.ptszldjtszldj.js')}</span><span class="right margin_5 green">*${ctp:i18n("office.auto.must.enter.js")}</span>
            </div>
        </div>
        <div id="tableDiv" class="stadic_layout_body stadic_body_top_bottom margin_b_10">
            <!--中间区域-->
            <div id="autoInfoDiv" class="form_area set_search align_center">
                    <div id="mainAutoInfo">
                    <input id="id" name="id" type="hidden" value="-1"/>
                    <table border="0" cellSpacing="0" cellPadding="0" align="center" class="w60b">
                        <tr>
                            <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">编号:</th>
                            <td colspan="2">
                                <div class="common_txtbox_wrap">
                                    <input  id="autoNum" name="autoNum" class="validate font_size12" maxlength="15" value="" validate="type:'string',name:'车牌号',notNull:true,errorMsg:'车牌号不能为空或特殊字符',avoidChar:'!@#$%^&\'*+()'" type="text"/>
                                </div>
                            </td>
                            <td colspan="3" rowspan="6" align="right">
                                <input type="hidden" id="autoImage" name="autoImage" value=""/>
                                <div id="imageDiv"></div>
                                <div id="dyncid"></div>
                            </td> 
                        </tr>                       
                        <tr>
                            <th noWrap="nowrap" align="right">名称:</th>
                            <td colspan="2">
                                <div class="common_selectbox_wrap">
                                    <select  id="autoType" name="autoType" class="codecfg font_size12" codecfg="codeId:'office_auto_type'"></select>
                                </div>
                            </td>
                        </tr>
                        
                        <tr>
                            <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">类别:</th>
                            <td colspan="2">
                                <div class="common_selectbox_wrap">
                                    <select  id="categoryId" name="categoryId" class="font_size12 validate" validate="name:'车辆分类',notNull:true,errorMsg:'车辆分类不能为空'" ></select>
                                </div>
                            </td>
                        </tr>
                        
                        <tr>
                            <th noWrap="nowrap" align="right">作者:</th>
                            <td colspan="2">
                                <div class="common_txtbox_wrap">
                                    <input  id="autoBrand" name="autoBrand" maxlength="15" class=" font_size12" value="" type="text"/>
                                </div>
                            </td>
                        </tr>
                        
                        <tr>
                            <th noWrap="nowrap" align="right">出版社:</th>
                            <td colspan="2">
                                <div class="common_txtbox_wrap">
                                    <input  id="autoModel" name="autoModel" maxlength="15" class=" font_size12" value="" type="text"/>
                                </div>
                            </td>
                        </tr>
                        
                        <tr>
                            <th noWrap="nowrap" align="right">出版日期:</th>
                            <td colspan="2">
                                <div class="common_txtbox_wrap">
                                    <input  id="autoPernum" name="autoPernum" maxlength="2" class="validate font_size12" validate="name:'座位数',regExp:'^[1-9][0-9]{0,1}$',errorMsg:'只能输入正整数'" value="" type="text"/>
                                </div>
                            </td>
                        </tr>
                        
                        <tr>
                            <th noWrap="nowrap" align="right">购买价格:</th>
                            <td colspan="2">
                                <div class="common_txtbox_wrap">
                                    <input  id="autoFuelNum" name="autoFuelNum" maxlength="15" class="font_size12" value="" type="text"/>
                                </div>
                            </td>
                            <th noWrap="nowrap" align="right"></th>
                            <td colspan="2" align="right">
                               <a id="imgUpload" class="common_button common_button_grayDark" href="javascript:void(0)">${ctp:i18n('office.auto.view.js') }</a>
                            </td>
                        </tr>
<!--                         图片 -->
                        
                        <tr>
                            <th noWrap="nowrap" align="right" valign="top">
                                <label  for="text">摘要:
                            </th>
                            <td colspan="4" align="left">
                                <div >
                                    <textarea  id="autoMemo" name="autoMemo" maxlength="1000" style="width: 114%; height: 70px;" ></textarea>
                                </div>
                            </td>
                        </tr>
                        
                         <tr>
                            <th noWrap="nowrap" align="right">库存数量:</th>
                            <td colspan="2">
                                <div class="common_txtbox_wrap">
                                    <input  id="autoEngine" name="autoEngine" maxlength="15" class="validate font_size12" value="" type="text"/>
                                </div>
                            </td>
                            <th noWrap="nowrap" align="right">计量单位:</th>
                            <td colspan="2">
                                <div class="common_txtbox_wrap">
                                    <input  id="autoIdentifier" name="autoIdentifier" maxlength="15" class="validate font_size12" value="" type="text"/>
                                </div>
                            </td>
                        </tr>
                        
                        <tr>
                            <th noWrap="nowrap" align="right"><label  for="text">图书资料库:</th>
                            <td colspan="2">
                                <div class="common_txtbox_wrap">
                                   <input  id="buyDate" readonly name="buyDate" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"  value=""/>
                                </div>
                            </td>
                            <th noWrap="nowrap" align="right">图书资料分类:</th>
                            <td>
                                <div class="common_txtbox_wrap">
                                    <input  id="buyPrice" name="buyPrice" maxlength="13" class="validate font_size12" validate="name:'购车价格',regExp:'^([1-9][0-9]{0,7})([.][0-9]{1,2})?$',errorMsg:'只能输入小于等于8个正数，2个小数点'" value="" type="text"/>
                                </div>
                            </td>
                        </tr>
                        
                         <tr>
                            <th noWrap="nowrap" align="right">加油卡:</th>
                            <td colspan="2">
                                <div class="common_txtbox_wrap">
                                    <input  id="autoFuelCard" name="autoFuelCard" maxlength="15" class="font_size12" value="" type="text"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                    </div>
            </div>
        </div>
        <div id="btnDiv" class="stadic_layout_footer stadic_footer_height padding_tb_5 align_center bg_color_gray">
        <!--下边区域-->
            <a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a> 
            <a id="btncancel" class="common_button common_button_grayDark margin_l_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
        </div>
    </div>
</body>
</html>