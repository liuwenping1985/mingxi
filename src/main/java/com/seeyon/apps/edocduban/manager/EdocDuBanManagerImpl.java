package com.seeyon.apps.edocduban.manager;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.enums.CollaborationEnum;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.edocduban.po.EdocDubanPo;
import com.seeyon.apps.edocduban.po.EdocDubanSendPo;
import com.seeyon.apps.edocduban.vo.DubanInfoVo;
import com.seeyon.client.CTPRestClient;
import com.seeyon.client.CTPServiceClientManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.comment.CommentManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.dao.AttachmentDAO;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.*;
import com.seeyon.v3x.edoc.domain.EdocOpinion;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.exception.EdocException;
import com.seeyon.v3x.edoc.manager.EdocManager;
import com.seeyon.v3x.edoc.webmodel.EdocOpinionModel;
import com.seeyon.v3x.edoc.webmodel.EdocSummaryModel;
import net.sf.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.CollectionUtils;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;

public class EdocDuBanManagerImpl implements EdocDuBanManager {
    private final static Log LOGGER = LogFactory.getLog(EdocDuBanManagerImpl.class);
    private EdocManager edocManager;
    private AffairManager affairManager;
    private OrgManager orgManager;
    private final static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    private final static SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");

    public OrgManager getOrgManager() {
        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public AffairManager getAffairManager() {
        if (affairManager == null) {
            affairManager = (AffairManager) AppContext.getBean("affairManager");
        }
        return affairManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public EdocManager getEdocManager() {
        if (edocManager == null) {
            edocManager = (EdocManager) AppContext.getBean("edocManager");
        }
        return edocManager;
    }

    public void setEdocManager(EdocManager edocManager) {
        this.edocManager = edocManager;
    }

    public static CommentManager commentManager;

    public static CommentManager getCommentManager() {
        if (commentManager == null) {
            commentManager = (CommentManager) AppContext.getBean("commentManager");
        }
        return commentManager;
    }

    public static void setCommentManager(CommentManager commentManager) {
        EdocDuBanManagerImpl.commentManager = commentManager;
    }

    private CollaborationApi collaborationApi;

    public CollaborationApi getCollaborationApi() {
        return collaborationApi;
    }

    public void setCollaborationApi(CollaborationApi collaborationApi) {
        this.collaborationApi = collaborationApi;
    }


    private static final String selectSummary = " summary.id ," +
            "summary.completeTime," +
            "summary.subject," +
            "summary.docMark," +
            "summary.serialNo," +
            "summary.createTime," +
            "summary.sendTo," +
            "summary.startTime," +
            "summary.createPerson," +
            "summary.sendUnit," +
            "summary.sendDepartment," +
            "summary.templeteId, " +
            "summary.state, " +
            "summary.copyTo, " +
            "summary.reportTo," +
            "summary.archiveId," +
            "summary.edocType, " +
            "summary.docMark2," +
            "summary.orgAccountId,"+
            "summary.urgentLevel,"+
            "summary.formId,"+

            "affair.id";
    private static void make(Object[] object, EdocSummaryModel model) {
        EdocSummary summary = new EdocSummary();
        int n = 0;
        summary.setId(object[n] == null ? null : ((Number) object[n]).longValue());
        n++;
        summary.setCompleteTime((Timestamp) object[n++]);
        summary.setSubject((String) object[n++]);
        summary.setDocMark((String) object[n++]);
        summary.setSerialNo((String) object[n++]);
        summary.setCreateTime((Timestamp) object[n++]);
        summary.setSendTo((String) object[n++]);
        summary.setStartTime((Timestamp) object[n++]);
        summary.setCreatePerson((String) object[n++]);
        summary.setSendUnit((String) object[n++]);
        summary.setSendDepartment((String) object[n++]);
        summary.setTempleteId(object[n] == null ? null : ((Number) object[n]).longValue());
        n++;
        summary.setState(object[n] == null ? null : ((Number) object[n]).intValue());
        n++;
        summary.setCopyTo((String) object[n++]);
        summary.setReportTo((String) object[n++]);
        summary.setArchiveId(object[n] == null ? null : ((Number) object[n]).longValue());
        n++;
        summary.setEdocType(object[n] == null ? null : ((Number) object[n]).intValue());
        n++;
        summary.setDocMark2((String) object[n++]);
        summary.setOrgAccountId(object[n] == null ? null : ((Number) object[n]).longValue());
        n++;
        summary.setFormId(object[n] == null ? null : ((Number) object[n]).longValue());
        n++;
        model.setSummary(summary);
        model.setAffairId(object[n] == null ? null : ((Number) object[n]).longValue());
    }

    /**
     * 查询未办结的收文数据
     *
     * @param fi
     * @param params
     * @return
     */
    @Override
    public FlipInfo findedocSummaryList(FlipInfo fi, Map<String, Object> params) {
        if (CollectionUtils.isEmpty(params)) {
            return fi;
        }
        String type = params.get("type") + "";
        String sql = "";
        String condition = (String) params.get("condition");
        Map param = new HashMap<>();
        sql="select "+selectSummary+" from EdocSummary summary, CtpAffair affair ";
        if ("1".equals(type)) {
            sql += " where summary.edocType=1 and summary.state=0  and summary.id not in (select summaryId from EdocDubanPo) ";
        } else {
            sql += " , EdocDubanPo ed where  summary.id=ed.summaryId  ";
            List<Long> summaryIds;
            if ("2".equals(type)) {
                sql += " and ed.state=" + 0;
                summaryIds = DBAgent.find("select summaryId from  EdocDubanPo where state=0");
            } else {
                sql += " and ed.state<>" + 0;
                summaryIds = DBAgent.find("select summaryId from  EdocDubanPo where state<>0");
            }
            if (CollectionUtils.isEmpty(summaryIds)) {
                return fi;
            }
        }
        sql+=" and summary.id=affair.objectId and  affair.id in (" ;
        //sql+=" and summary.templeteId= 5575017435186873803 and summary.id=affair.objectId" ;
        //sql+=" and affair.state =2 and affair.app= 20 and affair.delete=0 ";
        sql+="  select max(affair.id) from EdocSummary summary, CtpAffair affair";
        sql+=" where summary.templeteId= 5575017435186873803  and summary.id=affair.objectId";
        sql+=" and affair.state in(2,3,4) and affair.app= 20 and affair.delete=0 ";

        if (isNotBlankQuery(params, "lwUnitId")) {
            String lwUnitId = (String) params.get("lwUnitId");
            sql += " and (summary.sendUnitId like :sendUnitId or summary.sendUnitId2 like :sendUnitId2)";
            param.put("sendUnitId", "%" + SQLWildcardUtil.escape(lwUnitId) + "%");
            param.put("sendUnitId2", "%" + SQLWildcardUtil.escape(lwUnitId) + "%");
        }
        if (isNotBlankQuery(params, "sendUnit")) {
            String lwUnitId = (String) params.get("sendUnit");
            sql += " and (summary.sendUnit like :sendUnit or summary.sendUnit2 like :sendUnit2)";
            param.put("sendUnit", "%" + SQLWildcardUtil.escape(lwUnitId) + "%");
            param.put("sendUnit2", "%" + SQLWildcardUtil.escape(lwUnitId) + "%");
        }
        if (isNotBlankQuery(params, "subject")) {
            String subject = (String) params.get("subject");
            sql += " and summary.subject like :subject ";
            param.put("subject", "%" + SQLWildcardUtil.escape(subject) + "%");
        }
        if (isNotBlankQuery(params, "docMark")) {
            String docMark = (String) params.get("docMark");
            sql += " and summary.docMark like :docMark ";
            param.put("docMark", "%" + docMark + "%");
        }
        if (isNotBlankQuery(params, "createTime")) {
            String createTime = (String) params.get("createTime");
            String[] valueArray = createTime.split(",");
            if (valueArray.length > 0 && Strings.isNotBlank(valueArray[0])) {//开始时间
                sql += " and (summary.createTime >= :startTimeBegin) ";
                param.put("startTimeBegin", Datetimes.getTodayFirstTime(valueArray[0]));
            }

            if (valueArray.length > 1 && Strings.isNotBlank(valueArray[1])) {//结束时间
                sql += " and (summary.createTime <= :startTimeEnd) ";
                param.put("startTimeEnd", Datetimes.getTodayLastTime(valueArray[1]));
            }
        }
        if (isNotBlankQuery(params,"startTime")) {
            String startTime = (String) params.get("startTime");
            sql += " and summary.createTime >= :startTime ";
            param.put("startTime", Datetimes.getTodayFirstTime(startTime));
        }
        if (isNotBlankQuery(params,"endTime")) {
            String endTime = (String) params.get("endTime");
            sql += " and summary.createTime <= :endTime";
            param.put("endTime", Datetimes.getTodayFirstTime(endTime));
        }
        String state = (String) params.get("state");
        if (isNotBlankQuery(params, "state") && !"0".equals(state)) {
            sql += " and summary.state = :state ";
            if ("1".equals(state)) {
                //已办结
                param.put("state", 3);
            } else if ("2".equals(state)) {
                //未办结
                param.put("state", 0);
            }
        }
        //承办人
        String undertaker = (String) params.get("undertaker");
        if (!Strings.isBlank(undertaker)) {
            sql += " and  summary.undertaker like '%" + undertaker + "%' ";
        }
        //文种

        //承办部门

        //来文等级 urgentLevel（特急、加急）
        String urgentLevel = (String) params.get("urgentLevel");
        if (!Strings.isBlank(urgentLevel) && !"0".equals(urgentLevel)) {
            sql += " and  summary.urgentLevel = '" + urgentLevel + "' ";
        }

        /*if ("compQuery".equals(condition)) {

        } else {
            if ("3".equals(type)) {
                sql += " and (summary.state = " + 0 + ") ";
            }
        }*/
        sql+="  group by summary.id) ";
        sql += " order by summary.createTime ";
        if ("1".equals(type)) {
            LOGGER.info("查询公文督办语句：" + sql);
        } else if ("2".equals(type)) {
            LOGGER.info("查询督办待确认语句：" + sql);
        } else {
            LOGGER.info("查询督办台账列表数据语句：" + sql);
        }
        List<Object> summaryList=new ArrayList<>();
        FlipInfo  flipInfo=fi;
        try{
            LOGGER.info("查询数据语句start：" + System.currentTimeMillis());
            summaryList = DBAgent.find(sql, param, fi);
            LOGGER.info("查询数据语句end：" + System.currentTimeMillis());
        }catch (Exception e){
            LOGGER.error("查询数据语句异常：",e);
        }
        try {
            List<EdocSummaryModel> models = new ArrayList<EdocSummaryModel>(summaryList.size());
            for (int i = 0; i < summaryList.size(); i++) {
                Object[] object = (Object[]) summaryList.get(i);
                EdocSummaryModel model = new EdocSummaryModel();
                make(object, model);
                models.add(model);
            }
            flipInfo = toDubanInfo(models, fi, type);
        }catch (Exception e){
            LOGGER.error("督办拼装数据异常：",e);
        }
        return flipInfo;
    }


    /**
     * 验证查询条件是否为空
     *
     * @param paramMap
     * @param queryField
     * @return
     */
    private boolean isNotBlankQuery(Map<String, Object> paramMap, String queryField) {

        boolean ret = false;

        Object value = paramMap.get(queryField);

        if (value != null && !"".equals(value)) {
            ret = true;
        }

        return ret;
    }

    private FlipInfo toDubanInfo(List<EdocSummaryModel> summaryList, FlipInfo fi, String type) {
        Map<Long, String> options = new HashMap<>();
        if ("3".equals(type)) {
            Map<Long, Long> idMaps = findIds(summaryList);
            List<Long> colsummaryIds = new ArrayList<>();
            if (!CollectionUtils.isEmpty(idMaps)) {
                for (Long formId : idMaps.keySet()) {
                    colsummaryIds.add(formId);
                }
                List<ColSummary> summarys = null;
                if (!CollectionUtils.isEmpty(colsummaryIds)) {
                    try {
                        summarys = collaborationApi.findColSummarys(colsummaryIds);
                    } catch (BusinessException e) {
                        e.printStackTrace();
                    }
                }
                //已结束的
                Map<Long, ColSummary> sumIds = new HashMap<>();
                ColSummary colSummary=null;
                //未结束的
               // Map<Long, ColSummary> sumIds1 = new HashMap<>();
                String formIds = "";
                if (!CollectionUtils.isEmpty(summarys)) {
                    for (ColSummary summary : summarys) {
                        if (summary.getFormRecordid() == null || summary.getFormAppid() == null) {
                            continue;
                        }
                        colSummary=summary;
                        boolean isFinish = Integer.valueOf(CollaborationEnum.flowState.finish.ordinal()).equals(summary.getState());
                        boolean isTerminate = Integer.valueOf(CollaborationEnum.flowState.terminate.ordinal()).equals(summary.getState());
                        if (isFinish || isTerminate) {
                            formIds += summary.getFormRecordid() + ",";
                            sumIds.put(summary.getFormRecordid(), summary);
                        }
                    }
                }
                if (!CollectionUtils.isEmpty(sumIds) && !Strings.isEmpty(formIds)) {
                    options = findOptions(idMaps, sumIds, formIds.substring(0, formIds.length() - 1),colSummary);
                }
                //取未执行完的数据   标题+当前待办人
                //options=findOptions(idMaps,sumIds1,formIds.substring(0,formIds.length()-1));
            }

        }

        List<DubanInfoVo> dubanInfoVos = new ArrayList<>();
        for (EdocSummaryModel summaryModel : summaryList) {
            EdocSummary summary = summaryModel.getSummary();
            if(summary==null){
                continue;
            }
            DubanInfoVo dubanInfoVo = new DubanInfoVo(summary);
            dubanInfoVo.setAffairId(summaryModel.getAffairId());
            Map<String, EdocOpinionModel> map = edocManager.getEdocOpinion(summary);
            if (map != null) {
                EdocOpinionModel niban = map.get("niban");
                if (niban != null) {
                    List<EdocOpinion> opinions = niban.getOpinions();
                    StringBuffer stringBuffer = setOpinions(opinions);
                    dubanInfoVo.setNibanOpinion(stringBuffer.substring(0, stringBuffer.length() - 1));
                }
                EdocOpinionModel pishiOpinionModel = map.get("pishi");
                if (pishiOpinionModel != null) {
                    List<EdocOpinion> opinions = pishiOpinionModel.getOpinions();
                    StringBuffer stringBuffer = setOpinions(opinions);
                    dubanInfoVo.setLeaderOpinion(stringBuffer.substring(0, stringBuffer.length() - 1));
                }
                EdocOpinionModel banli = map.get("banli");
                if (banli != null) {
                    List<EdocOpinion> banliOpinions = banli.getOpinions();
                    StringBuffer stringBuffer = setOpinions(banliOpinions);
                    dubanInfoVo.setTransactionOpinion(stringBuffer.substring(0, stringBuffer.length() - 1));
                }
                dubanInfoVos.add(dubanInfoVo);
            }
            if ("3".equals(type)) {
                //落实情况
                if (CollectionUtils.isEmpty(options)) {
                    dubanInfoVo.setWorkableOpinion("");
                } else {
                    String s = options.get(summary.getId());
                    dubanInfoVo.setWorkableOpinion(s);
                }
            }
            fi.setData(dubanInfoVos);
        }
        return fi;
    }

    private Map<Long, String> findOptions(Map<Long, Long> idMaps, Map<Long, ColSummary> sumIds, String formIds, ColSummary summary) {
        Map<Long, String> values = new HashMap();
        JDBCAgent jdbcTemplate = new JDBCAgent();
        try {
            FormBean formBean = FormService.getForm(summary.getFormAppid());
            FormFieldBean fieldBean = formBean.getFieldBeanByDisplay("反馈意见");
            String name = fieldBean.getName();
            String tableName = fieldBean.getOwnerTableName();
            if (Strings.isEmpty(name) || Strings.isEmpty(tableName)) {
                return null;
            }
            LOGGER.info(sumIds.size());
            String formsql = "select id," + name + " from " + tableName + " where id in(" + formIds + ") and " + name + " is not null order by start_date";
            LOGGER.info(formsql);
            jdbcTemplate.execute(formsql);
            List<Map<String, Object>> mapList = jdbcTemplate.resultSetToList();
            if (mapList == null && mapList.size() == 0) {
                return null;
            }
            for (Map<String, Object> diQuListMap : mapList) {
                Object formid = diQuListMap.get("id");
                Object formName = diQuListMap.get(name);
                if (formid == null || formBean == null) {
                    continue;
                }
                Long formRecordid = Long.valueOf(String.valueOf(formid));
                values.put(sumIds.get(formRecordid).getId(), String.valueOf(formName));
            }
        } catch (Exception e) {
            LOGGER.error("获取表单反馈意见异常" + e.getMessage());
        } finally {
            jdbcTemplate.close();
        }

        if (!CollectionUtils.isEmpty(idMaps) && !CollectionUtils.isEmpty(values)) {
            Map<Long, String> optionMaps = new HashMap<>();
            for (Long formId : idMaps.keySet()) {
                if (optionMaps.get(idMaps.get(formId)) == null) {
                    optionMaps.put(idMaps.get(formId), values.get(formId));
                } else {
                    String s = optionMaps.get(idMaps.get(formId));
                    String s1 = values.get(formId);
                    StringBuffer sb = new StringBuffer();
                    if (Strings.isEmpty(s) && !Strings.isEmpty(s1)) {
                        sb.append(s1);
                    } else if (Strings.isEmpty(s1) && !Strings.isEmpty(s)) {
                        sb.append(s);
                    } else if (!Strings.isEmpty(s1) && !Strings.isEmpty(s)) {
                        sb.append(s).append("\r\n").append(s1);
                    }
                    optionMaps.put(idMaps.get(formId), sb.toString());
                }
            }
            return optionMaps;
        }
        return null;
    }

    private Map<Long, Long> findIds(List<EdocSummaryModel> summaryList) {
        List<Long> summaryIds = new ArrayList<>();
        for (EdocSummaryModel summary : summaryList) {
            EdocSummary summary1 = summary.getSummary();
            if(summary1!=null){
                summaryIds.add(summary1.getId());
            }
        }
        List<EdocDubanSendPo> list = null;
        if (!CollectionUtils.isEmpty(summaryIds)) {
            if (summaryIds.size() > 800) {
                int curIndex = 0;
                while (true) {
                    if (curIndex >= summaryIds.size()) {
                        break;
                    }
                    int endIndex = curIndex + 800;
                    if (endIndex > summaryIds.size()) {
                        endIndex = summaryIds.size();
                    }
                    List<Long> tempList = summaryIds.subList(curIndex, endIndex);
                    String sql = "from EdocDubanSendPo where summaryId in(:summaryIds)";
                    Map params = new HashMap();
                    params.put("summaryIds", tempList);
                    list.addAll(DBAgent.find(sql, params));
                    curIndex = endIndex;
                }
            } else {
                String sql = "from EdocDubanSendPo where summaryId in(:summaryIds)";
                Map params = new HashMap();
                params.put("summaryIds", summaryIds);
                list = DBAgent.find(sql, params);
            }
        }
        Map<Long, Long> idMaps = new HashMap<>();
        if (!CollectionUtils.isEmpty(list)) {
            for (EdocDubanSendPo dubanSendPo : list) {
                idMaps.put(dubanSendPo.getFormId(), dubanSendPo.getSummaryId());
            }
        }
        return idMaps;

    }

    /**
     * 添加值到督办中
     *
     * @param summaryIds
     */
    @Override
    public boolean saveOrUpdateEdocDuban(String summaryIds, String type) {
        String[] ids = summaryIds.split(",");
        List<EdocDubanPo> dubanInfoVos = new ArrayList<>();
        if ("1".equals(type)) {
            for (String summaryId : ids) {
                EdocDubanPo edocDubanPo = new EdocDubanPo();
                Long smId = Long.valueOf(summaryId);
                edocDubanPo.setSummaryId(smId);
                edocDubanPo.setCreateTime(new Date(System.currentTimeMillis()));
                edocDubanPo.setIdIfNew();
                edocDubanPo.setState(0);
                dubanInfoVos.add(edocDubanPo);
            }
        } else {
            List<Long> summaryId = new ArrayList<>();
            for (String edocId : ids) {
                summaryId.add(Long.valueOf(edocId));
            }
            Map params = new HashMap();
            params.put("summaryId", summaryId);
            if (!CollectionUtils.isEmpty(summaryId)) {
                List<EdocDubanPo> list = DBAgent.find("from EdocDubanPo where summaryId in(:summaryId)", params);
                for (EdocDubanPo dubanPo : list) {
                    dubanPo.setState(1);
                    dubanPo.setUpdateTime(new Date(System.currentTimeMillis()));
                    dubanInfoVos.add(dubanPo);
                }
            }
        }
        if (!CollectionUtils.isEmpty(dubanInfoVos)) {
            try {
                DBAgent.mergeAll(dubanInfoVos);
                return true;
            } catch (Exception e) {
                LOGGER.error("创建督办数据异常", e);
                return false;
            }
        }
        return false;
    }

    /**
     * 回退督办
     * @param summaryIds
     * @param type
     * @return
     */
    @Override
    public boolean rollbackEdocDuban(String summaryIds, String type) {
        String[] ids = summaryIds.split(",");
        if ("3".equals(type)) {
            //回退到督办确认   删除流程数据，affairs  colsummary   删除发送督办记录     修改督办表状态为待0

        }else if("2".equals(type)){
            //回退到数据抽取
            Map params = new HashMap();
            List<Long> summaryId = new ArrayList<>();
            for (String edocId : ids) {
                summaryId.add(Long.valueOf(edocId));
            }
            params.put("summaryId", summaryId);
            List<EdocDubanPo> list = DBAgent.find("from EdocDubanPo where summaryId in(:summaryId)", params);
            if(CollectionUtils.isEmpty(list)){
                return false;
            }
            DBAgent.deleteAll(list);
            return true;
        }
        return false;
    }

    @Override
    public void deleteDuban(Long edocId) {
        List<EdocDubanSendPo> dubanSendPoList = DBAgent.find("from EdocDubanSendPo where summaryId ="+edocId);
        if(!CollectionUtils.isEmpty(dubanSendPoList)){
            DBAgent.deleteAll(dubanSendPoList);
        }
        List<EdocDubanPo> list = DBAgent.find("from EdocDubanPo where summaryId ="+edocId);
        if(!CollectionUtils.isEmpty(list)){
            DBAgent.deleteAll(list);
        }
    }

    /**
     * 发送督办
     *
     * @param edocId
     * @param memberIds
     */
    @Override
    public void sendOversee(Long edocId, String memberIds) {

        EdocSummary summary = null;
        try {
            summary = edocManager.getEdocSummaryById(edocId, false, false);
        } catch (EdocException e) {
            LOGGER.error("收文督办根据edocId获取summary异常：edocIDs="+edocId,e);
        }
        Set<V3xOrgMember> membersByTypeAndIds = null;
        try {
            membersByTypeAndIds = orgManager.getMembersByTypeAndIds(memberIds);
        } catch (BusinessException e) {
            LOGGER.error("收文督办获取将发送人员异常：memberIds="+memberIds,e);
        }
        List<CtpAffair> affairs = null;
        try {
            affairs = affairManager.getAffairs(edocId, StateEnum.col_sent);
        } catch (BusinessException e) {
            LOGGER.error("收文督办根据edocId获取affair异常异常：edocIDs="+edocId,e);
        }
        if (affairs == null || affairs.size() <= 0) {
            return;
        }
        CtpAffair affair = affairs.get(0);
        List<Long> flowIds = new ArrayList<>();
        if (membersByTypeAndIds != null && membersByTypeAndIds.size() > 0 && summary != null) {
            String name = AppContext.getSystemProperty("edocduban.restUserName");
            String password = AppContext.getSystemProperty("edocduban.restUserPwd");
            String ip = AppContext.getSystemProperty("edocduban.webServiceIp");
            String port = AppContext.getSystemProperty("edocduban.webServicePort");
            String fundformid = AppContext.getSystemProperty("edocduban.fundFormId");
            CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance(ip + ":" + port);
            CTPRestClient client = clientManager.getRestClient();
            // 一次性验证token
            client.authenticate(name, password);
            Map<String, Object> data = new HashMap<>();
            data.put("标题", summary.getSubject());
            String doc_mark = summary.getDocMark() == null ? summary.getDocMark2() : summary.getDocMark();
            if (Strings.isEmpty(doc_mark)) {
                doc_mark = "";
            }
            data.put("文号", doc_mark);
            data.put("收文日期", summary.getCreateTime() == null ? "" : sdf1.format(summary.getCreateTime()));
            data.put("来文单位", summary.getSendUnit());
            data.put("收文详情", summary.getId());
            JSONObject object = JSONObject.fromObject(data);
            Iterator<V3xOrgMember> members = membersByTypeAndIds.iterator();
            while (members.hasNext()) {
                V3xOrgMember orgMember = members.next();
                Map<String, Object> info = new HashMap<String, Object>();

                info.put("senderLoginName", orgMember.getLoginName());
                info.put("subject", "公文督办反馈单（" + orgMember.getName() + " " + sdf.format(new Date()) + "）");
                info.put("data", object.toString());
                info.put("param", "0");
                info.put("transfertype", "json");


                Long flowId1 = null;

                try {
                    flowId1 = client.post("/flow/" + fundformid, info, Long.class);
                } catch (Exception e) {
                    LOGGER.error("收文督办发送流程异常" + JSON.toJSONString(info), e);
                }
                LOGGER.info("收文督办发送流程flowId1="+flowId1 + JSON.toJSONString(info));
                if (flowId1 != null) {
                    flowIds.add(flowId1);
                }
            }
            if (!CollectionUtils.isEmpty(flowIds)) {
                saveAttachment(summary.getId(), flowIds, affair);
            }
        }


    }

    private void saveAttachment(Long summaryId, List<Long> flowIds, CtpAffair affair) {
        AttachmentDAO attachmentDAO = (AttachmentDAO) AppContext.getBean("attachmentDAO");
        List<EdocDubanSendPo> dubanSendPos = new ArrayList<>();
        List<Attachment> atts = new ArrayList<>();
        for (Long flowId : flowIds) {
            Attachment atta = new Attachment();
            atta.setIdIfNew();
            atta.setReference(flowId);
            atta.setSubReference(summaryId);
            atta.setCategory(2);
            atta.setType(2);
            atta.setSize(0L);
            atta.setFilename(affair.getSubject());
            atta.setFileUrl(affair.getId());
            atta.setMimeType("edoc");
            atta.setCreatedate(affair.getCreateDate());
            atta.setDescription(affair.getId() + "");
            atta.setGenesisId(affair.getId());
            atts.add(atta);

            EdocDubanSendPo dubanSendPo = new EdocDubanSendPo();
            dubanSendPo.setCreateDate(new Date(System.currentTimeMillis()));
            dubanSendPo.setFormId(flowId);
            dubanSendPo.setSummaryId(summaryId);
            dubanSendPo.setIdIfNew();
            dubanSendPos.add(dubanSendPo);
        }
        if (!CollectionUtils.isEmpty(dubanSendPos)) {
            DBAgent.mergeAll(dubanSendPos);
        }
        if (!CollectionUtils.isEmpty(atts)) {
            attachmentDAO.savePatchAll(atts);
        }
    }

    /**
     * 根据督办管理员获取处长
     *
     * @param user
     * @return
     */
    @Override
    public boolean isDubanAdminSection(User user) {
        List<V3xOrgMember> members = new ArrayList<V3xOrgMember>();
        try {
            members = orgManager.getMembersByRole(-1730833917365171641L, "公文督办管理员");
        } catch (BusinessException e) {
            LOGGER.error("获取督办管理员异常" + e);
        }
        if (CollectionUtils.isEmpty(members)) {
            return false;
        }
        List<Long> memberIds = new ArrayList<>();
        for (V3xOrgMember orgMember : members) {
            memberIds.add(orgMember.getOrgDepartmentId());
        }
        String sql = "select distinct m FROM OrgMember as m, OrgRelationship as orp,OrgPost as op  WHERE orp.sourceId = m.id " +
                "and orp.type = 'Member_Post' and orp.objective1Id = op.id and  op.deleted=false and m.id =" + user.getId() + " and  op.name like '%处长%' and m.orgDepartmentId in(:orgDepartmentIds)";
        Map params = new HashMap();
        params.put("orgDepartmentIds", memberIds);
        List list = DBAgent.find(sql, params);
        if (!CollectionUtils.isEmpty(list)) {
            return true;
        }
        return false;
    }

    public static void main(String[] args) {
        String url = "http://100.16.16.41";
        String userName = "ceshi1";
        String passWord = "123456";
        Map<String, Object> data = new HashMap<>();
        data.put("标题", "ceshi");
        String doc_mark = "";
        if (Strings.isEmpty(doc_mark)) {
            doc_mark = "1";
        }
        data.put("文号", doc_mark);
        data.put("收文日期", "2020-10-10");
        data.put("来文单位", "中国信达");
        data.put("收文详情", -7966013017563902989L);
        JSONObject object = JSONObject.fromObject(data);
        CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance(url);
        CTPRestClient client = clientManager.getRestClient();
        client.authenticate(userName, passWord);
        Map<String, Object> info = new HashMap<String, Object>();
        // 一次性验证token
        client.authenticate("ceshi1", "123456");
        info.put("attachments", new Long[]{-7966013017563902989L});
        List list = new ArrayList();
        list.add(-7966013017563902989L);
        info.put("formContentAtt", list);
        info.put("accountCode", "edoc|-7966013017563902989");
        info.put("senderLoginName", "jsbfkq");
        info.put("subject", "公文督办反馈单（ceshi" + sdf.format(new Date()) + "）");
        info.put("data", object.toString());
        info.put("param", "0");
        info.put("transfertype", "json");
        Long flowId1 = client.post("/flow/DB_20200922_003", info, Long.class);


        System.out.println(flowId1);
    }

    private StringBuffer setOpinions(List<EdocOpinion> opinions) {
        StringBuffer stringBuffer = new StringBuffer();
        for (EdocOpinion opinion : opinions) {
            stringBuffer.append(opinion.getDepartmentName()).append(":");
            try {
                V3xOrgMember member = orgManager.getMemberById(opinion.getCreateUserId());
                if (member != null) {
                    stringBuffer.append(member.getName()).append("  ");
                }
            } catch (BusinessException e) {
                LOGGER.error("收文督办获取人员名称异常：opinionId="+opinion.getId(),e);
            }
            String content = opinion.getContent();
            if (Strings.isEmpty(content)) {
                content = "";
            }
            stringBuffer.append(content);
            stringBuffer.append(sdf.format(opinion.getCreateTime())).append("\r\n");
        }
        return stringBuffer;
    }

    public String updateDubanState(String type, String summaryId) {
        if (Strings.isEmpty(type) || Strings.isEmpty(summaryId)) {
            return "参数为空，请校验后重新操作！";
        }
        Long edocId = Long.valueOf(summaryId);
        List<EdocDubanPo> list = DBAgent.find(" from EdocDubanPo  where summaryId=" + edocId);
        if (!CollectionUtils.isEmpty(list)) {
            for (EdocDubanPo edocDubanPo : list) {
                edocDubanPo.setState(Integer.valueOf(type));
                edocDubanPo.setUpdateTime(new Date(System.currentTimeMillis()));
            }
            DBAgent.mergeAll(list);
            return "1";
        }
        return "0";
    }

    /**
     * 根据公文id获取未提交反馈的标题+当前人员
     *
     * @param valueOf
     * @return
     */
    @Override
    public String findoptionsById(Long summaryId) {
        StringBuffer stringBuffer = new StringBuffer();
        String sql = " from EdocDubanSendPo where summaryId=" + summaryId;
        List<EdocDubanSendPo> list = DBAgent.find(sql);
        if (CollectionUtils.isEmpty(list)) {
            return "";
        }
        List<Long> colIds = new ArrayList<>();
        for (EdocDubanSendPo sendPo : list) {
            colIds.add(sendPo.getFormId());
        }
        List<ColSummary> summarys = null;
        try {
            summarys = collaborationApi.findColSummarys(colIds);

            if (summarys == null) {
                return "";
            }

            for (ColSummary summary : summarys) {
                boolean isFinish = Integer.valueOf(CollaborationEnum.flowState.finish.ordinal()).equals(summary.getState());
                boolean isTerminate = Integer.valueOf(CollaborationEnum.flowState.terminate.ordinal()).equals(summary.getState());
                if (isFinish || isTerminate || null != summary.getFinishDate()) {
                    continue;
                }
                String subject = summary.getSubject();
                stringBuffer.append(subject).append("&nbsp;&nbsp;&nbsp;&nbsp;").append("当前待办人：");
                String nodesInfo = ColUtil.parseCurrentNodesInfo(summary);
                stringBuffer.append(nodesInfo);
                stringBuffer.append("<br/>");
            }
        } catch (BusinessException e) {
            LOGGER.error("收文督办获取当前待办人员名称异常：summaryId="+summaryId,e);
        }
        return stringBuffer.toString();
    }
}
