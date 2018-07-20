<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>车辆编辑</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoInfoUpdates.js"></script>
</head>
<body class="h100b over_hidden" >
    <div class="stadic_layout h100b font_size12">
        <div id="tableDiv" class="stadic_layout_body stadic_body_top_bottom margin_b_10">
            <!--中间区域-->
            <div id="autoInfoUpdates" class="form_area set_search align_center">
            		<table border="0" cellSpacing="0" cellPadding="0" align="center" class="w70b">
	                    <tr>
		    				<th width="10%" nowrap="nowrap"  align="right">${ctp:i18n('office.auto.admin.js') }:</th>
		    				<td width="60%" colspan="2">
			    				<div class="common_txtbox_wrap font_size12">
			    					<input  type="text"  id="autoManagertxt" name="autoManagertxt" readonly="readonly"   onclick="fnSelect('manager');" value=""/>
			    					<input type="hidden" id="autoManager" name="autoManager" value=""/>
			    				</div>
		    				</td>
		    			</tr>
		    			<tr>
		    				<th width="10%" nowrap="nowrap"  align="right">${ctp:i18n('office.auto.driver.js') }:</th>
		    				<td width="60%" colspan="2">
			    				<div class="common_txtbox_wrap font_size12">
			    					<input  type="text"  id="autoDrivertxt" name="autoDrivertxt" readonly="readonly" onclick="fnSelect('driver');" value=""/>
			    					<input type="hidden" id="autoDriver" name="autoDriver" value=""/>
			    				</div>
		    				</td>
	                    </tr>
	                    
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.averagefuel.js') }:</th>
	                        <td width="30%" >
		                        <div class="common_txtbox_wrap">
		                        	<input  id="aveFuelConsump" name="aveFuelConsump" maxlength="13" class="validate font_size12" validate="name:'${ctp:i18n('office.auto.averagefuel.js')}',regExp:'^([0-9][0-9]{0,7})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.money.check.js')}'" value="" type="text"/>                           
		                        </div>  
	                        </td>
	                        <td width="30%" align="left"><span class="margin_l_5">${ctp:i18n('office.auto.l.js') }/${ctp:i18n('office.auto.100km.js') }</span></td>
	                    </tr>
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right">${ctp:i18n('office.auto.avefuelcost.js') }:</th>
	                        <td width="30%">
		                        <div class="common_txtbox_wrap">
		                        	<input  id="aveFuelCost" name="aveFuelCost" maxlength="13" class="validate font_size12" validate="name:'${ctp:i18n('office.auto.avefuelcost.js')}',regExp:'^([0-9][0-9]{0,7})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.money.check.js')}'" value="" type="text"/>   
		                        </div>
	                        </td>
	                        <td width="30%" align="left"><span class="margin_l_5">${ctp:i18n('office.auto.element.js')}/${ctp:i18n('office.auto.100km.js') }</span></td>
	                    </tr>
	               
	                    <tr>
	                        <th width="10%" noWrap="nowrap" align="right" valign="top">
	                            <label  for="text">${ctp:i18n('office.auto.mark.js') }:
	                        </th>
	                        <td width="60%" colspan="2" align="left">
	                            <div >
	                                <textarea  id="autoMemo" name="autoMemo" maxlength="1000" style="width: 99%; height: 70px;" ></textarea>
	                            </div>
	                        </td>
	                    </tr>
                	</table>
            		</div>
            </div>
        </div>
    </div>
</body>
</html>