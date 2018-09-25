/**
 * 刷新页面
 */

try {
	getA8Top().endProc();
} catch(e) {
}

function refreshIt() {
    location.reload();
}

/**
 * 页面回退
 */
function locationBack() {
    history.back(-3);
}

/**
 * 取得列表中选中的id
 */
	function getSelectId(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=idCheckBox.value;
				break;
			}
		}
		return id;
	}
	
/**
 * 取得列表中所有选中的id
 */	
	function getSelectIds(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.value+',';
			}
		}
		return id;
	}
	
	//单击列表中的某一行,显示该行的详细信息
	function showDetail(id,type,tframe){
		tframe.location.href = organizationURL+"?method=edit"+type+"&id="+id+"&isDetail=readOnly";
	}
	
	//检查两次输入的密码是否一致
	function checkPassword(){
		var pass = parent.detailFrame.document.getElementById("member.password").value;
		var pass1 = parent.detailFrame.document.getElementById("member.password1").value;
		if(pass != pass1){
			alert(v3x.getMessage("organizationLang.organization_member_password"));
			return false;
		}else{
			if(pass.length <6 || pass.length >50){
				alert(v3x.getMessage("organizationLang.orgainzation_member_password_limited"));
				return false;
			}		
			return true;
		}
	}
	
	//点击部门树的单位节点,显示单位信息页面
	function showAccount(accountid){
		if(arguments[1]!=null && arguments[1]=='member'){
			parent.listFrame.location.href = organizationURL+"?method=showMemberList&accountId="+accountid;
		}else{
			parent.listAndDetailFrame.location.href = organizationURL+"?method=departManageInitPage";
		}
	}
	
	//点击部门树的部门节点,显示部门信息页面
	function showDepartment(deptid){
		if(arguments[1]!=null && arguments[1]=='member'){
			parent.listFrame.location.href = organizationURL+"?method=showMemberList&dept=dept&id="+deptid+"&accountId="+arguments[2]+"&deptAdmin="+arguments[3];
		}else{
			parent.listAndDetailFrame.location.href = organizationURL+"?method=editDept&id="+deptid+"&from=dept&isDetail=readOnly";
		}
	}
	// 双击部门管理的树型结构
	function showDbDepartment(deptid){
		if(arguments[1]!=null && arguments[1]=='member'){
			parent.listFrame.location.href = organizationURL+"?method=showMemberList&dept=dept&id="+deptid+"&accountId="+arguments[2]+"&deptAdmin="+arguments[3];
		}else{
			parent.listAndDetailFrame.location.href = organizationURL+"?method=editDept&id="+deptid+"&from=dept";
		}
		//parent.listAndDetailFrame.listFrame.location.href = organizationURL+"?method=listDept&pId="+deptid+"&from=dept";
	}
	
	//新增,修改职务级别后刷新页面
	function addLevel(){
		var form = document.getElementById("levelForm");
		form.action=organizationURL+"?method=createLevel";
		//form.target="listFrame";
		form.submit();
	}
	
	function modifyLevel(){
		var form = document.getElementById("levelForm");
		form.action=organizationURL+"?method=updateLevel";
		//form.target="listFrame";
		form.submit();
	}
	
	//新增,修改岗位后刷新页面
	function addPost(){
		var form = document.getElementById("postForm");
		form.action=organizationURL+"?method=createPost";
		form.target="listFrame";
		form.submit();
		
	}
	
	function modifyPost(){
		var form = document.getElementById("postForm");
		form.action=organizationURL+"?method=updatePost";
		form.target="listFrame";
		form.submit();	
	}
	
	function setDept(elements) {
		if (!elements) {
	    	return;
		}
    	document.getElementById("deptName").value = getNamesString(elements);
    	document.getElementById("orgDepartmentId").value = getIdsString(elements,false);
	}
	
	function setPost(elements) {
    	if (!elements) {
        	return;
    	}
    	document.getElementById("postName").value = getNamesString(elements);
    	document.getElementById("orgPostId").value = getIdsString(elements,false);
    	//alert(document.getElementById("orgPostId").value);
	}
	
	function setLevel(elements) {
    	if (!elements) {
        	return;
    	}
    	document.getElementById("levelName").value = getNamesString(elements);
    	document.getElementById("orgLevelId").value = getIdsString(elements,false);
    	//alert(document.getElementById("orgLevelId").value);
	}
	
	function setDept1(elements) {
    	if (!elements) {
        	return;
    	}
    	document.getElementById("deptName1").value = getNamesString(elements);
    	document.getElementById("deptId1").value = getIdsString(elements,false);
    	//alert(document.getElementById("deptId1").value);
	}
	
	function setSecondPosts(elements) {
	    showOriginalElement_assistantPosts = true;
    	if (!elements) {
        	return;
    	}
    	document.getElementById("secondPosts").value = getNamesString(elements);
    	document.getElementById("secondPostIds").value = getIdsString(elements,false);
    	//alert(document.getElementById("postId1").value);
	}
	
	function setTeamDept(elements) {
    	if (!elements) {
        	return;
    	}
    	document.getElementById("deptName").value = getNamesString(elements);
    	document.getElementById("depId").value = getIdsString(elements,false);
	}
	
	
	function addTeam(){
		var form = document.getElementById("teamForm");
		form.action=organizationURL+"?method=createTeam";
		form.target="listFrame";
		form.submit();
	}
	
	function modifyTeam(){
		var form = document.getElementById("teamForm");
		form.action=organizationURL+"?method=updateTeam";
		form.target="listFrame";
		form.submit();
	}
	
	//显示上级部门
	var isSelectSuperDept = false;
	function setSuperDept(elements) {
    	if (!elements) {
        	return;
    	}
    	document.getElementById("superDepartment").value = getNamesString(elements);
    	document.getElementById("parentId").value = getIdsString(elements,false);
    	isSelectSuperDept = true;
	}
	
	//显示部门管理员
	function setDeptAdmin(elements){
		if (!elements) {
        	return;
    	}
    	document.getElementById("deptAdmin").value = getNamesString(elements);	
    	document.getElementById("adminId").value = getIdsString(elements,false);	
	}
	
	//显示部门主管
	function setDeptLeader(elements){
		if (!elements) {
        	return;
    	}
    	document.getElementById("deptLeader").value = getNamesString(elements);	
    	document.getElementById("leaderId").value = getIdsString(elements,false);	
    	//alert(document.getElementById("leaderId").value);
	}
	
	//显示部门岗位
	function setDeptPosts(elements){
		if (!elements) {
        	return;
    	}
    	document.getElementById("deptPosts").value = getNamesString(elements);	
    	document.getElementById("postIds").value = getIdsString(elements,false);	
    	//alert(document.getElementById("leaderId").value);
		
	}
	
	
