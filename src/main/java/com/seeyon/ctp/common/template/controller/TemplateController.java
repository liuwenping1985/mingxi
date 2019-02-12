/**
 * $Author: muj $
 * $Rev: 4542 $
 * $Date:: 2013-02-26 13:55:39#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */

package com.seeyon.ctp.common.template.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.template.util.CtpTemplateUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.enums.TemplateEnum;
import com.seeyon.ctp.common.template.enums.TemplateTypeEnums;
import com.seeyon.ctp.common.template.manager.CollaborationTemplateManager;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.common.template.vo.TemplateCategoryComparator;
import com.seeyon.ctp.common.template.vo.TemplateTreeVo;
import com.seeyon.ctp.common.template.vo.TemplateVO;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.space.manager.PortletEntityPropertyManager;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;


/**
 * @author mujun
 *
 */
public class TemplateController extends BaseController {
    
    private static Log LOG = CtpLogFactory.getLog(TemplateController.class);
    
    public void setWapi(WorkflowApiManager wapi) {
		this.wapi = wapi;
	}

	private TemplateManager templateManager;
	
	private OrgManager       orgManager; 
	
	private CollaborationTemplateManager collaborationTemplateManager;

    public void setCollaborationTemplateManager(CollaborationTemplateManager collaborationTemplateManager) {
		this.collaborationTemplateManager = collaborationTemplateManager;
	}

	public OrgManager getOrgManager() {
		return orgManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public TemplateManager getTemplateManager() {
        return templateManager;
    }

    public void setTemplateManager(TemplateManager templateManager) {
        this.templateManager = templateManager;
    }
    
    private WorkflowApiManager wapi;
    
    private boolean isEdoc(String categoryKey){
        if(Strings.isNotBlank(categoryKey)){
        	//协同表单传入‘0,4’，转换出问题 直接判断。
        	String[] len = categoryKey.split(",");
        	if(len.length>1){
        		return false;
        	}
            int ordinal = Integer.valueOf(categoryKey);
            
            if(ModuleType.edoc.ordinal() == ordinal
                    ||ModuleType.edocRec.ordinal() == ordinal
                    ||ModuleType.edocSend.ordinal() == ordinal
                    ||ModuleType.edocSign.ordinal() == ordinal){
                return true;
            }
        }
        return false;
    }

    /**
     * 调用模板选择
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
	public ModelAndView templateChoose(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView modelAndView = new ModelAndView("common/template/templateChoose");
        // 模板分类
        String category = request.getParameter("category");
        if (category == null) {
            return modelAndView;
        }
        User user = AppContext.getCurrentUser();
        Long orgAccountId = user.getLoginAccount();
        //模板选择单位，不传值默认为当前用户的登录单位
        String accountId = request.getParameter("accountId");
        if (Strings.isNotBlank(accountId)) {
            orgAccountId = Long.parseLong(accountId);
        }
        
        if (!user.isV5Member()) {
            orgAccountId = OrgHelper.getVJoinAllowAccount();
        }
        
        String searchType = request.getParameter("searchType");
        String sName = request.getParameter("sName");
        String smtype = request.getParameter("smtype");
        String[] typestrs = StringUtils.split(category, ",");
        List<ModuleType> moduleTypes = new ArrayList<ModuleType>();
        //判断是否有信息报送插件
        Boolean hasInfoPlugin = AppContext.hasPlugin("infosend");
        Boolean hasEdoc =  AppContext.hasPlugin("edoc");
        String real_category = "";
        for (int i = 0; i < typestrs.length; i++) {
        	String cType = typestrs[i];
        	if("-1".equals(cType)){
        		continue;
        	}
            if(String.valueOf(ApplicationCategoryEnum.info.key()).equals(cType) && !hasInfoPlugin) {
        		continue;
        	}
            if(!hasEdoc && isEdoc(cType)){
                continue;
            }
        	real_category += cType+",";
        	try {
        	    ModuleType m = ModuleType.getEnumByKey(Integer.valueOf(cType));
        	    if(m != null){
        	        moduleTypes.add(m);
        	    }
            } catch (IllegalArgumentException e) {
                logger.error("获取枚举报错了", e);
            }
        }
        if(Strings.isNotBlank(real_category)) {
        	real_category = real_category.substring(0, real_category.length()-1);
        	category = real_category;
        }
        // 取对应单位某模块的模板分类
        List<CtpTemplateCategory> templeteCategory = new ArrayList<CtpTemplateCategory>();
        List<CtpTemplateCategory> templeteCategoryTemp = templateManager.getCategorys(orgAccountId, moduleTypes);
        // 移出已经删除的模板分类
        if (!CollectionUtils.isEmpty(templeteCategoryTemp)) {
            for (CtpTemplateCategory ctpTemplateCategory : templeteCategoryTemp) {
                if (ctpTemplateCategory.isDelete() == null || !ctpTemplateCategory.isDelete()) {
                    templeteCategory.add(ctpTemplateCategory);
                }
            }
        }
        Map<Long, CtpTemplateCategory> idCategory = new HashMap<Long, CtpTemplateCategory>();
        Map<String, CtpTemplateCategory> nameCategory = new HashMap<String, CtpTemplateCategory>();
        for (CtpTemplateCategory c : templeteCategory) {
            nameCategory.put(c.getName(), c);
            idCategory.put(c.getId(), c);
        }
        //取个人模板
        List<CtpTemplate> personalTempletes = null;
        /**
         * StringUtil.checkNull(request.getParameter("templateChoose")) 新建页面走上面的判断
         * "true".equals(request.getParameter("templateChoose") 我的模板更多 走下面查询不出来数据 也改成了 走上面
         */
        if((moduleTypes.contains(ModuleType.collaboration) || moduleTypes.contains(ModuleType.form))&&  
            "true".equals(request.getParameter("templateChoose"))){
        	
        	List<ModuleType> m = new ArrayList<ModuleType>();
        	m.add(ModuleType.collaboration);
        	m.add(ModuleType.form);
        	m.add(ModuleType.edoc);
        	m.add(ModuleType.edocSend);
        	m.add(ModuleType.edocRec);
        	m.add(ModuleType.edocSign);
        	
        	personalTempletes = templateManager.getPersonalTemplates(user.getId(),m);
        }else{
        	personalTempletes = templateManager.getPersonalTemplates(user.getId(),moduleTypes);
        }
        // 所有模板，包括协同和表单
        List<CtpTemplate> systemTempletes = templateManager.getSystemTemplatesByAcl(user.getId(), moduleTypes);
        
        List<CtpTemplate> showTempletes = new ArrayList<CtpTemplate>();
        // 是否显示外单位模板
        boolean isShowOuter = Boolean.valueOf(Functions.getSysFlag("col_showOtherAccountTemplate").toString());
        List<CtpTemplateCategory> outerCategory = new ArrayList<CtpTemplateCategory>();
        for (CtpTemplate template : systemTempletes) {
            //外单位的模板才进行分类合并
            if(!template.getOrgAccountId().equals(orgAccountId)){
            	if(!isShowOuter){
            		continue;
            	}
            	if (template.isSystem() && template.getCategoryId() != 0) {// 等于0是顶层的模板
            		CtpTemplateCategory tc = templateManager.getCtpTemplateCategory(template.getCategoryId());
            		if (tc != null) {
            			CtpTemplateCategory n = nameCategory.get(tc.getName());
            			if (n != null) {
            				template.setCategoryId(n.getId());
            			} else {
            				//TODO 先这么处理，外单位授权过来的直接显示在根目录下面，
            				//如果需要按照原有单位的单位层级显示的话，后面再考虑，先保持跟3.5 一致
            				tc.setParentId(1l);
            				outerCategory.add(tc);
            				idCategory.put(tc.getId(), tc);
            				nameCategory.put(tc.getName(), tc);
            			}
            		}
            	}
            }
            showTempletes.add(template);
        }
        List<TemplateTreeVo> listTreeVo = new ArrayList<TemplateTreeVo>();
        listTreeVo = getTemplateTree(listTreeVo,category, idCategory, showTempletes, personalTempletes,searchType, sName, smtype,false);
    	if(null == request.getParameter("templateChoose")){//如果不是从我的模板更多页面配置的
    		List<TemplateTreeVo> newListTreeVo = new ArrayList<TemplateTreeVo>();
    		Map<Long, TemplateTreeVo> realCategory = new HashMap<Long, TemplateTreeVo>();
			List<TemplateTreeVo> realTemplates = new ArrayList<TemplateTreeVo>();
			List<TemplateTreeVo> categorys = new ArrayList<TemplateTreeVo>();
			for (TemplateTreeVo vo : listTreeVo) {
				// 分类
				if ("category".equals(vo.getType()) || "personal".equals(vo.getType()) || "template_coll".equals(vo.getType())
						|| "text_coll".equals(vo.getType()) || "workflow_coll".equals(vo.getType()) || "edoc_coll".equals(vo.getType())) {
					realCategory.put(vo.getId(), vo);
					// 协同三个根节点："最近使用模板"、"公共模板"、"个人模板"无论下面是否有具体模板，都在前端展示。公文显示对应的公文
					if (vo.getId() == 0 || vo.getId() == 100 || vo.getId() == 110 || vo.getId() == Long.valueOf(ModuleType.edoc.getKey())
							|| vo.getId() == Long.valueOf(ModuleType.edocSend.getKey()) || vo.getId() == Long.valueOf(ModuleType.edocRec.getKey())
							|| vo.getId() == Long.valueOf(ModuleType.edocSign.getKey())) {
						categorys.add(vo);
					}
				} else {// 具体模板
					realTemplates.add(vo);
				}
			}
			for (TemplateTreeVo template : realTemplates) {
				// 如果包含此模板的分类
				if (realCategory.containsKey(template.getpId())) {
					TemplateTreeVo theCategory = realCategory.get(template.getpId());
					getParentCategory(theCategory, realCategory, categorys);
				}
			}
			
			newListTreeVo.addAll(categorys);
			newListTreeVo.addAll(realTemplates);
			//通过category的sort排序后的tree
	        for(Iterator<TemplateTreeVo> it = listTreeVo.iterator();it.hasNext();){
	        	TemplateTreeVo t = it.next();
	        	if (!newListTreeVo.contains(t)) {
	        		it.remove();
	        	}
	        }
		}
        
        request.setAttribute("fftree", listTreeVo);
        // 判断是否是来自我的模板配置
        // 如果来自我得模板配置则需要得到发布到首页的模板ID列表
        if (Strings.isNotBlank(request.getParameter("templateChoose"))) {
            // 已选的模板
            List<CtpTemplate> templeteList = templateManager.getPersonalTemplete(category, -1, false);
            Long[] templeteIds = null;
            if (templeteList != null) {
                templeteIds = new Long[templeteList.size()];
                for (int i = 0; i < templeteList.size(); i++) {
                    templeteIds[i] = templeteList.get(i).getId();
                }
            }
            request.setAttribute("templateChoose", true);
            request.setAttribute("fftempleteList", templeteIds);
        }
        StringBuffer htmlStr = transCategoryHtml(moduleTypes, idCategory);
        modelAndView.addObject("htmlStr", htmlStr);
        modelAndView.addObject("templeteCategory", templeteCategory);
        modelAndView.addObject("outerCategory", outerCategory);
        modelAndView.addObject("sysTempletes", showTempletes);
        modelAndView.addObject("isEdoc", isEdoc(category));
        // 传到前台 查询的时候传入到后台
        modelAndView.addObject("category", category);
        // 传到页面上查询的时候传入到后台
        modelAndView.addObject("accountId", accountId);
        modelAndView.addObject("searchType", searchType);
        modelAndView.addObject("sName", Strings.toHTML(sName));
        modelAndView.addObject("smtype", smtype);
        return modelAndView;
    }

