<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<script type="text/javascript">
var data = {
        "rows":[
            <c:forEach items="${templateList}" var = "tp" varStatus="status">
            {"id":"${tp.value}","name":"${tp.name}","createrId":"${tp.createrId}","createName":"${tp.creater}","formName":"${tp.formName}"}
            <c:if test = "${!status.end}">,</c:if>
            </c:forEach>
        ],
        "page": 1,
        "pages": 18,
        "startAt": 0,
        "dataCount": 10,
        "sortField": null,
        "sortOrder": null
};
var dialog = window.dialogArguments;
$(document).ready(function(){
  dialog = window.parentDialogObj['biztemplate'];
});
   function rend(txt, data, r, c) {
   }
   function clk(id,hasright) {
     if (hasright){
  		getCtpTop().showMenu("${path}/collaboration/collaboration.do?method=newColl&templateId="+id);
           dialog.close();
     }else{
       $.alert({
         msg:"${ctp:i18n('bizconfig.use.authorize.template')}",
         ok_fn:function(){
         }
       });
     }
   }
   function dblclk(data, r, c){
   }
</script>
</head>
<body style="padding: 5px;">
<c:set value="${v3x:currentUser()}" var="currentUser" />
    <table class="only_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
        <thead>
            <tr>
                <th>${ctp:i18n('formsection.config.template.label')}</th>
                <th>${ctp:i18n('formsection.config.template.sourceform')}</th>
                <th>${ctp:i18n('common.creater.label')}</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${templateList}" var = "tp" varStatus="status">
            <tr class="erow">
                <td><div class="link_box clearfix"><a onclick="clk('${tp.value}',${tp.hasright })">${tp.name}</a></div></td>
                <td>${tp.formName}</td>
                <td >${tp.creater}
                    <c:if test="${currentUser.id ne tp.createrId and ctp:hasPlugin('uc')}">
                        <span class="ico16 info_16" onclick="getCtpTop().sendUCMessage('${tp.creater}', '${ tp.createrId}');"></span>
                    </c:if>
                </td>
            </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>