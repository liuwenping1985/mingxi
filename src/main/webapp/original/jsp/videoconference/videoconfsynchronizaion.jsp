<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.isnc.resources.i18n.videoconference"/>

<fmt:setBundle basename="com.seeyon.apps.videoconference.resource.i18n.VideoConferenceResources" var="v3xVideoconf"/> 
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!--
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/css/css.css${ctp:resSuffix()}" />" />
 -->
<script type="text/javascript" src="/seeyon/apps_res/videoconference/js/videoconference.js"></script>
<script type="text/javascript">
function updateCurrentLocation(menus) {
    var icon = getCtpTop().currentSpaceType || "personal";
    var skinPathKey = getCtpTop().skinPathKey || "defaultV51";
    var html = "<span class='nowLocation_ico'><img src='" + _ctxPath + "/main/skin/frame/" + skinPathKey + "/menuIcon/" + icon + ".png'/></span>";
    html += "<span class='nowLocation_content'>";
    var items = [];
    for (var i = 0; i < menus.length; i++) {
        if (menus[i].url) {
            items.push("<a class='hand' onclick=\"showMenu('" + _ctxPath + menus[i].url + "')\">" + menus[i].name + "</a>");
        } else {
            items.push('<a>' + escapeStringToHTML(menus[i].name, false) + '</a>');
        }
    }
    html += items.join(' > ');
    html += '</span>';
    try{getA8Top().showLocation(html);}catch(e){}
}
var menus=[{name:"<fmt:message key='videoconference.org'/>"},
		 {name:"<fmt:message key='videoconference.synchronization'/>", url:"/videoConference.do?method=synchronOrg"}
];
     
updateCurrentLocation(menus); 	
var membersJsonStr = '<%=request.getAttribute("members")%>';
var membersJson = eval("(" + membersJsonStr + ")");

$(document).ready(function(){
	   new MxtLayout({
		'id': 'layout',
		'northArea': {
			'id': 'north',
			'height': 40,
			'sprit': false,
			'border': false
		},
		'centerArea': {
			'id': 'center',
			'border': false,
			'minHeight': 20
		}
	});  
	$("#q").focus(function(){
		var v = $("#q").attr("value");
		if("请输入人员名称" == v){
			$("#q").attr("value","");
		}
	});
	$("#toolbars").toolbar({
		toolbar: [
			{
				id: "start",
				name: "${ctp:i18n('videoconference.synchron.start')}",
				className: "ico16 modify_text_16",
				click: function () {
				//	alert("${ctp:i18n('videoconference.synchron.start')}");
				//	alert("videoconference.synchron.start");
					var msg =  "${ctp:i18n('videoconference.synchron.selectUser')}";
					asynchronism(msg);
				}
			}
		]

    });	
	
	$('#q').bind('keydown',function(event){
	    if(event.keyCode == "13") {
	    	searchDeptPeople();
	    }
	});
	
	//初始化同步人员列表
    initSelectPeople();
		

	//初始化树
	initUnitTree();
	//initSelectUnitTree(zNodes);
});
</script>
 
</head>

<body class="font_size12 h100b  page_color">

<div id='layout'>
    <div class="layout_north bg_color" id="north">
        <div id="toolbars"></div>
    </div>
    <div class="layout_center over_hidden" id="center"  style="overflow:auto">
       <div id="searchUnitTreeDiv" style="display:none; position:absolute;background: #ffffff; width:301px; height:430px;;z-index: 10" class="border_all">
    <div style="margin-top:0px; width:301px; height: 430px; display: block; overflow: auto">
        <div id="searchUnitTree" class="ztree"></div>
    </div>
