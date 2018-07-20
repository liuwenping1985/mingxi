<%--
 $Author:$
 $Rev:$
 $Date:: $:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="../common/common.js.jsp" %>
<%@ include file="../component/formFieldConditionComp.js.jsp" %>
<html class="h100b">
    <head>
        <title>Insert title here</title>
        <style type="text/css">
            .ellipsis {
                text-align:center;
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
                -moz-binding: url('ellipsis.xml#ellipsis');
            }
        </style>
        <script type="text/javascript">
            $(document).ready(function(){
              <c:if test="${rightStr ne ''}">
              $(".erow").css("cursor","pointer");
              $(".erow").click(function(){
                showFormData4Statistical(${formBean.formType},this.id,"${rightStr}","${queryBean.name}",null,${queryBean.formBean.id});
              });
              </c:if>
            });
        </script>
    </head>
    <body class="h100b bg_color_white bg_color_none">
        <table class="only_table edit_table " border="0" cellSpacing="0" cellPadding="0" width="100%">
		    <thead>
		        <tr>
		          <c:forEach items="${queryBean.resultShowFieldList }" var="fieldList">
		            <th nowrap="nowrap"><div style="text-align: center;">${fieldList.value }</div></th>
		          </c:forEach>
		        </tr>
		    </thead>
		    <tbody>
		      <c:forEach items="${queryResult }" var="result">
                  <tr>
                      <c:forEach items="${result.data }" var="resultData">
                          <c:choose>
                              <c:when test="${resultData.isUrl}">
                              <td  nowrap="nowrap" title="${resultData.value }"><a href="${resultData.value }" target="_blank">${ctp:getLimitLengthString(resultData.value , 20, '...')}</a>&nbsp;</td>
                          </c:when>
                              <c:when test="${resultData.isImage and not empty resultData.value}">
                                  <td class="erow" id="${result.id }" nowrap="nowrap" ><img class="showImg" src="${path}/fileUpload.do?method=showRTE&fileId=${resultData.value }&expand=0&type=image" height=25 />&nbsp;</td>
                              </c:when>
                          <c:otherwise>
                              <td class="erow" id="${result.id }" nowrap="nowrap" title="${resultData.value }" style="max-width: 120px;"><div class="ellipsis">${ctp:toHTMLAlt(resultData.value)}&nbsp;</div></td>
                          </c:otherwise>
                          </c:choose>
                  </c:forEach>
		        </tr>
		      </c:forEach>
		    </tbody>
	    </table>
    </body>
</html>