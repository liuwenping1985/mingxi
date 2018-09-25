
 function loadStyle() {
	//初始化布局
    new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 30,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
}
 
 function setGridWidthAndHeight() {
    $(".flexigrid").css("height", "100%");
    $(".flexigrid").css("width", "100%");
    $(".bDiv").css("height", $(".flexigrid").height()-$(".pDiv").height()-$(".hDiv").height()-5);
 }

 //列表单击事件
 function statclk(data, r, c) {
     var summaryId = data.summaryId;
     var govdocType = data.govdocType;
     var affairId = data.affairId;
     openDetail4ColSummary(summaryId,affairId,govdocType);
 }
 //列表双击事件
 function statdblclk(data, r, c){
     var summaryId = data.summaryId;
     var govdocType = data.govdocType;
     var affairId = data.affairId;
     openDetail4ColSummary(summaryId,affairId,govdocType);
 }
 //打开页面
 function openDetail4ColSummary(summaryId,affairId,govdocType){
     //新公文的
     var _url = "/seeyon/collaboration/collaboration.do?method=summary&openFrom=formQuery&summaryId=" + summaryId;
     if(govdocType==0){ //老公文
         //老公文打开和新的公文打开的方式不一样
         _url = "/seeyon/edocController.do?method=detail&openFrom=glwd&summaryId="+summaryId+"&affairId="+affairId;
     }
     /*v3x.openWindow({
         url: _url,
         FullScrean: 'yes',
         workSpace: 'yes',
         dialogType: 'modal'
     });*/
     //用v3x.openWindow会导致ie报错
     window.open(_url);
 }