    private List<TemplateTreeVo>  addRecentlyUsedTemplate(List<TemplateTreeVo> listTreeVo,List<CtpTemplate> personalRencentTemplete, String category) throws BusinessException {
    	
    	TemplateTreeVo rut = new TemplateTreeVo();
    	rut.setId(110L);
    	rut.setName(ResourceUtil.getString("template.choose.category.recent.label"));//最近使用根目录
    	rut.setpId(null);
    	rut.setType("category");
    	listTreeVo.add(rut);
    	CtpTemplate ctpTemplate= null;
    	Long la = AppContext.getCurrentUser().getLoginAccount();
    	boolean colFlag = true;
    	if("19".equals(category)||"20".equals(category)||"21".equals(category)){
    		colFlag = false;
    	}
    	for(int a = 0 ; a<personalRencentTemplete.size() ; a++){
    		ctpTemplate = personalRencentTemplete.get(a);
    		if(!ctpTemplate.isSystem() && null != ctpTemplate.getFormParentid()){
    			CtpTemplate parent_t = templateManager.getCtpTemplate(ctpTemplate.getFormParentid());
    			if(null != parent_t && (parent_t.isDelete() || Integer.valueOf(TemplateEnum.State.invalidation.ordinal()).equals(parent_t.getState()))){
    				continue;
    			}
    		}

    		if(null != ctpTemplate.getModuleType()){
    			if(!(ctpTemplate.getModuleType().toString().equals(category)) && 
    				!("1".equals(ctpTemplate.getModuleType().toString()) && !("2".equals(ctpTemplate.getModuleType().toString())
    					))){
    				continue;
    			}
    		}
    		rut = new TemplateTreeVo();
    		rut.setId(ctpTemplate.getId());
    		String shortName="";
    		if(null != ctpTemplate.getOrgAccountId() && !la.equals(ctpTemplate.getOrgAccountId()) && ctpTemplate.isSystem()){
    			 shortName= orgManager.getAccountById(ctpTemplate.getOrgAccountId()).getShortName();
    			rut.setName(ctpTemplate.getSubject() +"("+shortName+")");
    		}else{
    			rut.setName(ctpTemplate.getSubject());
    		}
    		if(!colFlag){
    			rut.setIsEdoc(true);
    		}
    		rut = setWendanId(rut, ctpTemplate);
    		rut.setWorkflowId(ctpTemplate.getWorkflowId());
    		rut.setBodyType(ctpTemplate.getBodyType());
    		if(null != ctpTemplate.getFormParentid()){
    			CtpTemplate ctpP = templateManager.getCtpTemplate(ctpTemplate.getFormParentid());
    			if(null != ctpP && !"text".equals(ctpP.getType())){
    				rut.setWorkflowId(ctpP.getWorkflowId());
    			}
    		}
    		rut.setType(ctpTemplate.getType());
    		try{
    		if(null != ctpTemplate.getModuleType()){
    			rut.setCategoryType(ctpTemplate.getModuleType());
    		}}catch(Exception e){
    		    LOG.error("", e);
    		}
    		
    		//设置浮动显示的title
            V3xOrgMember createrMember = orgManager.getMemberById(ctpTemplate.getMemberId());
            StringBuffer showTitle = new StringBuffer();
	        if(null != createrMember) {
	        	if(Strings.isNotBlank(createrMember.getName())){
	        		//创建人
	        		String creater = ResourceUtil.getString("collaboration.summary.createdBy")+":";
	        		if (null != ctpTemplate.getOrgAccountId() && !ctpTemplate.getOrgAccountId().equals(la)){
	        			
	        			showTitle.append(creater + OrgHelper.showMemberNameOnly(createrMember.getId())//显示单位管理员加简称
	        					+"("+shortName+")"+"\r");
	        		}else{
	        			showTitle.append(creater + OrgHelper.showMemberNameOnly(createrMember.getId()) +"\r");
	        		}
	        	}
	        	try{
	        		if(!createrMember.getIsAdmin()){
	        			//部门
	        			String departMent = ResourceUtil.getString("org.department.label") + ":";
	        			showTitle.append(departMent + Functions.showDepartmentFullPath(createrMember.getOrgDepartmentId())+"\r");
	        		}
	        	}catch(Exception e){
	        		//showTitle.append("部门:"+" ");
	        	}
	        	try{
	        		//岗位
	        		String post = ResourceUtil.getString("org.post.label") + ":";
	        		showTitle.append(post + orgManager.getPostById(createrMember.getOrgPostId()).getName());
	        	}catch(Exception e){
	        		//showTitle.append("岗位:"+" ");
	        	}
	        	rut.setFullName(showTitle.toString());
	        }
    		
    		String icon = getTemplateIcon(ctpTemplate);
            rut.setIconSkin(icon);
    		rut.setpId(110L);
    		rut.setFormAppId(ctpTemplate.getFormAppId());
    		listTreeVo.add(rut);
    	}
		return listTreeVo;
	}

