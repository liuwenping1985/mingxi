<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
var selectNode = -1;
$(document).ready(function(){
    <c:choose>
        <c:when test="${param.type eq 'view'}">
    $("#myform").disable();
    $("#selectedMenus").disable();
        </c:when>
        <c:otherwise>
      $("#struction").tooltip({
        event:true,
        openAuto:false,
        width:800,
        htmlID:'operInstructionDiv',
        targetId:'struction'
      });
    $("#mountSelect").click(function(){
      showOrHide();
    });
    $("#menuMount").click(function(){
      showOrHide();
    });
    $("#sectionName").keyup(function(){
      $("#selectedMenus").find("div[id^='div']").each(function(){
        var type = $("#menuColumnType",$(this)).val();
        type = type.split(",")[0];
        if (type != "7"){
            $("#menuColumnName",$(this)).val(getMenuName(type));
        }
      });
    });
    $("div[id^='div']").bind("click",function(){
      selectMenu(this);
    });
    $("div[id^='div']").bind("dblclick",function(){
      removeMenu();
    });
        </c:otherwise>
    </c:choose>
    $("#templateName").click(function(){
        parent.getFormTemplete('${param.type eq 'create' ? param.type : ffmyform.id }');
    });

    $("#template").click(function(){
      parent.getFormTemplete("${param.type eq 'create' ? param.type : ffmyform.id}");
    });

    $("#auth_set").click(function(){
      selectAuth();
    });
    $("#saveFormSection").click(function(){
      saveFormSectionSubmit();
    });
    $("#cancelFormSection").click(function(){
      cancelFormSectionSubmit();
    });
    $("#authText").click(function(){
      selectAuth();
    });
    $("#operInstructionDiv").show();
    showOrHide();

    <c:if test="${type eq 'view' and ffmyform eq null}">
    $("body").hide();
    $.alert({
      'msg':"${ctp:i18n('formsection.config.view.delete.label')}",
      'ok_fn':function(){
        getCtpTop().showMenu("${path}/form/formSection.do?method=index");
      }
    });
    <c:if test = "${param.from eq 'Message'}">
    alert("${ctp:i18n('formsection.config.view.delete.label')}");
    window.close();
    </c:if>
    </c:if>
});

function showOrHide(){
  if($("#columnType").prop("checked")){
    $("#formColumnDIV").show();
    if($("#menuType").prop("checked")){
        $("#formMenuDIV").show();
        $("#formColumnDIV").width("47%");
        $("#formMenuDIV").width("47%");
    }else{
      $("#formMenuDIV").hide();
        $("#formColumnDIV").width("100%");
    }
  }else{
    $("#column").val("");
    $("#formColumnDIV").hide();
    if($("#menuType").prop("checked")){
      $("#formMenuDIV").show();
        $("#formMenuDIV").width("100%");
    }else{
      $("#formMenuDIV").hide();
    }
  }
}

function saveFormSectionSubmit(){
    $("#saveFormSection").prop("disabled",true);
    $("#cancelFormSection").prop("disabled",true);
    if($("#columnType").attr("checked")){
        var value = selectColumnsIFrame.getAllItenValue(null);
        $("#column").val(value);
        if(value===""){
          $.alert('${ctp:i18n('formsection.config.column.must')}');
          $("#saveFormSection").prop("disabled",false);
          $("#cancelFormSection").prop("disabled",false);
            return;
        }
    }else{
        $("#column").val("");
    }
    if($("#menuType").attr("checked")){
      if($("div[id^='div']",$("#selectedMenus")).length < 1){
          $.alert('${ctp:i18n('formsection.config.menu.must')}');
          $("#saveFormSection").prop("disabled",false);
          $("#cancelFormSection").prop("disabled",false);
            return;
      }
    }
    if($("#myform").validate({errorAlert:false})){
        if(!$("#sectionContent").validate({errorAlert:true})){
            $("#saveFormSection").prop("disabled",false);
            $("#cancelFormSection").prop("disabled",false);
        }else{
            var sectionName = $("#sectionName").val();
            if(getTextLength(sectionName) > 255){
                $("#saveFormSection").prop("disabled",false);
                $("#cancelFormSection").prop("disabled",false);
                var showLabel = "${ctp:i18n('formsection.config.name.show') }";
                $.alert(showLabel+"超过允许的最大长度255（1个汉字算3个字符）！");
                return false;
            }
            $("#sectionContent").jsonSubmit({
                  domains:["myform","selectedMenus"],
                  validate : false,
                  action:"${path }/form/formSection.do?method=save",
                  beforeSubmit:whenSubmitForm,callback:function(){
                    getCtpTop().refreshMenus();
                  if($("#column").val() != ""){
                    <c:if test = "${param.type ne 'edit'}">
                      $.confirm({
                        'msg':'${ctp:i18n("formsection.config.homepage.topublish")}',
                        ok_fn:function(){
                          var fsm = new formSectionManager();
                          fsm.isAllowPublish({success:function(data){
                            if (data || data == "true"){
                              publish();
                                parent.loadData();
                            }else{
                              $.alert({
                                'msg':"${ctp:i18n('formsection.config.homepage.noright')}",
                                'ok_fn':function(){
                                  parent.loadData();
                                 // top.showMenu("${path}/form/formSection.do?method=index");
                                }
                              });
                            }
                          }});
                        },
                        cancel_fn:function(){parent.loadData();}
                      });
                      </c:if>
                    <c:if test = "${param.type eq 'edit'}">
                    parent.loadData();
                      </c:if>
                  }else{
                    parent.loadData();
                  }
                }});
        }
    } else {
      $("#saveFormSection").prop("disabled",false);
      $("#cancelFormSection").prop("disabled",false);
    }
}

