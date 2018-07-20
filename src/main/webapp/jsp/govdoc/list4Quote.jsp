<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/collaboration/collFacade.js.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>关联文档</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=colManager,pendingManager"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    
    <script type="text/javascript"><!--
    //fb 关联文档传主信息的流程密级
    var secretLevel = '${param.secretLevel}';
    	//全局的一个防止指定跟踪人字符串的信息
    	var zzGzr='';
    	var ie8VersionFlag =false;
        $(document).ready(function () {
            new MxtLayout({
                'id': 'layout',
                'northArea': {
                    'id': 'north',
                    'height': 33,
                    'sprit': false,
                    'border': false
                },
                'centerArea': {
                    'id': 'center',
                    'border': false,
                    'minHeight': 20
                }
            });
            //工具栏
           ie8VersionFlag = $.browser.version =='8.0';
            //搜索框
            var searchobj = $.searchCondition({
                top:3,
                right:10,
                searchHandler: function(){
                    var o = new Object();
                    var choose = $('#'+searchobj.p.id).find("option:selected").val();
                    if(choose === 'subject'){//标题
                        o.subject = $('#title').val();
                    }else if(choose=='serialNo'){//内部文号
                    	o.serialNo=$('#serialNo').val();
                    }else if(choose=='docMark'){//公文文号
                    	o.docMark=$('#docMark').val();
            		}else if(choose === 'startMemberName'){//发起人
                        o.startMemberName = $('#spender').val();
                    }else if(choose === 'createDate'){//发起时间
                        var fromDate = $('#from_datetime').val();
                        var toDate = $('#to_datetime').val();
                        if(fromDate != "" && toDate != "" && fromDate > toDate){
                            $.alert("${ctp:i18n('collaboration.rule.date')}");//开始时间不能大于结束时间
                            return;
                        }
                        var date = fromDate+'#'+toDate;
                        o.createDate = date;
                    }
                    var stateList = document.getElementsByName('sub_app');
                    for(var i=0; i<stateList.length; i++)  {
                        if (stateList[i].checked) {
                        	o.sub_app = stateList[i].value;
                            break;
                        }
                    }
                    var val = searchobj.g.getReturnValue();
                    if(val !== null){
                     	o.secretLevel = secretLevel;
                        $("#listSent").ajaxgridLoad(o);
                    }
                },
                conditions: [{
                    id: 'title',
                    name: 'title',
                    type: 'input',
                    text: '${ctp:i18n("cannel.display.column.subject.label")}',//标题
                    validate:false,
                    value: 'subject',
                    maxLength:100
                },{
                    id: 'docMark',
                    name: 'docMark',
                    type: 'input',
                    text: $.i18n("govdoc.docMark.label"),//公文文号
                    value: 'docMark',
                    maxLength:100
                },{
                    id: 'serialNo',
                    name: 'serialNo',
                    type: 'input',
                    text: $.i18n("govdoc.serialNo.label"),//内部文号
                    value: 'serialNo',
                    maxLength:100
                },{
                    id: 'spender',
                    name: 'spender',
                    type: 'input',
                    text: '${ctp:i18n("cannel.display.column.sendUser.label")}',//发起人
                    validate:false,
                    value: 'startMemberName'
                }, {
                    id: 'datetime',
                    name: 'datetime',
                    type: 'datemulti',
                    text: '${ctp:i18n("common.date.sendtime.label")}',//发起时间
                    value: 'createDate',
                    ifFormat:'%Y-%m-%d',
                    dateTime: true
                }]
            });
            //表格加载
            var grid = $('#listSent').ajaxgrid({
                render: render,
                colModel: [{
                	id:'id',
                    name: 'workitemId',
                    width: '6%',
                    isToggleHideShow:false
                },{
                	 display: $.i18n("common.coll.state.label"),//状态
                     name: 'subState',
                     sortable : true,
                     width: '9%'
                }, {
                	display: $.i18n("common.subject.label"),//标题
                    name: 'subject',
                    sortable : true,
                    width: '35%'
                }, {
                	display: $.i18n("govdoc.docMark.label"),//公文文号
                    name: 'docMark',
                    sortable : true,
                    width: '12%'
                }, {
                	display: $.i18n("govdoc.serialNo.label"),// 内部文号
                    name: 'serialNo',
                    sortable : true,
                    width: '12%'
                },{
                	display: '${ctp:i18n("cannel.display.column.sendUser.label")}',//发起人
                    name: 'startMemberName',
                    sortable : true,
                    width: '9%'
                },{
                	display:  $.i18n("common.date.sendtime.label"),//发起时间
                    name: 'startDate',
                    sortable : true,
                    width: '15%'
                }],
                height: 400,
                showTableToggleBtn: true,
                parentId: $('.layout_center').eq(0).attr('id'),
                vChange: false,
                resizable:false,
                vChangeParam: {
	                overflow: "hidden",
					autoResize:true
	            },
                isHaveIframe:true,
                managerName : "edocManager",
                managerMethod : "getList4Quote"
            });
            var o = new Object();
            o.secretLevel = secretLevel;
            var stateList = document.getElementsByName('sub_app');
            for(var i=0; i<stateList.length; i++)  {
                if (stateList[i].checked) {
                    o.sub_app = stateList[i].value;
                    break;
                }
            }
            $("#listSent").ajaxgridLoad(o);
            function render(text, row, rowIndex, colIndex,col){
                if (col.name=="workitemId") {
                    var mapOptions = parent.fileUploadAttachments.instanceKeys.instance;
                    for(var k = 0; k <mapOptions.length; k++) {
                        if (mapOptions[k] == row.affairId){
                            var content = "<input type='checkbox' checked='checked' createdate='"+row.startDate+"'  id='boxId' name='"+escapeStringToHTML(row.subject)+"' onclick='selectColInfo(this)' value='"+row.affairId+"'/>";
                            return content;
                        }
                    }
                    var content = "<input type='checkbox' createdate='"+row.startDate+"'  id='boxId' name='"+escapeStringToHTML(row.subject)+"' onclick='selectColInfo(this)' value='"+row.affairId+"'/>";
                    return content;
                }
                if(col.name=="subject") {
                    var affairId=row.affairId;
                    var nameContent = "<a class='card' href='#' onclick='openColInfo(this)' id='"+affairId+"' name='"+row.app+"' objid='"+row.summaryId+"'>"+text+"</a>";  
                    
                    //加图标
                    //重要程度 1普通 2平急 3加急 4特急 5特提
                    if(row.importantLevel !==""&& row.importantLevel >1 && row.importantLevel<=5){
                        nameContent = "<span class='ico16 important"+row.importantLevel+"_16 '></span>"+ nameContent ;
                    }
                    //附件
                    if(row.hasAttsFlag === true){
                        nameContent = nameContent + "<span class='ico16 affix_16'></span>" ;
                    }
                    //表单授权
                    if(row.showAuthorityButton){
                        nameContent = nameContent + "<span class='ico16 authorize_16'></span>";
                    }
         
                    //流程状态
                    if(row.state !== null && row.state !=="" && row.state != "0"){
                        nameContent = "<span class='ico16  flow"+row.state+"_16 '></span>"+ nameContent ;
                    }
                    return nameContent;
                }
                if(col.name=="subState"){
                    var affair = row.affair;
                	var stateContent = "<span>"+affair.state+"</span>"
                	//已发
                    if(affair.state !== null && affair.state !=="" && affair.state == '2'){
                        var stateContent = "<span>${ctp:i18n('common.toolbar.state.sended.label')}</span>"
                    }
                    //待办3
                    if(affair.state !== null && affair.state !=="" && affair.state == '3'){
                        var stateContent = "<span>${ctp:i18n('common.toolbar.state.pending.label')}</span>"
                    }
                 	//已办4
                    if(affair.state !== null && affair.state !=="" && affair.state == '4'){
                        var stateContent = "<span>${ctp:i18n('common.toolbar.state.done.label')}</span>"
                    }
                    return stateContent
                }
                return text;
            };
           
        });
        
        function deselectItem(affairId){

            if(ie8VersionFlag){
            	$(":checkbox[value='"+affairId+"']").attr("checked", false);
            }else{
	            $("#boxId[value='"+affairId+"']").attr("checked", false);
            }
        }   
          
       function changeColType(obj){
           if(obj.checked){
               var o = new Object();
               o.sub_app = obj.value;
               o.secretLevel = secretLevel;
               $("#listSent").ajaxgridLoad(o);
           }
       }
       
       function selectColInfo(obj){
           parent.quoteDocumentSelected(obj, obj.name, 'edoc', obj.value);
       }
       var v3x = new V3X();
       function openColInfo(obj) {
		   var url = "";
			if(obj.name == 34 || obj.name == 40){ //可能还会有其他类型的公文 需要区打开方式
				url = "${path}/edocController.do?method=edocRegisterDetail&forwardType=registered&registerId="+obj.attributes['objid'].nodeValue;
			}else if(obj.name > 4){
			   url ="${path}/edocController.do?method=detailIFrame&affairId="+obj.id;
		    }else{
			   url ="${path}/collaboration/collaboration.do?method=summary&openFrom=glwd&type=&affairId="+obj.id;
		    }
           
           //showSummayDialogByURL(url,obj.name);
           v3x.openWindow({
               url     : url,
               workSpace: 'yes',
               FullScrean: 'yes',
               dialogType: 'open',
               closePrevious : "no"
           });
           
       }
       
       
    --></script>
