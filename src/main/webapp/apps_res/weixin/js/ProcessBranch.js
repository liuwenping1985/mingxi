/**
 * Created by Ms on 2015/5/21.
 */

/*
     ���ఴť�ĵ���  more
*/
//�ײ�������ť���б�
var moreto=document.getElementById('more');
var bottom_group=document.getElementById('bottom_groups');
var cancel=document.getElementById('cancel');
//�ƶ������¼�
moreto.addEventListener('tap',function(){
    $(bottom_group).toggleClass('bottom_but_groups_toggle');
});
//��ͨ����¼�
$('#more').click(function(){
    $('#bottom_groups').toggleClass('bottom_but_groups_toggle');
});
cancel.addEventListener('tap',function(){
    $('#bottom_groups').removeClass('bottom_but_groups_toggle');
});
$('#cancel').click(function(){
    $('#bottom_groups').removeClass('bottom_but_groups_toggle');
});