function whenSubmitForm(){
    parent.proccess();
    return true;
}

function cancelFormSectionSubmit(){
  parent.loadData();
}

function chooseFormTemplet(obj){
    if(obj){
        $("#templateId").val(obj.value);
        $("#templateName").val(obj.name);
        $("#allColumnsIFrame").prop("src","${path}/form/formSection.do?method=showColumnTree&MountType=column&type=showAll&templateIds="+obj.value);
        $("#selectColumnsIFrame").prop("src","${path}/form/formSection.do?method=showColumnTree&MountType=column&type=showSelect&templateIds="+obj.value);
        $("#allMenuIFrame").prop("src","${path}/form/formSection.do?method=showMenuTree&MountType=menu&needRefresh=true&type=showAll&templateIds="+obj.value);
        updateFlowMenu(obj.value);
    }
}

function addNode(parentNode,node,needChiled){
  if (node.data.value ==7){
    if (node.children){
        var nodes = node.children;
        for(var i=0;i<nodes.length;i++){
          if(isExist(nodes[i])){
              getDivString(node,nodes[i]);
          }
        }
    }
  }else{
    if(isExist(node)){
      if(node.data.parentValue == 7){
          getDivString(parentNode,node);
      }else{
          getDivString(node,node);
      }
    }
  }
}

function updateFlowMenu(templates){
  $("#selectedMenus").find("input[value^='7']").each(function(){
    var templateId = $(this).val().split(",")[1];
    if (templates.indexOf(templateId) == -1){
      $(this).parents("div[id^='div']").remove();
    }
  });
}

function isExist(node){
  if ($("#div"+node.data.value,$("#selectedMenus")).length == 0){
    return true;
  }else{
    return false;
  }
}

function selectMenu(obj){
  $("#selectedMenus").find("div[id^='div']").each(function(i){
    if(this.id == obj.id){
      selectNode = i;
      $(this).css("background","highlight");
      $(this).css("color","highlighttext");
    }else{
      $(this).css("background","");
      $(this).css("color","");
    }
  });
}

function removeMenu(){
  var obj;
  $("#selectedMenus").find("div[id^='div']").each(function(i){
    if(i==selectNode){
      obj = this;
    }
  });
  if(obj){
    $(obj).remove();
    selectNode = -1;
  }
}

function moveMenu(direction){
  var temp = null;
  var temp1 = false;
  var menuName = null;
  $("#selectedMenus").find("div[id^='div']").each(function(i){
    if(i == selectNode){
      menuName = $("#menuColumnName",$(this)).val();
      if(direction == "up"){
        if(selectNode==0 || selectNode==-1) {
          return;
        }
        temp = $(this).prev();
        if(temp.attr("id")){
          temp.before(this.outerHTML);
          $(this).remove();
          temp1 = true;
            temp = $(temp).prev();
        }
      }else if(direction == "down") {
        if(selectNode==-1) {
          return;
        }
        temp = $(this).next();
        if(temp.attr("id")){
          temp.after(this.outerHTML);
          $(this).remove();
          temp1 = true;
            temp = $(temp).next();
       }
      }
    }
  });
  if (temp != null){
    $("#menuColumnName",temp).val(menuName);
    temp.unbind("click").bind("click",function(){
      selectMenu(this);
    });
    temp.unbind("dblclick").bind("dblclick",function(){
      removeMenu();
    });
}
if(temp1){
  if(direction == "up"){
    selectNode--;
  }else if(direction == "down") {
    selectNode++;
  }
}
}

