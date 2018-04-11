<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-store"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%-- 回退页面 --%>${ctp:i18n("workflow.label.returnPage")}</title>
</head>
<body>
    <table>
        <tbody>
            <tr>
                <td>
                    <%-- 回退到上一节点 --%>${ctp:i18n("workflow.label.returnToPreNode")}:
                </td>
                <td>
                    <input type="radio" id="stepBackTypeToLast" name="stepBackType" checked="checked" value="1"/>
                </td>
            </tr>
            <tr>
                <td>
                    <%-- 回退到指定节点 --%>${ctp:i18n("workflow.label.returnToSpecifiedNode")}:
                </td>
                <td>
                    <input type="radio" id="stepBackTypeToSetted" name="stepBackType" value="2"/>
                </td>
            </tr>
            <tr>
                <td><%-- 请选择要回退到的节点 --%>${ctp:i18n("workflow.label.returnToSelectNode")}:</td>
                <td>
                    <select id="targetNodeIdSelect" name="targetNodeId"><c:forEach items="${nodes}" var="d">
                        <option value="${d.id}">${d.name}</option>
                    </c:forEach></select>
                </td>
            </tr>
        </tbody>
    </table>
</body>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">
    function OK(){
        if($("#stepBackTypeToSetted").prop("checked")==true){
            return $("#targetNodeIdSelect").val();
        }else{
            return window.dialogArguments.nodeId;
        }
    }
</script>
</html>