</div>
<iframe id="searchUnitTreeIframe" height="430px" width="301" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display:none; position:absolute;background: #ffffff; width:301px; height:430px;z-index: 9"></iframe>    
<table id="selectPeopleTable" width="60%" height="70%" border="0" class="bg-body1" align="center" cellpadding="0" cellspacing="0">
    <tbody><tr valign="top">
        <td>
        <table width="100%" border="0" height="100%" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <td class="padding_l_15 padding_r_15 padding_t_10">
                    <table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
                        <tbody><tr>
                            <td valign="top">
                      	<div class="page_header clearfix"  style="width:368px;padding-left:0px;padding-right:0px"> 
						    <span class="page_header_title">同步选择</span> 
						</div>
                        <div style="border:1px solid #D8DBDD; width:368px; background:#fff;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tbody>
                                    
                                     
                                    <tr onselectstart="return false" valign="top">
                                        <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tbody>
                                    <tr>
                                        <td id="select_input_div_parent" height="46" bgcolor="#F6F9F9">
											<ul class="common_search" id="common_search_ul" style="width: 290px;">
                                                <li id="inputBorder" class="common_search_input">
												<input   style="width: 150px;" id="q" class="search_input color_gray" type="text" value="请输入人员名称"></li>
                                                <li>
												<a class="common_button search_buttonHand" 
												onclick="searchDeptPeople()">
												<em></em>
												</a>
												</li>
                                            </ul> 
                                           
                                        
                                        </td>
                                        <td height="46" bgcolor="#F6F9F9" align="right">
                                            <div id="select_input_div" class="border_all margin_l_5 padding_l_5 padding_r_5 bg_color_white" onclick="showMenu(); return false;" style="width: 45px;display:none;">
                                                <input name="currentAccountId" id="currentAccountId" type="text" class="select_input_width arrow_6_b hand" style="height: 24px; border: 0px; width: 143px;" readonly="readonly" value="" title="单位1">
                                            </div>
                                        </td>
									 
                                    </tr>
                                    <tr>
                                        <td id="Area1" style="border: none; height: 168px;" colspan="3" class="iframe">
										<div id="List1" style="width: 363px; height: 168px; overflow: auto; padding: 0px 0px 0px 5px;">
										 
												<div id="unit_tree" class="ztree"></div>
										</div>
										</td>
                                    </tr>
                                	</tbody>
                                </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="Separator1" valign="middle" style="text-align: left; height: 30px;">
                                            <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tbody>
												<tr>
                                                    <td id="" align="center" class="border_t w100b margin_0 padding_0" style="font-size:2px; background:#F6F9F9;">
                                        <div id="Separator1_0" style="height:8px;font-size:2px;text-align: center;">
                                           <span style="width:30px; height:8px; display:block; background:#D1D4DB; border-radius:0 0 3px 3px; display: inline-block;">
												<span class="ico16 arrow_1_t margin_0 padding_0" style="width:25px; height: 8px;background-position:0px -504px;vertical-align: top;" onclick="hiddenArea1()">
											 
												</span>
										   
										   </span>
                                        </div>
                                                    </td>
                                                </tr>
												 <tr>
                                                    <td id="Separator1_1" class="padding_l_5" bgColor="#f6f9f9" height="24">
                                                       
                                                    </td>
                                                </tr>
                                            </tbody>
											</table>
                                        </td>
                                    </tr>
                                    <tr onselectstart="return false">
                                        <td valign="top">
                                        <div id="Separator1_2" class="border_b" style="height:8px;font-size:2px;text-align: center; background:#F6F9F9;">
                                           <span style="width:30px; height:8px; display:block; background:#D1D4DB; border-radius:3px 3px 0 0; display: inline-block;"><span class="ico16 arrow_1_b margin_0 padding_0" style="width:25px; height: 8px;background-position:-24px -504px;vertical-align: top;" onclick="hiddenArea2()"></span></span>
                                        </div>
                                        <div id="Area2" class="padding_l_5">
                                        <select id="memberDataBody" ondblclick="selectOneMemberDiv(this)"  multiple="multiple" style="border: none; padding-top: 1px; overflow: auto; width: 100%; height: 190px;">
                                        
										</select>
										</div>
                                        </td>
                                    </tr>
                                </tbody></table>
                        </div>
                            </td>
                            
                            <td width="50" align="center">
                                <p>
                                    <span class="select_selected" title="选择" onclick="selectOne()"></span>
                                </p>
                                <br>
                                <p>
                                    <span class="select_unselect" title="删除" onclick="removeOne()"></span>
                                </p>
                            </td>
                            
                            <td style="height:406px;" valign="top">
                         <div class="page_header clearfix"  style="width:328px;padding-left:0px;padding-right:0px">
						  
						    <span class="page_header_title">同步人员</span> 
						</div>      
                            <div style="border:1px solid #D8DBDD; width:328px;">
							 
                                 <select id="List3" onclick="" ondblclick="removeOne(this.value, this)" multiple="multiple" style="padding-top: 1px;height:446px;width:328px;overflow:auto; border:none;" size="28">
                                 </select>
                            </div>

                            </td>
                           <!--  <td width="40" align="center">
                                <p>
                                    <span class="sort_up" title="上移" onclick="exchangeList3Item('up')"></span>
                                </p>
                                <br>
                                <p>
                                    <span class="sort_down" title="下移" onclick="exchangeList3Item('down')"></span>
                                </p>
                            </td> -->
                        </tr>
                    </tbody></table>
                </td>
            </tr>
        </tbody></table>
        </td>
    </tr>
    
</tbody>
</table>
</div>
	   
	   
</div>





 
 
</body>
</html>