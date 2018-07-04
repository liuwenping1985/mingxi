<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>MemberLevel</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=memberLeaveManager"></script>
<script type="text/javascript">
var grid;
var o = new Object();
o.memberId="${param.memberId}";
o.category = 0;
var searchobj;
var listHeight = $(window).height() - 265;	
$().ready(function() {
	//搜索条件
    searchobj = $('#searchDiv').searchCondition({
        searchHandler: function () {
            var ssss = searchobj.g.getReturnValue();
            o.condition = ssss.condition;
            o.value = ssss.value;
            $('#tab0_div').ajaxgridLoad(o);
        },
        conditions: [{
            id : 'accountName',
            name : 'accountName',
            type : 'selectPeople',
            text : "${ctp:i18n('member.leave.account')}",
            value : 'accountName',
            comp:"type:'selectPeople',mode:'open',panels:'Account',selectType:'Account',maxSize:'1',showMe:'true'"
        }, {
            id: 'type0',
            name: 'type0',
            type: 'select',
            text:  "${ctp:i18n('member.leave.type')}",
            value: 'type0',
            items: [ {
            	text: "${ctp:i18n('member.leave.collaboration.title')}",
                value: "${ctp:i18n('member.leave.collaboration.title')}"
            }, {
            	text: "${ctp:i18n('member.leave.culturalconstruction.title')}",
                value: "${ctp:i18n('member.leave.culturalconstruction.title')}"
            }, {
            	text: "${ctp:i18n('member.leave.knowledgemanagement.title')}",
                value: "${ctp:i18n('member.leave.knowledgemanagement.title')}"
            }, {
            	text: "${ctp:i18n('member.leave.role.title')}",
                value: "${ctp:i18n('member.leave.role.title')}"
            }, {
            	text: "${ctp:i18n('member.leave.space.title')}",
                value: "${ctp:i18n('member.leave.space.title')}"
            }, {
            	text: "${ctp:i18n('member.leave.meetmanagement.title')}",
                value: "${ctp:i18n('member.leave.meetmanagement.title')}"
            }, {
            	text: "${ctp:i18n('member.leave.report.title')}",
                value: "${ctp:i18n('member.leave.report.title')}"
            }]
        }, {
            id: 'type1',
            name: 'type1',
            type: 'select',
            text:  "${ctp:i18n('member.leave.type')}",
            value: 'type1',
            items: [ {
            	text: "${ctp:i18n('member.leave.form.title')}",
                value: "${ctp:i18n('member.leave.form.title')}"
            },{
            	text: "${ctp:i18n('member.leave.businessgenerator.title')}",
                value: "${ctp:i18n('member.leave.businessgenerator.title')}"
            },{
            	text: "${ctp:i18n('member.leave.project.title')}",
                value: "${ctp:i18n('member.leave.project.title')}"
            }]
        }, {
            id: 'type2',
            name: 'type2',
            type: 'select',
            text:  "${ctp:i18n('member.leave.type')}",
            value: 'type2',
            items: [{
            	text: "${ctp:i18n('member.leave.templateprocess.title')}",
                value: "${ctp:i18n('member.leave.templateprocess.title')}"
            }]
        }, {
            id: 'type3',
            name: 'type3',
            type: 'select',
            text:  "${ctp:i18n('member.leave.type')}",
            value: 'type3',
            items: [{
            	text: "${ctp:i18n('member.leave.office.title')}",
                value: "${ctp:i18n('member.leave.office.title')}"
            },{
                text: "${ctp:i18n('member.leave.identificationdog.title')}",
                value: "${ctp:i18n('member.leave.identificationdog.title')}"
            },{
            	text: "${ctp:i18n('member.leave.Electronicsignet.title')}",
                value: "${ctp:i18n('member.leave.Electronicsignet.title')}"
            }]
        },{
            id : 'content',
            name : 'content',
            type : 'input',
            text : "${ctp:i18n('member.leave.content')}",
            value : 'content'
        }, {
            id : 'title',
            name : 'title',
            type : 'input',
            text : "${ctp:i18n('member.leave.title')}",
            value : 'title'
        }]
    });
	//按照分类，显示搜索的类型
    initSearchType(o.category);
    
	
	//加载列表
	  grid = $("#tab0_div").ajaxgrid({
			resizable:false,
		    height: listHeight,
		    colModel: [{
		      display: 'id',
		      name: 'id',
		      width: '5%',
		      sortable: false,
		      align: 'center',
		      type: 'checkbox'
		    },
		    {
		      display: "${ctp:i18n('member.leave.account')}",
		      name: 'accountName',
		      sortable: true,
		      width: '30%'
		    },
		    {
		      display: "${ctp:i18n('member.leave.type')}",
		      name: 'type',
		      sortable: true,
		      width: '10%'
		    },
		    {
		      display: "${ctp:i18n('member.leave.content')}",
		      name: 'content',
		      sortable: true,
		      width: '25%'
		    },
		    {
		      display: "${ctp:i18n('member.leave.title')}",
		      name: 'title',
		      sortable: true,
		      width: '30%'
		    }],               
		    managerName: "memberLeaveManager",
		    managerMethod: "showLeaveInfo"
		  });
	$("#tab0_div").ajaxgridLoad(o);
  
 	    var toolBarVar = $("#toolbar").toolbar({
	        toolbar: [{
	          id: "import_export",
	          className: "ico16 import_16",
	            name: "${ctp:i18n('org.post_form.export.exel')}",
	            click: function() {
                    var downloadUrl_e = "/seeyon/organization/memberLeave.do?method=exportMemberLeaveList&memberId="+o.memberId+"&category="+o.category+"&condition="+encodeURI($.toJSON(o.condition))+"&value="+encodeURI($.toJSON(o.value));
                    var eurl_e = "<c:url value='" + downloadUrl_e + "' />";
                    exportIFrame.location.href = eurl_e;
	            }
	        }]
	      }); 
});

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
        beforeSubmit: function(){
        	if( window.parentDialogObj.showLeavePageDialog &&  window.parentDialogObj.showLeavePageDialog!=null &&　 window.parentDialogObj.showLeavePageDialog!=undefined){
	            window.parentDialogObj.showLeavePageDialog.disabledBtn('okButton');
	            window.parentDialogObj.showLeavePageDialog.disabledBtn('cancelButton');
        	}
        },
        debug : false
    });
    
    return true;
}

