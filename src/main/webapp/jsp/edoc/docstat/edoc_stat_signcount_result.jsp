<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<style type="text/css">
div,p{
    padding:0;
    margin:0;
}
.block{
    width: 100%;
    margin:0 auto;
    text-align: center;
}
.block-table{
    margin:20px 0;
    border-collapse: collapse;
    border-color:#ccc;
    width:100%;
    font-size:12px;
}
.block-table td{
    border-color:#999;
    height:36px;
}
.block-table thead td{
   padding:10px 0;
    background: #dcdcdc;
}
</style>
</head>
<body scroll="auto" >
	<input type="hidden" name="startTime" value="${startTime }">
	<input type="hidden" name="endTime" value="${endTime }">
    <div>
        <div id="statTitle" align="center" class="padding_tb_5" style="font-size:13px;">${statName }</div>
    </div>
    <div id="center" >
    <table border="1" class="block-table">   	
	<tr valign="top">
		 <td align="center" valign="top">
			 <TABLE border="1"  cellSpacing=0 cellPadding=0 width="100%" >
			 <thead>
             <tr>
                <td rowspan="2" colspan="2">单位</td>
                <td rowspan="2" >发文总数</td>
                <c:if test="${showTwo ==1 }">  
                <td colspan="2">2个工作日内接收</td>
                </c:if>
                <c:if test="${showThree ==1 }">  
                <td colspan="2">3至5个工作日内接收</td>
                </c:if>
                <c:if test="${showFive ==1 }">  
                <td colspan="2">5个工作日后接收</td>
                </c:if>
                <c:if test="${showNoRec ==1 }">  
                <td colspan="2">仍未签收</td>
                </c:if>
             </tr>
             <tr>
               <c:if test="${showTwo ==1 }"> 
               <td>数量</td>
               <td>百分比</td>
               </c:if>
               <c:if test="${showThree ==1 }"> 
               <td>数量</td>
               <td>百分比</td>
               </c:if>
               <c:if test="${showFive ==1 }"> 
               <td>数量</td>
               <td>百分比</td>
               </c:if>
               <c:if test="${showNoRec ==1 }"> 
               <td>数量</td>
               <td>百分比</td>
               </c:if>
             </tr>
            </thead>
			<tbody scroll="auto">		 	
					 
					<c:forEach  items="${list}" var="content" varStatus="status">
					<tr >	
						<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;${content.deptName }</td>
						<!-- 发文总数 -->
						<td>${content.allNum }</td>	
						<c:set var="allNum" value="${content.allNum }" />
						<c:if test="${showTwo ==1 }"> 
						<td >
							${content.twoSign }	
						</td>
						<td>${content.twoSignPer}</td>
						</c:if>
						<c:if test="${showThree ==1 }"> 
						<td>	
						    ${content.threeSign }	
						</td>
						<td>${content.threeSignPer }</td>	
						</c:if>
						<c:if test="${showFive ==1 }"> 
						<td >	
						    ${content.fiveSign }
						</td>
						<td>${content.fiveSignPer }</td>	
						</c:if>
						<c:if test="${showNoRec ==1 }"> 					
					 	<td >
					 		${content.noRecSignNum }
					 	</td>
					 	<td>
					 	    ${content.noRecSignNumPer }
					 	</td>
					 	</c:if>
					 </tr>
					 </c:forEach>
				</tbody>
			</table> 
		</td>	
	</tr>
</table>
	</div>

</body>
</html>