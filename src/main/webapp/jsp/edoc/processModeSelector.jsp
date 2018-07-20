<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<div id="processModeSelectPanel">
		<c:set value=",'${templateId }'" var="addTemplate"/>
		<c:if test="${keys ne null }">
		<c:forEach items="${keys}" var="nodeId"  varStatus="status">
			<div id="d${nodeId }">
			<label for="${nodeId }">
			<input type="checkbox" name="${nodeId }" id="${nodeId }" />
			${names[status.index] }&nbsp;
			</label>
			<label class="like-a" onclick="showBranchDesc('${links[status.index] }'${templateId!=null?addTemplate:'' })" id="p${nodeId }"></label>
			</div>
		</c:forEach>
		<c:forEach items="${conditions }" var="condition" varStatus="status">
			<c:set var="jsVar" value="${'v'}${fn:replace(keys[status.index],'-','_')}" />
			<input type="hidden" name="scripts" value="var ${jsVar} = eval('${condition}');if(${jsVar}==false) hiddenFailedCondition('${keys[status.index] }');document.getElementById('${keys[status.index]}').checked = ${jsVar};document.getElementById('${keys[status.index]}').disabled = ${forces[status.index]};if(${jsVar}) document.getElementById('p${keys[status.index]}').innerHTML = '[<fmt:message key="col.branch.sucess"/>]'; else document.getElementById('p${keys[status.index]}').innerHTML = '[<fmt:message key="col.branch.faile"/>]';">
      	</c:forEach> 
      	<input type="hidden" name="allNodes" value="${allNodes }">
      	<input type="hidden" name="nodeCount" value="${nodeCount }">
      	<div id="failedCondition" style="display:none">
      	</div>
      	<c:if test="${formContent!=null}">
	      	<div id="scrollDiv" style="display:none">
		     	<div id ="area" style="margin-left :20;margin-top:20">
			       	<div id="html" name="html" style="height:0px;display:none">
					<div id="formContent">
						<textarea id="tarea"></textarea>
					</div>
				   	</div>
				   	<div id="img" name="img" style="height:0px;"></div>
		    	</div>
				<script>
					var formContent7777 = "${formContent}";
					var isForm = true;
				</script>
			</div>
		</c:if>
	</c:if>
	
    <c:if test="${processModeSelector ne null}">
        <fmt:message key="common.default.selectPeople.value" var="defaultSP" bundle="${v3xCommonI18N}"/>

        <c:set value="${processModeSelector.mode}" var="mode" />
        <c:if test="${mode == 2}">
            <c:forEach items="${processModeSelector.nodeAdditions}" var="nodeAddition">
                <div>${nodeAddition.nodeName} / ${nodeAddition.processModeName} </div>
                <div>
                <input type="hidden" name="manual_select_node_id" value="${nodeAddition.nodeId}"/>

                <c:set value="manual_select_node_id${nodeAddition.nodeId}" var="id" />
                <c:set value="1" var="singleOrMany" />
                <c:choose>
                    <c:when test="${!empty nodeAddition.people}">
                        <select name="${id}" id="${id}" ${singleOrMany == 'n' ? 'multiple size="3"' : ''} class="input-100per">
                            <c:forEach items="${nodeAddition.people}" var="p">
                                <option value="${p.id}">${p.name}</option>
                            </c:forEach>
                        </select>
                    </c:when>
                    <c:otherwise>
                    	<c:set value="" var="pName" />
		                    	<c:set value="" var="pId" />
		                    	<c:forEach items="${nodeAddition.people}" var="p" varStatus="status">
		                         	<c:set value="${pId}${status.index!=0? ',':''}${p.id}" var="pId" />
		                         	<c:set value="${pName}${status.index!=0? '��':''}${p.name}" var="pName" />
		                </c:forEach>
                        <input name='${id}' type="hidden" value="" />
                        <input name='${id}Name' value="${defaultSP}" title="" deaultValue="${defaultSP}"
                            readonly class="cursor-hand input-100per" onclick="selectPeople('${singleOrMany}', '${id}')"
                            inputName="节点名称" validate="isDeaultValue,notNull" onAfterAlert="selectPeople('${singleOrMany}', '${id}')">
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </c:if>
    </c:if>
    
    <c:if test="${keys ne null }">
        <c:set value="2" var="mode" />
        <div id="aDiv" align="right" style="display:none">
	        <div class="like-a" onclick="showFailedCondition(this)">
	        	[<fmt:message key='col.branch.show'/>]
	        </div>
        </div>
    </c:if>
    <input type="hidden" id="processXML" name="processXML" value="${caseProcessXML}">
    <input type="hidden" id="desc_by" name="desc_by" value="${process_desc_by}">

    <span id="showProcessModeSelector" style="display:none"><c:out value="${mode}" default="0" /></span>
</div>    