/*
 *  验证原密码和新密码是否相等的
 */
function validaccount(){
	var oldword = document.getElementById("adminOldPass").value;
	var newword = document.getElementById("adminPass").value;
	var validateword = document.getElementById("adminPass1").value;
	var checkValue = document.getElementById("checkManager").checked;
	var id = document.getElementById("id").value;
	if ( oldword != "" && checkValue==true ){
		if (newword!=validateword){
			alert(v3x.getMessage("organizationLang.organization_account_notsame"));
			return false;
		}else{
			return true;
		}
	}else if( oldword=="" && checkValue==true ){
		alert(v3x.getMessage("organizationLang.organization_account_oldpassword"));
		return false;
	}else if (oldword=="" && checkValue==false){
		return true;
	}
}

//添加角色人员
function setRoleMembers(elements, flag){
	var elementsIds = getIdsString(elements,false);
	var memberNames = getNamesString(elements);
	var o = eval('document.all.' + flag);
	o.value = memberNames;
	var oId = eval('document.all.' + flag + 'id');
	oId.value=flag+"|"+elementsIds;
}
/*
 *   验证新建各个部门是否有重名问题
 */
function validateRepoint(entityClassName,property,value,names){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "isPropertyDuplicated", false);
	requestCaller.addParameter(1, "String", entityClassName);
	requestCaller.addParameter(2, "String", property);
	requestCaller.addParameter(3, "String", value);
	var org = requestCaller.serviceRequest();
	if (org=="true") {
		alert(names + v3x.getMessage("organizationLang.organization_double_name_2"));
		return false ;
	} else {
		return true;
	}
}
function validateRepointEnt(entityClassName,property,value,names,entId){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "isPropertyDuplicated", false);
	requestCaller.addParameter(1, "String", entityClassName);
	requestCaller.addParameter(2, "String", property);
	requestCaller.addParameter(3, "String", value);
	requestCaller.addParameter(4, "Long", entId);
	var org = requestCaller.serviceRequest();
	if (org=="true") {
		alert(names + v3x.getMessage("organizationLang.organization_double_name_2"));
		return false ;
	} else {
		return true;
	}
}
/*
 * 提示选择部门
 */
 function clueDept(){    
	var names = document.getElementById("name").value;
	var superDepartment = document.getElementById("superDepartment").value;
	var parentId = document.getElementById("parentId").value;
	if( names == superDepartment ){
		alert(v3x.getMessage("organizationLang.organization_department_same_name"));
		return false;
	}else if(!isSelectSuperDept&&parentId==''){	  	  
	      alert(v3x.getMessage("organizationLang.organization_department_parent_null"));  	    
	      return false;	
	}else{
	    return true;
	}
 }
