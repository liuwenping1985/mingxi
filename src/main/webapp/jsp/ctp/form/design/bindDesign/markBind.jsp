<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html>
  <head>
    <title>文号绑定</title>
    <script type="text/javascript">
    	function OK(){
    		var options = $("select option:selected");
    		var markArr = new Array();
    		for(var i=0;i<options.length;i++){
    			var curMark = new Object();
    			if($(options[i]).attr("id") == ''){
    				markArr[i]= curMark;
    				continue;
    			}
    			curMark.title = $(options[i]).val();
    			curMark.id=$(options[i]).attr("id");
    			curMark.fieldName = $(options[i]).parent().attr("id");
    			markArr[i]= curMark;
    		}    		
    		return markArr;
    	}
    </script>
  </head>
  <body>
  		<table valign="center" style="margin-top:20px;margin-left:20px;height:100px;width:280px;">  		
	  		<c:forEach var="curMark" items="${formMark }">
	  			<tr style="display:block; margin-top:5px; padding-left: 0px;font-size:12px">
	  				<td style="width:50px">${curMark.display}</td>
	  				<td>
	  					<select id="${curMark.fieldName }" type="${curMark.type }" style="width:200px;font-size:12px">
	  						<c:choose>
	  							<c:when test="${curMark.type == 'edocDocMark' }">	  								
	  								<option id='' title ='请选择公文文号'>请选择公文文号</option>	  								
	  							</c:when>					  							
	  							<c:when test="${curMark.type == 'edocInnerMark' }">	  								
	  								<option id='' title ='请选择内部文号'>请选择内部文号</option>	  								
	  							</c:when>
	  							<c:when test="${curMark.type == 'edocSignMark' }">	  								
	  								<option id='' title ='请选择签收编号'>请选择签收编号</option>	  								
	  							</c:when>
	  						</c:choose>
	  						<c:forEach var="subMark" items="${curMark.edocMark4Forms }">
	  							<option <c:if test='${subMark.memo =="select"}'>selected</c:if> id="${subMark.id }" >${subMark.mechanism }</option>
	  						</c:forEach>
	  					</select>
	  				</td>
	  			</tr>
	  		</c:forEach>
	  		<c:if test="${markSize <= 0 }">
	  			<tr><td><font class="color_red">暂未检索到文号类型控件!</font></td></tr>
	  		</c:if>
  		</table>
  </body>
</html>
