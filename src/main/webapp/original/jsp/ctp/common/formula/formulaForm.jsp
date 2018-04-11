<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style>
#editor div{
    font-family: Monaco, Menlo, Ubuntu Mono, Consolas, source-code-pro, monospace
}

</style>
</head>
<body>
<form name="addFormulaForm" id="addFormulaForm" method="post">
<div class="form_area">
    <div class="form_area_content">
    <p class="align_right"><font color="red">*</font>为必填项</p>
    <input type="hidden" id="formulaType" name="formulaType" value="2">
    <input type="hidden" name="id" id="id" value="-1" />
    <!-- 可用状态 -->
        <div class="one_row">
            <table border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ctp.formulas.formulaName')}:</label></th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
								<input type="text" id="formulaName" name="formulaName" class="validate word_break_all"
									validate="type:'string',name:'formulaName',maxLength:255">                                
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text">${ctp:i18n('ctp.formulas.description')}:</label></th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
								<input type="text" id="description" name ="description" class="validate word_break_all"
									validate="type:'string',name:'description',maxLength:255" >                                    
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text">${ctp:i18n('ctp.formulas.params.definition')}:</label></th>
                        <td>
                    <table id="paramTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table" >
					<input type="hidden" name="assist_id" id="assist_id" value="1" />
					    <thead>
					        <tr>
					            <th width="33.3%" align="center">${ctp:i18n('ctp.formulas.params')}</th>
					            <th width="33.3%" align="center">${ctp:i18n('ctp.formulas.dataType')}</th>
					            <th width="33.3%" align="center">${ctp:i18n('ctp.formulas.description')}</th>
					        </tr>
					    </thead>
					    <tbody id="mobody">
					        <tr class="assist" id = "1">
					            <td>
				            		<div class="common_txtbox_wrap ">
										<input type="text" id="fname"  name="fname"class="validate word_break_all"
											validate="type:'string',name:'fname',maxLength:100">
									</div>
					            </td>
					            <td>
									<div class="common_selectbox_wrap">
										<select id="fdType" name="fdateType" class="codecfg"
    										codecfg="codeType:'java',codeId:'com.seeyon.ctp.common.formula.enums.DataType'">
		    								<option value="">${ctp:i18n('ctp.formulas.please.select')}</option>
										</select>
									</div>
								</td>
								<td>
									<div class="common_txtbox_wrap ">
										<input type="text" id="fdescription" name="fdescription" class="validate word_break_all"
											validate="type:'string',name:'fdescription',maxLength:255">
									</div>
								</td>
					        </tr>
					    </tbody>
					</table>
					<input type="hidden" name="paramsJson" id="paramsJson" />
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ctp.formulas.returnType')}:</label></th>
                        <td width="100%">
                            <div class="common_selectbox_wrap">
                             	<input type="hidden" name="dataType" id="dataType" />
                                <select id="returnType" name="returnType" class="codecfg"
  										codecfg="codeType:'java',codeId:'com.seeyon.ctp.common.formula.enums.DataType'">
    								<option value="">${ctp:i18n('ctp.formulas.please.select')}</option>
								</select>
                            </div>
                        </td>
                    </tr>
                    <tr >
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ctp.formulas.category')}:</label></th>
                        <td>
                            <div class="common_selectbox_wrap">
                                <select id="category" name="category" class="codecfg"
  										codecfg="codeType:'java',codeId:'com.seeyon.ctp.common.formula.enums.CATEGORY'">
    								<option value="">${ctp:i18n('ctp.formulas.please.select')}</option>
								</select>
                            </div>
                        </td>
                    </tr>
                    <%-- <tr id="templatesTr">
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text">${ctp:i18n('ctp.formulas.templateNum')}:</label></th>
                        <td>
                            <div class="common_txtbox_wrap">
                                <input type="text" id="templates" name ="templates" class="validate word_break_all"
											validate="type:'string',name:'templates',maxLength:255" >
                            </div>
                        </td>
                    </tr> --%>
                    <tr>
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ctp.formulas.simple')}:</label>
                        </th>
                        <td>
                            <div class="common_txtbox_wrap">
                                 <input type="text" id="sample" name ="sample" class="validate word_break_all"
											validate="type:'string',name:'sample',maxLength:255">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text">${ctp:i18n('ctp.formulas.simple.expect.value')}:</label>
                        </th>
                        <td>
                            <div class="common_txtbox_wrap">
                                 <input type="text" id="expectValue" name ="expectValue" class="validate word_break_all"
											validate="type:'string',name:'expectValue'">
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <!-- 禁用状态 -->
        <div class="one_row">
            <table border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text">${ctp:i18n('ctp.formulas.formulaAlias')}:</label></th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                 <input type="text" id="formulaAlias" name ="formulaAlias" class="validate word_break_all"
											validate="type:'string',name:'formulaAlias',maxLength:255">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ctp.formulas.formulaExpression')}:</label></th>
                        <td width="100%">
                            <div id="editor"></div>                            
                            <div class="common_txtbox  clearfix">
                                <textarea rows="5" class="w100b validate word_break_all" id="formulaExpression" name ="formulaExpression" validate="type:'string',name:'formulaExpression',notNull:false,maxLength:1000" style="height:230px;display:none"></textarea>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="hidden"   id="img" style="width: 16px; height: 30px;  position: relative;float: right; border: 1px; " name="img">
		<div id="addDiv" style="height: auto;">
			<span  class="ico16 repeater_plus_16" id="addImg" style="display: block;"></span></div><div id="addEmptyDiv" style="height: auto;">
			<span  class="ico16 repeater_reduce_16" id="delImg" style="display: block;"></span>
		</div>
</div>
</form>
</body>
</html>