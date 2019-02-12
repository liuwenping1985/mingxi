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
import www.seeyon.com.utils.UUIDUtil;

import java.util.*;

/**
 * Created by tap-pcng43 on 2017-8-17.
 */
public class OutTimeSendScheduled {
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

            System.out.println("-----超期自動处理......start");
            JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
            BatchManager batchManager = (BatchManager) AppContext.getBean("batchManager");
            OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
            PropertiesUtils prop = PropertiesUtils.getInstance();
            String guoqi_send_sql = prop.get("guoqi_send_sql") + "";

            List<Map<String, Object>> list = jdbcTemplate.queryForList(guoqi_send_sql);
            if (list != null) {
                System.out.println("本次超期处理，发现记录数量===" + list.size() + "," + ToolkitUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
            }

            int ii = 0;

            for (Map<String, Object> m : list) {
                String member_id = m.get("member_id") + "";
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
                String guoqi_insert_sql = prop.get("guoqi_insert_sql") + "";
                Long form_son_id = UUIDUtil.getAbsUUIDLong();
                String shyy = KimdeConstant.OA_URL + "/seeyon/zongChai.do?method=zongCaiYiJianShyyShow&recordid=" + form_son_id;
                String zqyj = KimdeConstant.OA_URL + "/seeyon/zongChai.do?method=zongCaiYiJianZqyjShow&recordid=" + form_son_id;
//                insert into 	formson_2522  (id,formmain_id,field0009,field0012,field0013,field0014,field0015)  values (?,?,?,?,?,?,?)
                guoqi_insert_sql = guoqi_insert_sql
                        .replace("{0}", form_son_id + "")
                        .replace("{1}", _affairId)
                        .replace("{2}", "'超期自动跳过'")
                        .replace("{3}", "'" + shyy + "'")
                        .replace("{4}", "'" + zqyj + "'")
                        .replace("{5}", "'" + shyy + "'")
                        .replace("{6}", "'" + zqyj + "'");
                System.out.println("sql===" + guoqi_insert_sql);
                jdbcTemplate.update(guoqi_insert_sql);
                List<String> _affairIds = new ArrayList<String>();
                List<String> _summaryIds = new ArrayList<String>();
                List<String> _categorys = new ArrayList<String>();
                _affairIds.add(_affairId);
                _summaryIds.add(_summaryId);
                _categorys.add("1");

                try {
                    V3xOrgMember member = orgManager.getMemberById(Long.parseLong(member_id));
                    if (member == null) {
                        System.out.println("用户没找到，自动跳过，不进行发送");
//                        KimdeConstant.NOT_PARSE_AUTO.add(_affairId);
                        continue;
                    }

                    System.out.println("member=" + member);
                    System.out.println("batchManager=" + batchManager);

                    User user = new User();

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

                    SSOTicketManager.TicketInfo ticketInfo = TokenUtil.getDetailToken(member.getLoginName());
                    System.out.println(ticketInfo.getMemberId());
                    System.out.println(ticketInfo.getUsername());


                    Map map = new HashMap();
                    System.out.println("超期处理信息title：" + _subject);

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
//                                KimdeConstant.NOT_PARSE_AUTO.add(_affairId);
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
                    param.put("content", "超时系统自动提交");
                    param.put("conditionsOfNodes", br.getConditionsOfNodes());


                    try {
                        System.out.println("超期处理开始****************************：");
                        System.out.println("超期处理开始****************************：");
                        System.out.println("超期处理开始****************************：");
                        System.out.println("超期处理开始****************************：");

                        Object out = batchManager.transDoBatch(param);
                        System.out.println("超期处理结果：" + out);
                        System.out.println("超期处理结果：" + out);
                        System.out.println("超期处理结果：" + out);

                    } catch (Exception e) {
                        System.out.println("超期处理结果========" + e.getMessage());
                        System.out.println("超期处理结果========" + e.getMessage());
                        e.printStackTrace();

                    } finally {
                        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%========");
                        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%========");
                        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%========");

                    }
                    System.out.println("PPPPPPPPPPPPPPPPPPPPPPPP");
                    System.out.println("PPPPPPPPPPPPPPPPPPPPPPPP");
                    System.out.println("PPPPPPPPPPPPPPPPPPPPPPPP");

                } catch (BusinessException e) {
                    KimdeConstant.NOT_PARSE_AUTO.add(_affairId);
                    e.printStackTrace();

                }

            }
            System.out.println("-----超期自動处理......over");
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

}
