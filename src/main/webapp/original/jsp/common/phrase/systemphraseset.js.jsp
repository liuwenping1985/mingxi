<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<script type="text/javascript">
var  height;
var ss;
$(document).ready(function () {
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
                    'border': true,
                    'minHeight': 20
                }
            });
            //初始化toolbar
            $("#toolbar").toolbar({
            	 borderLeft:false,
                 borderRight:false,
                 borderTop:false,
                  toolbar : [ {
                    id : "newObj",
                    name : "${ctp:i18n('phrase.sys.js.newadd')}",
                    className : "ico16",
                    click:function(){
                    	addphrase();
                    }
                  }, {
                    id : "update",
                    click:function(){
                    	updatephrase();
                    },
                    name : "${ctp:i18n('phrase.sys.js.modify')}",
                    className : "ico16 editor_16"
                  }, {
                    id : "delete",
                    name : "${ctp:i18n('phrase.sys.js.delete')}",
                    className : "ico16 del_16",
                    click:function(){
                    	deletephrase();
                    }
                  } ]
                });
             //给确定按钮加事件
            $("#okBtn").bind("click",function(){
            	fokBtn();
            });
            //给取消按钮加事件
            $("#cancelBtn").bind('click',function(){
            	fcancelBtn();
            });
            //计算窗体宽度
            var rowLong = $(window).width();
            //取初始化常用语的数据
            ss = $("table.flexme3").ajaxgrid({
                click: forlookAction,
                dblclick: editActionDB,
                colModel: [{
                    display: 'id',
                    name: 'id',
                    width: '40',
                    sortable: false,
                    align: 'center',
                    type: 'checkbox'
                   // colAction: { 'click': test, 'dblclick': testDB }
                }, {
                    display: '${ctp:i18n("phrase.sys.js.content")}',
                    name: 'content',
                    width: rowLong*0.92,
                    sortable: true,
                    align: 'left'
                    //colAction: { 'click': test2, 'dblclick': testDB2 }
                }],
                sortname: "id",
                sortorder: "asc",
                usepager: true,
                useRp: true,
                height: 200,
                showTableToggleBtn: true,
                slideToggleBtn:true,
                parentId: 'center',
                vChange: true,
				vChangeParam: {
	                overflow: "hidden"
	            },
	            
                managerName:"phraseManager",
                managerMethod:"getAll"
            });
            height=$(".bDiv").height();
//            $("table.flexme3").css("height",parseInt($("#center").css("height"))/2);
  //          $("#operForm").css("height",parseInt($("#center").css("height"))/2);
});

