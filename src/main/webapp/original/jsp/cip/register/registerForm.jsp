<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<style type="text/css">
<!--
.iconArea {
	float: left;
	border: 1px solid #CCC;
	height: 75px;
	width: 75px;
	margin-right:10px;
}
.closeImg1 {
	display: none;
	position: absolute;
	background-position:0% 0%;
	width: 16px;
	height: 16px;
	cursor: pointer;
	background: url(/seeyon/apps_res/cip/img/icon.png) no-repeat -120px -54px;
	z-index:100;
}
-->
</style>
<body>
    <form name="addForm" id="addForm" method="post" target="" class="validate">
    <div class="form_area" >
        <div class="one_row" style="width:50%;">
            <br>
            <table border="0" cellspacing="0" cellpadding="0">
             <input type="hidden" id="paramValue" name="paramValue">
            <input type="hidden" id="id" name="id" value="-1">
                   <tr id="appCodetr">
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.service.register.appcode')}:</label></th>
                        <td width="100%">
                                <input type="text" id="appCode"   class="w100b validate"></input>
                        </td>
                    </tr>        
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.service.register.appname')}:</label></th>
                        <td width="100%">
                                <input type="text" id="appName" name="appName" class="w100b validate"  validate="type:'string',name:'${ctp:i18n('cip.service.register.appname')}',notNull:true,maxLength:12,avoidChar:'\\\/|><:*?&%$|,&quot;-_+'"/>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap" ><label class="margin_r_10" for="text">${ctp:i18n('cip.service.register.iconupload')}:</label></th>
                       <td width="100%" >
                       <input type = "hidden" id = "iconPC" name = "iconPC">
								<input id="iconInput" type="hidden" class="comp" comp="type:'fileupload', applicationCategory:'39',  
							        	extensions:'png,jpg', isEncrypt:false,quantity:1,maxSize: 1048576,
							            canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true,callMethod:'iconUploadCallback'">
								<input type = "hidden" id = "iconH5" name = "iconH5">
                          <table id="imgtb">
                             <tr><td>
                             <div id="iconDiv1" class="iconArea" onclick="insertAttachment();" title='104px*104px'></div>
                             <div id="closeImg0" class="closeImg1"></div>
                             </td>
                             <td><input type="radio" value="0" id="icontype" name="icontype" class="radio_com"> PC</td>
                             
                             </tr>
                             <tr><td>
                             
                             	<div id="iconDiv2" class="iconArea" onclick="insertAttachment();" title='104px*104px'></div>
								<li id="closeImg1" class="closeImg1"></li>
                             
                             </td>
                              <td><input type="radio" value="1" id="icontype" name="icontype" class="radio_com">${ctp:i18n('cip.service.register.mobile')}</td>
                             </tr>
                          </table>
					        </td>
                    </tr>
                         <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.register.product')}:</label></th>
                        <td width="100%">
                                <select  id = "productId" class="w100b validate"></select>
                        </td>
                    </tr>        
                        <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.service.register.versionno')}:</label></th>
                        <td width="100%">
                                <select  id = "versionNO" class="w100b validate"></select>
                        </td>
                    </tr>
                      <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.service.register.versiontip')}:</label></th>
                   <td width="100%" >
                            <input type="text" id="versionIntroduction" name="versionIntroduction" class="w100b validate" validate="notNull:true,name:'${ctp:i18n('cip.service.register.versiontip')}',maxLength:100,avoidChar:'\\\/|><:*?&%$|,&quot;-_+'">
                         </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.instance.introduce')}:</label></th>
                        <td width="100%">
                            <div class="common_txtbox clearfix">
                               <textarea type="text" id="introduction" cols='2'   name="introduction" class="validate" style="width:100%;height:80px;" validate="type:'string',name:'${ctp:i18n('cip.base.instance.introduce')}',notNull:true,maxLength:300"></textarea>
                            </div> 
                        </td>
                    </tr>
                   
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.service.register.applable')}:</th>
                        <td width="100%">
                                <div class="common_checkbox_box clearfix ">
                                 <input type="text" id="appLabel" name="appLabel" class="w100b validate">
                                </div>
                            </td>
                    </tr>

                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.service.register.appprovider')}:</label></th>
                        <td width="100%" colspan="5">
                            <div class="common_txtbox clearfix">
                               <input type="text" id="appProvider" name="appProvider" class="w100b validate" validate="notNull:true,maxLength:10,name:'${ctp:i18n('cip.service.register.appprovider')}',avoidChar:'\\\/|><:*?&%$|,&quot;-_+'">
                            </div> 
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10"><font color="red">*</font>${ctp:i18n('cip.service.register.access')}:</th>
                        <td width="100%">
                            <select id="accessMethod" class="w50b validate"></select>
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
    </form>
</body>
</html>