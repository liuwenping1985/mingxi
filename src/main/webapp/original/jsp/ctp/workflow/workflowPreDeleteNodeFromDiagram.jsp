<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<html class="h100b">
<head>
    <title>${ctp:i18n('workflow.deletePeople.title')}</title>
    <%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body class="h100b">
    <table class="only_table edit_table no_border"  id="scrollListTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="padding:20px 20px 194px 20px;background: #fafafa;">
        <thead>
            <tr>
                <th width="20" style="text-align: center;background: #80abd3;height:33px;"><input type="checkbox"  id='allCheckbox' disabled/></th>
                <th style="background: #80abd3;color:#fff;">${ctp:i18n("common.name.label") }</th>
            </tr>
        </thead>
        <tbody id="allNodeTbody">
            <c:choose>
                <c:when test="${activityList==null || fn:length(activityList)<=0}">
                    <tr class="erow">
                        <td style="height:33px;border-left:1px solid #dedede;background:#fff;border-right:none;">&nbsp;</td>
                        <td style="background:#fff;">${ctp:i18n("workflow.deletePeople.noChildren") }</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${activityList}" var="d">
                    <tr class="sort">
                        <td style="height:33px;background:#fff;"><input type="checkbox" disabled value="${d.id}"/></td>
                        <td style="background:#fff;">${d.BPMAbstractNodeName}</td>
                    </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">
    var processId = '${processId}';
    var currentNodeId = '${nodeId}';
    $("#allCheckbox").click(function(){
        if($(this).prop("checked")){
            $("#allNodeTbody input").prop("checked",true);
        }else{
            $("#allNodeTbody input").prop("checked",false);
        }
        
    });
    function OK(param){
        var deleteNodeId = [], deleteNodeName = [];
        $("#allNodeTbody").find(":checkbox:checked").each(function(){
            deleteNodeId.push($(this).val());
            deleteNodeName.push($(this).closest("td").next("td").text());
        });
        return $.toJSON({"idArray":deleteNodeId,"nameArray":deleteNodeName});
    }

	window.onload= function(){//fix:OA-33933was环境下：处理人进行减签操作，减签不生效
		$("#allCheckbox").removeAttr("disabled");
		$("#allNodeTbody").find(":checkbox").each(function(){
            $(this).removeAttr("disabled");
        });
	}
</script>
</body>
</html>