    private TemplateTreeVo setWendanId(TemplateTreeVo vo,CtpTemplate t) throws BusinessException{
      
      if(vo.getIsEdoc()!=null && vo.getIsEdoc()){
        CtpTemplate ct = templateManager.getCtpTemplate(t.getId());
        if(null != ct && Strings.isNotBlank(ct.getSummary())){
       
        	//TODO
        	/**     EdocSummary es = (EdocSummary)XMLCoder.decoder(ct.getSummary());
            vo.setWendanId(es.getFormId());
            */
        }
      }
      return vo;
    }
    
	/**
     * 查询条件中的模板类型条件的值
     * @param typesL
     * @param nameCategory
     * @return
     */
    private StringBuffer transCategoryHtml(List<ModuleType> moduleTypes, Map<Long, CtpTemplateCategory> nameCategory) {
        StringBuffer htmlStr = new StringBuffer();
        List<CtpTemplateCategory> ctcList = new ArrayList<CtpTemplateCategory>();
        CtpTemplateCategory ctc = null;
        // 公文的
        boolean pdocFlag = false;
        
        if (moduleTypes.contains(ModuleType.edoc) || moduleTypes.contains(ModuleType.edocSend) 
        		|| moduleTypes.contains(ModuleType.edocRec) || moduleTypes.contains(ModuleType.edocSign)) {
        	
            List<Long> ccc = new ArrayList<Long>();
            if (moduleTypes.contains(ModuleType.edocSend)) {
                ctc = new CtpTemplateCategory(19L, ResourceUtil.getString("template.edocsend.label"), 10000L);//"发文模板"
                ctcList.add(ctc);
                pdocFlag = true;
            }
            if (moduleTypes.contains(ModuleType.edocRec)) {
                ctc = new CtpTemplateCategory(20L, ResourceUtil.getString("template.edocrec.label"), 10000L);//"收文模板"
                ctcList.add(ctc);
                pdocFlag = true;
            }
            if (moduleTypes.contains(ModuleType.edocSign)) {
                ctc = new CtpTemplateCategory(21L, ResourceUtil.getString("template.edocsign.label"), 10000L);//"签报模板"
                ctcList.add(ctc);
                pdocFlag = true;
            }
            
            ccc = new ArrayList<Long>();
            ccc.add(10000L);
            htmlStr = templateManager.categoryHTML(ctcList, ccc, 0);
        }
        // 表单，协同的
        if (moduleTypes.contains(ModuleType.collaboration)|| moduleTypes.contains(ModuleType.form)) {
            // 公共部分
            Set<Long> keySet = nameCategory.keySet();
            ctcList = new ArrayList<CtpTemplateCategory>();
            for (Long str : keySet) {
                CtpTemplateCategory category2 = nameCategory.get(str);
                if (category2.getId() == ModuleType.form.ordinal()) {
                    continue;
                }
                ctcList.add(category2);
            }
            List<Long> ccc = new ArrayList<Long>();
            ccc = new ArrayList<Long>();
            ccc.add(Long.valueOf(1L));
            ccc.add(Long.valueOf(2L));
            htmlStr = templateManager.categoryHTML(ctcList, ccc, 0);

            ctc = new CtpTemplateCategory(101L, ResourceUtil.getString("collaboration.template.category.type.0"), 100L);//"协同模板"
            ctcList.add(ctc);
            ctc = new CtpTemplateCategory(102L, ResourceUtil.getString("collaboration.saveAsTemplate.formatTemplate"), 100L);//"格式模板"
            ctcList.add(ctc);
            ctc = new CtpTemplateCategory(103L, ResourceUtil.getString("collaboration.saveAsTemplate.flowTemplate"), 100L);//"流程模板"
            ctcList.add(ctc);
            if(pdocFlag){
            	ctc = new CtpTemplateCategory(104L,ResourceUtil.getString("collaboration.saveAsTemplate.edocPtem"), 100L);
            	ctcList.add(ctc);
            }
            ccc.add(Long.valueOf(100L));
            // 个人模板部分
            htmlStr = templateManager.categoryHTML(ctcList, ccc, 0);
        }
        return htmlStr;
    }
    
