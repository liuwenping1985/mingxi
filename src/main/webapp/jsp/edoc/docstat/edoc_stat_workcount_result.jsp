<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/docstat/edoc_stat_worklist.js${v3x:resSuffix()}" />"></script>
<script>
	var _ctxPath = '${path}';
	var edocStatUrl = _ctxPath+"/edocStatNew.do";
</script>
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
	<input type="hidden" name="startTime" id="checkSTime" value="${startTime }">
	<input type="hidden" name="endTime" id="checkETime" value="${endTime }">
	<input type="hidden" name="checkDeptId" id="checkDeptId" value="${dept }">
	<input type="hidden" name="statId" id="statId" value="${statId }">
    <div>
        <div id="statTitle" align="center" class="padding_tb_5" style="font-size:13px;">${statName }</div>
    </div>
    <div id="center" >
    <table border="1" class="block-table">   	
	<tr valign="top">
		 <td align="center" valign="top">
			 <TABLE border="1"  cellSpacing=0 cellPadding=0 width="100%" >
			 <thead>
             <tr listType="${webWorkCount.listType}" id="${webWorkCount.deptOrMemberId}">
                <td style="width:80px;" rowspan="2">部门</td>
                <c:if test="${webWorkCount.isShowSend ==1 }">  
                <td colspan="${webWorkCount.sendTdSize}" style="background: #dcdcdc">发文</td>
                </c:if>
                 <c:if test="${webWorkCount.isShowRec ==1 }">
                <td colspan="${webWorkCount.recTdSize}" style="background: #dcdcdc">收文</td>
                </c:if>
                 <c:if test="${webWorkCount.isShowTotal ==1 }">
                <td colspan="${webWorkCount.totalTdSize}" style="background: #dcdcdc">总计</td>
                </c:if>
             </tr>
             <tr>
                <c:if test="${webWorkCount.isShowSendCount ==1 }"> 
                <td>发文数</td>
                </c:if>
                 <c:if test="${webWorkCount.isShowFontSize ==1 }"> 
                <td>字数</td>
                </c:if>
                 <c:if test="${webWorkCount.isShowSendDCount ==1 }"> 
                <td>已办结</td>
                </c:if> 
                <c:if test="${webWorkCount.isShowSendPCount ==1 }"> 
                <td>办理中</td>
                </c:if>
                 <c:if test="${webWorkCount.isShowSendDPer ==1 }"> 
                <td>办结率</td>
                </c:if>
                <c:if test="${webWorkCount.isShowSendOCount ==1 }"> 
                <td>超期件数</td>
                </c:if>
                <c:if test="${webWorkCount.isShowSendOper ==1 }"> 
                <td>超期率</td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecCount ==1 }"> 
                <td>收文数</td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecDCount ==1 }"> 
                <td>已办结</td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecPCount ==1 }"> 
                <td>办理中</td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecDper ==1 }"> 
                <td>办结率</td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecOCount ==1 }"> 
                <td>超期件数</td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecOper ==1 }"> 
                <td>超期率</td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllCount ==1 }"> 
                <td>总计</td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllDCount ==1 }"> 
                <td>已办结</td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllPCount ==1 }"> 
                <td>办理中</td>
                </c:if>
                 <c:if test="${webWorkCount.isShowAllDPer ==1 }"> 
                <td>办结率</td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllOCount ==1 }"> 
                <td>超期件数</td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllOper ==1 }"> 
                <td>超期率</td>
                </c:if>
             </tr>
            </thead>
			<tbody scroll="auto" id="dataList">	
			   <c:forEach  items="${list}" var="content" varStatus="status">	 	
			    <tr deptId="${content.deptOrMemberId}" listType="${content.listType}" deptOrMName="${content.deptName }" statRangeType="${content.statRangeType }" statRangeId="${content.statRangeId }">
                <td>${content.deptName }</td>
                <c:if test="${webWorkCount.isShowSendCount ==1 }"> 
                <td><input type="hidden" name="sendCountIds" value="${content.sendCountSIds}"><a href="javascript:void(0);"  type="2">${content.sendCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowFontSize ==1 }"> 
                <td>${content.fontSize }</td>
                </c:if>
                <c:if test="${webWorkCount.isShowSendDCount ==1 }"> 
                <td><input type="hidden" name="sendDoneIds" value="${content.sendDoneSIds }"><a href="javascript:void(0);"  type="4">${content.sendDoneCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowSendPCount ==1 }"> 
                <td><input type="hidden" name="sendPendingIds" value="${content.sendPendingSIds }"><a href="javascript:void(0);"  type="5">${content.sendPendingCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowSendDPer ==1 }"> 
                <td>${content.sendDonePer }</td>
                </c:if>
                <c:if test="${webWorkCount.isShowSendOCount ==1 }"> 
                <td><input type="hidden" name="sendOverIds" value="${content.sendOverSIds }"><a href="javascript:void(0);"  type="7">${content.sendOverCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowSendOper ==1 }"> 
                <td>${content.sendOverPer }</td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecCount ==1 }"> 
                <td><input type="hidden" name="recCountIds" value="${content.recCountRIds }"><a href="javascript:void(0);"  type="10">${content.recCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecDCount ==1 }"> 
                <td><input type="hidden" name="recDoneIds" value="${content.recDoneRIds }"><a href="javascript:void(0);"  type="11">${content.recDoneCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecPCount ==1 }"> 
                <td><input type="hidden" name="recPendingIds" value="${content.recPendingRIds }"><a href="javascript:void(0);"  type="12">${content.recPendingCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecDper ==1 }"> 
                <td>${content.recDonePer }</td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecOCount ==1 }"> 
                <td><input type="hidden" name="recOverIds" value="${content.recOverRIds }"><a href="javascript:void(0);"  type="14">${content.recOverCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowRecOper ==1 }"> 
                <td>${content.recOverPer }</td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllCount ==1 }"> 
                <td><input type="hidden" name="allCountIds" value="${content.allCountIds }"><a href="javascript:void(0);"  type="17">${content.allCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllDCount ==1 }"> 
                <td><input type="hidden" name="allDoneIds" value="${content.allDoneIds }"><a href="javascript:void(0);"  type="18">${content.allDoneCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllPCount ==1 }"> 
                <td><input type="hidden" name="allPendingIds" value="${content.allPendingIds }"><a href="javascript:void(0);"  type="19">${content.allPendingCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllDPer ==1 }"> 
                <td>${content.allDonePer }</td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllOCount ==1 }"> 
                <td><input type="hidden" name="allOverIds" value="${content.allOverIds }"><a href="javascript:void(0);"  type="21">${content.allOverCount }</a></td>
                </c:if>
                <c:if test="${webWorkCount.isShowAllOper ==1 }"> 
                <td>${content.allOverPer}</td>
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