/*
 * 取消功能方法/
 */
 function cancelForm(form,orgTe){
 	document.getElementById(form).action= organizationURL+"?method=organizationFrame&from="+orgTe;
	document.getElementById(form).submit();
 }
 /*
  *  静态返回页面
  */
function cancelForms(form){
 	document.getElementById(form).action= organizationCancale;
	document.getElementById(form).submit();
 }
 function importReport(){
			v3x.openWindow({
				url		: organizationURL+'?method=importReport',
				width	: 400,
				height	: 300,
				resizable	: "yes"
			});
}

function memberSelectDepartment(){
	try{
		selectPeopleFun_dept();
	}catch(e){alert(e.message)}
}
function memberSelectBanchDepartment(){
	try{
		selectPeopleFun_dept();
	}catch(e){alert(e.message)}
}

function changeDepartIntenal(flag){
	var _display = (flag == '0' || flag == 'false') ? "none" : ""; //外部
	
	document.getElementById("manager_fieldset").style.display = _display;
	document.getElementById("post_fieldset").style.display = _display;
	document.getElementById("isCreateDeptSpaceTr").style.display = _display;
}


/*
 *  组连续添加方法
 */
function doEndTeam(accountId){	
	
	var _cont = document.getElementById("cont");

	if(_cont && _cont.checked){ //连续添加
	    document.getElementById("id").value = "";
	    
		document.getElementById("name").value = "";
		document.getElementById("name").deaultValue = "";
		
		document.getElementById("teamCharge").value = getDefaultValue(document.getElementById("teamCharge"));	
		document.getElementById("teamChargeIDs").value = "";	
		
		document.getElementById("teamMems").value = getDefaultValue(document.getElementById("teamMems"));
		document.getElementById("teamMemIDs").value = "";	
		
		document.getElementById("teamLead").value = getDefaultValue(document.getElementById("teamLead"));
		document.getElementById("teamLeadIDs").value = "";	
		
		document.getElementById("teamRela").value = getDefaultValue(document.getElementById("teamRela"));
		document.getElementById("teamRelaIDs").value = "";	
       if("${v3x:currentUser().groupAdmin}"=='false'){
		document.getElementById("deptName").value = "";
		document.getElementById("depId").value = "";
		}
		document.getElementById("description").value = "";
		
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "getMaxSortNum", false);
	    requestCaller.addParameter(1, "String", "V3xOrgTeam");
	    requestCaller.addParameter(2, "Long", accountId);
	    var maxNum = requestCaller.serviceRequest();	
	    document.getElementById("sortId").value = parseInt(maxNum)+1;	
	    	
		elements_dept = null ;
		elements_mem = null ;
		elements_rela = null ;
		elements_lead = null ;
		elements_charge = null ;
		exMems = new Array();
	    excludeElements_mem = exMems;
	    excludeElements_charge = exMems;
	    excludeElements_lead = exMems;
	    excludeElements_rela = exMems;
		document.getElementById("name").focus();
		
		disabledTeamButton(false);
		parent.detailFrame.showOrgDetail = false;
	}
	else{
		alert(_("organizationLang.option_organization_ok"));
		Form.disable("teamForm"); 
		parent.detailFrame.showOrgDetail = true;
	}	
	parent.listFrame.location.reload(true);
}

function disabledTeamButton(flag){
	document.getElementById("submintButton").disabled = flag;
	document.getElementById("submintCancel").disabled = flag;
}

/*
 * 部门管理的连续添加方法
 */