    private List<TemplateTreeVo> getTemplateTree(List<TemplateTreeVo> listTreeVo,String category, Map<Long, CtpTemplateCategory> idCategory,List<CtpTemplate> showTempletes, 
            List<CtpTemplate> personalTempletes, String searchType, String sName,String smtype,boolean isTemplateMore) throws BusinessException {
    	List<CtpTemplate> personalRencentTemplete = new ArrayList<CtpTemplate>();
    	//如果是我的模版更多页面则不需要查询个人的
    	if (!isTemplateMore) {
    		personalRencentTemplete = templateManager.getPersonalRencentTemplete(category+",-1",10);
    	}
        // 查询进入的
        if (Strings.isNotBlank(searchType)) {
            //按名字查询
            if ("1".equals(searchType)) {
                String searchTN =sName;
                for (int a = showTempletes.size() - 1; a > -1; a--) {
                    if (!(showTempletes.get(a).getSubject().indexOf(searchTN) > -1)) {
                        showTempletes.remove(showTempletes.get(a));
                    }
                }
                //最近使用
                for (int a = personalRencentTemplete.size() - 1; a > -1; a--) {
                    if (!(personalRencentTemplete.get(a).getSubject().indexOf(searchTN) > -1)) {
                        personalRencentTemplete.remove(a);
                    }
                }
                for (int a = personalTempletes.size() - 1; a > -1; a--) {
                    CtpTemplate pt = personalTempletes.get(a);
                    if(pt != null){
                        if(Strings.isNotBlank(pt.getSubject())){
                            if (!(pt.getSubject().indexOf(searchTN) > -1)) {
                                personalTempletes.remove(personalTempletes.get(a));
                            }
                        }
                    }
                }
            }
            //按分类查询
            if ("2".equals(searchType)) {
                for (int a = showTempletes.size() - 1; a > -1; a--) {
                    if (null == showTempletes.get(a).getCategoryId()) {
                        showTempletes.remove(showTempletes.get(a));
                        continue;
                    }
                    if (!(showTempletes.get(a).getCategoryId() == Long.valueOf(smtype).longValue())) {
                        showTempletes.remove(showTempletes.get(a));
                    }

                }
                if("101".equals(smtype) ||"102".equals(smtype) ||"103".equals(smtype)){
                	//个人模板下的 协同 流程 格式模板
                	for (int a = personalTempletes.size() - 1; a > -1; a--) {
                		if (null != personalTempletes.get(a).getCategoryId()) {
                			personalTempletes.remove(personalTempletes.get(a));
                			continue;
                		}
                		if ("101".equals(smtype) && !"template".equals(personalTempletes.get(a).getType())) {
                			personalTempletes.remove(personalTempletes.get(a));
                		}
                		if ("102".equals(smtype) && !"text".equals(personalTempletes.get(a).getType())) {
                			personalTempletes.remove(personalTempletes.get(a));
                		}
                		if ("103".equals(smtype) && !"workflow".equals(personalTempletes.get(a).getType())) {
                			personalTempletes.remove(personalTempletes.get(a));
                		}
                	}
                }else if("104".equals(smtype)){
                	for (int a = personalTempletes.size() - 1; a > -1; a--) {
                		if (!"templete".equals(personalTempletes.get(a).getType())) {
                			personalTempletes.remove(personalTempletes.get(a));
                		}
                	}
                }else{
                	for (int a = personalTempletes.size() - 1; a > -1; a--) {
                		if (null == personalTempletes.get(a).getCategoryId()) {
                			personalTempletes.remove(personalTempletes.get(a));
                			continue;
                		}
                		if (!(personalTempletes.get(a).getCategoryId() == Long.valueOf(smtype).longValue())) {
                			personalTempletes.remove(personalTempletes.get(a));
                		}
                	}
                }
            }
        }
        
        
        //sp1需求 树上增加最近使用模板
        if(!isTemplateMore && ("1,2".equals(category) || "19".equals(category)|| "20".equals(category)|| "21".equals(category))&& !"2".equals(searchType)){
            listTreeVo = addRecentlyUsedTemplate(listTreeVo,personalRencentTemplete,category);
        }
        
        String[] tv = category.split(",");
        List<Integer> typesL = new ArrayList<Integer>();
        for (int i = 0; i < tv.length; i++) {
            typesL.add(new Integer(tv[i]));
        }
        boolean pdocflag = false;
        boolean infoflag = false;
        if (typesL.contains(ModuleType.info.getKey()) && AppContext.hasPlugin(ApplicationCategoryEnum.info.name())) {
            infoflag = true;
        }
        if ((typesL.contains(ModuleType.collaboration.getKey()) || typesL.contains(ModuleType.form.getKey()))
                && (typesL.contains(ModuleType.edoc.getKey()) || typesL.contains(ModuleType.edocRec.getKey())
                        || typesL.contains(ModuleType.edocSend.getKey()) || typesL.contains(ModuleType.edocSign
                        .getKey()))) {
            if (typesL.contains(ModuleType.edoc.getKey())) {
                listTreeVo.add(setCategory(ModuleType.edoc.getValue()));
                pdocflag = true;
            }
            if (typesL.contains(ModuleType.edocSend.getKey())) {
                listTreeVo.add(setCategory(ModuleType.edocSend.getValue()));
                pdocflag = true;
            }
            if (typesL.contains(ModuleType.edocRec.getKey())) {
                listTreeVo.add(setCategory(ModuleType.edocRec.getValue()));
                pdocflag = true;
            }
            if (typesL.contains(ModuleType.edocSign.getKey())) {
                listTreeVo.add(setCategory(ModuleType.edocSign.getValue()));
                pdocflag = true;
            }
        }
        for (String s : tv) {
            // 构造几个个人分类目录
            TemplateTreeVo ttPersonlVO = new TemplateTreeVo();
            if ("1".equals(s) ||"2".equals(s)) {
                // 表单和协同的构建根节点(pid为空的，则为顶层)
                TemplateTreeVo templateTreeVO = new TemplateTreeVo(0L, ResourceUtil.getString("template.public.label"), "category", null,"");
                TemplateTreeVo ttPersonlVO1 = new TemplateTreeVo(101L, ResourceUtil.getString("collaboration.template.category.type.0"), "template_coll", 100L,"");//"协同模板"
                TemplateTreeVo ttPersonlVO2 = new TemplateTreeVo(102L, ResourceUtil.getString("collaboration.saveAsTemplate.formatTemplate"), "text_coll", 100L,"");//"格式模板"
                TemplateTreeVo ttPersonlVO3 = new TemplateTreeVo(103L, ResourceUtil.getString("collaboration.saveAsTemplate.flowTemplate"), "workflow_coll", 100L,"");//"流程模板"
                TemplateTreeVo ttPersonlVO4 = null;
                TemplateTreeVo ttPersonlVO5 = null;
                if(pdocflag) {
                	ttPersonlVO4 = new TemplateTreeVo(104L, ResourceUtil.getString("collaboration.saveAsTemplate.edocPtem"), "category", 100L,"");
                	ttPersonlVO4.setIsEdoc(true);
                }
                if(infoflag) {
	                ttPersonlVO5 = new TemplateTreeVo(105L, "信息个人模板", "category", 100L,"");
	            	ttPersonlVO5.setIsInfo(true);
                }
                listTreeVo.add(templateTreeVO);
                listTreeVo.add(ttPersonlVO1);
                listTreeVo.add(ttPersonlVO2);
                listTreeVo.add(ttPersonlVO3);
                if(pdocflag){
                	listTreeVo.add(ttPersonlVO4);
                }
                if(infoflag) {
                	listTreeVo.add(ttPersonlVO5);
                }
                // 插入个人模板到相应分类下面
                if (personalTempletes != null) {
                    for (CtpTemplate t : personalTempletes) {
                        Long pId = null;
                        if(null  == t.getType() && null == t.getSubject()){
                        	continue;
                        }
                        if ("template".equals(t.getType())) {
                        	pId = ttPersonlVO1.getId();
                        } else if ("text".equals(t.getType())) {
                        	pId = ttPersonlVO2.getId();
                        } else if("workflow".equals(t.getType())) {
                        	pId = ttPersonlVO3.getId();
                        } else if ("templete".equals(t.getType())) {//公文
                        	if(!pdocflag){
                        		continue;
                        	}
                        	if(null != ttPersonlVO4){
                        		pId = ttPersonlVO4.getId();
                        	}
                        }else if(Integer.valueOf(32).equals(t.getModuleType())){
                        	pId = ttPersonlVO5.getId();
                        }
                        ttPersonlVO = new TemplateTreeVo(t.getId(), t.getSubject(), t.getType(), pId,t.getBodyType());
                        if("templete".equals(t.getType())){
                        	ttPersonlVO.setIsEdoc(true);
                        }else if(null != t.getModuleType() && Integer.valueOf(32).equals(t.getModuleType())){
                        	ttPersonlVO.setIsInfo(true);
                        }
                        ttPersonlVO.setWorkflowId(t.getWorkflowId());
                        ttPersonlVO.setBodyType(t.getBodyType());
                        //个人协同和流程模板取父模板的wfId
                        if(!t.isSystem() && null != t.getFormParentid()){
                        	CtpTemplate xyz= templateManager.getCtpTemplate(t.getFormParentid());
                        	if(null == xyz){
                        		continue;
                        	}
                        	if(xyz.isSystem() && null != xyz.getWorkflowId()){
                        		ttPersonlVO.setWorkflowId(xyz.getWorkflowId());
                        		ttPersonlVO.setFormAppId(xyz.getFormAppId());
                        	}
                        }
                        String icon = getTemplateIcon(t);
                        ttPersonlVO.setIconSkin(icon);
                        ttPersonlVO.setCategoryType(t.getModuleType());
                        listTreeVo.add(ttPersonlVO);
                    }
                }
                break;
            } else if (isEdoc(s)) {
                if (personalTempletes != null) {
                    TemplateTreeVo vp = null;
                    for (CtpTemplate t : personalTempletes) {
                        try {//数据防护
                            if (!(t.getCategoryId().toString().equals(category))) {//个人模板过滤出各种类型
                                continue;
                            }
                            vp = new TemplateTreeVo();
                            vp.setId(t.getId());
                            vp.setName(t.getSubject());
                            vp.setType(t.getType());
                            vp.setWorkflowId(t.getWorkflowId());
                            //个人协同和流程模板取父模板的wfId
                            if(!t.isSystem() && null != t.getFormParentid()){
                                CtpTemplate pt= templateManager.getCtpTemplate(t.getFormParentid());
                                if(null == pt){
                                    continue;
                                }
                                if(pt.isSystem() && null != pt.getWorkflowId()){
                                    vp.setWorkflowId(pt.getWorkflowId());
                                }
                            }
                            vp.setIsEdoc(true);
                            vp.setBodyType(t.getBodyType());
                            try {
                            	vp.setCategoryType(t.getModuleType());
                            } catch (Exception e) {
                                LOG.error("", e);
                            }
                            if  ("templete".equals(t.getType()))
                                vp.setpId(100L);
                            
                            String icon = getTemplateIcon(t);
                            vp.setIconSkin(icon);
                            
                            listTreeVo.add(vp);
                        } catch (Exception e) {
                            LOG.error("ID为***********" + t.getId() + "*************的模板存在数据问题，不允许掉用。", e);
                        }
                    }
                }
                listTreeVo.add(setCategory(s));
            }else if(infoflag){
            	 TemplateTreeVo templateTreeVOInfo = new TemplateTreeVo(300L, "信息模板", "category", null,"");
            	 templateTreeVOInfo.setIsInfo(true);
            	 listTreeVo.add(templateTreeVOInfo);
            }
        }
        // 个人模板
        TemplateTreeVo tvo = new TemplateTreeVo(100L, ResourceUtil.getString("template.templatePub.personalTemplates"), "personal", null,"");//"个人模板"
        listTreeVo.add(tvo);
        transCategory2TreeVo(idCategory, listTreeVo);
        transTemplate2TreeVo(showTempletes, listTreeVo);
        return listTreeVo;
	}

