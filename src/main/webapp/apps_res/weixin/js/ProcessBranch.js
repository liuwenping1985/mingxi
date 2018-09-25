/**
 * Created by Ms on 2015/5/21.
 */

/*
     更多按钮的弹出  more
*/
//底部弹出按钮的列表
var moreto=document.getElementById('more');
var bottom_group=document.getElementById('bottom_groups');
var cancel=document.getElementById('cancel');
//移动监听事件
moreto.addEventListener('tap',function(){
    $(bottom_group).toggleClass('bottom_but_groups_toggle');
});
//普通点击事件
$('#more').click(function(){
    $('#bottom_groups').toggleClass('bottom_but_groups_toggle');
});
cancel.addEventListener('tap',function(){
    $('#bottom_groups').removeClass('bottom_but_groups_toggle');
});
$('#cancel').click(function(){
    $('#bottom_groups').removeClass('bottom_but_groups_toggle');
});




