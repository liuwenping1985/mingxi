<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.addressbook.resource.i18n.AddressBookResources"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
	function viewMember(memberId){
		//TODO
		//parent.detailFrame.location.href = addressbookURL+"?method=viewDept&id="+deptid+"&from=dept";
		parent.detailFrame.location.href = addressbookURL+"?method=viewMember&addressbookType=2&mId="+memberId;
	}
</script>
</head>
<body>
<table width="100%"  height="100%" border="0" cellspacing="0"
	cellpadding="0">
	<tr>
		<td colspan="2">
			<div class="scrollList">
			<form id="memberform" method="post">
				<v3x:table data="${members}" var="member" leastSize="0" htmlId="memberlist">

				<c:set var="click" value="viewMember('${member.id}')"/>
				<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type="checkbox" name="id" value="${member.id}">
				</v3x:column>
				<v3x:column  width="15%" label="addressbook.account_form.companyName.label"
					value="${member.companyName}" onClick="${click}" className="cursor-hand sort"
					 symbol="..." alt="${member.companyName}"
					></v3x:column>
				<v3x:column  width="10%" label="addressbook.username.label"
					 className="cursor-hand sort"
					 maxLength="28" symbol="..." alt="${member.name}">
					 <a class="defaulttitlecss" href="javascript:${click}">${v3x:getLimitLengthString(member.name,12,'...')}</a>
					</v3x:column>
				<v3x:column  width="10%" label="addressbook.company.department.label"
					value="${member.companyDept}" onClick="${click}" className="cursor-hand sort"
					 symbol="..." alt="${member.companyDept}"
					></v3x:column>
				<v3x:column  width="10%"  label="addressbook.company.level.label"
					value="${member.companyLevel}" onClick="${click}" className="cursor-hand sort"
					 maxLength="65" symbol="..." alt="${member.companyLevel}"
					></v3x:column>
				<v3x:column  width="10%" label="addressbook.company.post.label"
					value="${member.companyPost}" onClick="${click}" className="cursor-hand sort"
					symbol="..." alt="${member.companyPost}"
					></v3x:column>
				<v3x:column  width="10%" label="addressbook.company.telephone.label"
				value="${member.companyPhone}" onClick="${click}" className="cursor-hand sort"
				symbol="..." alt="${member.companyPhone}"
					 >
				</v3x:column>
				<v3x:column  width="10%" label="addressbook.mobilephone.label"
				value="${member.mobilePhone}" onClick="${click}" className="cursor-hand sort"
				symbol="..." alt="${member.mobilePhone}"
					 >
				</v3x:column>
				<v3x:column  width="20%" label="addressbook.email.label" onClick="${click}"
				symbol="..." alt="${member.email}">
				<div class="like-a">
					${member.email} &nbsp;
				</div>
				</v3x:column>
			</v3x:table>
			</form>
			</div>
		</td>
	</tr>
</table>
</body>
</html>
