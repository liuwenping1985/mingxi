<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript">
Array.prototype.insert = function (index, item) {
	this.splice(index, 0, item);
};
var current_toolbar;
var table;
var v3x = new V3X();
var seeyonreportPlugin = "${ctp:hasPlugin('seeyonreport')}";
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
  var isA6s = ${v3x:getSysFlagByName('form_preset_data') };//判断是否是A6s
  $(document).ready(
      function() {
    	var colModels = [{
                display : 'id',
                name : 'id',
                width : '25',
                sortable : false,
                align : 'center',
                isToggleHideShow:false,
                type : 'checkbox'
              }, {
                display : "${ctp:i18n('form.base.formname.label')}",
                name : 'name',
                width : '40%',
                sortable : true,
                align : 'left',
                isToggleHideShow:false
              },{
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
                width : '8%',
                sortable : true,
                isToggleHideShow:false,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.formcreate.enable')}",
                name : 'useFlag',
                width : '8%',
                sortable : true,
                isToggleHideShow:false,
                align : 'center'
              }, {
                display : "${ctp:i18n('form.base.maketime')}",
                name : 'createTime',
                isToggleHideShow:false,
                width : '9%',
                sortable : true,
                align : 'left'
              }, {
                  display : "${ctp:i18n('form.base.modifytime')}",
                  name : 'modifyTime',
                  width : '9%',
                  isToggleHideShow:false,
                  sortable : true,
                  align : 'left'
                }];
    	if(_formType == '6'){
            colModels[1].display="${ctp:i18n('form.base.edocformname.label')}";
    		colModels[1].width = '55%';
    	}
    	if(_formType != '6' && _formType != '7' && _formType != '8'){
    		colModels.insert(2,{
    			display : "${ctp:i18n('formsection.config.template.category')}",
                name : 'categoryId',
                width : '10%',
                sortable : true,
                isToggleHideShow:false,
                align : 'left'
              });
    	}
    	if(_formType == '5' || _formType == '7' || _formType == '8'){//如果表单类型是收文单或发文单才显示‘是否是默认’这一字段
            colModels[1].display="${ctp:i18n('form.base.edocformname.label')}";
    		colModels.push({
                display : "${ctp:i18n('from.base.isdefault.label')}",
                name : 'isDefault',
                width : '12%',
                isToggleHideShow:false,
                sortable : true,
                align : 'left'
              });
    		
    	}
    	if(_formType != '5' && _formType != '6'&& _formType != '7' && _formType != '8'){
    		colModels.insert(3,{
    			display : "${ctp:i18n('form.base.affiliatedsortperson.label')}",
                name : 'ownerId',
                width : '10%',
                sortable : true,
                isToggleHideShow:false,
                align : 'center'
              });
    	}
        table = $("table.flexme3").ajaxgrid({
              colModel : colModels,
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
                }else{
                    if(txt == 'isDefaultTrue'){
                          var temp = "${ctp:i18n('form.base.yes')}";
                          return temp;
                    }else if(txt == 'isDefaultFalse'){
                          return "${ctp:i18n('form.base.no')}";
                    }
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
                    $("#viewFrame").prop("src",_ctxPath + "/content/content.do?isFullPage=true&myFormId="+data.id+"&moduleId="+data.id+"&myFormId="+data.id+"&moduleType=35&rightId=-2&viewState=4");
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
                        $("#viewFrame").prop("src",_ctxPath + "/content/content.do?isFullPage=true&myFormId="+data.id+"&moduleId="+data.id+"&myFormId="+data.id+"&moduleType=35&rightId=-2&viewState=4");
                    }
                }
            }
          //自定义时没有查询条件
          if("customerForm"!=="${property}"){
                searchobj = $.searchCondition({
                    top:2,
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

</script>