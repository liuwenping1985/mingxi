<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${param.subject}</title>
<script type="text/javascript">
  $(function() {
	
  	var sendToOther = "${param.sendToOther}";
    var t = $("#selfCollData").ajaxgrid({
      click : clk,//单击事件
      dblclick : dblclk,//双击事件
      render : rend,
      "vresize" : false,
      "isHaveIframe" : true,
      "usepager" : true,// 是有翻页条
      "showTableToggleBtn" : false,
      "vChange": false,
      "customize":false,
      "slideToggleBtn" : false,// 上下伸缩按钮是否显示
      "parentId" : $('.layout_center').eq(0).attr('id'),// grid占据div空间的id
      "resizable" : false,// 明细页面的分隔条
      colModel: [{
          display: 'id',
          name: 'affairId',
          width: '4%',
          type: 'checkbox',
          hide:true,//默认显示与否,
          isToggleHideShow:false
      },{
        display : "${ctp:i18n('cannel.display.column.subject.label')}",
        name : 'subject',
        width : '30%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('datarelation.tab.sTime.js')}",
        name : 'startDate',
        width : '20%',
        sortable : true,
        align : 'center'
       
      } , {
          display : "${ctp:i18n('datarelation.tab.sender.js')}",
          name : 'startMemberName',
          width : '20%',
          sortable : true,
          align : 'left'
         
      }, {
            display : "${ctp:i18n('datarelation.tab.reTime.js')}",
            name : 'receiveTime',
            width : '16%',
            sortable : true,
            align : 'center'
           
       } ],
      managerName : "colDataRelationHandler",
      managerMethod : "getSelfCollData"
    });
    
    function rend(txt, data, r, c, col) {
        
        if("subject" == col.name){
            
            //加图标
            //重要程度
            var importIcon = "";
            if(data.importantLevel !="" && data.importantLevel != 1){
                importIcon = "<span class='ico16 important"+data.importantLevel+"_16 '></span>";
            }
            
          //流程状态
          /*   var stateIcon = "";
            if(data.state != null && data.state !="" && data.state != "0"){
                stateIcon = "<span class='ico16  flow"+data.state+"_16 '></span>" ;
            }
             */
            //附件
            var attIcon = "";
            if(data.hasAttsFlag == true){
                attIcon = "<span class='ico16 affix_16'></span>" ;
            }
            //协同类型
            var bodyIcon = "";
            if(data.bodyType!=""&&data.bodyType!=null&&data.bodyType!="10"&&data.bodyType!="30"){
                bodyIcon = "<span class='ico16 office"+data.bodyType+"_16'></span>";
            }
            
            //如果是代理 ，颜色变成蓝色
            var proxyColor = "";
            if (data.proxy) {
                proxyColor = "color_blue";
            }
            txt="<span class='grid_black " + proxyColor + "'>"+ txt +"</span>";
            
            txt =  importIcon + txt + attIcon + bodyIcon;
        }
        return txt;
    }
    
    function clk(data, r, c) {
      //$("#txt").val("clk:" + $.toJSON(data) + "[" + r + ":" + c + "]");
      //$('#selfCollDetail').attr("src","/seeyon/collaboration/collaboration.do?method=summary&openFrom=glwd&affairId=" + data.affairId);
    	//t.grid.resizeGridUpDown('middle');
    }
    function dblclk(data, r, c) {
    	var affairId = data.affairId;
    	if(sendToOther=="true"){
			var dataM = new dataRelationManager();
			affairId = dataM.getSenderAffairId(data.summaryId);
    	}
    	var url =_ctxPath+"/collaboration/collaboration.do?method=summary&openFrom=glwd&affairId=" + affairId;
        id = getMultyWindowId("id",url);
        openCtpWindow({
            "url"     : url,
            "id"		: id
        });
      //  t.grid.resizeGridUpDown('down');
    }
    
    var topSearchSize = 2;
    if($.browser.msie && $.browser.version=='6.0'){
        topSearchSize = 5;
    }
    var searchobj= $.searchCondition({
        top:topSearchSize,
        right:10,
        searchHandler: function(){
        	var val = searchobj.g.getReturnValue();
            if(val != null){
	        	o.subject = null;
	        	o.startMemberName = null;
	        	o.createDate = null;
	        	o.receiveDate = null;
	            var choose = $('#'+searchobj.p.id).find("option:selected").val();
	            if(choose == 'subject'){
	                o.subject = $('#title').val();
	            }else if(choose == 'startMemberName'){
	                o.startMemberName = $('#spender').val();
	            }else if(choose == 'createDate'){
	                var fromDate = $('#from_datetime').val();
	                var toDate = $('#to_datetime').val();
	                var date = fromDate+'#'+toDate;
	                o.createDate = date;
	            }else if(choose == 'receiveDate'){
	                var fromDate = $('#from_receivetime').val();
	                var toDate = $('#to_receivetime').val();
	                var date = fromDate+'#'+toDate;
	                o.receiveDate = date;
	            }
                $("#selfCollData").ajaxgridLoad(o);
            }
        },
        conditions: [{
            id: 'title',
            name: 'title',
            type: 'input',
            text: $.i18n("cannel.display.column.subject.label"),//标题
            value: 'subject',
            maxLength:100
        },{
            id: 'spender',
            name: 'spender',
            type: 'input',
            text: $.i18n("cannel.display.column.sendUser.label"),//发起人
            value: 'startMemberName'
        }, {
            id: 'datetime',
            name: 'datetime',
            type: 'datemulti',
            text: $.i18n("datarelation.tab.sTime.js"),//发起时间
            value: 'createDate',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }, {
            id:'receivetime',
            name:'receivetime',
            type:'datemulti',
            text: $.i18n("cannel.display.column.receiveTime.label"),//接受时间
            value:'receiveDate',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }]
    });
    searchobj.g.setCondition('title', '');
    
    var o = new Object();
  	o.id = "${param.pid}";//配置文件id
  	o.affairId = "${param.affairId}";
  	o.openFrom = "more";
    
    o.senderId = "${param.senderId}";
    o.memberId = "${param.memberId}";
    o.summaryId = "${param.summaryId}";

    
    $("#selfCollData").ajaxgridLoad(o);
  });
</script>
</head>
<body class="h100b over_hidden">
  <div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="layout_north" layout="height:30,sprit:false,border:false">
      <div id="toolbars"></div>
    </div>
    <div class="layout_center page_color over_hidden" layout="border:false">
      <table id="selfCollData" class="flexme3" style="display: none;">
      </table>
      <div id="grid_detail" class="h100b">
                <iframe id="selfCollDetail" name='selfCollDetailF' width="100%" height="100%" frameborder="0"  class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
      </div>
    </div>
  </div>
</body>
</html>