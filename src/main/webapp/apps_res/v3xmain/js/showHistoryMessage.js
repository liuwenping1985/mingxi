//for showHistroyMessage.jsp
//切换Tag样式
function initTagStyle()
{

        if(showType==0)
        {
            
            document.getElementById("tag0-left").className="tab-tag-left-sel";
            document.getElementById("tag0-middel").className="tab-tag-middel-sel";
            document.getElementById("tag0-right").className="tab-tag-right-sel";
            
            document.getElementById("tag1-left").className="tab-tag-left";
            document.getElementById("tag1-middel").className="tab-tag-middel";
            document.getElementById("tag1-right").className="tab-tag-right";
            
         }
         else{
         
            document.getElementById("tag0-left").className="tab-tag-left";
            document.getElementById("tag0-middel").className="tab-tag-middel";
            document.getElementById("tag0-right").className="tab-tag-right";
            
            document.getElementById("tag1-left").className="tab-tag-left-sel";
            document.getElementById("tag1-middel").className="tab-tag-middel-sel";
            document.getElementById("tag1-right").className="tab-tag-right-sel";
            
        }
        
}

//选中按“创建时间”搜索的条件时，显示两个时间选择框
function showTextField(){

       if(document.all.condition.value=="creationDate")
       {
       document.all.textfield.style.display="none";
       document.all.datefield1.style.display="";
       document.all.datefield2.style.display="";
       }
       else
       {
       document.all.textfield.style.display="";
       document.all.datefield1.style.display="none";
       document.all.datefield2.style.display="none";
       }
}

/**
 * 信息查询
 */
function doSearchMessage() {
        var theForm = document.getElementsByName("searchForm")[0];
        var condition = theForm.condition;
        if(condition.value == 'creationDate') {         
            var startDate = document.getElementById("startDate").value;
            var endDate = document.getElementById("endDate").value;
            if(startDate != "" && endDate != ""){
                if(compareDate(startDate, endDate) > 0){
                    alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
                    return false;
                }
            }
        }
        doSearch();
}

/**
 * 显示回复
 */
function showReply(id){
    var element = document.getElementById("reply" + id);
    if(element){
        element.innerHTML = v3x.getMessage("MainLang.message_reply");
    }
}

/**
 * 隐藏回复
 */
function removeReply(id){
    var element = document.getElementById("reply" + id);
    if(element){
        element.innerHTML = "";
    }
}

/**
 * 默认菜单
 */
function setMenuState(showType, menu_id){
    if(showType == "0"){
        if(menu_id == null || menu_id == ""){
            menu_id = "allType";
        }
        var menuDiv = document.getElementById(menu_id);
        if(menuDiv != null){
            menuDiv.className = "webfx-menu--button-sel";
            menuDiv.firstChild.className="webfx-menu--button-content-sel";
            menuDiv.onmouseover = "";
            menuDiv.onmouseout = "";
            document.getElementById("readType").value = menu_id;
        }else{
            return;
        }
    }
}

/**
 * 忽略未读消息
 */
function updateMessageState(id, readType, type){
    var requestCaller = null;
    if(id){//忽略一条未读消息
        if($("#" + id + "Span").length > 0){
            requestCaller = new XMLHttpRequestCaller(this, "ajaxMessageManager", "updateSystemMessageState", false);
            requestCaller.addParameter(1, "long", id);
            requestCaller.serviceRequest();
            $("#" + id + "Span").remove();
            $("#" + id + "Div").remove();
			//2017年7月3日修改
			$("#" + id + "A").removeClass("color_black");
			$("#" + id + "A").removeClass("font_bold");
        }
    }else{//忽略全部未读消息
        if($("span[name='unReadMsg']").length == 0){
            return;
        }else{
            if(confirm(_("MainLang.message_system_ignore_all"))){
                requestCaller = new XMLHttpRequestCaller(this, "ajaxMessageManager", "updateSystemMessageStateByUser", false);
                requestCaller.serviceRequest();
                if(readType == "notRead"){
                    location.href = location.href;
                }else{
                    $("div[name='unReadMsg'],span[name='unReadMsg']").remove();
                }
            }
        }
    }
}

/**
 * 显示全部消息
 */
function showAllType(){
	document.location.href = v3x.baseURL+"/message.do?method=showMessages&showType=0&readType=allType";
}

/**
 * 显示未读消息
 */
function showNotRead(){
	document.location.href = v3x.baseURL+"/message.do?method=showMessages&showType=0&readType=notRead";
}