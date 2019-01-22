package com.seeyon.apps.ztask.po;

import com.alibaba.fastjson.annotation.JSONField;
import com.alibaba.fastjson.serializer.ToStringSerializer;
import com.seeyon.apps.nbd.annotation.ClobText;
import com.seeyon.apps.platform.po.CommonPo;

import java.util.Date;

/**
 * 任务本体
 * Created by liuwenping on 2019/1/18.
 */
public class Task extends CommonPo{
    //任务名称
    private String title;

    //任务正文
    @ClobText
    private String content;

    //父任务id
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long parentTaskId;


    //根任务id
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long rootTaskId;

    //权重
    private Integer weight;

    //完成百分比 0-100
    private Integer progress;

    //单位所属id
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long accountId;

    //任务归属
    //任务所属人员
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long userId;
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long departmentId;

    private Date startDate;

    private Date endDate;

    private Integer status;

    private Integer subStatus;

    //创建人ID
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long createUserId;

    //
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long createDepartmentId;


    private String referenceId;
    /**
     * 督办人
     */
    private String supervisior;





}
