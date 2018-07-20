<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<script type="text/javascript">
<!--

getDetailPageBreak();
	
	function showDetail(id) {
		parent.bottom.location.href = "${edocStat}?method=edocDetail&id="+id;
	}

//-->
</script>
<body scroll="no">
<div class="scrollList">
<form name="statForm" id="statForm" method="post">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">	
	<tr>
		<td valign="top">
			<div class="scrollList">
			<v3x:table data="${edocStats}" var="edocStat1" isChangeTRColor="true" showHeader="true" showPager="true">							
				<v3x:column width="15%" maxLength="16" label="common.subject.label" alt="${edocStat1.subject}" symbol="..."  value="${edocStat1.subject}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort  mxtgrid_black"></v3x:column>
				<v3x:column width="15%" maxLength="16" alt="${edocStat1.docMark}" symbol="..." label="edoc.element.wordno.label" value="${edocStat1.docMark}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort"></v3x:column>
				<v3x:column width="10%" label="common.date.sendtime.label"  onClick="showDetail('${edocStat1.id}');" type="Date" className="cursor-hand sort">
					<fmt:formatDate value='${edocStat1.createDate}' type='both' dateStyle='full' pattern='yyyy-MM-dd' />
				</v3x:column>
				<v3x:column width="10%" label="edoc.element.issuer" value="${edocStat1.issuer}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort"></v3x:column>
				<v3x:column width="16%" maxLength="20" alt="${edocStat1.sendTo}" symbol="..." label="edoc.element.sendtounit" value="${edocStat1.sendTo}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort"></v3x:column>
				<v3x:column width="16%" maxLength="20" alt="${edocStat1.copyTo}" symbol="..." label="edoc.element.copytounit" value="${edocStat1.copyTo}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort"></v3x:column>
				<v3x:column width="9%" label="edoc.element.copies" value="${edocStat1.copies}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort"></v3x:column>
				<v3x:column width="9%" maxLength="12" alt="${edocStat1.remark}" symbol="..."  label="edoc.stat.remark.label" value="${edocStat1.remark}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort"></v3x:column>
			</v3x:table>
			</div>
		</td>
	</tr>
</table>
</form>
</div>
</body>