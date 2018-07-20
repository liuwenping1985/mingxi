<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" src="<c:url value='/ajax.do?managerName=selectPeopleManager' />"></script>
<script type="text/javascript">
$().ready(function() {
    var parentWindowData = window.parentDialogObj["saveAsTeamDialog"].getTransParams();
    $("#memberNames").val(parentWindowData["memberNames"]);
});

function OK() {
    if(!$("#validDomain").validate()){
        return -1;
    }

    var parentWindowData = window.parentDialogObj["saveAsTeamDialog"].getTransParams();
    
    var memberIds = parentWindowData["memberIds"];
    var teamName = $("#teamName").val();

    var spm = new selectPeopleManager();
    var r = spm.saveAsTeam(teamName, memberIds);
    if(!r){
        return -1;
    }
    
    if(r["RepeatName"]){
        $.alert($.i18n("selectPeople_saveAsTeam_same_personal_name"));
        return -1;
    }
    
    return {
        "TeamId" : r["TeamId"],
        "TeamName" : teamName
    };
}
</script>
</head>
<body class="page_color h100b">
<div id="validDomain" class="form_area padding_5">
    <table border="0" cellSpacing="0" cellPadding="0" width="80%">
      <tbody>
        <tr>
            <td height="40" width="25%" noWrap="nowrap" align="right">${ctp:i18n("common.name.label") } :&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td width="70%">
                <div class="common_txtbox_wrap">
                <input type="text" class="validate w100b" name="teamName" id="teamName" validate="type:'string',notNull:true,maxLength:120,displayName:'${ctp:i18n("common.name.label") }',avoidChar:'\\/|><:*?&quot&%$'" />
            </td>
        </tr>
        <tr>
            <td height="40" noWrap="nowrap" align="right">${ctp:i18n("selectPeople.TeamMember_label") } :&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td><input type="text" id="memberNames" class="w100b" readonly="readonly" /></td>
        </tr>
      </tbody>
    </table>
</div>
</body>
</html>