function doEndDept(accountId, act, id, parentId, text, sort){
	/*
	if(parent.listFrame){
		parent.listFrame.location.reload(true); 
	}
	if(parent.treeFrame){
		if(act == 'add'){
			var newParent = parent.treeFrame.webFXTreeHandler.all[parent.treeFrame.webFXTreeHandler.getIdByBusinessId(parentId)];
			if(newParent){
				newParent.addWebFXTreeItem(id, text, sort, "javascript:showDepartment('" + id + "')", "javascript:showDbDepartment('" + id + "')");
				try {
					getA8Top().endProc();
				} catch(e) {
				}
			}
			else{
				parent.treeFrame.location.reload(true);
			}
		}
		else{
			parent.treeFrame.location.reload(true);
		}
	}
	*/
	if(parent.listFrame){
		parent.listFrame.location.reload(true); 
	}
	if(parent.treeFrame){
		//parent.treeFrame.location.reload(true);
		try{
			parent.treeFrame.location.href = organizationURL+"?method=showtree&currentId="+id+"&currentParentId="+parentId;
		}catch(e){
			parent.treeFrame.location.reload(true);
		}
	}
		
	try {
		getA8Top().endProc();
	} catch(e) {
	}
	
	var _cont = document.getElementById("cont");
	if(_cont && _cont.checked){ //连续添加
		document.getElementById("name").value = "";
		document.getElementById("name").deaultValue = "";
		document.getElementById("code").value = "";
		//document.getElementById("postIds").value = "";
		document.getElementById("dept.description").value = "";
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "getMaxSortNum", false);
	    requestCaller.addParameter(1, "String", "V3xOrgDepartment");
	    requestCaller.addParameter(2, "Long", accountId);
	    var maxNum = requestCaller.serviceRequest();	
	    document.getElementById("sortId").value = parseInt(maxNum)+1;
	    //政务新增部门简称
	    if(document.getElementById("deptShortName")!=null){
	      document.getElementById("deptShortName").value = "";
	    }
		
		document.getElementById("name").focus();
		disabledDeptButton(false);
		if(parent.listFrame)
		    parent.detailFrame.showOrgDetail = false;
	}else{
		alert(_("organizationLang.option_organization_ok"));
		Form.disable("addForm");
	    if(parent.listFrame){
	        parent.location.reload(true);
	        parent.detailFrame.showOrgDetail = true;
	    }	        
	    if(parent.treeFrame)
	        parent.listAndDetailFrame.location.href = organizationURL+"?method=departManageInitPage";
	        
	    
    }
}


function doEndExternalDept(accountId, act, id, parentId, text, sort){

	try {
		getA8Top().endProc();
	} catch(e) {}
	
	var _cont = document.getElementById("cont");
	if(_cont && _cont.checked){ //连续添加
		document.getElementById("name").value = "";
		document.getElementById("name").deaultValue = "";
		document.getElementById("code").value = "";
		document.getElementById("dept.description").value = "";
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "getMaxExternalDeptSortNum", false);
	    requestCaller.addParameter(1, "Long", accountId);
	    var maxNum = requestCaller.serviceRequest();	
	    document.getElementById("sortId").value = parseInt(maxNum)+1;		
		document.getElementById("name").focus();
		disabledDeptButton(false);
		parent.detailFrame.showOrgDetail = false;
	}else{
		alert(_("organizationLang.option_organization_ok"));
		Form.disable("addForm");
		parent.detailFrame.showOrgDetail = true;
   }   
   parent.listFrame.location.reload(true); 
}


function disabledDeptButton(flag){
	document.getElementById("submintButton").disabled = flag;
	document.getElementById("submintCancel").disabled = flag;
}

