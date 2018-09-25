/**
 * @author wangchw 2011-12
 * @description 离职交接办理相关js方法
 */

/**
 * 离职办理
 * @returns
 */
function leave(){
	var id = getSelectIds(parent.listFrame);
	var ids = id.split(",");
	if(ids.size()>2){
		alert(v3x.getMessage("organizationLang.orgainzation_select_one_once"));
		return false;
	}
	var names = [];
	for(var i = 0 ; i < ids.size()-1; i++ ){
		var requestCaller = new XMLHttpRequestCaller(this,"ajaxOrgManagerDirect","getMemberById",false);
		requestCaller.addParameter(1,"Long",ids[i]);
		var orglevel = requestCaller.serviceRequest();
		names[i] = orglevel.get("N");
	}
	names = names.join(v3x.getMessage("V3XLang.common_separator_label"));
	var theForm = parent.listFrame.document.getElementsByName("memberform")[0];
    if (!theForm) {
        return false;
    }
    var id_checkbox = parent.listFrame.document.getElementsByName("id");
    if (!id_checkbox) {
        return;
    }
    var hasMoreElement = false;
    var len = id_checkbox.length;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
            hasMoreElement = true;
            break;
        }
    }
    if (!hasMoreElement) {
        alert(v3x.getMessage("organizationLang.orgainzation_member_leave_onlyone"));
        return;
    }
	if(!confirm(v3x.getMessage("organizationLang.organization_member_leave",names))){
		return false;
	}
	//getA8Top().startProc('');
	//alert("离职办理!");
	//弹出离职办理详细对话框页面
	if(v3x.getBrowserFlag('OpenDivWindow')==true){
		doPcLeavePage(ids[0]);
	}else{
		//todo:ipad上的处理
		alert(v3x.getMessage("organizationLang.orgainzation_member_leave_notsupport_ipad"));
	}
}
/**
 * 
 * 弹出离职办理页面
 * @param id
 * @returns
 */
function doPcLeavePage(id){
	 //alert(id+":="+names);
	 var result = v3x.openWindow({
	        url: popeleLeaveURL+"?method=showLeaveManagementColPage&userid="+id,
	        height: 680,
	        width: 900,
	        resizable : "false"
	    });
	 if(result==null || result=="undefined" || result=="cancle" ){//取消离职办理
		 return false;
	 }else{//离职办理
		try {
   			getA8Top().startProc(getA8Top().v3x.getMessage("V3XLang.processing")); 
		}catch(e) {}
		submitLeaveDataForm(result,id);
		try {
			getA8Top().endProc();
			if(fun){
				eval(fun);
			}
		}catch(e) {}
		parent.detailFrame.location.href=organizationCancale;
		parent.listFrame.location.reload(true);
	 }
}
/**
 * 提交离职办理表单数据
 * @param result
 * @param agent_id
 * @returns
 */
function submitLeaveDataForm(result,agent_id){
	var theForm = document.getElementById("leaveDataFormID");
	if(theForm){
		theForm.innerHTML = "";
	}else{
		theForm = document.createElement("form");
		theForm.setAttribute('name','leaveDataFormID');
		theForm.setAttribute('action','leaveDataFormAction');
		theForm.id='leaveDataFormID';
		document.body.appendChild(theForm);
	}
	theForm.innerHTML = result;
	var ss = $('#leaveDataFormID').ajaxSubmit({
    	url : popeleLeaveURL+"?method=save4Leave&agent_to_id="+agent_id,
        type : 'POST',
        async : false,
        success : function(data) {
        	alert(v3x.getMessage("organizationLang.orgainzation_member_leave_success"));
        }
	});
}


/**
 * 离职办理弹出页面确定办理
 */
function doLeave(com_count,commonAgent,isExhange,edoc_count,edocAgent){
	var isSetUserForEdocObj= document.getElementById("leave4userId");
	var isSetUserForPubObj= document.getElementById("leave9userId");
	if(com_count>0 && commonAgent=="false"){//有待审核的公共发布信息，则必须指定一个人。
		if(!isSetUserForPubObj){
			alert(v3x.getMessage("organizationLang.orgainzation_member_leave_must_set_user_for_common"));
			return;
		}
	}
	if(isExhange=="true" && edoc_count>0 && edocAgent=="false"){//公文有待办，且该人员又是公文交换员，则必须指定一个人。
		if(!isSetUserForEdocObj){
			alert(v3x.getMessage("organizationLang.orgainzation_member_leave_must_set_user_for_edoc"));
			return;
		}
	}
	var selectResult="";
	for(var i=1;i<=10;i++){
		var id_str="leave"+i+"_pepole_inputs";
		if(document.getElementById(id_str) && document.getElementById(id_str)!= null){
			var divLeave= document.getElementById(id_str).innerHTML;
			//alert("divLeave["+i+"]:="+divLeave);
			selectResult += divLeave;
		}
	}
	v3x.setResultValue(selectResult);
	window.returnValue = selectResult;
	window.close();
}