	// 获取父节点分类，如果新的分类列表中没有添加，则将其添加进去
	private void getParentCategory(TemplateTreeVo category, Map<Long, TemplateTreeVo> realCategory, List<TemplateTreeVo> categorys) {
		if (category != null && category.getpId() != null && realCategory.containsKey(category.getpId())) {
			TemplateTreeVo pCategory = realCategory.get(category.getpId());
			if (pCategory != null && !categorys.contains(pCategory)) {
				categorys.add(pCategory);
			}
			getParentCategory(pCategory, realCategory, categorys);
		}
		if (realCategory.containsKey(category.getId())) {
			if (category != null && !categorys.contains(category)) {
				categorys.add(category);
			}
		}
	}
    public  ModelAndView moreTreeTemplate(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
    	
    	ModelAndView modelAndView = new ModelAndView("common/template/moreTreeTemplate");
    	User user = AppContext.getCurrentUser();
    	Long orgAccountId = user.getLoginAccount();
    	//保存我的模板个性化查看方式-树状结构
    	collaborationTemplateManager.saveCustomViewType("0");
    	//***********************更多页面传递过来的参数处理 begin****************************************
        // 全部种类
    	String category = request.getParameter("category");
    	//如果有则不查询    	
    	if (Strings.isBlank(category)) {
    		category =  "-1";
        	if(AppContext.hasPlugin("collaboration")){
        		category += ",1,2";
        	}
        	if(AppContext.hasPlugin("edoc")){
        		category += ",4,19,20,21";
        	}
        	if(AppContext.hasPlugin("infosend")){
        		category += ",32";
        	}
            String fragmentId = ReqUtil.getString(request, "fragmentId");
            String ordinal = ReqUtil.getString(request, "ordinal");
            category = collaborationTemplateManager.getMoreTemplateCategorys(category, fragmentId, ordinal);
    	}
        //显示的最近使用模版数量
        Integer recent = ReqUtil.getInt(request, "recent",10);
        //**********************更多页面传递过来的参数处理 end*********************************************
        
        
        //**************************我的模版更多页面传递过来的参数 begin*************************************
        //获取显示授权模版的单位
    	String selectAccountId = request.getParameter("selectAccountId");
    	//是否所有模版。
        String isShowTemplates = "true";
        //传递的单位selectAccountId=1为全部，则查询外单位授权过来的
        if (Strings.isNotBlank(selectAccountId) && "1".equals(selectAccountId)) {
        	isShowTemplates = "true";
        } else if (Strings.isNotBlank(selectAccountId) && !"1".equals(selectAccountId)) {
        	isShowTemplates = "false";
            orgAccountId = Long.parseLong(selectAccountId);
        }
        String searchValue = ReqUtil.getString(request, "searchValue");
        //**************************我的模版更多页面传递过来的参数 end******************************************
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("category",category);
        params.put("subject",searchValue);
        params.put("isToMoreTree",true);
        //合并权限
        templateManager.transMergeCtpTemplateConfig(user.getId());
        
        //根据首页模板栏目编辑页面条件，查询所有配置模板的集合
    	List<CtpTemplate> allTempletes = collaborationTemplateManager.getMyConfigCollTemplate(null, params);
    	List<TemplateVO> showTemplates = new ArrayList<TemplateVO>();
    	
    	Map<String, CtpTemplateCategory> nameCategory = new HashMap<String, CtpTemplateCategory>();
    	Map<Long, CtpTemplateCategory> idCategory =  this.templateManager.getAllShowCategorys(orgAccountId, category,nameCategory);
        
    	
    	//模版所在的单位集合
    	Map<Long,String> accounts = new HashMap<Long,String>();
    	V3xOrgAccount logonOrgAccount = orgManager.getAccountById(orgAccountId);
        if (!accounts.containsKey(logonOrgAccount.getId())) {
        	accounts.put(logonOrgAccount.getId(), logonOrgAccount.getName());
        }
    	
        for (CtpTemplate template : allTempletes) {
        	if(null != template.getFormParentid()){
        		CtpTemplate pTemplate = templateManager.getCtpTemplate(template.getFormParentid());
        		if(null == pTemplate){
        			continue;
        		}else if(null != pTemplate){
        			boolean templateEnabled = templateManager.isTemplateEnabled(pTemplate,AppContext.getCurrentUser().getId());
        			if(!templateEnabled || pTemplate.isDelete() || template.getState().equals(TemplateEnum.State.invalidation.ordinal())){
        				continue;
        			}
        		}
        	}
        	TemplateVO templateVO = new TemplateVO();
        	templateVO.setSubject(template.getSubject());
            //外单位的模板才进行分类合并
            if(!template.getOrgAccountId().equals(orgAccountId)){
            	V3xOrgAccount outOrgAccount = orgManager.getAccountById(template.getOrgAccountId());
                if (!accounts.containsKey(outOrgAccount.getId())) {
                	accounts.put(outOrgAccount.getId(), outOrgAccount.getName());
                }
            	if(!"true".equals(isShowTemplates)){
            		continue;
            	} else if (template.isSystem() && template.getCategoryId() != 0) {// 等于0是顶层的模板
            		CtpTemplateCategory tc = this.templateManager.getCtpTemplateCategory(template.getCategoryId());
            		if (tc != null) {
            			CtpTemplateCategory n = nameCategory.get(tc.getName());
            			if (n != null) {
            				template.setCategoryId(n.getId());
            			} else {
            				//如果需要按照原有单位的单位层级显示的话，后面再考虑，先保持跟3.5 一致
            				tc.setParentId(1l);
            				idCategory.put(tc.getId(), tc);
            				nameCategory.put(tc.getName(), tc);
            			}
            		}
            	}
            }
            // 客开 去除模板名称后缀的单位简称   赵培珅  START
           /* if (!template.getOrgAccountId().equals(user.getLoginAccount())) {
            	V3xOrgAccount outOrgAccount = orgManager.getAccountById(template.getOrgAccountId());
            	templateVO.setSubject(template.getSubject()+"("+outOrgAccount.getShortName()+")");
            }*/
            // 客开 END
            templateVO.setId(template.getId());
            templateVO.setCategoryId(template.getCategoryId());
            templateVO.setMemberId(template.getMemberId());
            templateVO.setModuleType(template.getModuleType());
            templateVO.setSystem(template.isSystem());
            templateVO.setType(template.getType());
            templateVO.setBodyType(template.getBodyType());
            templateVO.setOrgAccountId(template.getOrgAccountId());
            templateVO.setFormAppId(template.getFormAppId());
            showTemplates.add(templateVO);
        }
    	
        
        List<TemplateTreeVo> listTreeVo = new ArrayList<TemplateTreeVo>();
        //一、添加最近使用模版的分类
    	TemplateTreeVo recentTemplate = new TemplateTreeVo();
    	recentTemplate.setId(-1l);
    	recentTemplate.setName(ResourceUtil.getString("template.choose.category.recent.label"));//最近使用根目录
    	recentTemplate.setpId(null);
    	recentTemplate.setType("category");
    	listTreeVo.add(recentTemplate);
        
        List<CtpTemplate> templetes = new ArrayList<CtpTemplate>();
        listTreeVo = getTemplateTree(listTreeVo,category, idCategory, templetes, null,null, null, null,true);
        //新建一个最终显示的分类树
        List<TemplateTreeVo> newTreeVoList = new ArrayList<TemplateTreeVo>();
        //分类id及对应的map
        Map<Long, TemplateTreeVo> categoryMap = new HashMap<Long, TemplateTreeVo>();
        //分类的树
        for(TemplateTreeVo vo:listTreeVo){
        	if ("category".equals(vo.getType()) || "personal".equals(vo.getType()) || "template_coll".equals(vo.getType())
					|| "text_coll".equals(vo.getType()) || "workflow_coll".equals(vo.getType()) || "edoc_coll".equals(vo.getType())) {
        		categoryMap.put(vo.getId(), vo);
        		}
        	// 协同三个根节点："最近使用模板"、"公共模板"、"个人模板"无论下面是否有具体模板，都在前端展示。公文显示对应的公文
			if (vo.getId() == 0 || vo.getId() == 100 || vo.getId() == -1 || ((vo.getId() == Long.valueOf(ModuleType.edoc.getKey())
					|| vo.getId() == Long.valueOf(ModuleType.edocSend.getKey()) || vo.getId() == Long.valueOf(ModuleType.edocRec.getKey())
					|| vo.getId() == Long.valueOf(ModuleType.edocSign.getKey())) && user.getExternalType() == OrgConstants.ExternalType.Inner.ordinal())) {
				newTreeVoList.add(vo);
				}
        }
        for (TemplateVO template : showTemplates) {
			// 如果包含此模板的分类
			if (template.getSystem() && categoryMap.containsKey(template.getCategoryId())) {
				TemplateTreeVo theCategory = categoryMap.get(template.getCategoryId());
				getParentCategory(theCategory, categoryMap, newTreeVoList);
			}else if(!template.getSystem()){//个人模板
				TemplateTreeVo vv =null;
				if("template".equals(template.getType())){//协同模板
					vv=categoryMap.get(101L);
				}else if("text".equals(template.getType())){//格式模板
					vv=categoryMap.get(102L);	
				}else if("workflow".equals(template.getType())){//流程模板
					vv=categoryMap.get(103L);
				}else if("templete".equals(template.getType()) && user.getExternalType() == OrgConstants.ExternalType.Inner.ordinal()){//公文个人模板
					vv=categoryMap.get(104L);
				}else if(null != template.getModuleType() && Integer.valueOf(32).equals(template.getModuleType())){//信息报送
					vv=categoryMap.get(105L);
				}
				if(null !=vv && !newTreeVoList.contains(vv))
					newTreeVoList.add(vv);
			}
		}
        //通过category的sort排序后的tree,listTreeVo是有顺序的
        for(Iterator<TemplateTreeVo> it = listTreeVo.iterator();it.hasNext();){
        	TemplateTreeVo t = it.next();
        	if (!newTreeVoList.contains(t)) {
        		it.remove();
        	}
        }
        request.setAttribute("fftree", listTreeVo);
        
        
        Map<Long, String> templeteIcon = new HashMap<Long, String>();
    	Map<Long, String> templeteCreatorAlt = new HashMap<Long, String>();
    	//设置图标,设置浮动显示的模版来源
    	this.templateManager.floatDisplayTemplateSource(showTemplates, templeteIcon, templeteCreatorAlt);
    	
    	modelAndView.addObject("showTemplates",JSONUtil.toJSONString(showTemplates));
    	modelAndView.addObject("templeteIcon",templeteIcon);
    	modelAndView.addObject("templeteCreatorAlt", templeteCreatorAlt);
        
        modelAndView.addObject("category", category);
        modelAndView.addObject("orgAccountId", orgAccountId);
        modelAndView.addObject("recent", recent);
        modelAndView.addObject("searchValue",Strings.toHTML(CtpTemplateUtil.unescape(searchValue),false));
    	modelAndView.addObject("accounts",accounts);
    	modelAndView.addObject("isShowTemplates",isShowTemplates);
    	
    	return modelAndView;
    	
    }