//新增常用语
function addphrase(){
	$("#old_id").show();
	$("#new_id").hide();
	//标题显示
	$("#newLagText").show();
	$("#viewLagText").hide();
	$("#editLagText").hide();
    //ss.grid.resizeGridUpDown('middle');
    ss.grid.resizeGrid(105);
	$("#s").val("");
	$("textarea").removeAttr("disabled").val("");

	$("#okBtn").show();
	$("#cancelBtn").show();
}
//修改常用语的方法
function updatephrase(){
	//标题显示
	var selobj = $("table.flexme3");
	var selobj2 =selobj.find(":checked");
	
	if(selobj2.size() <= 0 ){
	    $.alert("${ctp:i18n('phrase.sys.js.qxzyxgdjl')}");
		$(".bDiv").height(height);
		return;
	}
	if(selobj2.size() > 1){
		$.alert("${ctp:i18n('phrase.sys.js.qxzytjl')}");
		$(".bDiv").height(height);
		return;
	}
	$("#newLagText").hide();
	$("#viewLagText").hide();
	$("#editLagText").show();
	$("#old_id").show();
	$("#new_id").hide();
	//ss.grid.resizeGridUpDown('middle');
	ss.grid.resizeGrid(105);
	$("#txtPhrase").val(selobj2.parents("tr").find("td").eq(1).text().replace(/\u00A0/g, " ")).removeAttr("disabled");
	$("#s").val(selobj2[0].value);

	$("#okBtn").show();
	$("#cancelBtn").show();
}
//删除常用语
function deletephrase(){
	var selobj = $("#flexme3").find(":checked");
	if(selobj.size() <= 0){
		$.alert("${ctp:i18n('phrase.sys.js.qxzxyscdcyy')}");
		return;
	}
	var pid="";
	var confirm = "";
    confirm = $.confirm({
        'msg': '${ctp:i18n("phrase.sys.js.suredelete")}',
        ok_fn: function () { 
        	if(selobj.size()==1){
        		pid =  selobj[0].defaultValue;
        	}else{
        		for(var count = 0 ; count < selobj.size() ; count ++){
        			if(count == selobj.size()-1){
        				pid  = pid + selobj[count].defaultValue; 
        			}else{
        				pid = pid+selobj[count].defaultValue +"*"; 
        			}
        		}
        	}
        	$("#s")[0].value=pid;
        	//window.location=_ctxPath+"/phrase/phrase.do?method=deleteSysphrase&pid="+pid;
        	$("#operForm").attr("action","phrase.do?method=deleteSysPhrase");
        	$("#operForm").jsonSubmit();
        }
    });
	
}
//确定事件
function fokBtn(){
	if(!valibeforesubmit()){
		return;
	}
	var pcontent = $("textarea").val();
	var pid = $("#s").val();
	//window.location=_ctxPath+"/phrase/phrase.do?method=updateoraddSysphrase&pcontent="+encodeURI(encodeURI(pcontent))+"&pid="+pid;
	$("#operForm").attr("action","phrase.do?method=updateOrAddSysPhrase");
	$("#operForm").jsonSubmit();
}
function render(text, row, rowIndex, colIndex) {
    if (rowIndex == 2 && colIndex == 2) {
        return "<a href='#'>" + text + "</a>";
    } else {
        return text;
    }
}

//取消事件
function fcancelBtn(){
	//$(".bDiv").height(height);
	$("#old_id").hide();
	$("#new_id").show();
}

//单机列表行是进入查看
function forlookAction(row, rowIndex, colIndex) {
	//ss.grid.resizeGrid(105);
	ss.grid.resizeGridUpDown('middle');
	$("#new_id").css("height","0");
   //回填数据到表单
   $("textarea").val(row.content).disable();
   $("#s").val(row.id);
   //标题显示
   $("#newLagText").hide();
   $("#viewLagText").show();
   $("#editLagText").hide();
   //切换显示隐藏简介
   $("#old_id").show();
   $("#new_id").hide();
   //查看的时候 隐藏两个按钮
   $("#okBtn").hide();
   $("#cancelBtn").hide();
}
//双击列表行直接进入修改
function editActionDB(row, rowIndex, colIndex) {
	forlookAction(row, rowIndex, colIndex);
	$("#new_id").css("height","0");
	$("textarea").val(row.content).removeAttr("disabled");
	$("#s").val(row.id);
   // $('#s').val('DBclick----' + row.id + '---' + colIndex + '---' + rowIndex);
   //标题显示
   $("#newLagText").hide();
   $("#viewLagText").hide();
   $("#editLagText").show();

   $("#okBtn").show();
   $("#cancelBtn").show();
}

//对输入的常用语做校验
function valibeforesubmit(){
	var xx = $("textarea").val();
	if($.trim(xx) ==""){
		$.alert("${ctp:i18n('phrase.sys.js.cantbenull')}");
		return false;
	}
	if(xx.length>80){
	    $.alert("${ctp:i18n_1('phrase.sys.js.cyycd','"+xx.length+"')}");
		return false;
	}
	return true;
}
//先预留
function test(id) {
    //$('#s').val('click---' + id);
}
function test2(id) {
   // $('#s').val('test2---' + id);
}
function testDB(id) {
  //  $('#s').val('dbclick----' + id);
}
function testDB2(id) {
  //  $('#s').val('dbclick222----' + id);
}

</script>