/*
 *  人员管理的连续添加方法
 */
 function doEndMember(accountId){
	
	var _cont = document.getElementById("cont");
 	
 	if(_cont && _cont.checked){ //连续添加
		document.getElementById("name").value = "";
		document.getElementById("name").deaultValue = "";
		document.getElementById("member.loginName").value = "";
		document.getElementById("member.password").value = "123456";
		document.getElementById("member.password1").value = "123456";
//		document.getElementById("member.password").value = "";
//		document.getElementById("member.password1").value = "";
		document.getElementById("telNumber").value = "";
		document.getElementById("officeNum").value = "";
		document.getElementById("emailAddress").value = "";
		document.getElementById("member.code").value = "";
		document.getElementById("memberDescription").value = "";
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "getMaxExternalMemberSortNum", false);
	    requestCaller.addParameter(1, "Long", accountId);
	    var maxNum = requestCaller.serviceRequest();	
	    document.getElementById("sortId").value = parseInt(maxNum)+1;
		
		document.getElementById("name").focus();
		disabledMemberButton(false);	
		parent.detailFrame.showOrgDetail = false;	
 	}else{
		alert(_("organizationLang.option_organization_ok"));
		Form.disable("memberForm");
		parent.detailFrame.showOrgDetail = true;
	}	
	parent.listFrame.location.href=parent.listFrame.location;
 }
 
 /*
 *  人员管理的连续添加方法,根据不同来源
 */
 function doEndMemberFrom(accountId,from,id){
	
	var _cont = document.getElementById("cont");
 	
 	if(_cont && _cont.checked){ //连续添加
 		document.getElementById("id").value = id;
 		document.getElementById("thePicture").innerHTML = "<img src='/seeyon/apps_res/hr/images/photo.JPG' width='100' height='120'>";
 		document.getElementById("fileId").value = "";
 		document.getElementById("createDate").value = "";
		document.getElementById("name").value = "";
		document.getElementById("name").deaultValue = "";
		document.getElementById("member.loginName").value = "";
		document.getElementById("member.password").value = "123456";
		document.getElementById("member.password1").value = "123456";
//		document.getElementById("member.password").value = "";
//		document.getElementById("member.password1").value = "";
		document.getElementById("telNumber").value = "";
		document.getElementById("officeNum").value = "";
		document.getElementById("emailAddress").value = "";
		document.getElementById("member.code").value = "";
		document.getElementById("secondPosts").value = "";
		document.getElementById("secondPostIds").value = "";
		showOriginalElement_assistantPosts = false;
		document.getElementById("gender").value = "";
		document.getElementById("birthday").value = "";
		document.getElementById("memberDescription").value = "";
		//政务版新增四个字段-身份证号、政治面貌、最高学历、最高学位
		if(document.getElementById("ID_card")!=null){
			document.getElementById("ID_card").value = "";
		}
		if(document.getElementById("edu_level")!=null){
			document.getElementById("edu_level").value = "";
		}
		if(document.getElementById("degreeLevel")!=null){
			document.getElementById("degreeLevel").value = "";
		}
		if(document.getElementById("political_position")!=null){
			document.getElementById("political_position").value = "";
		}
		
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "getMaxMemberSortNum", false);
	    requestCaller.addParameter(1, "Long", accountId);
	    var maxNum = requestCaller.serviceRequest();	
	    document.getElementById("sortId").value = parseInt(maxNum)+1;
		
		document.getElementById("name").focus();
		disabledMemberButton(false);	
		parent.detailFrame.showOrgDetail = false;	
 	}else{
		alert(_("organizationLang.option_organization_ok"));
		Form.disable("memberForm");
		parent.detailFrame.showOrgDetail = true;
	}	
 	/*
 	if(from == 'addMember'){
		var deptAdmin = "";
	    if(document.getElementById("deptAdmin")){
	        deptAdmin = document.getElementById("deptAdmin").value;
	    }	
	    var deptFlag = deptAdmin == "1" ? "4Dept" : "";
	    parent.listFrame.location.href = organizationURL+"?method=listMember" + deptFlag + "&deptAdmin="+deptAdmin;
	}else{
	*/
	    parent.listFrame.location.reload(true);
	//}	
 }
 
function disabledMemberButton(flag){
	document.getElementById("submintButton").disabled = flag;
	document.getElementById("submintCancel").disabled = flag;
}
/*
 * 岗位管理的连续添加方法
 */
function doEndPost(accountId){	
	var _cont = document.getElementById("cont");
	
 	if(_cont && _cont.checked){ //连续添加
		document.getElementById("name").value = "";
		document.getElementById("name").deaultValue = "";
		document.getElementById("post.code").value = "";
		document.getElementById("post.sortId").value = "";
		document.getElementById("description").value = "";
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "getMaxSortNum", false);
	    requestCaller.addParameter(1, "String", "V3xOrgPost");
	    requestCaller.addParameter(2, "Long", accountId);
	    var maxNum = requestCaller.serviceRequest();	
	    document.getElementById("sortId").value = parseInt(maxNum)+1;
		document.getElementById("name").focus();
		desabledPostButton(false);
		parent.detailFrame.showOrgDetail = false;
 	}else{
		Form.disable("postForm");
		parent.detailFrame.showOrgDetail = true;
	}
	parent.listFrame.location.reload(true);
}
function desabledPostButton(flag){
	document.getElementById("submintButton").disabled = flag;
	document.getElementById("submintCancel").disabled = flag;
}
/*
 * 职务级别管理的连续添加方法
 */
