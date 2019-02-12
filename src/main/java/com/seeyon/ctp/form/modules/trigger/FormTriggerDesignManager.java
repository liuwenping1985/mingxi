package com.seeyon.ctp.form.modules.trigger;

import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.util.FlipInfo;

import java.util.List;
import java.util.Map;

public interface FormTriggerDesignManager {

    public void saveTrigger4Cache(Map<String, String> baseInfo, List<Map<String, String>> actionList) throws BusinessException;

    public String deleteTrigger4Cache(List<String> ids);

    public Map<String, Object> editTrigger(String id) throws BusinessException;
    
    public Map<String, Object> copyTrigger(String id) throws BusinessException;

    public List<FormFieldBean> getOutwriteField(String formId) throws BusinessException;

    /**
     * 保存或更新回写设置
     *
     * @param fillBackList
     * @return
     * @throws BusinessException
     */
    public Object saveOrUpdateFillBackSet(List<Map<String, Object>> fillBackList) throws BusinessException;

    /**
     * ajax调用，用于取条件式中的重复表名字
     *
     * @param condition
     * @return 条件式中不包含重复表："",包含：重复表名
     * @throws BusinessException
     */
    public String getSubTableNameFromCondition(String condition) throws BusinessException;

    String getSubTableNameFromCondition(String condition,FormBean formBean) throws BusinessException;

    /**
     * ajax调用，用于取条件式中的重复表名字
     *
     * @param condition
     * @param needDefault 是否需要返回默认的重复表名：
     *                    true,如果只有一个重复表，则返回这个重复表名；false ，条件中包含重复表时才返回重复表名，不包含则返回空
     * @return 条件式中不包含重复表："",包含：重复表名
     * @throws BusinessException
     */
    public String getSubTableNameFromCondition(String condition, boolean needDefault) throws BusinessException;

    String getSubTableNameFromCondition(String condition,FormBean formBean,boolean needDefault);

    /**
     * 获取触发消息的消息模板中的重复表表名
     *
     * @param msg         消息模板
     * @param needDefault 是否需要返回默认的重复表名：
     *                    true,如果只有一个重复表，则返回这个重复表名；false ，条件中包含重复表时才返回重复表名，不包含则返回空
     * @return 消息模板包含的重复表对象列表
     * @throws BusinessException
     */
    public String getSubTableBean4Msg(String msg, boolean needDefault) throws BusinessException;

    /**
     * ajax 调用，判断流程发起人是否包含在条件式中字段所在的表中，根据结果决定是否需要修改发起人.
     *
     * @param condition
     * @param sender
     * @return 发起人是主表字段或者发起人是从表字段但条件式中包含该表，不需要修改，其他则需要修改
     * @throws BusinessException
     */
    public boolean senderIsSubField(String condition, String sender) throws BusinessException;

    /**
     * ajax 调用，判断消息接收人是否包含在条件式中字段所在的表中，根据结果决定是否需要修改发起人.
     * @param condition 条件式
     * @param msg 消息模板
     * @param sender 接收人
     * @return true 需要修改
     * @throws BusinessException
     */
    public boolean senderIsSubField(String condition, String msg, String sender) throws BusinessException;

    /**
     * 获取触发配置模板列表
     *
     * @param user      当前登录人员
     * @param condition 条件类型： subject 模板名称，categoryId 分类ID
     * @param textfield 条件类型值
     * @return 模板树的item  value：对应项ID，parentValue：分类ID，name：名称
     * @throws BusinessException
     */
    public List<Map<String, String>> getFormTemplateList(User user, String condition, String textfield, boolean isAll) throws BusinessException;

    public FlipInfo getFormTemplateList(FlipInfo fi, Map<String, Object> params) throws BusinessException;
    
    /**
     * 校验触发名称
     * @param triggerId
     * @param triggerName
     * @return
     */
    boolean validateTriggerName(String triggerId, String triggerName,String currentTypeStr);

    /**
     * 触发设置保存前的校验，校验死循环的可能性和触发名称是否重复
     * */
    String checkTriggerDeadCycle(String targetFormIds);
}