</head>
<body>
    <div id='layout' style="width:99%">
        <div class="layout_north bg_color" id="north">
            <div class="common_radio_box clearfix" style="padding-top: 8px;padding-left:5px;">
                <!-- 发文  -->
                <label for="sentC" class="resCode margin_r_10 hand" resCode="F01_listSent">
                    <label>
                    <input type="radio" value="1" id="sub_app" name="sub_app" onclick="changeColType(this)"
                        class="radio_com" ${(param.sub_app eq '1' || empty param.sub_app) ? 'checked' : ''}/>${ctp:i18n('collaboration.pending.lable2')}
                    </label>
                </label>
                <!--收文 -->
                <label for="pendingC" class="resCode margin_r_10 hand" resCode="F01_listPending">
                    <label>
                    <input type="radio" value="2,4" id="sub_app" name="sub_app"  onclick="changeColType(this)"
                        class="radio_com"/>${ctp:i18n('collaboration.pending.lable1')}
                    </label>
                </label>
                <!--签报 -->
                <label for="pendingC" class="resCode margin_r_10 hand" resCode="F01_listPending">
                    <label>
                    <input type="radio" value="3" id="sub_app" name="sub_app"  onclick="changeColType(this)"
                        class="radio_com"/>${ctp:i18n('collaboration.pending.lable6')}
                    </label>
                </label>
                
            </div>
            <a ></a>
            <div id="toolbars"></div>  
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listSent"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary"  width="100%" height="100%" frameborder="0"  style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div>
</body>
</html>
