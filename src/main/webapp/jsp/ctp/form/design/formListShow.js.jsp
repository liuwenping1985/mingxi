<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript">
function getDictionary(id){
    var cManager = new formListManager();
    var dictionary = cManager.getDataDictionary(id);
	if(dictionary){
        var dialog = $.dialog({
            html     : showDictionary(dictionary),
            title    : "${ctp:i18n('form.base.datadictionary')}",
            width    : 700,
            height   : 560,
            isDrag   : false,
            checkMax : true,
            buttons  :[{text        : dictionary.keys.close,
						isEmphasize : true,
						handler     : function () {dialog.close()}
					  }]
					});
    }
}
var current_toolbar;
var isAdmin = "${isAdmin}";
var table;
var v3x = new V3X();
var seeyonreportPlugin = "${ctp:hasPlugin('seeyonreport')}";
var notShowDataSet = "${notShowDataSet}";
var _isAdvanced = "${isAdvanced}";
var bizPlugin = "${ctp:hasPlugin("formBiz")}";
//操作类型
var _property = "${property}";
//表单应用分类
var _formType = "${formType}";

var _canCreate = ${canCreate};
//表单管理员JSON对象
var formAdmin = new Properties();
var searchobj;
<c:forEach items="${formAdmin}" var="admin" varStatus="status">
formAdmin.put("${admin.id}", "${fn:escapeXml(admin.name)}");
</c:forEach>
//表单分类JSON对象
var _formTemplateCategorysJson = [];
<c:forEach items="${catgs}" var="category" varStatus="status">
_formTemplateCategorysJson[_formTemplateCategorysJson.length] = {'id':"${category.id }",'name':"${fn:replace(fn:escapeXml(category.name)," ", "&nbsp;")}"};
</c:forEach>
  var formPresetDraft = ${v3x:getSysFlagByName('form_preset_draft') };//判断是否显示表单预置草稿流程数据
  $(document).ready(
      function() {
        table = $("table.flexme3").ajaxgrid({
              colModel : [ {
                display : 'id',
                name : 'id',
                width : '3%',
                sortable : false,
                align : 'center',
                isToggleHideShow:false,
                type : 'checkbox'
              }, {
                display : "${ctp:i18n('form.base.formname.label')}",
                name : 'name',
                width : '27%',
                sortable : true,
                align : 'left',
                isToggleHideShow:false
              }, {
                display : "${ctp:i18n('formsection.config.template.category')}",
                name : 'categoryId',
                width : '10%',
                sortable : true,
                isToggleHideShow:false,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.base.affiliatedsortperson.label')}",
                name : 'ownerId',
                width : '10%',
                sortable : true,
                isToggleHideShow:false,
                align : 'center'
              }, {
                display : "${ctp:i18n('form.base.formtype.label')}",
                name : 'formType',
                width : '0%',
                sortable : true,
                align : 'left',
                isToggleHideShow:false,
                hide:true
              }, {
                display : "${ctp:i18n('form.base.formtype.label')}",
                name : 'formTypeName',
                width : '10%',
                sortable : true,
                isToggleHideShow:false,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.trigger.triggerSet.state.label')}",
                name : 'stateText',
                width : '5%',
                sortable : true,
                isToggleHideShow:false,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.formcreate.enable')}",
                name : 'useFlag',
                width : '5%',
                sortable : true,
                isToggleHideShow:false,
                align : 'center'
              }, {
                display : "${ctp:i18n('form.base.maketime')}",
                name : 'createTime',
                isToggleHideShow:false,
                width : '10%',
                sortable : true,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.base.modifytime')}",
                name : 'modifyTime',
                width : '10%',
                isToggleHideShow:false,
                sortable : true,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.base.datadictionary')}",
                name : 'dataDictionary',
                isToggleHideShow:false,
                width : '7%',
                sortable : false,
                align : 'center'
                } ],
              isToggleHideShow:false,
              managerName : "formListManager",
              managerMethod : "designFormshow",
              click :clk,
              dblclick : dblclk,
              usepager : true,
              useRp : true,
              callBackTotle : successFun,
              customize:false,
              resizable : true,
              render : rend,
              showToggleBtn: false,
                    parentId: $('.layout_center').eq(0).attr('id'),
                    vChange: true,
                    vChangeParam: {
                        overflow: "hidden",
                        autoResize:true
                    },
                    slideToggleBtn: true
            });
            //初始化
            var o = new Object();
            if("${formType}"!=='9999'){
                o.formType="${formType}";
                }
            o.property="${property}";
            //用户自定义列表
            if("customerForm"==="${property}")
                {
                if("${formId}"!=='-1'){
                o.formid="${formId}";}
                if("${ownerId}"!=='-1'){
                o.ownerId="${ownerId}";}
                if("${categoryId}"!=='-1'){
                o.categoryId="${categoryId}";}
                if("${state}"!=='9999'){
                o.state="${state}";}
                if("${useFlag}"!=='9999'){
                o.useFlag="${useFlag}";}
                if("${name}"!==''){
                o.name="${name}";}
                if("${orgAccountId}"!=='-1'){
                o.orgAccountId="${orgAccountId}";}
                }
            $("#mytable").ajaxgridLoad(o);
            
            //回调函数
            function rend(txt, data, r, c) {
                if(c == 1){
                    if(data.isExistsDataset == true){
                        txt = txt + "<em class='ico16 form_16'></em>";
                    }
                    if (data.showPIcon) {
                        txt = txt + "<em class='ico16 formPhone_16'></em>";
                    }
                    return txt;
                } else if(c == 10){
                   return  "&nbsp;<a class='ico16 view_log_16 noClick' href='javascript:void(0)' onclick='getDictionary(\""+data.id+"\")'></a>&nbsp;";
                } else{
                    return txt;
                }
            }
            function clk(data, r, c) {
                var cManager = new formListManager();
                var formDetail = cManager.beforeViewOneRecord(data.id);
                if(!formDetail){
                  $.messageBox({
                          'title': "${ctp:i18n('common.prompt')}",
                          'type': 0,
                          'imgType':0,
                          'msg': "${ctp:i18n('form.base.form.deleted')}",
                          ok_fn: function() {
                            location.reload();
                          }
                   });
                  return;
                }
                if (data.isPForm) {//纯移动表单链接到移动表单设计器上，并且只读
                    $("#viewFrame").prop("src",_ctxPath + "/form/lightForm.do?method=designer4Phone&formType="+_formType+"&formId="+data.id+"&inputStatus=update&readOnly=true");
                }else{
                    $("#viewFrame").prop("src",_ctxPath + "/content/content.do?isFullPage=true&moduleId="+data.id+"&moduleType=35&rightId=-2&viewState=4");
                }
            }
            function dblclk(data, r, c){
                if("myForm"==="${property}"){
                    forwardFormDesign(data.id);
                }
                else{
                    var cManager = new formListManager();
                    var formDetail = cManager.beforeViewOneRecord(data.id);
                    if(!formDetail){
                      $.messageBox({
                              'title': "${ctp:i18n('common.prompt')}",
                              'type': 0,
                              'imgType':0,
                              'msg': "${ctp:i18n('form.base.form.deleted')}",
                              ok_fn: function() {
                                location.reload();
                              }
                       });
                      return;
                    }
                    if (data.isPForm) {//纯移动表单链接到移动表单设计器上，并且只读
                        $("#viewFrame").prop("src",_ctxPath + "/form/lightForm.do?method=designer4Phone&formType="+_formType+"&formId="+data.id+"&inputStatus=update&readOnly=true");
                    }else{
                        $("#viewFrame").prop("src",_ctxPath + "/content/content.do?isFullPage=true&moduleId="+data.id+"&moduleType=35&rightId=-2&viewState=4");
                    }
                }
            }
          //自定义时没有查询条件
          if("customerForm"!=="${property}"){
                searchobj = $.searchCondition({
                    top:7,
                    right:10,
                    searchHandler: function(){
                        var o = new Object();
                        if("${formType}"!=='9999'){
                            o.formType="${formType}";
                        }
                        o.property="${property}";//此列表显示哪种数据
                        getSearchCondition(o);
                        <c:if test = "${property eq 'accountForm'}">
                            var tree = $("#tree").treeObj();
                             var selectedNode = tree.getSelectedNodes()[0];
                             if (selectedNode) {
                                if (selectedNode.data.id != 2) {
                                  o.categoryId = selectedNode.data.id;
                                }
                              }
                        </c:if>
                    $("#mytable").ajaxgridLoad(o);
            },
            conditions: getSearchConditionList()
        });
        //searchobj.g.setCondition('name','');
        }
          //自定义时,将toolbar的高度设置为0
          if("customerForm"==="${property}"){
                var layout = $("#layout").layout();
                layout.setNorth(0);
          }
        //单位管理员
        if("${property}"==='accountForm'){
            $("#tree").tree({
                onClick : treeclk,
                idKey : "id",
                pIdKey : "parentId",
                nameKey : "name",
                nodeHandler : function(n) {
                    n.isParent = true;
                }
            });
            //对同步树的一些操作，根节点默认展开和选中等
            var treeObj = $.fn.zTree.getZTreeObj("tree");
            var nodes = treeObj.getNodes();
            if (nodes.length>0) {
                treeObj.expandNode(nodes[0], true, false, false);
            }
            treeObj.selectNode(nodes[0]);
            $(treeObj.transformToArray(nodes)).each(function(index, elem){
                if(elem.level == 1 && !elem.children){
                  expandNode(elem);
                }
            });
            //树节点单击事件
            function treeclk(e, treeId, node) {
                table.p.rp = 20;
                successFun(0);
                $("#rpInputChange").val(20);
                if (node.data.id == 2) {
                    var o = new Object();
                    o.property="${property}";//此列表显示哪种数据
                    $("#mytable").ajaxgridLoad(o);
                }else{
                    var o = new Object();
                    o.property="${property}";//此列表显示哪种数据
                    o.categoryId = node.data.id;
                    $("#mytable").ajaxgridLoad(o);
                }
            }
            function expandNode(pnode){
                  if(pnode){
                    var treeObj = $.fn.zTree.getZTreeObj("tree");
                    treeObj.expandNode(pnode, true, false, true);
                    var node = pnode.getParentNode();
                    if(node){
                      expandNode(node);
                    }
                  }
            }
            var layout = $("#layout").layout();
            layout.setWest(240);
        }
        
        if("${formType}"==="1"){
            $(this).attr("title","${ctp:i18n('form.base.formtype.templete')}");
        }else if("${formType}"==="2"){
            $(this).attr("title","${ctp:i18n('form.base.formtype.message')}");
        }else{
            $(this).attr("title","${ctp:i18n('form.base.formtype.basedata')}");
        }
        //显示工具栏
        setToolbar();    
      });
  /**
   * 返回数据字典信息的HTML
   */
  function showDictionary(data){
	  var html=[];

      html.push("<div>");

      var info=[];
      info.push("  <fieldset style='margin:20px;'><legend>"+data.keys.formInfo+"</legend>");
      info.push("  <div id='info'>");
      info.push("    <table cellspacing='0' cellpadding='0'>");
      info.push("      <tr><th style='font-weight: bold;height: 32px;'>"+data.keys.formName+"</th><th>"+data.formInfo.formName+"</th></tr>");
      info.push("      <tr><th style='font-weight: bold;height: 32px;'>"+data.keys.categoryName+"</th><th>"+data.formInfo.categoryName+"</th></tr>");
      info.push("      <tr><th style='font-weight: bold;height: 32px;'>"+data.keys.formTypeName+"</th><th>"+data.formInfo.formTypeName+"</th></tr>");
      info.push("      <tr><th style='font-weight: bold;height: 32px;'>"+data.keys.creatorName+"</th><th>"+data.formInfo.creatorName+"</th></tr>");
      info.push("      <tr><th style='font-weight: bold;height: 32px;'>"+data.keys.ownerName+"</th><th>"+data.formInfo.ownerName+"</th></tr>");
      info.push("    </table>");
      info.push("  </div>");
      info.push("  </fieldset>");

      html.push(info.join(""));

      var master=[];
      master.push("  <fieldset style='margin:20px;'><legend>"+data.keys.masterInfo+"</legend>");
      master.push("  <div id='master'>");
      master.push("    <table border='0'>");
      master.push("      <tr><th style='font-weight: bold;height: 32px;'>"+data.keys.tableName+"</td><td>&nbsp;</td><td colspan='5'>"+data.mList[0].Fields.mTableDisplay+"</td></tr>");
      master.push("      <tr><th style='font-weight: bold;height: 32px;'>"+data.keys.DBtableName+"</td><td>&nbsp;</td><td colspan='5'>"+data.mList[0].Fields.mTableName+"</td></tr>");
      master.push("      <tr><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.fieldName+"</td><td>&nbsp;</td><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.fieldType+"</td><td>&nbsp;</td><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.fieldLength+"</td><td>&nbsp;</td><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.fieldDisplay+"</td><td>&nbsp;</td><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.finalInputType+"</td><td>&nbsp;</td><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.finalFieldType+"</td></tr>");
      var masterfield =[];
      var mfields=data.mList[0].Fields.mFieldsInfo
      for(var i=0;i<mfields.length;i++){
	      masterfield.push("   <tr>")
	      masterfield.push("     <td align='center'>"+mfields[i].name+"</td><td>&nbsp;</td>");
          masterfield.push("     <td align='center'>"+mfields[i].fieldType+"</td><td>&nbsp;</td>");
	      masterfield.push("     <td align='center'>"+mfields[i].fieldLength+"</td><td>&nbsp;</td>");
	      masterfield.push("     <td align='center'>"+mfields[i].display+"</td><td>&nbsp;</td>");
	      masterfield.push("     <td align='center'>"+mfields[i].finalInputType+"</td><td>&nbsp;</td>");
	      masterfield.push("     <td align='center'>"+mfields[i].finalFieldType+"</td>");
	      masterfield.push("   </tr>");
      }
      master.push(masterfield.join(""));
      master.push("    </table>");
      master.push("  </div>");
      master.push("  </fieldset>");

      html.push(master.join(""));

      var subtable=data.sList
      if(subtable){
	      var sub=[];
	      sub.push("  <fieldset style='margin:20px;'><legend>"+data.keys.subInfo+"</legend>");
	      sub.push("  <div id='sub'>");
	      
	      for(var j=0;j<subtable.length;j++){
	          var subtablefield=subtable[j].Fields;
              sub.push("    <br/><table border='0'>");
	          sub.push("      <tr><th style='font-weight: bold;height: 32px;'>"+data.keys.tableName+"</td><td>&nbsp;</td><td colspan='5'>"+subtable[j].Fields.sTableDisplay+"</td></tr>");
              sub.push("      <tr><th style='font-weight: bold;height: 32px;'>"+data.keys.DBtableName+"</td><td>&nbsp;</td><td colspan='5'>"+subtable[j].Fields.sTableName+"</td></tr>");
	          sub.push("      <tr><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.fieldName+"</td><td>&nbsp;</td><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.fieldType+"</td><td>&nbsp;</td><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.fieldLength+"</td><td>&nbsp;</td><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.fieldDisplay+"</td><td>&nbsp;</td><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.finalInputType+"</td><td>&nbsp;</td><th style='font-weight: bold;height: 32px;' align='center'>"+data.keys.finalFieldType+"</td></tr>");
	          var sfields=subtablefield.sFieldsInfo;
	          for(var k=0;k<sfields.length;k++){
	                sub.push("   <tr>")
	                sub.push("     <td align='center'>"+sfields[k].name+"</td><td>&nbsp;</td>");
                    sub.push("     <td align='center'>"+sfields[k].fieldType+"</td><td>&nbsp;</td>");
	                sub.push("     <td align='center'>"+sfields[k].fieldLength+"</td><td>&nbsp;</td>");
	                sub.push("     <td align='center'>"+sfields[k].display+"</td><td>&nbsp;</td>");
	                sub.push("     <td align='center'>"+sfields[k].finalInputType+"</td><td>&nbsp;</td>");
	                sub.push("     <td align='center'>"+sfields[k].finalFieldType+"</td>");
	                sub.push("   </tr>");
	          }
              sub.push("    </table><br/>");
	      }
	      
	      sub.push("  </div>")
	      sub.push("  </fieldset>");
	      
	      html.push(sub.join(""));
      }

      html.push("</div>");
	  return html.join("");
  }
    
</script>