    /**
     * 将CtpTemplateCategory模板类型对象转换为树节点对象
     * @param idCategory
     * @param listTreeVo
     */
    private void transCategory2TreeVo(Map<Long, CtpTemplateCategory> idCategory, List<TemplateTreeVo> listTreeVo) {
        //分类
        TemplateTreeVo templateTreeVO = null;
        List<CtpTemplateCategory> categoryList = new ArrayList<CtpTemplateCategory>();
        for (CtpTemplateCategory ctpTemplateCategory : idCategory.values()) {
            categoryList.add(ctpTemplateCategory);
        }
        Collections.sort(categoryList, new TemplateCategoryComparator());
        for (CtpTemplateCategory ctpTemplateCategory : categoryList) {
            //做个防护 去除表单模板这个分类。
            if (ctpTemplateCategory.getId() == 2L || ctpTemplateCategory.getId() == 19L
                    || ctpTemplateCategory.getId() == 20L || ctpTemplateCategory.getId() == 21L) {
                continue;
            }
            templateTreeVO = new TemplateTreeVo();
            templateTreeVO.setId(ctpTemplateCategory.getId());
            templateTreeVO.setName(ctpTemplateCategory.getName());
            templateTreeVO.setType("category");
            if (null == ctpTemplateCategory.getParentId()) {
                templateTreeVO.setpId(null);
            } else {
                //表单的插入到公共模板下面
                if (ctpTemplateCategory.getParentId() == 2L || 1L == ctpTemplateCategory.getParentId()) {
                    templateTreeVO.setpId(0L);
                } else {
                    templateTreeVO.setpId(ctpTemplateCategory.getParentId());
                }

            }
            listTreeVo.add(templateTreeVO);
        }
    }

