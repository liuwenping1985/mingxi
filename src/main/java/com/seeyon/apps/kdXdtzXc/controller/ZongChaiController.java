package com.seeyon.apps.kdXdtzXc.controller;

import com.seeyon.apps.kdXdtzXc.base.util.MapWapperExt;
import com.seeyon.apps.kdXdtzXc.base.util.StringUtilsExt;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import com.seeyon.apps.kdXdtzXc.manager.ZongCaiShyyManager;
import com.seeyon.apps.kdXdtzXc.manager.ZongCaiZqyjManager;
import com.seeyon.apps.kdXdtzXc.oawsclient.MessageServiceStub;
import com.seeyon.apps.kdXdtzXc.oawsclient.MessageUtil;
import com.seeyon.apps.kdXdtzXc.po.ZongCaiShyy;
import com.seeyon.apps.kdXdtzXc.po.ZongCaiZqyj;
import com.seeyon.apps.kdXdtzXc.rest.util.ZzdlJsonObject;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.apps.kdXdtzXc.util.OaWebServiceUtil;
import com.seeyon.apps.kdXdtzXc.util.WriteUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.v3x.common.web.login.CurrentUser;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

/**
 * Created by tap-pcng43 on 2017-10-2.
 */
public class ZongChaiController extends BaseController {
	private static Log log = LogFactory.getLog(ZongChaiController.class);
	private ZongCaiShyyManager zongCaiShyyManager;
	private ZongCaiZqyjManager zongCaiZqyjManager;

	public ZongCaiShyyManager getZongCaiShyyManager() {
		return zongCaiShyyManager;
	}

	public void setZongCaiShyyManager(ZongCaiShyyManager zongCaiShyyManager) {
		this.zongCaiShyyManager = zongCaiShyyManager;
	}

	public ZongCaiZqyjManager getZongCaiZqyjManager() {
		return zongCaiZqyjManager;
	}

	public void setZongCaiZqyjManager(ZongCaiZqyjManager zongCaiZqyjManager) {
		this.zongCaiZqyjManager = zongCaiZqyjManager;
	}

