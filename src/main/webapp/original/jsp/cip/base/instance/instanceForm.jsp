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
            <input type="hidden" id="id" name="id" value="-1">
             <input type="hidden" id="paramValue" name="paramValue">
                   <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.register.product')}:</label></th>
                        <td width="100%">
                                <select  id = "productId" class="w100b validate"></select>
                        </td>
                    </tr>        
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.form.product.version')}:</label></th>
                        <td width="100%">
                                <select  id = "productVersionId" class="w100b validate"></select>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap" ><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.instance.code')}:</label></th>
                       <td width="100%" >
                         <div class="common_selectbox_wrap">
                             <input type="text" id="systemCode" class="w100b" >
                         </div>
					   </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.instance.introduce')}:</label></th>
                        <td width="100%">
                            <div class="common_txtbox clearfix">
                            <textarea id="instanceIntroduce" cols='2'  class="validate" style="width:100%;height:80px;" validate="type:'string',name:'${ctp:i18n('cip.base.instance.introduce')}',notNull:true,maxLength:300"></textarea>
                            </div> 
                        </td>
                    </tr>
                    <tr>
                  <th nowrap="nowrap" id="appText"><label class="margin_r_10">${ctp:i18n('cip.base.product.param1')}：</label></th>
                    <td width="100%" >
					<table id="appTable"  class="only_table" border="0"  width="100%">
					   <thead>
					        <tr>
					            <th width="30%">${ctp:i18n('cip.base.product.param1')}</th>
					            <th width="30%">${ctp:i18n('cip.base.product.param3')}</th>
					            <th width="40%">${ctp:i18n('cip.base.product.param8')}</th>
					        </tr>
					    </thead>
					     <tbody id="mobody">
					     </tbody>
					</table>
					</td>
                    </tr>
            </table>
        </div>
        </div>
	</div>
    </form>
</body>
</html>