    /**
     * 将CtpTemplate模板对象转换为树节点对象
     * @param showTempletes
     * @param listTreeVo
     * @throws BusinessException
     */
    private void transTemplate2TreeVo(List<CtpTemplate> showTempletes, List<TemplateTreeVo> listTreeVo)
            throws BusinessException {
        TemplateTreeVo templateTreeVO;
        Long caccountId = AppContext.getCurrentUser().getLoginAccount();
        for (CtpTemplate ctpTemplate : showTempletes) { 
            templateTreeVO = new TemplateTreeVo();
            templateTreeVO.setId(ctpTemplate.getId());
            String shortName="";
            if (null != ctpTemplate.getOrgAccountId() && !ctpTemplate.getOrgAccountId().equals(caccountId)) {
            	V3xOrgAccount  orgAccount = orgManager.getAccountById(ctpTemplate.getOrgAccountId());
            	if(null!=orgAccount){
            		shortName = orgAccount.getShortName();
            	}
                if (Strings.isNotBlank(shortName)) {
                    templateTreeVO.setName(ctpTemplate.getSubject() + "(" + shortName + ")");
                } else {
                    templateTreeVO.setName(ctpTemplate.getSubject());
                }
            } else {
                templateTreeVO.setName(ctpTemplate.getSubject());
            }
            templateTreeVO.setType(ctpTemplate.getType());
            // 表单显示在公共模板分类下
            if(Integer.valueOf(32).equals(ctpTemplate.getModuleType())){
            	templateTreeVO.setpId(300L);
            	templateTreeVO.setIsInfo(true);
            }else{
            	templateTreeVO.setpId(ctpTemplate.getCategoryId() == 2 ? 0l : ctpTemplate.getCategoryId());
                templateTreeVO.setIsEdoc(isEdoc(String.valueOf(ctpTemplate.getModuleType())));
            }
            templateTreeVO.setCategoryType(ctpTemplate.getModuleType());
            templateTreeVO.setWorkflowId(ctpTemplate.getWorkflowId());
            templateTreeVO.setBodyType(ctpTemplate.getBodyType());
            //设置浮动显示的title
            V3xOrgMember createrMember = orgManager.getMemberById(ctpTemplate.getMemberId());
            StringBuffer showTitle = new StringBuffer();
	        if(null != createrMember) {
	        	if(Strings.isNotBlank(createrMember.getName())){
	        		//创建人
	        		String creater = ResourceUtil.getString("collaboration.summary.createdBy")+":";
	        		if (null != ctpTemplate.getOrgAccountId() && !ctpTemplate.getOrgAccountId().equals(caccountId)){
	        			
	        			showTitle.append(creater + OrgHelper.showMemberNameOnly(createrMember.getId())//显示单位管理员加简称
	        					+"("+shortName+")"+"\r");
	        		}else{
	        			showTitle.append(creater + OrgHelper.showMemberNameOnly(createrMember.getId()) +"\r");
	        		}
	        	}
	        	try{
	        		if(!createrMember.getIsAdmin()){
	        			//部门
	        			String departMent = ResourceUtil.getString("org.department.label") + ":";
	        			showTitle.append(departMent + Functions.showDepartmentFullPath(createrMember.getOrgDepartmentId())+"\r");
	        		}
	        	}catch(Exception e){
	        		//showTitle.append("部门:"+" ");
	        	}
	        	try{
	        		//岗位
	        		String post = ResourceUtil.getString("org.post.label") + ":";
	        		showTitle.append(post + orgManager.getPostById(createrMember.getOrgPostId()).getName());
	        	}catch(Exception e){
	        		//showTitle.append("岗位:"+" ");
	        	}
	            templateTreeVO.setFullName(showTitle.toString());
	        }
	        templateTreeVO = setWendanId(templateTreeVO,ctpTemplate);
            String icon = getTemplateIcon(ctpTemplate);
            templateTreeVO.setIconSkin(icon);
            templateTreeVO.setFormAppId(ctpTemplate.getFormAppId());
            listTreeVo.add(templateTreeVO);
        }
    }

