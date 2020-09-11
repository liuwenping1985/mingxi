layui.use(["upload", "element", "form","laydate"], function () {
    var $ = layui.$, upload = layui.upload, element = layui.element, form = layui.form,laydate=layui.laydate;


    upload.render({
        elem: '#task_file_upload'
        , url: 'https://httpbin.org/post' //改成您自己的上传接口
        , done: function (res) {
            layer.msg('上传成功');
            layui.$('#uploaded_view').removeClass('layui-hide').find('img').attr('src', res.files.file);

        }
    });
    //xad-date
    laydate.render({
        elem: '#deadLine'
    });
    // laydate.render({
    //     elem: '#finishDate'
    // });
    form.render();
});



