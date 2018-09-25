// js开始处理
$(function() {
    //table
    pTemp.tab = officeTab().addAll(["assetNum","assetTypeName","assetName","assetBrand","assetModel","assetDesc","hasAmount","handleTime","useTime"]).init("myAssetTab", {
        argFunc : "fnTabItem4UsePub",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        render:fnUseTimeRenderPub,
        "managerName" : "assetUseManager",
        "managerMethod" : "findMyAssetList"
    });
    pTemp.tab.load();
});