    private String getTemplateIcon(CtpTemplate ctpTemplate) {
        String icon = "";
        if(null == ctpTemplate.getType()){
        	return "";
        }
        switch (TemplateTypeEnums.getEnumByKey(ctpTemplate.getType())) {
            case workflow:
                icon = "flow";
                break;
            case text:
                icon = "format";
                break;
            case templete:
                icon = "edoc";
                break;
            case template:
                icon = "collaboration";
                break;
        }
        return icon;
    }
    
    private TemplateTreeVo setCategory(String s) {
        TemplateTreeVo ttpersonlVO = null;
        ttpersonlVO = new TemplateTreeVo();
        // 表单和协同的构建根节点(pid为空的，则为顶层)
        ttpersonlVO.setId(Long.valueOf(s));
        if (s.equals(ModuleType.edoc.getValue()))
            ttpersonlVO.setName(ResourceUtil.getString("template.edoc.label"));
        if (s.equals(ModuleType.edocSend.getValue()))
            ttpersonlVO.setName(ResourceUtil.getString("template.edocsend.label"));
        if (s.equals(ModuleType.edocRec.getValue()))
            ttpersonlVO.setName(ResourceUtil.getString("template.edocrec.label"));
        if (s.equals(ModuleType.edocSign.getValue()))
            ttpersonlVO.setName(ResourceUtil.getString("template.edocsign.label"));
        ttpersonlVO.setType("category");
        if (s.equals(ModuleType.edoc.getValue()))
            ttpersonlVO.setpId(null);
        else
            ttpersonlVO.setpId(Long.parseLong(ModuleType.edoc.getValue()));
        return ttpersonlVO;
    }
    //@CheckRoleAccess(roleTypes = { Role_NAME.PerformanceAdmin})  525权限问题
    public ModelAndView templateChooseMul(HttpServletRequest request, HttpServletResponse response)  throws BusinessException {
        ModelAndView modelAndView = new ModelAndView("common/template/templateChooseM");
        String moduleType = request.getParameter("moduleType");
        
        String isMul = request.getParameter("isMul");//是否多选
        String accountId = request.getParameter("accountId");
        String scope = request.getParameter("scope");
        String reportId = request.getParameter("reportId");
        String searchType = request.getParameter("searchType");
        String excludeTemplateIds = request.getParameter("excludeTemplateIds");
        String templateTypes = request.getParameter("templateTypes");
        String isCanSelectCategory = request.getParameter("isCanSelectCategory");
        String memberId = request.getParameter("memberId");
       
        Map<String, String> m = new HashMap<String, String>();
        m.put("moduleType", moduleType);
        m.put("scope", scope);
        m.put("reportId", reportId);
        m.put("searchType", searchType);
        m.put("excludeTemplateIds", excludeTemplateIds);
        m.put("templateTypes", templateTypes);
        m.put("memberId", memberId);
        
        List<TemplateTreeVo> vos = templateManager.getTemplateChooseTreeData(m);
        request.setAttribute("fftemplateTree", vos);
        
        
        Long accountIdLong   = Strings.isBlank(accountId) ? AppContext.currentAccountId() : Long.valueOf(accountId);
        
        boolean isV5Member = AppContext.getCurrentUser().getExternalType() == OrgConstants.ExternalType.Inner.ordinal();
        if (!isV5Member) {
            accountIdLong = OrgHelper.getVJoinAllowAccount();
        }
        // 需要根据指定的类型查找分类
        if (Strings.isBlank(moduleType)) {
            modelAndView.addObject("categoryHTML", templateManager.categoryHTML(accountIdLong,true).toString());
        } else {
            List<String> types = Strings.newArrayList(moduleType.split(","));
            if(types.size() == 1 && (String.valueOf(ModuleType.edoc.getKey()).equals(types.get(0)) 
            							|| String.valueOf(ModuleType.edocSend.getKey()).equals(types.get(0)))
            							|| String.valueOf(ModuleType.edocRec.getKey()).equals(types.get(0))
            							|| String.valueOf(ModuleType.edocSign.getKey()).equals(types.get(0))){
            	
            	modelAndView.addObject("categoryHTML", templateManager.categoryHTMLEdoc(types.get(0)).toString());
            	
            }else{
            	if(types.contains(String.valueOf(ModuleType.edoc.getKey()))){
            		modelAndView.addObject("categoryHTML", templateManager.categoryHTML(accountIdLong).toString());
            	}else{
            		modelAndView.addObject("categoryHTML", templateManager.categoryHTML(accountIdLong,false).toString());
            	}
            }
        }
        
        
        modelAndView.addObject("moduleType", moduleType);
        modelAndView.addObject("isMul", isMul);
        modelAndView.addObject("accountId", accountId);
        modelAndView.addObject("scope", scope);
        modelAndView.addObject("reportId", reportId);
        modelAndView.addObject("isCanSelectCategory", isCanSelectCategory);
        return modelAndView;
    }

    public ModelAndView getDes(HttpServletRequest request,
            HttpServletResponse response) throws BusinessException {
        ModelAndView modelAndView =  new ModelAndView("common/template/templateDes") ;
        String templateId = request.getParameter("templateId");
        String moduleType = request.getParameter("moduleType");
        CtpTemplate ctpTemplate = templateManager.getCtpTemplate(Long.parseLong(templateId));
        if(null == ctpTemplate.getWorkflowId()){
        	return modelAndView;
        }
        String workflowRuleInfo = wapi.getWorkflowRuleInfo(moduleType,ctpTemplate.getWorkflowId().toString());
        modelAndView.addObject("workflowRuleInfo",
        		!Strings.isNotBlank(workflowRuleInfo) ? workflowRuleInfo : Strings.toHTML(workflowRuleInfo));
        return modelAndView;
    }
}
