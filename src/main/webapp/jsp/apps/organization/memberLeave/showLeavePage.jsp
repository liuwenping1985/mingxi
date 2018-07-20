<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>MemberLevel</title>
<script type="text/javascript">

function showList4Leave(key){
    var dialog = $.dialog({
        url : "<c:url value='/organization/memberLeave.do' />?method=showList4Leave&memberId=${param.memberId}&key=" + key,
        title : '${ctp:i18n("member.leave.notdeal.affairtype")}',
        width : 640,
        height : 460,
        buttons: [
          {
              text : $.i18n('common.button.ok.label'),
              handler : function() {
                  dialog.close();
              }
          }
        ]
    });
}

function transferto(key){
    $.selectPeople({
        panels      :'Department,Team,Post',
        selectType  :'Member',
        minSize     : 0,
        maxSize     : 1,
        returnValueNeedType : false,
        isNeedCheckLevelScope : false,
        excludeElements : parseElements4Exclude("${param.memberId}", "Member"),
        
        callback : function(ret) {
            if(ret.value){
                $("#AgentName_" + key).html(ret.text);
            }
            else{
                $("#AgentName_" + key).html($.i18n("common.default.selectPeople.value"));
            }
            
            $("#AgentId_" + key).val(ret.value);
        }
    });
}

function OK(){
    <c:forEach items="${pendings}" var="p">
        <c:if test="${p.mustSetAgentMember}">
            if(!$("#AgentId_${p.key}").val()){
                alert("${ctp:i18n(p.label)} ${ctp:i18n('member.leave.alert.mustSetAgentMember')}");
                return;
            }
        </c:if>
    </c:forEach>
    
    $("#form1").jsonSubmit({
        debug : false
    });
    
    return true;
}

</script>
<style>
    .stadic_head_height{
        height: 160px;
    }
    .stadic_body_top_bottom{
        bottom: 0px;
        top: 160px;
    }
    .stadic_footer_height{
        height:0px;
    }
    .stadic_right{
        float:right;
        width:100%;
        height:100%;
        position:absolute;
        z-index:100;
    }
    .stadic_right .stadic_content{
        margin-left:345px;
        height:100%;
        overflow: hidden;
    }
    .stadic_left{
        width:320px; 
        float:left; 
        position:absolute;
        height:100%;
        z-index:300;
        overflow: hidden;
    }
    .o-div{
        overflow-y: scroll;
        height: 320px; 
        margin: 10px; 
        border: 1px solid #d1d1d1; 
        background-color: rgb(247, 247, 247);
    }
    .b{
        padding: 6px 5px 6px 5px; 
        border-bottom:1px solid #d1d1d1;
    }
</style>

</head>
<body class="h100b over_hidden">
<div class="stadic_layout">
    <div class="stadic_layout_head stadic_head_height">
        <fieldset class="margin_5">
            <legend>${ctp:i18n("member.leave.notdeal.affairtype")}</legend>
            <form id="form1" action="<c:url value='/organization/memberLeave.do' />?method=save4Leave">
            <input type="hidden" name="memberId" value="${param.memberId}" />
            <table align="center" class="only_table" border="0" cellspacing="0" cellpadding="0" width="97%">
                <thead>
                    <tr>
                        <th align="left" width="50%">${ctp:i18n("common.type.label")}</th>
                        <th align="center" width="20%">${ctp:i18n("member.leave.notdeal.affairnum")}</th>
                        <th align="center" width="30%">${ctp:i18n("member.leave.notdeal.operation")}</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${pendings}" var="p">
                     <tr class="erow">
                        <td align="left">${ctp:i18n(p.label)}</td>
                        <td align="center">
                            <c:choose>
                                <c:when test="${p.count > 0}">
                                    <a href="javascript:showList4Leave('${p.key}')">${p.count}</a>
                                </c:when>
                                <c:otherwise>
                                    ${p.count}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td align="center">
                            <c:choose>
                                <%-- 已经设了代理人 --%>
                                <c:when test="${!empty p.agentMemberId}">
                                    <a href="javascript:transferto('${p.key}')">
                                        ${ctp:i18n("member.leave.transferto")} : 
                                        <span id="AgentName_${p.key}">${ctp:showMemberName(p.agentMemberId)}</span>
                                     </a>
                                </c:when>
                                <c:when test="${empty p.agentMemberId}">
                                    <a href="javascript:transferto('${p.key}')">
                                        ${ctp:i18n("member.leave.transferto")} :
                                        <span id="AgentName_${p.key}">${ctp:i18n("common.default.selectPeople.value")}</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    -
                                </c:otherwise>
                            </c:choose>
                            <input type="hidden" id="AgentId_${p.key}" value="${p.agentMemberId}" />
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
            </form>
        </fieldset>
    </div>
    <div class="stadic_layout_body stadic_body_top_bottom clearfix">
        <div class="stadic_left">
            <div class="stadic_content">
                <fieldset class="margin_5">
                    <legend>${ctp:i18n("member.leave.otherssetting.title")}</legend>
                    <div class="o-div">
                        <c:forEach items="${handItems}" var="h">
                            <div class="b">${h}</div>
                        </c:forEach>
                    </div>
                    <br />
                </fieldset>
            </div>
        </div>
        <div class="stadic_right">
            <div class="stadic_content">
                <fieldset class="margin_5">
                    <legend>${ctp:i18n("org.role.label")}</legend>
                    <div class="o-div">
                        <c:forEach items="${roles}" var="h">
                            <div class="b">${ctp:toHTML(h)}</div>
                        </c:forEach>
                    </div>
                    <br />
                </fieldset>
            </div>
        </div>
    </div>
    <div class="stadic_layout_footer stadic_footer_height">
    </div>
</div>
</body>
</html>