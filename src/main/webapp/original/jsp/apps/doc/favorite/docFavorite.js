
/*************************************** 收藏 ******************************************************
 * appName:应用 枚举key; 
 * id:要归档的源数据id；附件的url
 * hasAtts:是否含有附件
 * type：是否附件收藏，默认false（正文收藏） 否则 true(附件收藏)
 */
function favorite_v3x(appName, id, hasAtts, type){
  if(typeof(type) == 'undefined') type = "false";
  var returnval = v3x.openWindow({
    url : v3x.baseURL+"/doc/knowledgeController.do?method=docFavorite&sourceId="+id+"&appName=" + appName + "&hasAtts=" + hasAtts + "&favoriteType="+type+"&t="+getUUID(),
    width : "300",
    height : "400"     
  });

  if (returnval == undefined)
    returnval = "cancel";
  return returnval;
}
var  dialog;
function favorite(appName, id, hasAtts,type){
  dialog = $.dialog({
       url: "/seeyon/doc/knowledgeController.do?method=docFavorite&sourceId="+id+"&appName=" + appName + "&hasAtts=" + hasAtts + "&favoriteType="+type+"&t="+getUUID(),
       width: 300,
       height:400,
       title: $.i18n('doc.collect')
   });
}