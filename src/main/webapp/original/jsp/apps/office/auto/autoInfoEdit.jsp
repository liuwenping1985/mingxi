<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.car.edit.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoInfoEdit.js"></script>
</head>
<body class="h100b over_hidden" >
    <div class="stadic_layout h100b font_size12">
        <div class="stadic_layout_head stadic_head_height">
            <!--上边区域-->
            <div class="clearfix bg_color_gray">
                <span class="left margin_5 font_bold color_blue">${ctp:i18n("office.auto.set.js") }</span><span class="right margin_5 green">*${ctp:i18n("office.auto.must.enter.js")}</span>
            </div>
        </div>
        <div id="tableDiv" class="stadic_layout_body stadic_body_top_bottom margin_b_10">
            <!--中间区域-->
            <div id="autoInfoDiv" class="form_area set_search align_center">
            		<div id="mainAutoInfo">
            		<input id="id" name="id" type="hidden" value="-1"/>
            		<table border="0" cellSpacing="0" cellPadding="0" align="center" class="w80b">
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.num.js')}:</th>
	                        <td width="40%" colspan="2">
	                        	<div class="common_txtbox_wrap">
	                                <input  id="autoNum" name="autoNum" class="validate font_size12" maxlength="20" value="" validate="type:'string',notNullWithoutTrim:'true',name:'',notNull:true,errorMsg:'${ctp:i18n('office.auto.autonul.check.js')}',avoidChar:'!@#$%^&\'*+()'" type="text"/>
	                            </div>
	                        </td>
	                        <td width="50%" colspan="3" rowspan="6" align="right">
	                        	<input type="hidden" id="autoImage" name="autoImage" value=""/>
		                        <div id="imageDiv"></div>
								<div id="dyncid"></div>
	                        </td> 
	                    </tr>	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.type.js')}:</th>
	                        <td width="40%" colspan="2">
		                        <div id="autoTypeNameDiv" class="common_txtbox_wrap">
		                       		<input id="autoTypeName" name="autoTypeName" value="" />
		                        </div>
	                        	<div class="common_selectbox_wrap">
	                            	<select  id="autoType" name="autoType" class="validate codecfg font_size12" codecfg="codeId:'office_auto_type'"></select>
	                            </div>
	                        </td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.group.js')}:</th>
	                        <td width="40%" colspan="2">
	                        	<div class="common_selectbox_wrap">
	                                <select  id="categoryId" name="categoryId" class="font_size12 validate" validate="name:'',notNull:true,errorMsg:'${ctp:i18n('office.auto.type.not.null.js')}'" ></select>
	                        	</div>
	                        </td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.name.js') }:</th>
	                        <td width="40%" colspan="2">
	                        	<div class="common_txtbox_wrap">
	                            	<input  id="autoBrand" name="autoBrand" maxlength="65" class=" font_size12" value="" type="text"/>
	                        	</div>
	                        </td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.model.js') }:</th>
	                        <td width="40%" colspan="2">
		                        <div class="common_txtbox_wrap">
		                        	<input  id="autoModel" name="autoModel" maxlength="65" class=" font_size12" value="" type="text"/>
		                        </div>
	                        </td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.sitsum.js') }:</th>
	                        <td width="40%" colspan="2">
		                        <div class="common_txtbox_wrap">
		                        	<input  id="autoPernum" name="autoPernum" maxlength="2" class="validate font_size12" validate="name:'${ctp:i18n('office.auto.sitsum.js')}',regExp:'^[1-9][0-9]{0,1}$',errorMsg:'${ctp:i18n('office.auto.input.check.number.js')}'" value="" type="text"/>
		                        </div>
	                        </td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.fulnum.js') }:</th>
	                        <td width="40%" colspan="2">
		                        <div class="common_txtbox_wrap">
		                        	<input  id="autoFuelNum" name="autoFuelNum" maxlength="45" class="font_size12" value="" type="text"/>
		                        </div>
	                        </td>
	                        <th width="10%" noWrap="nowrap" align="right"></th>
	                        <td width="40%" colspan="2" align="right">
	                           <a id="imgUpload" class="common_button common_button_grayDark" href="javascript:void(0)">${ctp:i18n('office.auto.view.js') }</a>
	                           <a id="imgCancel" class="common_button common_button_grayDark" href="javascript:void(0)">${ctp:i18n('office.bookinfo.cover.default.js')}</a>
	                        </td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.fuelcard.js') }:</th>
	                        <td width="40%" colspan="2">
		                        <div class="common_txtbox_wrap">
		                        	<input  id="autoFuelCard" name="autoFuelCard" maxlength="65" class="font_size12" value="" type="text"/>
		                        </div>
	                        </td>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.state.js') }:</th>
	                        <td width="40%" colspan="2" align="right">
	                        	<div class="common_selectbox_wrap">
	                        		<select  id="state" name="state" class="codecfg font_size12 validate" validate="notNull:true" codecfg="codeType:'java',codeId:'com.seeyon.apps.office.constants.AutoInfoStateEnum'" ></select>
	                        	</div>
	                        </td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.motornum.js') }:</th>
	                        <td width="40%" colspan="2">
		                        <div class="common_txtbox_wrap">
		                        	<input  id="autoEngine" name="autoEngine" maxlength="65" class="validate font_size12" value="" type="text"/>
		                        </div>
	                        </td>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.autoidentifier.js') }:</th>
	                        <td width="40%" colspan="2">
		                        <div class="common_txtbox_wrap">
		                        	<input  id="autoIdentifier" name="autoIdentifier" maxlength="65" class="validate font_size12" value="" type="text"/>
		                        </div>
	                        </td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.buyData.js') }:</th>
	                        <td width="40%" colspan="2">
	                        	<div class="common_txtbox_wrap">
	                               <input  id="buyDate" readonly name="buyDate" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"  value=""/>
	                         	</div>
	                        </td>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.price.js') }:</th>
	                        <td width="30%">
		                        <div class="common_txtbox_wrap">
		                        	<input  id="buyPrice" name="buyPrice" maxlength="13" class="validate font_size12" validate="name:'${ctp:i18n('office.auto.price.js')}',regExp:'^([1-9][0-9]{0,7})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.money.check.js')}'" value="" type="text"/>
		                        </div>
	                        </td>
	                        <td width="10%" align="left" ><span class="margin_l_5">${ctp:i18n('office.auto.element.js') }</span></td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.averagefuel.js') }:</th>
	                        <td width="30%" >
		                        <div class="common_txtbox_wrap">
		                        	<input  id="aveFuelConsump" name="aveFuelConsump" maxlength="13" class="validate font_size12" validate="name:'${ctp:i18n('office.auto.averagefuel.js')}',regExp:'^([0-9][0-9]{0,7})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.check.money2.js')}'" value="" type="text"/>                           
		                        </div>  
	                        </td>
	                        <td width="10%" align="left"><span class="margin_l_5">${ctp:i18n('office.auto.l.js') }/${ctp:i18n('office.auto.100km.js') }</span></td>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.avefuelcost.js') }:</th>
	                        <td width="30%" >
		                        <div class="common_txtbox_wrap">
		                        	<input  id="aveFuelCost" name="aveFuelCost" maxlength="13" class="validate font_size12" validate="name:'${ctp:i18n('office.auto.avefuelcost.js')}',regExp:'^([0-9][0-9]{0,7})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.check.money2.js')}'" value="" type="text"/>   
		                        </div>
	                        </td>
	                        <td width="10%" align="left"><span class="margin_l_5">${ctp:i18n('office.auto.element.js')}/${ctp:i18n('office.auto.100km.js') }</span></td>
	                    </tr>
	                    
	                    <tr>
		    				<th width="10%" nowrap="nowrap"  align="right"><span class="required margin_r_5">*</span>${ctp:i18n('office.auto.admin.js') }:</th>
		    				<td width="40%" colspan="2">
			    				<div class="common_txtbox_wrap font_size12">
			    					<input  type="text"  id="autoManagertxt" name="autoManagertxt" readonly="readonly"  class="validate" validate="name:'${ctp:i18n('office.auto.admin.js')}',notNull:true" onclick="fnSelect('manager');" value=""/>
			    					<input type="hidden" id="autoManager" name="autoManager" value=""/>
			    				</div>
		    				</td>
		    				<th width="10%" nowrap="nowrap"  align="right">${ctp:i18n('office.auto.driver.js') }:</th>
		    				<td width="40%" colspan="2">
			    				<div class="common_txtbox_wrap font_size12">
			    					<input  type="text"  id="autoDrivertxt" name="autoDrivertxt" readonly="readonly" onclick="fnSelect('driver');" value=""/>
			    					<input type="hidden" id="autoDriver" name="autoDriver" value=""/>
			    				</div>
		    				</td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right" valign="top">
	                            <label  for="text">${ctp:i18n('office.auto.mark.js') }:
	                        </th>
	                        <td width="90%" colspan="4" align="left">
	                            <div class="margin_b_5 common_txtbox">
	                                <textarea  id="autoMemo" name="autoMemo" maxlength="1000" style="width: 112%; height: 70px;" ></textarea>
	                            </div>
	                        </td>
	                    </tr>
                	</table>
               </div>
            </div>
        </div>
        <div id="btnDiv" class="stadic_layout_footer stadic_footer_height padding_tb_5 align_center bg_color_black">
           <a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a> 
           <a id="btncancel" class="common_button common_button_grayDark margin_l_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
        </div>
    </div>
</body>
</html>