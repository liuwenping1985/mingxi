<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.seeyon.apps.nc.multi.NCMultiManager,java.util.List"%>
<%@page import="com.seeyon.apps.nc.multi.NCMultiManager.Provider"%>
<%@page import="com.seeyon.apps.nc.constants.NCConstants"%>
<%
    Provider ehrProvider=NCMultiManager.getInstance().getProvider(NCConstants.DEFAULT_EHR);
    String ehrName = (ehrProvider==null?"":ehrProvider.getName());
    pageContext.setAttribute("ehrName", ehrName);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


<script type="text/javascript">
function selectTemplate() {
 var dialog = $.dialog({
     
    url:"/seeyon/ncBusiBindController.do?method=showbilltempselectForm",
    width: 800,
    height: 450,
    title: "${ctp:i18n('ncbusinessplatform.business.label.chosetemp')}",//选择模板

    buttons: [{
        text: "${ctp:i18n('common.button.ok.label')}", //确定
        handler: function () {
           var rv = dialog.getReturnValue();
            if(rv.length<=0){
               $.alert("${ctp:i18n('ncbusinessplatform.business.label.selectone')}");
               return;
           }
           else if(rv.length>=2){
               $.messageBox({
                'type' : 0,
                'title':"${ctp:i18n('ncbusinessplatform.business.label.systemtitle')}",
                'msg' : "${ctp:i18n('ncbusinessplatform.business.label.selectmustone')}",
                'imgType':2,
                ok_fn : function() {
                }
              });
              return;
           }else{
               var formName = rv[0][0];
               var templateCode = rv[0][1];
               var templateName = rv[0][2];
               var accountName = rv[0][3];
               var templateId = rv[0][4];
               var accountId = rv[0][5];
               var form_id = rv[0][6];
               $("#billtemp_name").val(formName);
               $("#templete_name").val(templateName);
               $("#templete_id").val(templateId);
               $("#corp_name").val(accountName);
               $("#orgAccountId").val(accountId);
               $("#form_id").val(form_id);
           }
           
           dialog.close();
        }
    }, {
        text: "${ctp:i18n('common.button.cancel.label')}", //取消
        handler: function () {
            dialog.close();
        }
    }]
  });
 
}
    
</script>
</head>
<body>

    <form name="addForm" id="addForm" method="post" target="addDeptFrame">
    <div class="form_area" >
    
        <div class="one_row">
        <p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
            <table border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <input type="hidden" name="orgAccountId" id="orgAccountId" value="" />
                    <input type="hidden" name="id" id="id" value="" />
                    <input type="hidden" name="posttype" id="posttype" value="" />
                    <input type="hidden" name="form_id" id="form_id" value="">
                    <input type="hidden" name="templete_id" id="templete_id" value="">
                
                
                    <tr>
                         <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ncbusinessplatform.business.band.templetename')}:</label></th>
                         <td class="new-column" width="70%" nowrap="nowrap">
                            <input type="text" id="templete_name" name="templete_name" deaultValue=""  readonly="readonly"
                                inputName="${ctp:i18n('ncbusinessplatform.business.band.templetename')}" validate="type:'string',name:'${ctp:i18n('ncbusinessplatform.business.band.templetename')}',notNull:true" class="cursor-hand input-80per"
                                onclick="selectTemplate()" value="" />
                                
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ncbusinessplatform.business.band.billtempname')}:</label></th>
                        <td>
                            <div class="common_txtbox_wrap">
                                <input type="text" id="billtemp_name" class="validate word_break_all" readonly="readonly"
                                    validate="type:'string',name:'${ctp:i18n('ncbusinessplatform.business.band.billtempname')}',notNull:true">
                            </div>
                                
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('ncbusinessplatform.business.band.corpname')}:</label></th>
                        <td>
                            <div class="common_txtbox_wrap">
                                <input type="text" id="corp_name" class="validate word_break_all" readonly="readonly"
                                    validate="type:'string',name:'${ctp:i18n('ncbusinessplatform.business.band.corpname')}',notNull:true">
                            </div>
                            
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>NC:</label></th>
                        <td width="100%">
                            <div>
                                <select name="ncMultiJcId" id="ncMultiJcId"  class="w100b" >
                                <%
                                List<Provider> providers=NCMultiManager.getInstance().getProviderList();
                                for(Provider p:providers){
                                    %>
                                    <option value="<%=p.getId()%>"><%=p.getName()%></option>
                                    <%
                                }
                                %>
                                
                                </select>
                            </div>
                        </td>
                        
                    </tr>
                    <tr>
                        <td></td>
                        <td nowrap="nowrap"><label style="color:#008000;">
                        <c:if test="${not empty ehrName}">
                        ${ehrName}：${ctp:i18n('ncbusinessplatform.ehr.display')}
                        <br>
                        </c:if>
                        ${ctp:i18n('ncbusinessplatform.ehr.display2')}</label></td>
                    </tr>
                    <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ncbusinessplatform.business.label.busistate')}:</label></th>
                        <td width="100%">
                            <div>
                                <select name="extAttr1" id="extAttr1"  class="w100b">
                                    <option value="1" >${ctp:i18n('ncbusinessplatform.business.label.save')}</option>
                                    <option value="2">${ctp:i18n('ncbusinessplatform.business.label.check')}</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('common.sort.label')}:</label></th>
                        <td>
                            <div class="common_txtbox_wrap">
                                <input type="text" id="sortId" class="validate word_break_all"
                                    validate="type:'number',isInteger:true,name:'${ctp:i18n('common.sort.label')}',notNull:false,minValue:1,minLength:1,maxValue:99999">
                            </div>

                        </td>
                    </tr>
                <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('common.state.label')}:</label></th>
                        <td>
                            <div class="common_radio_box clearfix">
                                <label class="margin_r_10 hand"> <input
                                    type="radio"  value="true"  id="enable" name="enable" 
                                    class="radio_com">${ctp:i18n('common.state.normal.label')}
                                </label> <label class="margin_r_10 hand"> <input
                                    type="radio"  value="false" id="enable" name="enable" 
                                    class="radio_com">${ctp:i18n('common.state.invalidation.label')}
                                </label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('common.description.label')}:</label></th>
                        <td>
                            <div class="common_txtbox  clearfix">
                                <textarea rows="5" class="w100b validate word_break_all" id="description" validate="type:'string',name:'${ctp:i18n('common.description.label')}',notNull:false,maxLength:1000"></textarea>
                            </div>
                        </td>
                    </tr>
                
                </tbody>
            </table>
        </div>
        </div>
    </form>


</body>
</html>