/**
 * 离职办理弹出页面取消办理
 */
function doCloseWindow(){
	window.returnValue = "cancle";
	window.close();
}

/**
 * 离职办理弹出页面离职工作移交
 * @param tag
 * @param obj
 */
function showLeaveDetail(tag,obj){
	//alert("id:="+obj.id+";isSelect:="+obj.isSelect);
	obj.setAttribute("isSelect","true");
	if(tag=="turnover"){//移交给
		doWorkFlow("new");
		//alert("ok");
		obj.setAttribute("isSelect","false");
	}else if(tag=="ignore"){//忽略
		//alert("忽略!");
	}
}
//是否进行职务级别范围验证
var isNeedCheckLevelScope_wf = true ;
//是否回显原有被选数据
var showOriginalElement_wf = false;
//是否只一直显示登录简称
var showAccountShortname_wf = "yes";
//不允许选择空的组、部门
var unallowedSelectEmptyGroup_wf = true;
//是否隐藏集团单位
var hiddenRootAccount_wf = true;
//是否隐藏"多层"按钮
var hiddenMultipleRadio_wf = true;
//是否隐藏"另存为组"
var hiddenSaveAsTeam_wf= true;
//是否隐藏组下的外单人员
var hiddenOtherMemberOfTeam_wf= true;

/**
 * 离职办理弹出页面选人控件回调函数
 * @param elements
 * @returns {Boolean}
 */
function setPeopleFieldsOfLeave(elements){
	if (!elements) {
        return false;
    }
	//alert("选择了具体人员!");
	var leaveas= document.getElementsByName("leave_a");
	var selectAId="";
	for(var i=0;i<leaveas.length;i++){
		if(leaveas[i].getAttribute("isSelect")== "true"){//选中的
			//alert("选中的Id:="+leaveas[i].id);
			if(leaveas[i].id!=""){
				selectAId= leaveas[i].id;
			}
		}
	}
	if(selectAId!=""){
		var str = "";
		var person = elements[0] || [];
		str += '<input type="hidden" name="'+selectAId+'userType" value="' + person.type + '" />';
        str += '<input type="hidden" name="'+selectAId+'userId" value="' + person.id + '" />';
        str += '<input type="hidden" name="'+selectAId+'userName" value="' + escapeStringToHTML(person.name) + '" />';
        str += '<input type="hidden" name="'+selectAId+'accountId" value="' + person.accountId + '" />';
        str += '<input type="hidden" name="'+selectAId+'accountShortname" value="' + escapeStringToHTML(person.accountShortname) + '" />';
		var targetObject= document.getElementById(selectAId);
		document.getElementById(selectAId+"_pepole").innerHTML="<input type=\"text\" value=\""+person.name+"\" size=\"15\" disabled=\"true\">"
		+"<a title=\""+v3x.getMessage("organizationLang.orgainzation_member_leave_select_change_tip")+"\" href=\"#\""
		+" onclick=\"showLeaveHref('"+selectAId+"','"+targetObject.name+"')\" >&nbsp;&nbsp;×&nbsp;&nbsp;</a>";
		document.getElementById(selectAId+"_parent").innerHTML= v3x.getMessage("organizationLang.orgainzation_member_leave_transferto_tip");
		document.getElementById(selectAId+"_pepole_inputs").innerHTML= str;
	}
}

/**
 * 离职办理弹出页面显示“移交给”的按钮，清楚选择的交接人员
 * @param selectAId
 * @param tagName
 */
function showLeaveHref(selectAId,tagName){
	document.getElementById(selectAId+"_pepole").innerHTML= "";
	document.getElementById(selectAId+"_pepole_inputs").innerHTML= "";
	document.getElementById(selectAId+"_parent").innerHTML="<a name=\""
	+tagName+"\" href=\"#\" onclick=\"showLeaveDetail('turnover',this)\" "
	+" id=\""+selectAId+"\" userid=\"\" username=\"\" isSelect=\"false\">["+v3x.getMessage("organizationLang.orgainzation_member_leave_transferto")+"]</a>";
}

/**
 * 离职办理弹出页面显示详细列表
 * @param type 待办类型
 */
function listPendingDetail(type,leaved_userid){
	if(v3x.getBrowserFlag('OpenDivWindow')==true){
		var atts = v3x.openWindow({
	        url: popeleLeaveURL+"?method=showList4LeaveFrame&leaved_userid="+leaved_userid+"&type="+type,
	        height: 800,
	        width: 900,
	        resizable : "false"
	    });
	}else{//暂不支持ipad
		alert(v3x.getMessage("organizationLang.orgainzation_member_leave_notsupport_ipad"));
	}
}