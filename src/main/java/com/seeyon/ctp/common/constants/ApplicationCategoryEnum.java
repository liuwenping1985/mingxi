/**
 *
 */


package com.seeyon.ctp.common.constants;

/**
 * <pre>
 * 定义系统中所包含的应用下的子应用
 *
 * 一、枚举定义规范
 * 1、名称纯字母，不允许出现下划线
 * 2、key必须全局唯一
 *
 * 二、国际化要求：需要显示他对应的名称，这样来做：
 * 1、在com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources定义显示名称
 *    key的命名规范是 application.${key}.label; 如：application.26.label 表示"综合办公"
 * 2、在common\js\i18n\zh-cn.js定义显示名称<br>
 *    key的命名规范是 application_${key}_label; 如：application_26_label 表示"综合办公"
 *
 * 三、无序，禁止使用 {@link #ordinal()}
 * </pre>
 *
 * @author <a href="mailto:tanmf@seeyon.com">Tanmf</a>
 * @version 1.0 2006-11-3
 */
public enum ApplicationCategoryEnum {

    global(0), // 全局
    collaboration(1), // 协同应用
    form(2), // 表单
    doc(3), // 知识管理
    edoc(4), // 公文
    plan(5), // 计划
    meeting(6), // 会议
    bulletin(7), // 公告
    news(8), // 新闻
    bbs(9), // 讨论
    inquiry(10), // 调查
    calendar(11), // 日程事件
    mail(12), // 邮件
    organization(13),// 组织模型
    project(14), // 项目
    relateMember(15), // 关联人员
    exchange(16), // 交换
    hr(17), //人力资源
    blog(18), //博客
    edocSend(19), //发文
    edocRec(20),    //收文
    edocSign(21),    //签报
    exSend(22), //待发送公文
    exSign(23), //待签收公文
    edocRegister(24), //待登记公文
    communication(25), //在线交流
    office(26),//综合办公
    agent(27),//代理设置
    modifyPassword(28), //密码修改
    meetingroom(29), //会议室
    taskManage(30), //任务管理
    guestbook(31),    //留言板
    info(32), //信息报 送
    infoStat(33),  //信息报送统计
    edocRecDistribute(34),//收文分发
    notice(35),  //公示板
    attendance(36),    // 签到
    mobileAppMgrForHTML5(37), //移动应用接入-html5应用包
    sapPlugin(38), //sap插件
    ThirdPartyIntegration(39), //第三方整合
    show(40),//大秀
    wfanalysis(41),//流程绩效
    behavioranalysis(42),//行为绩效，足迹(cmp)


    biz(43), //业务生成器(cmp)
    commons(44), //公共资源(cmp)
    workflow(45), //工作流(cmp)
    //footprint(46)足迹(cmp)已合并到行为绩效中
    unflowform(47), //无流程表单(cmp)
    formqueyreport(48), //表单查询统计(cmp)
    cmp(49), //cmp
    dee(51), //dee模块(cmp)

    application(52), //应用模块(m3)
    m3commons(53), //公共资源(m3)
    login(54), //登陆(m3)
    message(55), //消息模块(m3)
    my(56), //我的模块(m3)
    search(57), //搜索模块(m3)
    todo(58), //待办模块(m3)
    //index(59),//全文检索(m3)未使用
    mycollection(60),//我的收藏(m3)
    uc(61),//UC(m3)
    addressbook(62),//通讯录(m3)
    seeyonreport(63),//帆软报表
    statusRemind(64),//状态提醒
    portal(65),//H5门户(m3)
    bjzl(501); //公文背景资料 赵辉 添加(信达pc)

    // 标识 用于数据库存储
    private int key;

    ApplicationCategoryEnum(int key) {
        this.key = key;
    }

    public int getKey() {
        return this.key;
    }

    public int key() {
        return this.key;
    }

    /**
     * 根据key得到枚举类型
     *
     * @param key
     * @return
     */
    public static ApplicationCategoryEnum valueOf(int key) {
        ApplicationCategoryEnum[] enums = ApplicationCategoryEnum.values();

        if (enums != null) {
            for (ApplicationCategoryEnum enum1 : enums) {
                if (enum1.key() == key) {
                    return enum1;
                }
            }
        }

        return null;
    }

}