//判断意见是否为空
function dealCommentTrue(){
    //节点权限和意见，如果节点权限选择了意见必填，添加校验
    if($.trim($("#content_deal_comment").val()) === "" && $("#canDeleteORarchive").val() === "true"){
        $.alert($.i18n('collaboration.common.deafult.dealCommentNotNull'));
        return false;
    }
    return true;
}