function changeDiv(divNum){
	o.category=divNum;
    o.condition = "";
    o.value = "";
    initSearchType(divNum);
    $("#tab0_div").ajaxgridLoad(o);
}

function initSearchType(divNum){
	searchobj.g.clearCondition();
	if(divNum==0){
		searchobj.g.showItem("type0")
		searchobj.g.hideItem("type1");
		searchobj.g.hideItem("type2");
		searchobj.g.hideItem("type3");
	}
	
	if(divNum==1){
		searchobj.g.hideItem("type0");
		searchobj.g.showItem("type1")
		searchobj.g.hideItem("type2");
		searchobj.g.hideItem("type3");
	}
	
	if(divNum==2){
		searchobj.g.hideItem("type0");
		searchobj.g.hideItem("type1");
		searchobj.g.showItem("type2")
		searchobj.g.hideItem("type3");
	}
	
	if(divNum==3){
		searchobj.g.hideItem("type0");
		searchobj.g.hideItem("type1");
		searchobj.g.hideItem("type2");
		searchobj.g.showItem("type3")
	}
}
</script>
<style>
    .stadic_head_height{
        height: 160px;
    }
    
   .stadic_head_middle{
        top: 0px;
        bottom:0px;
        background: #f0f0f0;
    }
    .stadic_body_top_bottom{
        top: 0px;
        bottom:20px;
        height:100%;
    }
    .stadic_footer_height{
        height:0px;
    }
    .stadic_right{
        float:right; 
        height:100%;
       /*  overflow: hidden; */
        background: #f0f0f0;
    }
    .stadic_left{
        width:400px; 
        float:left; 
        height:100%;
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
    <div class=" stadic_head_height">
        <fieldset class="margin_5">
            <legend>${ctp:i18n("member.leave.notdeal.affairtype")}</legend>
            <form id="form1" action="<c:url value='/organization/memberLeave.do' />?method=save4Leave">
            <input type="hidden" name="memberId" value="${param.memberId}" />
             <input type="hidden" name="noupdateState" value="${param.noupdateState}" />
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
                                <c:when test="${(empty p.agentMemberId) && ('member.leave.publicinfopending.title' eq p.label) && p.count == 0}">
                                	-
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
<!--     <div class=" stadic_head_middle" style="height:40px;">
        <div id="toolbar" class="stadic_left"></div>
        <div id="searchDiv" class="stadic_right" style="margin-top: 7px;height:30px;"></div>
    </div >-->
      
    <div id="tabs2" class="comp" comp="type:'tab',width:700,height:200">
    <div id="tabs2_head" class="common_tabs clearfix">
        <ul class="left">
            <li class="current"><a href="javascript:changeDiv(0)" tgt="tab0_div"><span>${ctp:i18n("member.leave.roleauthorization.title")}</span></a></li>
            <li><a href="javascript:changeDiv(1)" tgt="tab0_div"><span>${ctp:i18n("member.leave.business.title")}</span></a></li>
            <li><a href="javascript:changeDiv(2)" tgt="tab0_div"><span>${ctp:i18n("member.leave.processnode.title")}</span></a></li>
            <li><a href="javascript:changeDiv(3)" tgt="tab0_div"><span>${ctp:i18n("member.leave.other.title")}</span></a></li>
        </ul>
    </div>
    <div>
	    <div class=" stadic_head_middle" style="height:40px;">
	        <div id="toolbar" class="stadic_left"></div>
	        <div id="searchDiv" class="stadic_right" style="margin-top: 7px;height:30px;"></div>
	    </div>
	    <div id="tabs2_body" class="common_tabs_body ">
	        <table  class="flexme3 " id="tab0_div"></table>
<!-- 	        <div id="tab1_div" class="hidden"></div>
	        <div id="tab2_div" class="hidden"></div>
	        <div id="tab3_div" class="hidden"></div> -->
	    </div>
    </div>
	</div>
</div>
<iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>