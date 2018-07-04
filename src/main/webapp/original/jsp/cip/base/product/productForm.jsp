<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
    <form name="addForm" id="addForm" method="post" target="" class="validate">
    <div class="form_area" >
        <div class="one_row" style="width:50%;">
            <br>
            <table border="0" cellspacing="0" cellpadding="0">
            <input type="hidden" id="count_id" name="count_id">
            <input type="hidden" id="current_id" name="current_id" value=1>
            <input type="hidden" id="id" name="id" value="-1">
             <input type="hidden" id="productItemList" name="productItemList">
             <input type="hidden" id="sonNeed" value="">
            <input type="hidden" id="objectId">
                   <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.form.product.code')}:</label></th>
                        <td width="100%">
                                <input type="text" id="productCode"   class="w100b validate" validate="type:'string',name:'${ctp:i18n('cip.base.form.product.code')}',maxLength:50,notNull:true,regExp:'^[0-9a-zA-Z_]+$',errorMsg:'${ctp:i18n('cip.base.product.code.tip')}'"></input>
                        </td>
                    </tr>        
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.form.product.name')}:</label></th>
                        <td width="100%">
                                <input type="text" id="productName"  class="w100b validate"  validate="type:'string',name:'${ctp:i18n('cip.base.form.product.name')}',notNull:true,maxLength:80"/>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap" ><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.form.product.class')}:</label></th>
                       <td width="100%" >
                         <div class="common_selectbox_wrap">
                             <select  id = "productClassify" class="w50b validate"></select>
                         </div>
					   </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.base.form.product.introduce')}:</label></th>
                        <td width="100%">
                            <div class="common_txtbox clearfix">
                            <textarea id="productIntroduce" cols='2'  class="validate" style="width:100%;height:80px;" validate="type:'string',name:'${ctp:i18n('cip.base.form.product.introduce')}',maxLength:300"></textarea>
                            </div> 
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.form.product.company')}:</label></th>
                        <td width="100%" >
                            <div class="common_txtbox clearfix">
                            <input type="text" id="productCompany" class="w100b validate" validate="name:'${ctp:i18n('cip.base.form.product.company')}',notNull:true,maxLength:80,avoidChar:'\\\/|><:*?&%$|,&quot;+'">
                            </div>
                         </td>
                    </tr>
                    <tr>
                  <th nowrap="nowrap" id="appText"><label class="margin_r_10">${ctp:i18n('cip.base.form.product.serial')}：</label></th>
                    <td width="100%" >
					<table id="appTable"  class="only_table" border="0"  width="100%">
					
					    <thead>
					        <tr>
					            <th width="20%">${ctp:i18n('cip.base.form.product.version')}</th>
					            <th width="50%">${ctp:i18n('cip.base.form.product.version.info')}</th>
					            <th width="30%">${ctp:i18n('cip.base.form.product.param')}</th>
					        </tr>
					    </thead>
					    <tbody id="mobody">
					        <tr class="autorow" id = "1">
					            <td>
					            	<div class="common_txtbox_wrap">
									<input type="text" id="versionNO1" class="validate w50b"
											validate="type:'string',maxLength:50,name:'${ctp:i18n('cip.base.form.product.version')}',notNull:true,regExp:'^[0-9a-zA-Z_.]+$'">
									</div>
					            </td>
					            <td>
									<div class="common_txtbox_wrap ">
										<input type="text" id="versionMemo1" class="validate word_break_all" validate="type:'string',name:'${ctp:i18n('cip.base.form.product.version.info')}',maxLength:80">
									</div>
								</td>
								<td>
								    <div class="common_txtbox_wrap ">
								          <input type="text" id="paramId1" class="validate word_break_all"  tgt="1">
								   </div>
								</td>
					        </tr>
					    </tbody>
					</table>
					</td>
                    </tr>
            </table>
        </div>
        </div>
        <div class="hidden"   id="img" style="width: 16px; height: 30px;  position: relative;float: right; border: 1px; ">
			<div id="addDiv" style="height: auto;">
				<span title="${ctp:i18n('cip.base.product.add')}" class="ico16 repeater_plus_16" id="addImg" style="display: block;"></span></div><div id="addEmptyDiv" style="height: auto;">
				<span title="${ctp:i18n('form.base.delRow.label')}" class="ico16 repeater_reduce_16" id="delImg" style="display: block;"></span>
			</div>
	</div>
    </form>
</body>
</html>