function doEndLevel(){	
	var _cont = document.getElementById("cont");	
 	if(_cont && _cont.checked){ //连续添加
 	    document.getElementById("name").value = "";
		document.getElementById("name").deaultValue = "";
		document.getElementById("level.code").value = "";
		document.getElementById("level.levelId").value = "";
		document.getElementById("description").value = "";
		document.getElementById("name").focus();
 	    desabledPostButton(false);
 	    parent.detailFrame.showOrgDetail = false;
 	}else{
		Form.disable("levelForm");
		parent.detailFrame.showOrgDetail = true;
	}
	parent.listFrame.location.reload(true);
}

/*
 * 政务版——职级的连续添加方法
 */
function doEndDutyLevel(){	
	var _cont = document.getElementById("cont");	
 	if(_cont && _cont.checked){ //连续添加
 	    document.getElementById("name").value = "";
		document.getElementById("name").deaultValue = "";
		document.getElementById("level.code").value = "";
		document.getElementById("level.levelId").value = "";
		document.getElementById("description").value = "";
		document.getElementById("name").focus();
 	    desabledPostButton(false);
 	    parent.detailFrame.showOrgDetail = false;
 	}else{
		Form.disable("levelForm");
		parent.detailFrame.showOrgDetail = true;
	}
	parent.listFrame.location.reload(true);
}

function desabledLevelButton(flag){
	document.getElementById("submintButton").disabled = flag;
	document.getElementById("submintCancel").disabled = flag;
}

/*
 * 取的当前详细内容页所在框架的样式
 */
 
function setDetailStyle(){
  if(getA8Top().contentFrame.mainFrame.listAndDetailFrame.detailFrame){
    var detailDoc = getA8Top().contentFrame.mainFrame.listAndDetailFrame.detailFrame.document;
    var str = "<img src=\"/seeyon/common/images/button.preview.up.gif\" height=\"8\" onclick=\"previewFrame('Up')\" class=\"cursor-hand\"><img src=\"/seeyon/common/images/button.preview.down.gif\" height=\"8\" onclick=\"previewFrame('Down')\" class=\"cursor-hand\">";
    detailDoc.getElementById("deptDetail").innerHTML=str;
  }
}
/*
 *  涮洗单位
 */
function doAccount(){
	parent.listFrame.location.reload(true); 
	parent.detailFrame.location.reload(true); 
}
/**
 * 刷新部门
 */
function refuishDeptList(){
	parent.menuFrame.menuListFrame.location.reload(true);
}
// 导入组织模型弹出页
function impOrganization(type,x,y){
			var impURL = v3x.openWindow({
				url		: organizationURL+'?method=importExcel&importType='+type,
				width	: x,
				height	: y,
				resizable	: "yes"
			});		
			if(impURL){
				//alert(impURL);
				var url = impURL.substring(0,impURL.indexOf('|'));
				var selectvalue = impURL.substring(impURL.indexOf('|')+1,impURL.indexOf('#'));
				var radiovalue = impURL.substring(impURL.indexOf('#')+1,impURL.indexOf('@'));
				var sheetnumber = impURL.substring(impURL.indexOf('@')+1,impURL.indexOf('|@'));
				var accountid = impURL.substring(impURL.indexOf('|@')+2,impURL.indexOf('@#'));
				var language = impURL.substring(impURL.indexOf('@#')+2);

			var kkk = v3x.openWindow({
				url		: organizationURL+'?method=matchField&impURL='+encodeURI(url)+'&selectvalue='+selectvalue+'&radiovalue='+radiovalue+'&sheetnumber='+sheetnumber+'&accountid='+accountid+'&language='+language,
				width	: 600,
				height	: 530,
				resizable	: "yes"
			});	
				//var url = kkk.substring(0,impURL.indexOf('|'));
				//var repeat = kkk.substring(impURL.indexOf('|')+1,impURL.indexOf('#'));
				//var language = kkk.substring(impURL.indexOf('#')+1);
				//getA8Top().contentFrame.mainFrame.location.href=organizationURL+"?method=importOrganization&impURL="+encodeURI(url)+"&repeat="+repeat+"&language="+language;
			}
}
/**
 * 提交表单
 */