function getMenuName(type){
  var menuName = "";
  var id = parseInt(type);
  var bizConfigName = $("#sectionName").val();
  switch(id) {
      //新建事项另行处理，以下依次为：待发事项、已发事项、待办事项、已办事项、督办事项、表单查询、表单统计、信息中心
      case 8 : 
          menuName = bizConfigName  + "${ctp:i18n('formsection.homepage.WAITSEND.label')}";
          break;
      case 9 : 
          menuName = bizConfigName + "${ctp:i18n('formsection.homepage.send.label')}";
          break;
      case 10 : 
          menuName = bizConfigName + "${ctp:i18n('formsection.homepage.pending.label')}";
          break;
      case 20 : 
          menuName = bizConfigName + "${ctp:i18n('formsection.homepage.done.label')}";
          break;
      case 30: 
          menuName = bizConfigName + "${ctp:i18n('formsection.homepage.supervise.label')}";
          break;
      case 40 : 
          menuName = bizConfigName + "${ctp:i18n('formsection.homepage.query.label')}";
          break;
      case 50 : 
          menuName = bizConfigName + "${ctp:i18n('formsection.homepage.statistic.label')}";
          break;
      case 60 : 
          menuName = bizConfigName + "${ctp:i18n('formsection.homepage.center.label')}";
          break;
  }
  return menuName;
}

function getDivString(parentNode,node){
  var divId = "div" + node.data.value;
  var menuDiv = $("<div id="+divId+" class=\"font_size12\"></div>");
  menuDiv.unbind("click").bind("click",function(){
    selectMenu(this);
  });
  menuDiv.unbind("dblclick").bind("dblclick",function(){
    removeMenu();
  });
  var menuName = "";
  if(node.data.parentValue == 7){
    menuName = node.data.name;
  }else{
    menuName = $("#sectionName").val() + node.data.selectVal;
  }
  var odiv = $("<div class='clearfix' style='line-height: 20px;margin: 3px;'></div>");
  odiv.append("<div class='left margin_r_5'>"+parentNode.data.name+"</div>");
  odiv.append("<div class='left' ><input id='subMenuId' name='subMenuId' type='hidden' value='"+getUUID()+"'><input id='menuColumnType' name='menuColumnType' type='hidden' value='"+parentNode.data.value + "," + node.data.value+"'><input id='menuColumnName' name='menuColumnName' class='validate' style='width: 120px;'  validate=\"name:'菜单名称',notNull:true,isWord:true,maxLength:20\" type='text' value='"+menuName+"'></div>");
  menuDiv.append(odiv);
  $("#selectedMenus").append(menuDiv);
}

function showOperDetailInfo() {
    var infoContent;
    var postionX;
    var postionY;
    //infoContent = "<ul>${ctp:i18n('formsection.config.operinstruction.info')}</ul>";
    postionX = parseInt(window.event.clientX);
    postionY = parseInt(window.event.clientY) + 10;
    $("#operInstructionDiv").css("top",postionY + parseInt(document.body.scrollTop));
    $("#operInstructionDiv").css("left",postionX);
    $("#operInstructionDiv").html(infoContent);
    showOrHideOperInstruction('true');
}
function showOrHideOperInstruction(show) {
    document.getElementById('operInstructionDiv').style.display = show=="true" ? "block" : "none";
}
function selectAuth(){
    var par = {};
    par.value = $("#authValue").val();
    par.text = $("#authText").val();
    $.selectPeople({
        panels: 'Account,Department,Team',
        selectType: 'Account,Department,Team,Member',
        params : par,
        minSize:0,
        isNeedCheckLevelScope:false,
        showFlowTypeRadio: false,
        callback : function(ret) {
          $("#authValue").val(ret.value);
          $("#authText").val(ret.text);
        }
      });
}
function messageCenter(){
    getCtpTop().window.open("${path}/form/formSection.do?method=messageCenter&sectionId=${ctp:escapeJavascript(param.id)}&type=flow&column=Pending","main");
}

function selectTreeNode(){
    allColumnsIFrame.selectColumn();
}
function publish(){
    //getCtpTop().showMenu("${path}/portal/portalController.do?method=personalInfoFrame&path=/portal/spaceController.do?method=showSpacesSetting");
    openCtpWindow({'url':'${path}/portal/spaceController.do?method=personalSpaceSetting'});
    changePublish(true);
}
function cancelPublish(){
    var fsm = new formSectionManager();
    var sectionId = $("#id").val();
    fsm.doCancelPublish(sectionId,false,{success:function(data){
        if(data == "true"){
            changePublish(false);
        }else{
          $.messageBox({
            'type' : 0,
            'msg' : '${ctp:i18n("formsection.infocenter.cancelconfig.error")}',
            ok_fn : function() {
            }
          });
        }
    }});
}
function changePublish(display){
    if(!display){
        $("#publish").show();
        $("#cancelPublish").hide();
    }else{
        $("#cancelPublish").show();
        $("#publish").hide();
    }
}
//获取字符串长度；中文算3个字符
function getTextLength(value){
    if(value==null||value==""){
        return 0;
    }else{
        var result = 0;
        for(var i=0, len=value.length; i<len; i++){
            var ch = value.charCodeAt(i);
            if(ch<256){
                result++;
            }else{
                result +=3;
            }
        }
        return result;
    }
}
</script>