<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<%@ include file="/main/common/portal_header.jsp"%>
<title></title>
<link rel="stylesheet" href="${path}/skin/default/skin.css" />

</head>
<body scroll="no" class="w100b h100b">
    <iframe id="main" name="main" frameborder="0" idsw="222" class="w100b h100b" style="position: fixed;"></iframe>
</body>
<script type="text/javascript">
	var isCtpTop = true;
	if(${param.isFolder == true}){
	    var url = "/seeyon/doc.do?method=docHomepageIndex&docResId=${param.docResId}";
	    if(${param.isLink == true}){
			url = "/seeyon/doc.do?method=docHomepageIndex&docResId=${param.docResId}&parentId=${param.parentId}";
	    }
		$("#main").attr("src",url);
	}else{
		fnOpenKnowledge("${param.docResourceId}",6);
	}

	function fnOpenKnowledge(docId, entrance, baseDocId, showBorrowApply, showDelete) {
    //OA-66320,屏蔽文档借阅功能
    var ctxMenu = (getA8Top().$&&getA8Top().$.ctx) ? getA8Top().$.ctx.menu : null;
    if(typeof(showBorrowApply) === 'undefined' || showBorrowApply == null) {
        showBorrowApply = true;
        if(typeof(ctxMenu) != 'undefined' && ctxMenu!= null){
            var flag = true;
            for(var i=0;i<ctxMenu.length;i++){
                var ctxMenuItems = ctxMenu[i].items;
                if(ctxMenuItems != null){
                	for(var j=0;j<ctxMenuItems.length;j++){
                        if(ctxMenuItems[j].resourceCode === 'F04_showKnowledgeNavigation'){
                            flag = false;
                            break;
                        }
                    }
                }
            }
            if(flag){
                showBorrowApply = false;
            }
        }
    }
    
    // 从关联文档打开，不会显示申请借阅(先阶段，在关联文档打开也不会出现打不开的状况)
    if(entrance === 8 || entrance === '8' || typeof($) === 'undefined') {
        showBorrowApply = false;
    }
    
    if(entrance === 8 || entrance === '8'){
        //showDelete  在关联文档中表示是否是链接
        var isLink = showDelete ;
        if(baseDocId === 'true' && isLink==='false' ){
            fnAlert(fnI18n('doc.prompt.noright'));
            return ;
        }
        baseDocId = null;
    }
    
    var requestCaller = new XMLHttpRequestCaller(this, "docHierarchyManager", "getValidInfo", false);
    requestCaller.addParameter(1, "Long", docId);
    if(typeof(entrance) === 'undefined' || entrance === null) {
        entrance = 6;
    }
    requestCaller.addParameter(2,"Integer",entrance);
    if(typeof(baseDocId) === 'undefined' || baseDocId === null) {
        baseDocId = null;
    }
    requestCaller.addParameter(3,"Long",null);
    requestCaller.addParameter(4,"Long",baseDocId);
    ret = requestCaller.serviceRequest();
    var isExist = ret.charAt(0);
    // 现在为了统一，在任何位置都不提示删除
    showDelete = false;
    if(isExist === '4') {
        fnAlert(fnI18n('doc.prompt.docLib.disabled'));
        return;
    } else if(isExist !== '0') {
        if(showDelete && typeof(delF) !== 'undefined') {
            fnConfirm(fnI18n('doc.prompt.inexistence.delete'),function (){
                delF(docId, "self", false);
            });
            return;
        } else {
            fnAlert(fnI18n('doc.prompt.inexistence'));
            return;
        } 
    }
    // 0:代表有权限，1：代表没有打开权限，2代表没有资源，3代表仅仅有学习区的权限
    var hasOP = ret.charAt(1);
    if((hasOP === 1 || hasOP ==='1') && (entrance == '11'||entrance == 11)){
        fnConfirm(fnI18n('doc.prompt.noright.sendlearningcancel.borrow'),function (){
            fnAddDocBorrowApply(docId,null);
        });
        return;
    }
    
    if(hasOP === '2'||hasOP === 2) {
        fnAlert(fnI18n('doc.prompt.noright'));
        return;
    }
    
    if(hasOP !== '0' && hasOP!=='3') {
        if(showBorrowApply && typeof(fnAddDocBorrowApply) !== 'undefined') {
            fnConfirm(fnI18n('doc.prompt.noright.borrow'),function (){
                fnAddDocBorrowApply(docId,null);
            });
            return;
        } else {
            fnAlert(fnI18n('doc.prompt.noright'));
            return;
        }
    }
    
    //文档库打开
    if((entrance === 5 || entrance === '5') && (hasOP == '3'||hasOP === 3)){//文档中心打开，仅仅学习区有权限
        fnAlert(fnI18n('doc.prompt.noright'));
        return;
    }
    
    var url ;
	url = _ctxPath+ret.substring(2);
    if((entrance === 6 || entrance === '6' )&& typeof(ownerId) !== 'undefined'){
        url = url + "&ownerId=" + ownerId ;
    }
    
    window.location.href = url;
}
</script>
</html>