function submitOrgForm(isVaidata,theForm){
	    if(isVaidata){
	      getA8Top().startProc(''); 
	      document.getElementById("submintButton").disabled = true;
	      document.getElementById("submintCancel").disabled = true;
	      return true;
	    }else{
	      return false;
	    }
}
function toEditMember(){
          getA8Top().endProc();
	      document.getElementById("submintButton").disabled = false;
	      document.getElementById("submintCancel").disabled = false;
}

/**
 * 人员管理FORM 系统权限设置弹出窗口
 */
function setMenuSecurity(linkURL){
	var securityIdsObj = document.getElementById("securityIds");
	if(securityIdsObj){
		linkURL += "&securityIds=" + securityIdsObj.value;
	}
	var result = v3x.openWindow({
		url		: linkURL,
		width	: 200,
		height	: 300,
		resizable	: "yes"
	});	
	if(!result){
		return ;
	}
	document.all.securityIds.value = result[0];
	document.all.securityNames.value = result[1];
}

/*
 *   IMPEXP function
 */
function canIO(userid){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgIoManager", "canIO", false);
	if(userid!=null){
	    requestCaller.addParameter(1, "String", userid);
	}
	var org = requestCaller.serviceRequest();
	//alert(org);
	return org;
}


/**
 * ******************************************************************************************
 *	集团组织树型结构
 * *******************************************************************************************
 */
 
 //点击树节点查看单位信息
 function showAccountInfo(accountId){
 	try{
	 	if(arguments[1]=='readonly'){
	 		window.location.href = organizationURL + "?method=editAccountOfTree&id="+accountId+"&readOnly=true";
	 	}else{
	 		parent.detailFrame.location.href = organizationURL + "?method=editAccountOfTree&id="+accountId+"&readOnly=true";
	 	}
 	}catch(e){return;}
 }
 
 //点击树节点编辑单位信息
 function editAccountInfo(accountId){
 	parent.detailFrame.location.href = organizationURL + "?method=editAccountOfTree&id="+accountId+"&readOnly=false";
 }
 

//无效输入判断(为真说明输入无效） 
function  InValidChar(s){             
	   var    haserrorChar;     
	   var    CorrectChar    =    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "   
	   haserrorChar  = isCharsNotInBag(s,CorrectChar);   
	   return    haserrorChar;   
}

//逐个判断s字符串中每个字符是否都在限定范围bag内   
function  isCharsNotInBag(s,bag){        
       
	   var    i,c;     
	   for(i=0;i<s.length;i++){     
	        
		   c = s.charAt(i);   
		   if(bag.indexOf(c) <  0){    //不在则返回真   
		     return true;     
		     }
	   }     
	   return false;     
} 

function showNextSpecialCondition(conditionObject) {
	var options = conditionObject.options;
		
	for (var i = 0; i < options.length; i++) {
		 var d = document.getElementById(options[i].value + "Div");
		  if (d) {
		       d.style.display = "none";
		  }
	}
	if(document.getElementById(conditionObject.value + "Div") == null) return;
	document.getElementById(conditionObject.value + "Div").style.display = "block";
}			

function preReturnValueFun_dept(elements){
    if (!elements) 
        return;
    var depsPathStrEle = document.getElementById("depsPathStr");
    if( depsPathStrEle && typeof(depsPathStrEle)!='undefined'){
        var depsPathStr = depsPathStrEle.value;
        if(depsPathStr!=''){
	    var depsPath = depsPathStr.split('|');
	    for(i=0;i<elements.length;i++){
	        var deptPath = elements[i].entity.path;
	        var isContain = false;	        
	          for(j=0;j<depsPath.length;j++){	            
	            if(deptPath.indexOf(depsPath[j])>=0){
	                    var substr = deptPath.substring(depsPath[j].length,deptPath.length); 
	                    if(substr == '' || substr.indexOf('.')>=0){
	                        isContain = true;
	                    }                                 
	            }
	          }	        
	        if(!isContain){
	            return new Array(false,v3x.getMessage("organizationLang.orgainzation_validate_dept_not_manager", elements[i].name));
	        }       
	    } 
	    }         
    }else{
        return;
    }
}

function tirmElementById(elementId){
    try{
        document.getElementById(elementId).value = document.getElementById(elementId).value.trim();
        return true;    
    }catch(e){
    }
}