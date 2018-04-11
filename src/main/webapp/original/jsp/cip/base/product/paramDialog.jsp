<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<style type="text/css">
<!--
.check_middle{margin:2px 2px 0 30px; float:left; vertical-align:middle;margin-top:3px!important ;margin-top:0px;}
-->
</style>
</head>
 <script type="text/javascript">
 var parWin = parent.window;
 $(document).ready(function() {
	       var parentTbody  = $("#sonNeed",parWin.document);
           var tableJson = parentTbody.val();
           var objectId = "${param.objectId}";
			var position = "${param.versionId}";
			if(tableJson!=null&&tableJson!=""){
				var obj = JSON.parse(tableJson);
				var tableS=new StringBuffer();
				for (var i=0;i<10;i++) {
					tableS.append("<tr class=\"autorow\">");
					tableS.append("<td><div class=\"common_txtbox_wrap\">");
					tableS.append( "<input type=\"text\" id='paramName"+i +"' class=\"validate word_break_all\"  validate=\"type:'string',minLength:1,maxLength:100\">");
					tableS.append("</div></td>");
					tableS.append("<td><div class=\"common_selectbox_wrap \">");
					tableS.append("<select id='dataType"+i +"'  class='validate word_break_all'>");
					tableS.append("<option value=\"1\">${ctp:i18n('cip.base.product.param6')}</option>");
					tableS.append("<option value=\"2\">${ctp:i18n('cip.base.product.param7')}</option>");
					tableS.append("</select>");
					tableS.append("</div></td>"); 
					tableS.append("<td><div class=\"common_txtbox_wrap \">");
					tableS.append("<input type='text' id='paramDes"+i +"' class='validate word_break_all'>");
					tableS.append("</div></td>"); 
					tableS.append("<td><div class=\"common_checkbox_wrap \">");
					tableS.append("<input type='checkbox' id='required"+i +"'  class='validate word_break_all check_middle'> ");
					tableS.append("</div></td>"); 
					tableS.append("<td><div class=\"common_txtbox_wrap \">");
					tableS.append("<input type='text' id='paramMemo"+i +"'  class='validate word_break_all'>");
					tableS.append("</div></td>"); 
					tableS.append("</tr>");
				}
					
				$("#mobody").html(tableS.toString());
					
				for (var i=0;i<obj.length;i++) {
					$("#paramName"+i).val(obj[i].paramName);
					$("#dataType"+i +" option[value="+obj[i].dataType+"]").attr("selected", true);
					$("#paramDes"+i).val(obj[i].paramDes.escapeHTML());
					if(obj[i].required){
						$("#required"+i).attr("checked",true);
					}else{
						$("#required"+i).attr("checked",false);
					}
					$("#paramMemo"+i).val(obj[i].paramMemo.escapeHTML());
				}
			}
			
			$("#objectId").val(objectId);
			$("#position").val(position);
			$("#paramName0").disable();
			$("#paramName1").disable();
			$("#paramDes0").disable();
			$("#paramDes1").disable();
			$("#dataType0").disable();
			$("#dataType1").disable();
			$("#required0").disable();
			$("#required1").disable();
 });
 
 function OK() {
	 
	   var trList = $("#mobody").children("tr")
	   var map = [];
	   var position = $("#position").val();
	   var isNotSave = false;
	   var isNameSame = false;
       for (var i=0;i<trList.length;i++) {
         var tdArr = trList.eq(i).find("td");
         var paramName =tdArr.eq(0).find("input").val();
         if(paramName==null||paramName==""||paramName==undefined){
        	 continue;
         }
         
        	 var pat=new RegExp("^[a-zA-Z_]+$");
        	 if(!pat.test(paramName)){
        		 isNotSave=true;
        		 break;
        	 }
        	 for(var y=0;y<map.length;y++) {
        		 if(map[y].paramName==paramName){
        			 isNameSame=true;
        			 break;
        		 }
        	 }
        	 if(isNameSame){
        	 break;
        	 }
         var dataTypeObject =tdArr.eq(1).find("option:selected").val();
         var paramDes =tdArr.eq(2).find("input").val();
         var required =tdArr.eq(3).find("input").is(":checked");
         var paramMemo =tdArr.eq(4).find("input").val();
   	     if(paramDes.length>50){
		     $.alert("${ctp:i18n('cip.base.param.length.des')}");
		     return  {"result":false};
         }
	     if(paramMemo.length>80){
		     $.alert("${ctp:i18n('cip.base.param.length.memo')}");
		     return  {"result":false};
         }
         var json={"objectId":$("#objectId").val(),"paramName":paramName,"dataType":dataTypeObject,"paramDes":paramDes,"required":required,"paramMemo":paramMemo,"position":position};
         map.push(json);
       }
       if(isNotSave){
    	   $.alert("${ctp:i18n('cip.base.param.tip5')}");
           return  {"result":false};
       }
       if(isNameSame){
    	   $.alert("${ctp:i18n('cip.base.param.tip7')}");
           return  {"result":false};
       }
       if(map.length>=1){
    	   
         return {"list":map,"position":position};
       }
       
       return false;
 }
</script>
<body>
<table id="appTable"  class="only_table" >
	                         <input type="hidden" id="objectId">
	                         <input type="hidden" id="position" >
					    <thead>
					        <tr>
					            <th width="10%">${ctp:i18n('cip.base.product.param1')}</th>
					            <th width="10%">${ctp:i18n('cip.base.product.param2')}</th>
					            <th width="20%">${ctp:i18n('cip.base.product.param3')}</th>
					            <th width="10%">${ctp:i18n('cip.base.product.param4')}</th>
					            <th width="30%">${ctp:i18n('cip.base.product.param5')}</th>
					        </tr>
					    </thead>
					    <tbody id="mobody">
					   <c:forEach items="${newParamList}" var="item" varStatus="status">
				
					  
					        <tr class="autorow">
					            <td>
					            	<div class="common_txtbox_wrap">
									<input type="text" id="paramName${status.index}" class="validate word_break_all"
											validate="type:'string',maxLength:50,regExp:'^[a-zA-Z_]+$',errorMsg:'请使用英文和下划线组合'" value="${item.paramName }">
									</div>
					            </td>
					            <td>
									 <div class="common_selectbox_wrap">
										 <select  id = "dataType${status.index}" class="w50b validate">
										    <option value="1" <c:if test="${item.dataType==1}">selected</c:if>>${ctp:i18n('cip.base.product.param6')}</option>
										     <option value="2" <c:if test="${item.dataType==2}">selected</c:if>>${ctp:i18n('cip.base.product.param7')}</option>
										 </select>
									</div>
								</td>
								<td>
								    <div class="common_txtbox_wrap ">
								        <input type="text" id="paramDes${status.index}" class="validate word_break_all" value="${ctp:toHTML(item.paramDes)}">
								   </div>
								</td>
								<td>
								    <div class="common_checkbox_wrap ">
								        <input type="checkbox" id="required${status.index}" class="word_break_all check_middle" <c:if test="${item.required}">checked="checked"</c:if>>
								   </div>
								</td>
								<td>
								    <div class="common_txtbox_wrap ">
								      <input type="text" id="paramMemo" class="validate word_break_all" value="${ctp:toHTML(item.paramMemo)}">
								   </div>
								</td>
					        </tr>
					
					   </script>	     
                      </c:forEach>
					    </tbody>
					</table>
					</body>
					</html>