package com.seeyon.ctp.form.modules.engin.base.formData;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.seeyon.apps.collaboration.enums.ColHandleType;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.ctp.common.content.comment.Comment;
import com.seeyon.ctp.common.content.mainbody.CtpContentAllBean;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.DataContainer;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.form.bean.FormAuthViewBean;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormBindAuthBean;
import com.seeyon.ctp.form.bean.FormBindAuthBean.AuthName;
import com.seeyon.ctp.form.bean.FormDataBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormDataSubBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormQueryResult;
import com.seeyon.ctp.form.bean.FormQueryTypeEnum;
import com.seeyon.ctp.form.bean.FormQueryWhereClause;
import com.seeyon.ctp.form.vo.FormCalcParamVO;
import com.seeyon.ctp.form.vo.FormSearchFieldBaseBo;
import com.seeyon.ctp.form.vo.FormSearchFieldVO;
import com.seeyon.ctp.form.vo.FormTreeNode;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgAccount;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public interface FormDataManager {

    /**
     * 最大并发下载数
     */
    int TOTAL_DOWNLOAD_NUM = 0;

    /**
     * 最大并发批量操作数：包含批量修改/批量刷新/隐藏批量刷新
     */
    int TOTAL_BATCH_UPDATE_NUM = 0;

    void insertOrUpdateMasterData(FormDataMasterBean masterData) throws BusinessException, SQLException;

    /**
     * 批量保存表单数据
     * @param masterBeen 数据列表
     * @param formBean 表单对象
     * @throws BusinessException
     */
    void saveMasterData(List<FormDataMasterBean> masterBeen, FormBean formBean, boolean isUpdate, List<CtpContentAll> contentAlls) throws BusinessException, SQLException;

    /**
     * 计算出给定单元格在表单中所参与的所有计算结果
     *
     * @param form 表单
     * @param formFieldBean 指定字段
     * @param cacheMasterData 数据
     * @param recordId 重复表记录id
     * @param resultMap 返回结构map
     * @param authViewBean 权限
     * @param needHtml            是否需要表单单元格html字符串
     * @param needDealSysRelation 是否需要刷新系统条件类型的关联表单
     * @throws BusinessException 业务异常
     */
    void calcAllWithFieldIn(FormBean form, FormFieldBean formFieldBean, FormDataMasterBean cacheMasterData, Long recordId, Map<String, Object> resultMap, FormAuthViewBean authViewBean, boolean needHtml, boolean needDealSysRelation) throws BusinessException;

    /**
     * 系统自动条件选择类型关联表单
     * 说明：当单元格参与了系统条件判断，则当光标离开控件之后会将当前单元格的值传递到此方法
     * 方法负责找到当前单元格所参与的系统自动条件类型的关联表单进行条件判断查询，如果符合条
     * 件，则根据设置找到关联的值返回回填页面。
     *
     * @param fromFormBean
     * @param formcacheMasterData
     * @param fieldBean
     * @param currentOperation
     * @param recordId
     * @return
     * @throws BusinessException
     */
    public Map<String, Object> dealSysRelation(FormBean fromFormBean, FormDataMasterBean formcacheMasterData, FormFieldBean fieldBean, FormAuthViewBean currentOperation, Long recordId) throws BusinessException;

    /**
     *
     * @param fromFormBean
     * @param formcacheMasterData
     * @param fieldBean
     * @param currentOperation
     * @param recordId
     * @param refreshAttr 是否需要刷新关联系统关联表单附件字段的附件，true时，moduleId值不能为空
     * @param moduleId 对应正文id
     * @return
     * @throws BusinessException
     */
    public Map<String, Object> dealSysRelation(FormBean fromFormBean, FormDataMasterBean formcacheMasterData, FormFieldBean fieldBean, FormAuthViewBean currentOperation, Long recordId, boolean refreshAttr, Long moduleId,boolean needHtml) throws BusinessException;

    /**
     * 带条件的权限，条件满足之后处理权限的变更，变更之后的值保存在以字段名字为key，字段html为value的map中
     *
     * @param currentField    当前单元格
     * @param form            表单bean
     * @param oldAuthViewBean 当前打开表单的权限，用以过滤单元格权限没有修改的就不用做处理，提高性能
     * @param newAuthViewBean 条件满足之后需要转换为的条件
     * @param formDataBean    表单数据
     * @param resultMap       存放替换结果
     * @param needHtml        是否需要表单单元格html字符串
     * @return
     * @throws NumberFormatException
     * @throws BusinessException
     */
    public Map<String, Object> dealFormRightChangeResult(FormBean form, FormAuthViewBean newAuthViewBean, FormDataMasterBean formDataBean) throws NumberFormatException, BusinessException;

    /**
     * 表单递归计算方法
     *
     * @param form
     * @param resultFormFieldBean
     * @param cacheMasterData
     * @param recordId
     * @param resultMap
     * @param authViewBean
     * @param needHtml            是否需要表单单元格html字符串
     * @param needDealSysRelation 是否需要刷新关联
     * @throws BusinessException
     */
    public void calc(FormBean form, FormFieldBean resultFormFieldBean, FormDataMasterBean cacheMasterData, Long recordId, Map<String, Object> resultMap, FormAuthViewBean authViewBean, boolean needHtml, boolean needDealSysRelation) throws BusinessException;

    /**
     * 表单递归计算方法.
     * @param paramVO 刷新参数vo
     * @throws BusinessException
     */
    public void calc(FormCalcParamVO paramVO) throws BusinessException;

    /**
     * 表单全字段计算，将表单中有运算公式的单元格都计算一遍
     *
     * @param form
     * @param masterData
     * @param auth
     * @param needHtml是否需要表单单元格html字符串
     * @param needCalSN                是否需要计算流水号
     * @param needDealSysRelation      是否需要刷新系统条件类型的关联表单
     * @return
     * @throws BusinessException
     */
    public Map<String, Object> calcAll(FormBean form, FormDataMasterBean masterData, FormAuthViewBean auth, boolean needHtml, boolean needCalSN, boolean needDealSysRelation) throws BusinessException;

    /**
     *
     * @param form
     * @param masterData
     * @param auth
     * @param needHtml
     * @param needCalSN
     * @param needDealSysRelation
     * @param needAttr 是否需要刷新系统关联表单涉及的附件/图片/关联文档，此值为true时，moduleId值不能为空
     * @param moduleId 附件/图片/关联文档刷新时需要的正文id
     * @return
     * @throws BusinessException
     */
    public Map<String, Object> calcAll(FormCalcParamVO paramVO) throws BusinessException;

    /**
     * 获取添加行的json封装
     *
     * @param form
     * @param authViewBean
     * @param cacheMasterData
     * @param formDataBeans
     * @return
     * @throws BusinessException
     */
    public Set<DataContainer> getSubDataLineContainer(FormBean form, FormAuthViewBean authViewBean, FormDataMasterBean cacheMasterData, Set<FormDataSubBean> formDataBeans, Map<String, Object> resultMap) throws BusinessException;

    /**
     * 将前台提交的表单数据和后台缓存的表单数据进行增量合并
     *
     * @param masterData
     * @param cacheData
     * @param fb
     * @return
     */
    public void mergeFormData(FormDataMasterBean masterData, FormDataMasterBean cacheData, FormBean fb);

    /**
     * 接收前台提交的表单数据
     *
     * @param form
     * @param formMasterId
     * @return
     */
    public FormDataMasterBean procFormParam(FormBean form, Long formMasterId, Long rightId) throws BusinessException;

    /**
     * 添加删除重复项或者重复节处理函数
     *
     * @param formMasterId 表单主数据id
     * @param formId       表单id
     * @param rightId      当前编辑权限id
     * @param tableName    从表名字
     * @param type         操作类型
     *                     -copy:复制上一行
     *                     -empty:添加一行空行
     *                     -del:删除一行
     * @param recordId     对应于不同type有不同的含义
     *                     -type==copy时,recordId代表被复制的那一行的id
     *                     -type==empty时，recordId代表被复制的那一行的id
     *                     -type==del时，recordId代表被删除的那一行的id
     * @param data         在复制或者添加一行空数据的时候前端传过来的行数据
     * @return
     */
    public StringBuffer addOrDelDataSubBean(Long formMasterId, Long formId, Long rightId, String tableName, String type, Long recordId, Map<String, Object> data);

    /**
     * @param formId     无流程表单模板ID
     * @param ids
     * @param templateId
     * @return
     * @throws BusinessException
     * @throws SQLException
     */
    public boolean delFormData(Long formId, String ids, Long templateId) throws BusinessException, SQLException;

    /**
     * 删除无流程数据
     *
     * @param formId
     * @param ids
     * @param templateId
     * @param needLog
     * @return
     * @throws BusinessException
     * @throws SQLException
     */
    public boolean delFormData(Long formId, String ids, Long templateId, boolean needLog) throws BusinessException, SQLException;

    /**
     * 业务表单数据的导入
     *
     * @param formId
     * @param templeteId
     * @param fileId
     * @param rightId
     * @param repeat
     * @param unlockAuth
     * @param templeteTitle
     * @return
     */
    public String saveDataFromImportExcel(Long formId, Long templeteId, Long fileId, Long rightId, String repeat, int unlockAuth, String templeteTitle);

    /**
     * 加锁
     *
     * @param formId
     * @param ids
     * @param templateId
     * @return
     * @throws NumberFormatException
     * @throws BusinessException
     * @throws SQLException
     */
    public String setLock(Long formId, String ids, Long templateId) throws NumberFormatException, BusinessException, SQLException;

    /**
     * 解锁
     *
     * @param formId
     * @param ids
     * @param templateId
     * @return
     * @throws BusinessException
     * @throws SQLException
     */
    public boolean unLock(Long formId, String ids, Long templateId) throws BusinessException, SQLException;

    /**
     * 根据表单id查询该表单
     * *************************************************************************************************
     * 提取无流程关联表单的规则:
     * 1、关联基础数据->当前登录人员是否在使用者授权作为判断规则
     * 2、关联信息管理->循环该表单所有绑定，判断当前人员在使用者授权当中并且符合操作范围的数据的并集
     * 3、有流程表单    ->当前登录人员已发（流程以及流转完毕）列表以及表单授权授予当前登录者的列表
     * *************************************************************************************************
     *
     * @param flipInfo
     * @param params
     * @return
     * @throws BusinessException
     * @throws SQLException
     */
    public FlipInfo getFormMasterDataListByFormId(FlipInfo flipInfo, Map<String, Object> params) throws BusinessException, SQLException;

    /**
     * 根据表单id查询该表单
     * *************************************************************************************************
     * 提取无流程关联表单的规则:
     * 1、关联基础数据->当前登录人员是否在使用者授权作为判断规则
     * 2、关联信息管理->循环该表单所有绑定，判断当前人员在使用者授权当中并且符合操作范围的数据的并集
     * 3、有流程表单    ->当前登录人员已发（流程以及流转完毕）列表以及表单授权授予当前登录者的列表
     * *************************************************************************************************
     *
     * @param flipInfo
     * @param params
     * @param isExport
     * @return
     * @throws BusinessException
     * @throws SQLException
     */
    public FlipInfo getFormMasterDataListByFormId(FlipInfo flipInfo, Map<String, Object> params, boolean isExport) throws BusinessException, SQLException;

    /**
     * 更新表单数据状态、并执行流程表单相应的触发
     *
     * @param colSummary 需要更新状态的表单模板协同
     * @param affair     处理人对应的事项
     * @param type       操作类型
     * @param list       处理意见列表
     * @throws BusinessException
     * @throws SQLException
     */
    public void updateDataState(ColSummary colSummary, CtpAffair affair, ColHandleType type, List<Comment> list) throws BusinessException, SQLException;

    /**
     * 传人一个处理意见对象，把这个意见和对应协调历史意见合并，组装最新的流程意见控件值
     *
     * @param formId       表单id
     * @param colSummaryId 协同id
     * @param comment      意见对象
     * @return
     * @throws BusinessException
     */
    public Map<String, Object> getNewFlowDealOpitionValue(Long formId, ColSummary colSummary, Comment comment) throws BusinessException;

    /**
     * 根据recordId获取json格式的子表行数据
     *
     * @param param:masterId（主数据id） recordId（子表行id） formId（表单id） subTableName（子表名字）
     * @return
     */
    public String getJsonSubDataById(Map<String, Object> param);

    /**
     * 根据参数获取所选FormDataMasterBean列表，其中的FormDataMasterBean中的子表行已经根据参数进行过移除没选中行的操作
     *
     * @param selectArray
     * @param toFormBean
     * @return
     * @throws BusinessException
     */
    public List<FormDataMasterBean> findSelectedDataBeans(List<Map> selectArray, FormBean toFormBean, String relationType) throws BusinessException;

    /**
     * 获取无流程数据模板数据列头-字段的显示名称列表
     * idx:0为主表字段，其它为各个重复表字段
     *
     * @param form         表单
     * @param authViewBean 权限
     * @return 字段列表
     * @throws BusinessException
     */
    public List<List<FormFieldBean>> getFormFieldDisplayForImportAndExport(FormBean form, FormBindAuthBean bindAuthBean,AuthName authName) throws BusinessException;

    public boolean isFieldUnique(FormFieldBean ffb, String tableName, List<FormDataBean> dataList, List<FormDataBean> oldDataList) throws BusinessException;

    public boolean isFieldUnique(FormFieldBean ffb, String tableName, List<FormDataBean> dataList, List<FormDataBean> oldDataList, boolean needCheckSameValue) throws BusinessException;

    boolean isFieldUnique4FillBack(FormFieldBean ffb, String tableName, List<Object> dataList, List<Object> oldDataList) throws BusinessException;

    /**
     * 字段值是否满足唯一
     *
     * @param ffb
     * @param data
     * @param isNew
     * @return
     * @throws BusinessException
     */
    public boolean isFieldValue4Unique(FormFieldBean ffb, Object data, String isNew) throws BusinessException;

    /**
     * 用于ajax判断字段是否已经有数据满足数据唯一
     *
     * @param fieldName
     * @return
     * @throws BusinessException
     */
    public boolean isFieldHasUnique(String fieldName, String tableName) throws BusinessException;

    /**
     * 判断是否符合唯一标识。
     *
     * @param fb
     * @param formData
     * @param fieldList
     * @return
     * @throws BusinessException
     */
    public boolean isUniqueMarked(FormBean fb, FormDataMasterBean formData, List<String> fieldList) throws BusinessException;

    /**
     * 该方法用于前台ajax判断数据中是否已经有相同的数据满足唯一标识。如果满足，就不让设置了。
     *
     * @param formId
     * @param fieldList
     * @return
     * @throws BusinessException
     */
    public boolean isFieldHasUniqueMarked(String fieldList) throws BusinessException;

    /**
     * 替换字符串中的字段变量和系统变量，主要用于触发消息和流程标题用.
     *
     * @param fb
     * @param data
     * @return
     * @throws BusinessException
     */
    public String getReplaceMsg(String msg, FormBean fb, Map<String, Object> data, boolean needSubData) throws BusinessException;

    /**
     * 更新表单缓存数据状态，用于协同处理节点点击提交按钮时，在保存正文和入库数据前
     * 如果审核，核定为流程最后一个节点，且都是通过状态，则需要调用两次本方法
     * 第一次type参数为审核或者核定，第二次为flow
     *
     * @param formId 表单id
     * @param dataId 数据记录ID
     * @param type   更新状态分类，审核：audit；核定：vouch；流程结束：flow
     * @param state  需要更新到的状态，审核：3-不过，2-过；核定：2-不过，1-过；流程：0-未结束，1-已结束，3-终止
     * @return
     * @throws BusinessException
     */
    void updateDataState(Long formId, Long dataId, String type, int state) throws BusinessException;

    /**
     * 保存数据和创建新的contentAll并保存
     *
     * @param formBean   表单
     * @param masterBean 数据
     * @param creater    创建人
     * @param templateId 模板Id
     * @param title      标题
     * @throws BusinessException
     * @throws SQLException
     */
    void saveDataAndContent(FormBean formBean, FormDataMasterBean masterBean, long creater, long templateId, String title) throws BusinessException, SQLException;

    /**
     * 查询动态表的基础方法
     *
     * @param returnFields
     * @param table
     * @param whereId
     * @param id
     * @return
     * @throws BusinessException
     * @throws SQLException
     */
    public List<Map<String, Object>> getFormSlaveDataListById(String[] returnFields, String table, String whereId, List<Long> ids) throws BusinessException, SQLException;

    /**
     * 设置要显示的字段
     *
     * @param formBean
     * @param formDataList
     * @param showFieldList
     * @return
     */
    public Map<Long, List<List<String>>> setShowValueList(FormBean formBean, List<Map<String, Object>> formDataList, List<FormFieldBean> showFieldList, Map<Long, String> idMap) throws BusinessException;


    /**
     * 保存表单中的附件、图片、关联文档
     *
     * @param form
     * @param cacheMasterData
     * @param moduleId
     * @throws Exception
     */
    public void saveAttachments(FormBean form, FormDataMasterBean cacheMasterData, FormDataMasterBean frontMasterBean, Long moduleId, boolean justMerge) throws Exception;

    /**
     * 删除已经不在表单中存在的lbs数据
     *
     * @param cacheMasterData
     * @param type
     */
    public void deleteNotInFormDataLbs(FormDataMasterBean cacheMasterData, String type);

    public boolean updateDataState() throws BusinessException;

    /**
     * 信息管理支持快速修改功能方法。
     * 根据权限id,主表数据id,表单id，按照5步骤：
     * 1.加载表单数据。2刷新表单所有单元格初始值。3刷新所有计算。4进行数据唯一、唯一标示、校验规则校验
     * 5执行触发、回写。
     *
     * @param rightId
     * @param masterDataId
     * @param formId
     * @return
     * @throws BusinessException
     */
    public Map<String,Object> fixDefaultValue4HiddenRefresh(String rightId, List<String> masterDataIds, String formTemplateId, Long formId) throws BusinessException;

    public Map<String,Object> fixDefaultValue4HiddenRefresh(String rightId, List<String> masterDataIds, String formTemplateId, Long formId, boolean fromPortalet) throws BusinessException;

    /**
     * 重复表导出Excel模板
     *
     * @param form
     * @param authViewBean
     * @param tableName
     * @return
     * @throws BusinessException
     */
    public List<FormFieldBean> getRepeatFormFieldForImport(FormBean form, FormAuthViewBean authViewBean, String tableName) throws BusinessException;

    /**
     * ajax解析excel数据(导入重复表)
     *
     * @param params
     * @return
     * @throws BusinessException
     */
    public String dealExcelForImport(Map<String, Object> params, Map<String, Object> data) throws BusinessException;

    /**
     * 查询无流程数据，主要供无流程栏目选择单据时调用
     *
     * @param flipInfo
     * @param params
     * @param reverse  排序是否反转，用来控制取第一条或者最后一条数据,将原先正常情况下的最后一条数据变成第一条数据
     * @return
     * @throws BusinessException
     */
    public FlipInfo getFormData4SingleData(FlipInfo flipInfo,
                                           Map<String, Object> params, boolean reverse) throws BusinessException;

    /**
     * 无流程数据批量刷新
     *
     * @param moduleIds 数据ID
     * @param formId    表单ID
     * @return
     * @throws BusinessException
     */
    public String saveBatchRefresh(List<String> moduleIds, String formId, String moduleType,String formTemplateId) throws BusinessException;

    /**
     * 根据表单id，应用绑定id获取对应的批量修改前端展示的HTML
     *
     * @param formId     表单id
     * @param templateId 模板id
     * @return
     * @throws BusinessException
     */
    public List<Map<String, String>> getBatchUpdateHTML(Long formId, Long templateId) throws BusinessException;

    /**获取批量刷新进度条名称（根据能保证应用唯一性的原则创建）
     * @param formId 表单ID 
     * @param userId 人员ID
     * @return 进度条名称
     */
    public String getProgressName4UpdateData4BatchUpdate(String formId,String userId);
    
    /**获取当前特定操作进度
     * @param formId 表单ID
     * @param userId 人员ID
     * @return 进度
     */
    public String getProgress4UpdateData4BatchUpdate(String formId,String userId);
    /**
     * 批量更新表单数据
     * @param formId 需要更新表单ID
     * @param templateId 需要更新的模板Id
     * @param dataIds 需要更新的数据ID
     * @param updateType 对于空值的处理方式
     * @param data 新数据值
     * @return
     * @throws BusinessException
     */
    public Map<String,Object> updateData4BatchUpdate(String formId, String templateId,List<String> dataIds,String updateType,Map<String,String> data) throws BusinessException, SQLException;
    
    /**
     * 关联有表单，关联条件SQL转换
     * @param formBean
     * @param params
     * @return
     */
    public String getChangeFormFormulaSQL(FormBean formBean, Map<String, Object> params);
    
    /**
     * 表单公共查询接口
     * @param currentUserId 当前操作用户ID
     * @param flipInfo 分页组件对象
     * @param isNeedPage 是否需要分页
     * @param formBean 被查询的表单对象
     * @param templeteId 表单单据中的模板编号
     * @param queryType 查询类型
     * @param customCondition 自定义查询条件
     * @param customOrderBy 自定义排序字段
     * @param customShowFields 自定义查询显示字段
     * @param fromFormId 发起该查询的表单ID
     * @param fromRecordId 发起该查询的数据记录主键ID
     * @param fromDataId 表单数据ID
     * @param fromRelationAttrStr 关联表单关联属性信息
     * @param reverse 是否反转查询结果：将排序方式置反，将原先正常情况下的最后一条数据变成第一条数据
     * @return
     * @throws BusinessException
     */
    public FormQueryResult getFormQueryResult(Long currentUserId, FlipInfo flipInfo, boolean isNeedPage,
            FormBean formBean, Long templeteId, FormQueryTypeEnum queryType, FormQueryWhereClause customCondition,
          List<Map<String, Object>> customOrderBy, String[] customShowFields,FormQueryWhereClause relationSqlWhereClause,boolean reverse) throws BusinessException;
    
    /**
     * 获得表单关联查找条件WhereClause
     * @param formBean
     * @param params
     * @return
     */
    public FormQueryWhereClause getRelationConditionFormQueryWhereClause(FormBean formBean, Map<String, Object> params);
    
    public String checkBindsNum(Map<String, Object> params);

    /**
     * 添加下载记录到缓存，防止重复提交下载
     * @param formId 表单id
     * @param subReferenceId 二级引用id
     * @param userId 人员id
     */
    void addDownlaodRecord(Long formId, Long subReferenceId, Long userId);

    /**
     * 添加批量操作记录到缓存，防止重复提交
     * @param formId 表单id
     * @param subReferenceId 二级引用id
     * @param userId 人员id
     */
    void addBatchUpdateRecord(Long formId, Long subReferenceId, Long userId);

    Map<String,Object> canDownload(Long formId, Long subReferenceId, Long userId);

    Map<String,Object> canBatchUpdate(Long formId, Long subReferenceId, Long userId);

    void removeDownloadRecord(Long formId, Long subReferenceId, Long userId);

    void removeBatchUpdateRecord(Long formId, Long subReferenceId, Long userId);

    public void removeCacheRecord(Long formId, Long subReferenceId, Long userId, String key);

    /**
     * 后台生成表单中的每个控件的二维码内容，因为前端生成会有如下两个问题：
     * 1.前端生成二维码后，客户又修改了其他内容，但是没有点击重新生成二维码，导致二维码中的内容和实际的有差异；
     * 2.流程表单的moduleId在新建的时候为-1，会导致如果为url格式的二维码中的moduleId不正确，导致最终扫码打不开页面。
     * @param form
     * @param masterBean
     * @param contentAll
     * @throws BusinessException
     */
    public void refreshAllBarCode(FormBean form,FormDataMasterBean masterBean,CtpContentAllBean contentAll) throws BusinessException;

    /**
     * 根据重复表表间关系重新计算目标重复表的数据
     * @param formId 需要计算的表单id
     * @param masterBean 数据
     * @param tableName 需要计算的重复表表名
     * @param replaceOldValue 是否用新生成的值，替换旧的值
     * @return 计算结果
     */
    @AjaxAccess
    List<FormDataSubBean> calcRelationSubTable(FormBean fb, FormDataMasterBean masterBean, String tableName, boolean replaceOldValue) throws BusinessException;

    List<FormDataSubBean> calcRelationSubTable(FormBean fb, FormDataMasterBean masterBean, String tableName, boolean replaceOldValue, FormAuthViewBean authViewBean) throws BusinessException;

    /**
     * 根据重复表表间关系重新计算目标重复表的数据,计算表单包含的所有的表间关系
     * @param formId 表单id
     * @param masterBean 数据对象
     * @param replaceOldValue 是否用新生成的值，替换旧的值
     * @return 计算结果 <tableName:数据结果>
     */
    @AjaxAccess
    Map<String, List<FormDataSubBean>> calcAllRelationSubTable(Long formId, FormDataMasterBean masterBean, boolean replaceOldValue, FormAuthViewBean authViewBean, Map<String, Object> resultMap, boolean needDealSysRelation) throws BusinessException;

    List<FormDataSubBean>  calcRelationSubTable(FormBean fb, FormDataMasterBean masterBean, String tableName, FormAuthViewBean authViewBean, Map<String, Object> resultMap, boolean needDealSysRelation) throws BusinessException;

    /**
     * 移动端查询接口
     *
     * @param flipInfo 页面信息
     * @param param    查询参数
     */
    Map<String, Object> getQueryData4Phone(FlipInfo flipInfo, Map<String, Object> param) throws BusinessException;

    /**
     * 移动端查询接口 针对指标
     *
     * @param formId      表单ID
     * @param queryBeanId 查询对象ID
     * @param indicatorId 指标ID
     */
    Map<Long, Object> selectData4PhoneIndicator(Long formId, Long queryBeanId, Long indicatorId) throws BusinessException;

    /**
     * 批量更新数据 针对回写批量更新动态表使用 采用先删除后新增的方式 add by chenxb 2016-11-30
     * */
    void insertOrUpdateMasterData(List<FormDataMasterBean> masterBeanList) throws BusinessException, SQLException;

    /**
     * 批量删除数据
     * */
    void deleteMasterData(List<FormDataMasterBean> masterBeanList) throws BusinessException, SQLException;

    /**
     * 删除指定表单的指定数据
     * */
    void deleteData(Long masterId, FormBean formBean) throws BusinessException, SQLException;

    /**
     * 移动端看板查询栏目接口
     *
     * @param flipInfo 页面信息
     * @param param    查询参数
     */
    void getQuerySectionData4Phone(FlipInfo flipInfo, Map<String, Object> param) throws BusinessException;

    /**
     * 判断数据唯一标识 采用加数据转入中间表的方式进行处理 进行联合查询，如果不能查到数据或者只能查询到一条，则表示符合规则，如果多余1条，则表示违反了唯一标识规则
     *
     * @param fb        表单
     * @param fieldList 唯一标识组合
     * @return boolean true--不存在或者只有一条  false--存在多余1条
     */
    boolean isUniqueMarked(FormBean fb, List<String> fieldList, List<Object> valueList) throws BusinessException;

    /**
     * 校验数据唯一 方式采用数据唯一标识的方式
     *
     * @param fb        表单
     * @param fieldName 唯一字段
     * @return boolean true--不存在或者只有一条  false--存在多余1条
     */
    boolean isFieldUnique(FormBean fb, String fieldName, List<Object> valueList) throws BusinessException;
    
    /**
     * 无流程表单（信息管理） 数据查询 树结构<br>
     * 树形展现 部门、枚举
     * @return
     * @throws BusinessException
     */
    public List<FormTreeNode>  getUnflowFormQueryTree(Map params)  throws BusinessException;
    

    
    /**
     * 查询无流程表单（信息管理）设置的查询条件字段,返回第一个设置树形展现的节点
     * @return
     * @throws BusinessException
     */
    public FormSearchFieldBaseBo getUnfolwFormSearchFirstTreeField(Long formId,Long formTemplateId) throws BusinessException;
    
    /**
     * 获取radio、checkbox、select、date、datetime字段的html
     * @param formId
     * @param formTemplateId
     * @return
     * @throws BusinessException
     */
    public Map<String,String> convertUnflowFormQuery2Html4First(Long formId,Long formTemplateId)throws BusinessException;
    
    /**
     * 获取非radio、checkbox、select、date、datetime字段的html
     * @param formId
     * @param formTemplateId
     * @return
     * @throws BusinessException
     */
    public Map<String,String> convertUnflowFormQuery2Html4Others(Long formId,Long formTemplateId)throws BusinessException;
    /**
	 * 查询无流程表单（信息管理）设置的查询条件字段<br>
	 * @param formId
	 * @param formTemplateId
	 * @return
	 * @throws BusinessException
	 */
    public List<FormSearchFieldVO> findUnfolwFormSearchFieldVOs(Long formId,Long formTemplateId) throws BusinessException;
    /**
   	 * 根据查询条件获取表单数据<br>
   	 * @param flipInfo
   	 * @param params 查询参数
   	 * @return
   	 * @throws BusinessException
     * @throws SQLException 
   	 */
    public FlipInfo getFormMasterDataListBySearch(FlipInfo flipInfo, Map<String, Object> params,boolean forExpot) throws BusinessException, SQLException;
    /**
   	 * 获取表单数据总入口<br>
   	 * @param flipInfo
   	 * @param params 查询参数 queryType ：baseSearch --普通查询；highSearch--高级查询
   	 * @return
   	 * @throws BusinessException
     * @throws SQLException 
   	 */
    @AjaxAccess
    public FlipInfo getFormMasterDataList(FlipInfo flipInfo, Map<String, Object> params) throws BusinessException, SQLException;
    /**
     * 获取表单数据总入口<br>
     * @param flipInfo
     * @param params 查询参数 queryType ：baseSearch --普通查询；highSearch--高级查询
     * @param forExport  是否为导出
     * @return
     * @throws BusinessException
     * @throws SQLException
     */
    public FlipInfo getFormMasterDataList(FlipInfo flipInfo, Map<String, Object> params,boolean forExport) throws BusinessException, SQLException;
    /**
	 * 单位树
	 * @return
	 * @throws BusinessException
	 */
    @AjaxAccess
    public List<WebV3xOrgAccount> getAccountTree(Map<String, Object> params) throws BusinessException;
    /**
   	 * 查询枚举表单字段对应的枚举值
   	 * @return
   	 * @throws BusinessException
   	 */
    public List<CtpEnumItem> findEnumListByField(FormFieldBean fieldBean)throws BusinessException;
	
	boolean switchTemplate(String formId, String reference, String subReference, String fileId, String newTemplateName);

}
