package com.seeyon.apps.kdXdtzXc.scheduled;

import com.seeyon.apps.collaboration.batch.BatchResult;
import com.seeyon.apps.collaboration.batch.manager.BatchManager;
import com.seeyon.apps.kdXdtzXc.KimdeConstant;
import com.seeyon.apps.kdXdtzXc.base.util.StringUtilsExt;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.TokenUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.GlobalNames;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.sso.SSOTicketManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.v3x.common.web.login.CurrentUser;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.*;

/**
 * Created by tap-pcng43 on 2017-8-17.
 */
public class AutoDoneScheduled {
    public  static Long l1=0L;

    private JdbcTemplate jdbcTemplate;
    private BatchManager batchManager;
    private OrgManager orgManager;

    public JdbcTemplate getJdbcTemplate() {
        return jdbcTemplate;
    }

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public BatchManager getBatchManager() {
        return batchManager;
    }

    public void setBatchManager(BatchManager batchManager) {
        this.batchManager = batchManager;
    }

    public OrgManager getOrgManager() {
        return orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void doneAffair() {
        try {
            String login_name = PropertiesUtils.getInstance().get("auto_send_user") + "";
            if (StringUtilsExt.isNullOrNone(login_name)) {
                return;
            }
            l1++;

            System.out.println("自動处理，序号："+l1+"......start");
            JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
            BatchManager batchManager = (BatchManager) AppContext.getBean("batchManager");
            OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");

            List<Map<String, Object>> list = jdbcTemplate.queryForList("SELECT id as affairId, object_id  as summaryId ,SUBJECT FROM ctp_affair WHERE state=3 and app=1 AND member_id=(SELECT member_id FROM  org_principal WHERE login_name='" + login_name + "' )");
            if (list != null) {
                System.out.println("本次自动处理，发现记录数量===" + list.size() + "," + ToolkitUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
            }
            SSOTicketManager.TicketInfo ticketInfo = TokenUtil.getDetailToken(login_name);
            if (ticketInfo == null) {
                throw new Exception("ticket获取为空，。。。。");
            }
            System.out.println("ticket===" + ticketInfo.getUsername() + "--" + ticketInfo.getMemberId() + "");
            System.out.println();

            User user = new User();
            V3xOrgMember member = orgManager.getMemberByLoginName(login_name);
            if (StringUtilsExt.isNullOrNone(member)) {
                return;
            }

            user.setAccountId(member.getOrgAccountId());
            user.setId(member.getId());
            user.setLoginName(member.getLoginName());
            user.setName(member.getName());
            user.setDepartmentId(member.getOrgDepartmentId());
            user.setLevelId(member.getOrgLevelId());
            user.setPostId(member.getOrgPostId());
            user.setLoginAccount(member.getOrgAccountId());
            AppContext.putThreadContext(GlobalNames.SESSION_CONTEXT_USERINFO_KEY, user);
            CurrentUser.set(user);

            //

            int ii = 0;
            for (Map<String, Object> m : list) {
                String _affairId = m.get("affairId") + "";
                String _summaryId = m.get("summaryId") + "";
                String _subject = m.get("subject") + "";
                System.out.println("自动处理信息：" + _subject);
                System.out.println("affairId：" + _affairId);
                System.out.println("summaryId：" + _summaryId);
                ii++;
                System.out.println("处理第" + ii + "个");
                if (KimdeConstant.NOT_PARSE_AUTO.contains(_affairId)) {
                    System.out.println("此AffairID=" + _affairId + "，之前处理故障，本次跳过不处理");
                    continue;
                }

                List<String> _affairIds = new ArrayList<String>();
                List<String> _summaryIds = new ArrayList<String>();
                List<String> _categorys = new ArrayList<String>();
                _affairIds.add(_affairId);
                _summaryIds.add(_summaryId);
                _categorys.add("1");

                try {
                    Map map = new HashMap();
                    map.put("affairs", _affairIds);
                    map.put("summarys", _summaryIds);
                    map.put("categorys", _categorys);

                    BatchResult[] brs = batchManager.checkPreBatch(map);
                    _affairIds.clear();
                    _summaryIds.clear();
                    _categorys.clear();
                    BatchResult br = brs[0];

                    Map param = new HashMap();
                    String[] res = br.getMessage();
                    StringBuffer sb = new StringBuffer();
                    for (String s : res) {
                        if (!StringUtilsExt.isNullOrNone(s)) {
                            System.out.println("s=" + s);
                            Integer i = ToolkitUtil.parseInt(s, null);
                            if (i == null) {
                                System.out.println("格式化数字出错，不进行发送");
                                KimdeConstant.NOT_PARSE_AUTO.add(_affairId);
                                continue;
                            }
                            sb.append(s).append(",");
                        }
                    }

                    param.put("affairId", br.getAffairId() + "");
                    param.put("summaryId", br.getSummaryId() + "");
                    param.put("category", "1");
                    param.put("parameter", sb.toString());
                    param.put("attitude", "2");
                    param.put("content", "系统自动提交");
                    param.put("conditionsOfNodes", br.getConditionsOfNodes());

                    Object out = batchManager.transDoBatch(param);
                    System.out.println("自动处理结果：" + out);
                } catch (BusinessException e) {
                    KimdeConstant.NOT_PARSE_AUTO.add(_affairId);
                    e.printStackTrace();
                }

            }
            System.out.println("自動处理......over");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