	/**
	 * 上会原因
	 *
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@NeedlessCheckLogin
	public ModelAndView zongCaiYiJianShyy(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("kdXdtzXc/zongCaiYiJianShyy");
		return mav;

	}

	@NeedlessCheckLogin
	public ModelAndView zongCaiYiJianShyyShow(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String recordid = request.getParameter("recordid");
		ModelAndView mav = new ModelAndView("kdXdtzXc/zongCaiYiJianShyyShow");
		mav.addObject("recordid", recordid);
		return mav;
	}

	@NeedlessCheckLogin
	public void getZongCaiYiJianShyyData(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String formmain_id_str = request.getParameter("formmain_id");
			Long formmain_id = ToolkitUtil.parseLong(formmain_id_str);
			Long id = formmain_id;
			ZongCaiShyy zongCaiShyy = zongCaiShyyManager.getZongCaiShyy(id);
			if (zongCaiShyy == null) {
				System.out.println("数据库无对象==");
				zongCaiShyy = new ZongCaiShyy();
				zongCaiShyy.setFormmain_id(formmain_id);
				zongCaiShyy.setId(id);
			} else {
				System.out.println("数据库有对象");
			}
			zongCaiShyy.initStr();
			String json = JSONUtilsExt.toJson(new MapWapperExt().add("success", true).add("message", "成功").add("data", zongCaiShyy).toMap());
			System.out.println("反馈内容get=" + json);
			WriteUtil.write(json, response);

		} catch (Exception e) {
			String json = JSONUtilsExt.toJson(new MapWapperExt().add("success", false).add("message", "失败").add("data", null).toMap());
			log.error("保存错误", e);
			e.printStackTrace();
			WriteUtil.write(json, response);

		}
	}

	public void saveZongCaiYiJianShyyData(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String id_str = request.getParameter("id");
			String formmain_id_str = request.getParameter("formmain_id");
			String gszd = request.getParameter("gszd");// 公司制度
			String jygl = request.getParameter("jygl");// 经验管理重大事项
			String qt = request.getParameter("qt");// 其他

			Long formmain_id = ToolkitUtil.parseLong(formmain_id_str);
			Long id = ToolkitUtil.parseLong(id_str);
			ZongCaiShyy zongCaiShyy = zongCaiShyyManager.getZongCaiShyy(id);
			if (zongCaiShyy == null) {
				zongCaiShyy = new ZongCaiShyy();
			}
			zongCaiShyy.setId(id);
			zongCaiShyy.setFormmain_id(formmain_id);
			zongCaiShyy.setGszd(gszd);
			zongCaiShyy.setJygl(jygl);
			zongCaiShyy.setQt(qt);
			zongCaiShyy.setInsert_date(new Date());
			zongCaiShyyManager.save(zongCaiShyy);
			String json = JSONUtilsExt.toJson(new MapWapperExt().add("data", zongCaiShyy).add("success", true).add("message", "保存成功！").toMap());
			System.out.println("反馈内容=" + json);
			WriteUtil.write(json, response);
		} catch (Exception e) {
			log.error("保存错误", e);
			e.printStackTrace();
			String json = JSONUtilsExt.toJson(new MapWapperExt().add("data", null).add("success", false).add("message", "保存失败：" + e.getMessage()).toMap());
			WriteUtil.write(json, response);

		}
	}

	/**
	 * 征求意见
	 *
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@NeedlessCheckLogin
	public ModelAndView zongCaiYiJianZqyj(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("kdXdtzXc/zongCaiYiJianZqyj");
		return mav;

	}

	@NeedlessCheckLogin
	public ModelAndView zongCaiYiJianZqyjShow(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String recordid = request.getParameter("recordid");
		ModelAndView mav = new ModelAndView("kdXdtzXc/zongCaiYiJianZqyjShow");
		mav.addObject("recordid", recordid);
		return mav;

	}

	@NeedlessCheckLogin
	public void sendMessage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		boolean success = true;
		String message = "";
		try {
			String ids = request.getParameter("ids");
			String titles = request.getParameter("titles");

			if (StringUtils.isEmpty(ids))
				throw new Exception("ids参数丢失!");
			User user = CurrentUser.get();

			String[] idAry = ids.split(",");
			String[] titleAry = titles.split(",");
			int successCount = 0;
			OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
			if (idAry != null && idAry.length > 0) {
				for (int i = 0; i < idAry.length; i++) {
					try {
						String id = idAry[i];
						String content = user.getName() + "请您尽快处理:" + titleAry[i];
						// 根据人员id取用户登录名
						JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
						//formmain_1854正式服务器上的表，formmain_0019本地开发表
						String userId = jdbcTemplate.queryForObject("select field0005 from formmain_1854 where id=" + id, String.class);
						if (!StringUtils.isEmpty(userId)) {
							V3xOrgMember member = orgManager.getMemberById(Long.valueOf(userId));
							if (member != null) {
								String toLoginName = member.getLoginName();
								MessageServiceStub.ServiceResponse res = MessageUtil.sendMessage(toLoginName, content, null, OaWebServiceUtil.getTokenId());
								if (res.getResult() != -1) { //  不等于-1处理成功
									successCount++;
								}
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			success = true;
			message = "处理完成，共处理" + idAry.length + "条记录，处理成功" + successCount + "条记录，没有承办责任人的记录不做处理！";
		} catch (Exception e) {
			e.printStackTrace();
			success = false;
			message = "系统错误:" + e.getMessage();
		}
		String json = JSONUtilsExt.toJson(new MapWapperExt().add("success", success).add("message", message).toMap());
		WriteUtil.write(json, response);
	}

	@NeedlessCheckLogin
	public void getCaiYiJianZqyjData(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String formmain_id_str = request.getParameter("formmain_id");
			Long formmain_id = ToolkitUtil.parseLong(formmain_id_str);
			Long id = formmain_id;
			ZongCaiZqyj zongCaiZqyj = zongCaiZqyjManager.getZongCaiZqyj(id);
			if (zongCaiZqyj == null) {
				System.out.println("数据库无对象==");
				zongCaiZqyj = new ZongCaiZqyj();
				zongCaiZqyj.setFormmain_id(formmain_id);
				zongCaiZqyj.setId(id);
			} else {
				System.out.println("数据库有对象");
			}
			zongCaiZqyj.initStr();
			String json = JSONUtilsExt.toJson(new MapWapperExt().add("success", true).add("message", "成功").add("data", zongCaiZqyj).toMap());
			System.out.println("反馈内容get=" + json);
			WriteUtil.write(json, response);

		} catch (Exception e) {
			String json = JSONUtilsExt.toJson(new MapWapperExt().add("success", false).add("message", "失败").add("data", null).toMap());
			log.error("保存错误", e);
			e.printStackTrace();
			WriteUtil.write(json, response);

		}
	}

	public void saveCaiYiJianZqyjData(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String id_str = request.getParameter("id");
			String formmain_id_str = request.getParameter("formmain_id");
			String zb = request.getParameter("zb");// 总部各部室
			String zb_gfgs = request.getParameter("zb_gfgs");// 总部各部室-各分公司
			String zb_djs = request.getParameter("zb_djs");// 总部各部室-董监事
			String zb_gzgs = request.getParameter("zb_gzgs");// 总部各部室- 各子公司

			String gsfgld = request.getParameter("gsfgld");// 公司分管领导
			String gsfgld_xgfgs = request.getParameter("gsfgld_xgfgs");// 公司分管领导-
																		// 相关分公司
			String gsfgld_xgzgs = request.getParameter("gsfgld_xgzgs");// 公司分管领导-
																		// 相关子公司
			String gsfgld_bsjdjs = request.getParameter("gsfgld_bsjdjs");// 公司分管领导-
																			// 不涉及董监事

			String qtgsld = request.getParameter("qtgsld");// 其他公司领导
			String qtgsld_bsjfgs = request.getParameter("qtgsld_bsjfgs");// 其他公司领导-不涉及分公司
			String qtgsld_bsjzgs = request.getParameter("qtgsld_bsjzgs");// 其他公司领导-不涉及子公司
			String tsqk = request.getParameter("tsqk");

			Long formmain_id = ToolkitUtil.parseLong(formmain_id_str);
			Long id = ToolkitUtil.parseLong(id_str);
			ZongCaiZqyj zongCaiZqyj = zongCaiZqyjManager.getZongCaiZqyj(id);
			if (zongCaiZqyj == null) {
				zongCaiZqyj = new ZongCaiZqyj();
			}
			zongCaiZqyj.setId(id);
			zongCaiZqyj.setFormmain_id(formmain_id);
			zongCaiZqyj.setZb(zb);
			zongCaiZqyj.setZb_gfgs(zb_gfgs);
			zongCaiZqyj.setZb_djs(zb_djs);
			zongCaiZqyj.setZb_gzgs(zb_gzgs);

			zongCaiZqyj.setGsfgld(gsfgld);
			zongCaiZqyj.setGsfgld_xgfgs(gsfgld_xgfgs);
			zongCaiZqyj.setGsfgld_xgzgs(gsfgld_xgzgs);
			zongCaiZqyj.setGsfgld_bsjdjs(gsfgld_bsjdjs);

			zongCaiZqyj.setQtgsld(qtgsld);
			zongCaiZqyj.setQtgsld_bsjfgs(qtgsld_bsjfgs);
			zongCaiZqyj.setQtgsld_bsjzgs(qtgsld_bsjzgs);
			zongCaiZqyj.setTsqk(tsqk);

			zongCaiZqyj.setInsert_date(new Date());
			zongCaiZqyjManager.save(zongCaiZqyj);
			String json = JSONUtilsExt.toJson(new MapWapperExt().add("data", zongCaiZqyj).add("success", true).add("message", "保存成功！").toMap());
			System.out.println("反馈内容=" + json);
			WriteUtil.write(json, response);
		} catch (Exception e) {
			log.error("保存错误", e);
			e.printStackTrace();
			String json = JSONUtilsExt.toJson(new MapWapperExt().add("data", null).add("success", false).add("message", "保存失败：" + e.getMessage()).toMap());
			WriteUtil.write(json, response);

		}
	}

}