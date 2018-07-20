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
    
    <script type="text/javascript">

    //fb  关联文档传主信息的流程密级
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
                    o.secretLevel = secretLevel;
                    var choose = $('#'+searchobj.p.id).find("option:selected").val();
                    if(choose === 'subject'){
                        o.subject = $('#title').val();
                    }else if(choose === 'importantLevel'){
                        o.importantLevel = $('#importent').val();
                    }else if(choose === 'startMemberName'){
                        o.startMemberName = $('#spender').val();
                    }else if(choose === 'createDate'){
                        var fromDate = $('#from_datetime').val();
                        var toDate = $('#to_datetime').val();
                        if(fromDate != "" && toDate != "" && fromDate > toDate){
                            $.alert("${ctp:i18n('collaboration.rule.date')}");//开始时间不能大于结束时间
                            return;
                        }
                        var date = fromDate+'#'+toDate;
                        o.createDate = date;
                    }
                    var stateList = document.getElementsByName('state');
                    for(var i=0; i<stateList.length; i++)  {
                        if (stateList[i].checked) {
                            o.state = stateList[i].value;
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
                }, {
                    id: 'importent',
                    name: 'importent',
                    type: 'select',
                    text: '${ctp:i18n("common.importance.label")}',//重要程度
                    value: 'importantLevel',
                    items: [{
                        text: '${ctp:i18n("common.importance.putong")}',//普通
                        value: '1'
                    }, {
                        text: '${ctp:i18n("common.importance.zhongyao")}',//重要
                        value: '2'
                    }, {
                        text: '${ctp:i18n("common.importance.feichangzhongyao")}',//非常重要
                        value: '3'
                    }]
                }, {
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
                    width: '4%',
                    isToggleHideShow:false
                }, {
                    display: '${ctp:i18n("common.subject.label")}',//标题
                    name: 'subject',
                    sortable : true,
                    width: '55%'
                },{
                    display: '${ctp:i18n("cannel.display.column.sendUser.label")}',//发起人
                    name: 'startMemberName',
                    sortable : true,
                    width: '19%'
                },{
                    display: '${ctp:i18n("common.date.sendtime.label")}',//发起时间
                    name: 'startDate',
                    sortable : true,
                    width: '19%'
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
                managerName : "colManager",
                managerMethod : "getSentlist4Quote"
            });
            var o = new Object();
            o.secretLevel = secretLevel;
            var stateList = document.getElementsByName('state');
            for(var i=0; i<stateList.length; i++)  {
                if (stateList[i].checked) {
                    o.state = stateList[i].value;
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
                   
                    var nameContent = "<a class='card' href='#' onclick='openColInfo(this)' id='"+affairId+"'>"+text+"</a>";  
                    
                    //加图标
                    //重要程度
                    if(row.importantLevel !==""&& row.importantLevel !== 1){
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
                    //协同类型
                    if(row.bodyType!==""&&row.bodyType!==null&&row.bodyType!=="10"&&row.bodyType!=="30"){
                        nameContent = nameContent+ "<span class='ico16 office"+row.bodyType+"_16'></span>";
                    }
                    //流程状态
                    if(row.state !== null && row.state !=="" && row.state != "0"){
                        nameContent = "<span class='ico16  flow"+row.state+"_16 '></span>"+ nameContent ;
                    }
                    return nameContent;
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
               o.state = obj.value;
               o.secretLevel = secretLevel;
               $("#listSent").ajaxgridLoad(o);
           }
       }
       
       function selectColInfo(obj){
           parent.quoteDocumentSelected(obj, obj.name, 'collaboration', obj.value);
       }
       var v3x = new V3X();
       function openColInfo(obj) {
           var url ="${path}/collaboration/collaboration.do?method=summary&openFrom=glwd&type=&affairId="+obj.id;
           //showSummayDialogByURL(url,obj.name);
           v3x.openWindow({
               url     : url,
               workSpace: 'yes',
               FullScrean: 'yes',
               dialogType: 'open',
               closePrevious : "no"
           });
           
       }
       
       
    </script>
</head>
<body>
    <div id='layout' style="width:99%">
        <div class="layout_north bg_color" id="north">
            <div class="common_radio_box clearfix" style="padding-top: 8px;padding-left:5px;">
                <!-- 已发  -->
                <label for="sentC" class="resCode margin_r_10 hand" resCode="F01_listSent">
                    <label>
                    <input type="radio" value="2" id="state" name="state" onclick="changeColType(this)"
                        class="radio_com" ${(param.state eq '2' || empty param.state) ? 'checked' : ''}/>${ctp:i18n('collaboration.state.12.col_sent')}
                    </label>
                </label>
                <!--待办 -->
                <label for="pendingC" class="resCode margin_r_10 hand" resCode="F01_listPending">
                    <label>
                    <input type="radio" value="3" id="state" name="state"  onclick="changeColType(this)"
                        class="radio_com" ${param.state eq '3' ? 'checked' : ''}/>${ctp:i18n('collaboration.state.13.col_pending')}
                    </label>
                </label>
                <!-- 已办 -->
                <label for="doneC" class="resCode hand" resCode="F01_listDone">
                    <label>
                    <input type="radio"   value="4" id="state" name="state" onclick="changeColType(this)"
                        class="radio_com" ${param.state eq '4' ? 'checked' : ''}/>${ctp:i18n('collaboration.state.14.done')}
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
