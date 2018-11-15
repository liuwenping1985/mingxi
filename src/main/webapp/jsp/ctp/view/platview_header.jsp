<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    <style type="text/css">
      body,html,ul{
        list-style-type:none;
        color: #fff;
        font-size: 14px;
        overflow:hidden;
        height:100%;
        padding:0px;
        margin:0px;
        font-weight:lighter;
        font-family:'Microsoft YaHei',微软雅黑;
    }
    ::-webkit-scrollbar {
      width: 8px;
      height: 8px;
     margin-right: 10px;
    }
    ::-webkit-scrollbar-thumb {
      background-color: #c3c3c3;
      border-radius: 3px;

    }
    ::-webkit-scrollbar-thumb:hover {
      background-color: #7e7e7e;
    }
    ::-webkit-scrollbar-thumb:active {
      background-color: #7e7e7e;
    }
    /*公共样式*/
    .icon16{
        display: inline-block;
        vertical-align: middle;
        height: 16px;
        width: 16px;
        line-height: 16px;
        background: url(${path}/common/platview/img/icon16.png) no-repeat;
        background-position: 0 0;
        cursor: pointer;
    }
    .pc_up_16{
        background-position: 0 0; 
    }
    .pc_down_16{
        background-position: -16px 0; 
    }
    .margin_l_5{
        margin-left: 5px;
    }



     /*checkbox 框样式*/

    /*pc_index.html*/
    .body_main{
        width: 100%;
        min-width: 1024px;
        height: 100%;
        background: url("${path}/common/platview/img/pc_body.png") no-repeat;
        background-image:none\9; 
        filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='${path}/common/platview/img/pc_body.png', sizingMethod='scale')\9; 
        
        background-size: cover;
        -moz-background-size:100% 100%;
        -webkit-background-size:100% 100%;
        margin: 0 auto;
        z-index: 11;
    }
    .index_head{
        position: absolute;
        top: 0;
        z-index: 5;
        width: 100%;
        height: 60px;
        line-height: 60px;
        color: #fff;
        background: rgba(4,26,50,.5)!important;
        background: #041a32;
        filter:alpha(opacity=50);
    }
    .index_head .left{
        position: relative;
        padding-left: 20px;
        font-size: 18px;
    }
    .head_right{
         position: relative;
        margin-right: 20px;
    }
    .set_span,.exit_span{
        display: inline-block;
        width: 38px;
        text-align: center;
    }
    .set_span img,.exit_span img{
        opacity: 0.7;
        filter:alpha(opacity=70);
    }
    .set_span:hover img,.exit_span:hover img{
        opacity: 1;
        filter:alpha(opacity=100);
    }
    .iframe_body{
        width: 100%;
        position: absolute;
        text-align: center;
        top: 60px;
        bottom: 50px;
        z-index: 1;
    }
    /*pc_body.html*/
    .body_auto{
        display: inline-block;
        width: 100%;
        height: 100%;
        background: url("${path}/common/platview/img/pc_body.png") no-repeat;
        background-image:none\9; 
        filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='${path}/common/platview/img/pc_body.png', sizingMethod='scale')\9; 
        background-size: cover;
        -moz-background-size:100% 100%;
        -webkit-background-size:100% 100%;
        margin: 0 auto;
        z-index: 11;
    }
    .body_html,.second_body_html{
        height: 100%;
        width: 100%;
    }
    .index_body{
        position: absolute;
        text-align: center;
        width: 100%;
        height: 100%;
        top: 0px;
        z-index: 10;
    }
    .second_index_body{
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0px;
        z-index: 10;
    }
    .index_foot{
        text-align: center;
        line-height: 50px;
        color: #fff;
        position: absolute;
        bottom: 0;
        height: 50px;
        width: 100%;
        background: rgba(4,26,50,.3)!important;
        background: #041a32;
        filter:alpha(opacity=30);
    }
    .index_foot span{
        position: relative;
        font-size: 12px;
    }
    .left{
        float: left;
    }
    .right{
        float: right;
    }
    .logo{
        width: 35px;
        height: 32px;
        overflow: hidden; 
        vertical-align: middle;
    }
    .user img,.set img{
        vertical-align: middle;
    }
    .opacity70{
        opacity: 0.7;
        filter:alpha(opacity=70);
    }
    .banner_line{
        width: 1px;
        height: 19px;
        border-left: 1px solid #fff;
        opacity: 0.15;
        filter:alpha(opacity=15);
        margin-top: 20px;
        margin-right: 15px;
        margin-left: 20px;
    }
    .margin_r_5{
        margin-right: 5px;
    }
    .body_ul{
        display: inline-block;
        width: 100%;
        min-width: 1024px;
        text-align: center;
        padding: 0px;
        height: 100%;
        overflow-y: auto;
        
    }
    .body_ul .li_single{
        float: left;
        width:19.5%; 
        min-width: 200px;
        display: inline-block;
        text-align: center;
    }
    .transform_info{
        display: inline-block;
        padding: 0;
        margin: 0;
       
        width: 115px;
        height: 115px;
        position: relative;
    }
    .circle{
        padding: 0;
        margin: 0;
       
        width: 115px;
        height: 115px;
        background: url(${path}/common/platview/img/circle.png) no-repeat;
        -webkit-transition: -webkit-transform 0.5s ease-out;
        -moz-transition: -moz-transform 0.5s ease-out;
        -o-transition: -o-transform 0.5s ease-out;
        -ms-transition: -ms-transform 0.5s ease-out ;

    }
    .li_header_img{
        position: absolute;
        left: 23px;
        top: 25px;
    }
    .li_single{
        margin-top: 75px;
    }
    .li_double{
        margin-top: 126px;
    }
    .second_ul{
        padding: 0;
        margin-left: 5px;
        text-align: left;
        height: auto;
    }
    .second_ul li{
        width: 100%;
        float: left;
    }
    .second_ul li span{
        cursor: pointer;
    }
    .second_ul .sort_type{
        color: #fff;
        height: auto;
        margin-bottom: 9px;
        cursor: pointer;
    }
    .sort_name{
        height: 45px;
        line-height: 45px;
        color: #ffc102;
        font-size: 20px;
    }
    .down_up{
        margin: 0px 5px 2px 0px; 
        opacity: 0.5;
        filter:alpha(opacity=50);
    }
    .small_circle{
        width: 6px;
        height: 6px;
        border-radius: 50%;
        background: #fff;
        opacity: 0.5;
        filter:alpha(opacity=50);
        margin: 0px 8px 2px 0px; 
        display: inline-block;
    }
    .third_ul{
        text-align: left;
        padding: 0;
        height: auto;
    }
    .second_ul_span{
        width: 100%;
    }
     .third_ul li{
        margin: 8px 0px 0px 20px;
        text-align: left;
        color: #fff;
        cursor: pointer;
     }
     .pointer{
        cursor: pointer;
     }

     /*pc_info.html*/
     .body_infos{
        width: 100%;
        height: 100%;
        min-width: 1024px;
        background: url("${path}/common/platview/img/pc_info_body.png") no-repeat center #eaf4fe;
        background-image:none\9; 
        filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='${path}/common/platview/img/pc_info_body.png', sizingMethod='scale')\9; 
        background-size: cover;
        -moz-background-size:100% 100%;
        -webkit-background-size:100% 100%;
        margin: 0 auto;
        z-index: 11;
     }
     .body_info{
        display: inline-block;
        width: 100%;
        height: 100%;
        min-width: 1024px;
        background: url("${path}/common/platview/img/pc_info_body.png") no-repeat center #eaf4fe;
        background-image:none\9; 
        filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='${path}/common/platview/img/pc_info_body.png', sizingMethod='scale')\9; 
        background-size: cover;
        -moz-background-size:100% 100%;
        -webkit-background-size:100% 100%;
        margin: 0 auto;
        z-index: 11;
     }
     .info_head{
        position: absolute;
        top: 0;
        height: 60px;
        line-height: 60px;
        width: 100%;
         background: url("${path}/common/platview/img/info_head.png") no-repeat center #eaf4fe;
        background-image:none\9; 
        filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='${path}/common/platview/img/info_head.png', sizingMethod='scale')\9; 
        background-size: cover;
        -moz-background-size:100% 100%;
        -webkit-background-size:100% 100%;
        z-index: 5;
     }
     .info_head_logo{
        margin-left: 15px;
        font-size: 18px;
     }
     .info_head_logo img{
        width: 40px;
        height: 36px;
        margin-right: 10px;
        vertical-align: middle;
        display: inline-block;
        /*opacity: 0.8;
        filter:alpha(opacity=80);*/
     }
     #second_iframe{
        width: 100%;
        height: 100%;
        position: absolute;
        top: 60px;
        z-index: 1;
     }
     .info_body{
        width: 100%;
        height: 100%;
        /*padding-bottom: 20px;*/
        overflow: auto;
        position: relative;
        z-index: 10;
        
     }
     .hide_table_handle{
        float: right;
        margin:15px 55px 10px 0;
        display: inline-block;
        color: #103e75;
     }
     .hide_table_handle input{
        margin-bottom: -1px;
     }
     .servise_info{
        position: relative;
        clear: both;
        margin-right: 55px;
        margin-left: 55px;
     }
     .servise_info h1{
        font-size: 30px;
        margin-bottom: 20px;
        font-weight: normal;
        color: #103d75;
     }
     .servise_info .servise_info_span{
        font-size: 30px;
        margin-bottom: 10px;
        color: #103d75;
        margin-top: 35px;
        display: inline-block;
     }
     .info_table{
        border:solid #5687ba;
        border-width:1px 0px 0px 1px;
        width: 100%;
     }
     .info_table td{
        height: 33px;
        line-height: 33px;
        border:solid #5687ba;
        border-width:0px 1px 1px 0px;
        text-align: center;
        color: #000;
     }
    .info_table th{
        height: 33px;
        line-height: 33px;
     }
    .info_table .blue_td{
        background: #1e5fa8;
        color: #fff;
     }
    .meter_infos{
       margin-left: 10px;
    }
    .meter_img img{
         margin-bottom: 25px;
    }
    .servise_info span.tables_hide{
        color: #103e75;
        opacity: 0.8;
        filter:alpha(opacity=80);
        font-size: 14px;
        margin-bottom: 5px;
        margin-top: 0px;
        display: inline-block;
        cursor: default;
    }
    .tables_hide em{
        margin-left: 3px;
    }
     .dialog_main_body{
        color:#000;
     }
     .dialog_main_footer{
        color:#fff;
     }
     .echartsarea{
        float:left;
     }
    </style>
