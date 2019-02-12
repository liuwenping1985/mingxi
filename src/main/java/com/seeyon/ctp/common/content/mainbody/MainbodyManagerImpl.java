package com.seeyon.ctp.common.content.mainbody;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.ContentConfig;
import com.seeyon.ctp.common.content.dao.ContentDao;
import com.seeyon.ctp.common.content.mainbody.handler.MainbodyHandler;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.form.bean.*;
import com.seeyon.ctp.form.service.FormCacheManager;
import com.seeyon.ctp.form.upgrade.UpgradeUtil;
import com.seeyon.ctp.form.util.Enums;
import com.seeyon.ctp.form.util.Enums.FieldAccessType;
import com.seeyon.ctp.form.util.Enums.FormType;
import com.seeyon.ctp.form.util.StringUtils;
import com.seeyon.ctp.util.*;
import com.seeyon.v3x.common.security.AccessControlBean;
import org.apache.commons.logging.Log;
import www.seeyon.com.utils.UUIDUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.sql.SQLException;
import java.util.*;

/**
 * 正文组件Manager实现类
 * @author weijh
 *
 */
public class MainbodyManagerImpl implements MainbodyManager {

    private final Map<MainbodyType, MainbodyHandler> contentHandlerMap    = new HashMap<MainbodyType, MainbodyHandler>();
    private boolean initTag = false;
    private final Map<String, Method>                getContentListMap    = new HashMap<String, Method>();
    private final Map<String, Object>                getContentListMgrMap = new HashMap<String, Object>();
    private static final Log logger = CtpLogFactory.getLog(MainbodyManagerImpl.class);
    private FormCacheManager formCacheManager;
    private AttachmentManager attachmentManager;
    private ContentDao contentDao;
    /**
     * 内容管理接口初始化，内容处理器接口加载
     */
    public void init() {
        Map<String, MainbodyHandler> contentHandlers = AppContext.getBeansOfType(MainbodyHandler.class);
        for (String key : contentHandlers.keySet()) {
            MainbodyHandler handler = contentHandlers.get(key);
            contentHandlerMap.put(handler.getType(), handler);
        }
        initTag = true;
    }

    /* (non-Javadoc)
     * @see com.seeyon.ctp.common.mainbody.ContentManager#transContentNewResponse(com.seeyon.ctp.common.ModuleType, java.lang.Long, com.seeyon.ctp.common.mainbody.ContentType, java.lang.Long, java.lang.Long)
     */
    public CtpContentAllBean transContentNewResponse(ModuleType moduleType, Long moduleId, MainbodyType contentType, String rightId) throws BusinessException {
        CtpContentAllBean content = new CtpContentAllBean();
        //新建时id应该为空
        //content.setId(UUIDUtil.getUUIDLong());
        content.setCreateId(AppContext.currentUserId());
        content.setModuleType(moduleType.getKey());
        content.setModuleId(moduleId);
        content.setModuleTemplateId(0L);
        content.setContentTemplateId(0L);
        content.setContentType(contentType.getKey());
        content.setTitle("");
        content.setContent("");
        content.setSort(0);

        content.setRightId(rightId);
        content.setStatus(MainbodyStatus.STATUS_RESPONSE_NEW);
        content.setViewState(CtpContentAllBean.viewState__editable);
        //处理CtpContentAllBean对象的_contentHtml属性用于显示最终正文
        MainbodyHandler handler = getContentHandler(content.getContentType());
        handler.handleContentView(content);

        return content;
    }
    
    /* (non-Javadoc)
     * @see com.seeyon.ctp.common.content.mainbody.MainbodyManager#transContentViewResponse(com.seeyon.ctp.common.ModuleType, java.lang.Long)
     */
    public List<CtpContentAllBean> transContentViewResponse(int moduleType, Long moduleId) throws BusinessException {
    	return transContentViewResponse(ModuleType.getEnumByKey(moduleType),moduleId, CtpContentAllBean.viewState_readOnly,null,-1);
    }  
    
    public List<CtpContentAllBean> transContentViewResponse(ModuleType moduleType, Long moduleId, Integer viewState, String rightId) throws BusinessException {
    	return transContentViewResponse(moduleType, moduleId, viewState,rightId,-1);
    }
    /* (non-Javadoc)
     * @see com.seeyon.ctp.common.content.mainbody.MainbodyManager#transContentViewResponse(com.seeyon.ctp.common.ModuleType, java.lang.Long, java.lang.Integer, java.lang.String)
     */
    public List<CtpContentAllBean> transContentViewResponse(ModuleType moduleType, Long moduleId, Integer viewState, String rightId, Integer index) throws BusinessException {
        return transContentViewResponse(moduleType, moduleId, viewState, rightId, index, -1l);
    }

	@Override
	public List<CtpContentAllBean> transContentViewResponse(ModuleType moduleType, Long moduleId, Integer viewState, String rightId, Integer index, Long fromCopy)
			throws BusinessException{
		return transContentViewResponse(moduleType, moduleId, viewState, rightId, index, fromCopy,false);
	}

	@Override
	public List<CtpContentAllBean> transContentViewResponse(ModuleType moduleType, Long moduleId, Integer viewState, String rightId, Integer index, Long fromCopy,boolean onlyGenList)
			throws BusinessException {
		List<CtpContentAllBean> contentList = new ArrayList<CtpContentAllBean>();
		if(fromCopy==null||fromCopy.longValue()==-1){//非复制自（目前只有个人计划模块使用了复制自功能）
			//无流程表单rightId表单权限ID，除此之外的其他应用功能 rightId都为节点ID
	        CtpContentAllBean content = null;

			//如果是触发消息来的，则重新根据当前登录人获取权限ID，仅针对无流程表单有此参数 add by chenxb
			String triggerMessage = (String)AppContext.getThreadContext("triggerMessage");
			if (Strings.isNotEmpty(triggerMessage)) {
				String formId = (String) AppContext.getThreadContext("formId");
				if (Strings.isNotEmpty(formId)) {
					FormBean formBean = formCacheManager.getForm(Long.valueOf(formId));
					List<FormBindAuthBean> list = formBean.getBind().getUnflowFormBindAuthByUserId(AppContext.currentUserId());
					if (Strings.isNotEmpty(list)) {
						for (FormBindAuthBean bindAuthBean : list) {
							String auth = bindAuthBean.getAuthByName(FormBindAuthBean.AuthName.BROWSE.getKey());
							if (Strings.isNotBlank(auth) && !"false".equals(auth)) {
								//比如修改权限，可能存在过个，因此需要进行拆分
								String[] auths = auth.split("\\|");
								FormAuthViewBean authViewBean = formBean.getAuthViewBeanById(Long.parseLong(auths[0].split("\\.")[1]));
								if (authViewBean != null) {
									rightId = String.valueOf(authViewBean.getId());
									break;
								}
							}
						}
					}
				}
			}


	        List<CtpContentAll> contentPoList = getContentList(moduleType, moduleId,rightId);
			if(contentPoList==null||contentPoList.isEmpty()){
				logger.error("查询不到正文：moduleType " + String.valueOf(moduleType) + " moduleId " + String.valueOf(moduleId) + " rightId " + String.valueOf(rightId));
			}
	        boolean showIndex = false;
	        if(index!=null&&index!=-1){
		        if((index+1)>contentPoList.size()){
		        	throw new BusinessException("index超出正文数量,moduleId="+moduleId);
		        }
		        if(index.intValue()>=0){
		        	showIndex = true;
		        }
	        }
	        for(int i=0;i<contentPoList.size();i++) {
	        	CtpContentAll contentAll = contentPoList.get(i);
	            content = new CtpContentAllBean(contentAll);
	            content.setViewState(viewState);
	            content.setStatus(MainbodyStatus.STATUS_RESPONSE_VIEW);
	            //表单信息管理需要显示多视图，每个视图有自己查看的rightId
	            if(content.getRightId()==null&&contentAll.getExtraAttr("rightId")!=null){
	                content.setRightId((String)contentAll.getExtraAttr("rightId"));
	            }else{
	                content.setRightId(rightId);
	            }

	            MainbodyHandler handler = getContentHandler(contentAll.getContentType());
	            if (handler == null){throw new BusinessException("Handler not found for content type:" + contentAll.getContentType());}
	            if(showIndex){
	            	content.putExtraMap("showIndex", showIndex);
	            	if(i==index.intValue()&&!onlyGenList){
	            		handler.handleContentView(content);
	            	}else{
	            		content.setContent("");
	            	}
	            	content.putExtraMap("viewTitle", contentAll.getExtraAttr("viewTitle"));
	            }else if(!onlyGenList){
	            	handler.handleContentView(content);
	            }
	            content.putExtraMap("isLightForm", contentAll.getExtraAttr("isLightForm"));
	            contentList.add(content);
	        }
		}else{//需要复制自fromCopy
			String tempRightId = rightId;
			if(Strings.isNotBlank(rightId)&&!"-1".equals(rightId)){
                //处理基础表单或信息管理
                if(rightId.indexOf(".")!=-1){
                    String[] authStrs = rightId.split("_");
                    String ids = authStrs[0];
                    if(ids.contains(",")){
                        tempRightId = ids.substring(ids.indexOf(".")+1,ids.indexOf(","));
                    }else{
                        tempRightId = ids.substring(ids.indexOf(".")+1);
                    }
                }else{
                    tempRightId = rightId;
                }
                rightId =  tempRightId;
        	}
            Map<String,Object> param = new HashMap<String,Object>();
            String hql ="from CtpContentAll where id=:id";
            param.put("id", fromCopy);
            //List<CtpContentAll> contentPoList = DBAgent.find(hql,param);
			List<CtpContentAll> contentPoList = getContentList(hql,param);//修改为可以查询分库的接口
            FormAuthViewBean auth =null;
            FormViewBean view = null;
            if(!StringUtil.checkNull(rightId)){
            	auth = formCacheManager.getAuth(Long.parseLong(rightId));
            	view = formCacheManager.getView(auth.getFormViewId());
            }
            if(contentPoList.size()>0){
            	CtpContentAll contentAll = contentPoList.get(0);
	            CtpContentAllBean content = new CtpContentAllBean(contentAll);
	            content.putExtraMap("viewTitle", (view==null?contentAll.getExtraAttr("viewTitle"):view.getFormViewName()));
	            content.setViewState(viewState);
	            content.setId(UUIDUtil.getUUIDLong());
	            Date now = DateUtil.currentTimestamp();
	            content.setModifyId(AppContext.currentUserId());
	            content.setModuleId(0l);
	            content.setModifyDate(now);
	            content.setCreateId(AppContext.currentUserId());
	            content.setCreateDate(now);
	            content.setStatus(MainbodyStatus.STATUS_RESPONSE_NEW);
	            //表单信息管理需要显示多视图，每个视图有自己查看的rightId
	            if(content.getRightId()==null&&contentAll.getExtraAttr("rightId")!=null){
	                content.setRightId((String)contentAll.getExtraAttr("rightId"));
	            }else{
	                content.setRightId(rightId);
	            }
	            content.putExtraMap("fromCopy", fromCopy);
				if(!onlyGenList) {
					MainbodyHandler handler = getContentHandler(contentAll.getContentType());
					handler.handleContentView(content);
				}
	            content.putExtraMap("isNew", true);
	            contentList.add(content);
            }else{
                FormBean b = formCacheManager.getForm(view.getFormBeanId());
                if(b!=null&&FormType.getEnumByKey(b.getFormType()).isCopyData()){
                	Map params = new HashMap();
                    params.put("moduleType", moduleType.getKey());
                    params.put("moduleId", moduleId);
                    //List<CtpContentAll> tempContentList = DBAgent.findByNamedQuery("ctp_common_content_findContentByModule", params);
					List<CtpContentAll> tempContentList = getContentList("from CtpContentAll cc where cc.moduleType = :moduleType and cc.moduleId = :moduleId",params);
                    CtpContentAll tempTemplate = tempContentList.get(0);
                    CtpContentAllBean content = new CtpContentAllBean();
                	content.setViewState(viewState);
    	            content.setId(UUIDUtil.getUUIDLong());
    	            Date now = DateUtil.currentTimestamp();
    	            content.setModifyId(AppContext.currentUserId());
    	            content.setModuleId(0l);
    	            content.setModifyDate(now);
    	            content.setCreateId(AppContext.currentUserId());
    	            content.setCreateDate(now);
    	            content.setStatus(MainbodyStatus.STATUS_RESPONSE_NEW);
    	            content.setContentDataId(fromCopy);
    	            content.setRightId(rightId);
    	            content.putExtraMap("fromCopy", fromCopy);
    	            content.setViewState(CtpContentAllBean.viewState__editable);
    	            content.setContentTemplateId(b.getId());
    	            content.setContentType(MainbodyType.FORM.getKey());
    	            content.setModuleTemplateId(tempTemplate.getId());
    	            content.setModuleType(tempTemplate.getModuleType());
    	            content.putExtraMap("viewTitle", view.getFormViewName());
					if(!onlyGenList) {
						MainbodyHandler handler = getContentHandler(MainbodyType.FORM.getKey());
						handler.handleContentView(content);
					}
    	            contentList.add(content);
                }else{
                	throw new BusinessException("复制功能参数传递错误");
                }
            }
		}
		if(contentList.size()>0){
			CtpContentAllBean first = contentList.get(0);//协同正文需要判断要不要添加office套红正文
			if(Strings.isBlank(first.getContent())){
				for(CtpContentAllBean c:contentList){
					if(c!=first){
						if(!Strings.isBlank(c.getContent())){
							first.setContent(c.getContent());
						}
					}
				}
			}
			boolean isNew = first.getAttr("isNew")==null?false:(Boolean)(first.getAttr("isNew"));
			if(first!=null&&first.getContentType()!=null&&first.getContentType()== MainbodyType.FORM.getKey()&&first.getModuleType()!=null&&first.getModuleType()== ModuleType.collaboration.getKey()){
				String r = (String)first.getRightId();
				FormBean formBean = formCacheManager.getForm(first.getContentTemplateId());
				Long uuid = 0l;
				Attachment a = null;
				Long templateSubReference = formBean.getSubReference();
				if(isNew&&((Strings.isBlank(first.getContent()))||(first.getContent()!=null&&!first.getContent().matches("[-]{0,1}[\\d]+?")))){
					//可编辑态下office正文附件是空的说明还没有拷贝
					if(viewState== CtpContentAllBean.viewState__editable&&!StringUtil.checkNull(String.valueOf(formBean.getTemplateFileId()))&&templateSubReference!=null&&templateSubReference!=0l){
						uuid = UUIDUtil.getUUIDLong();
						attachmentManager.copy(formBean.getId(), formBean.getSubReference(), first.getContentDataId(), uuid, ApplicationCategoryEnum.form.getKey(), AppContext.currentUserId(), AppContext.currentAccountId());
						for(CtpContentAllBean c:contentList){
							c.setContent(String.valueOf(uuid));
						}
						List<Attachment> atts = attachmentManager.getByReference(first.getContentDataId(), uuid);
						if(atts!=null && atts.size() > 0){
							a = atts.get(0);
							String title = first.getTitle();
							for(Attachment att:atts){
								att.setFilename((title!=null?title:"") + "[正文].doc");
								attachmentManager.update(att);
							}
						}
					}
    			}else{
    				if(first.getContent()!=null){
    					if(first.getContent().matches("[-]{0,1}[\\d]+?")){
        					uuid = Long.parseLong(first.getContent());
        				}
    				}
    			}
				//移动端不显示正文页签，但是通过移动端发送的流程，在pc端查看的时候还是需要显示正文，所以将判断移到这里来
            	if(Strings.isNotBlank(r)&&uuid!=0l){
            		Long rlong = Long.parseLong(r);
            		FormAuthViewBean auth = formBean.getAuthViewBeanById(rlong);
            		if(auth!=null){
            			String tempAuth = auth.getTemplateAuth();
            			if(Strings.isNotBlank(tempAuth)&&!tempAuth.equals(FieldAccessType.hide.getKey())){
            				CtpContentAllBean myContent = new CtpContentAllBean();
            				myContent.setTitle(ResourceUtil.getString("form.auth.field.content.lable"));
            				myContent.putExtraMap("viewTitle", ResourceUtil.getString("form.auth.field.content.lable"));
            				myContent.putExtraMap("isOffice", true);
            				myContent.setModuleType(1);
            				if(a==null){
            					List<Attachment> atts = attachmentManager.getByReference(first.getContentDataId(), uuid);
            					if(atts!=null&&!atts.isEmpty()){
	            					a = atts.get(0);
            					}
            				}
            				//KFZX2017101116555_快速需求响应，判断在提交时是否需要跳转到正文页面。--2017-10-23 by Liyang
							//当前处理节点没有设置高级权限、没有流程意见回填、全部为浏览权限、没有初始值设置，则该节点提交时不做套红和切换到正文视图。
							boolean needSkip = false;
							//没有高级权限
							FormAuthViewBean authParent = null;
							if (auth.getParentId() != null && auth.getParentId() != -1 && auth.getParentId() != 0){
								authParent = formBean.getAuthViewBeanById(auth.getParentId());
							} else {
								authParent = auth;
							}
							if (authParent.getAdvanceAuthType() != -1){
								needSkip = true;
							}
							//所有字段为浏览权限
							if(!Enums.FormAuthorizationType.show.getKey().equals(auth.getType())){
								if (Enums.FormAuthorizationType.add.getKey().equals(auth.getType())) {
									needSkip = true;
								}else if(auth.hasCanEditField()){//此处判断是否有编辑权限即可判断出是否设置流程意见回填
									needSkip = true;
								}
							}
							//没有初始值
							List<FormAuthViewFieldBean> fieldAuthList = auth.getFormAuthorizationFieldList();
							for (FormAuthViewFieldBean fieldAuth : fieldAuthList){
								if (Strings.isNotBlank(fieldAuth.getDefaultValue())) {
									needSkip = true;
									break;
								}
							}
							logger.info("提交时是否需要套红及跳转正文操作："+needSkip);
							if(a != null) {
								String maxSizeStr = AppContext.getSystemProperty("officeFile.maxSize");
								int maxSize = Strings.isBlank(maxSizeStr) ? 8192 : Integer.parseInt(maxSizeStr);
								myContent.setContent("{'extension':'"+a.getExtension()+"','fileId':'"+a.getFileUrl()+"','reference':'"+first.getContentDataId()+"','subReference':'"+uuid+"','auth':'" + tempAuth + "','createDate':'"+ DateUtil.format(first.getCreateDate())+"','formDataId':'"+first.getContentDataId()+"','officeOcxUploadMax':'"+maxSize+"','needSkipMainBody':'"+needSkip+"'}");
							}
            				contentList.add(myContent);
            			}
            		}
            	}
			}
    	}
		return contentList; 
	}

	@SuppressWarnings("unchecked")
    @Override
    public List<CtpContentAll> getContentList(ModuleType moduleType, Long moduleId, String rightId) throws BusinessException {

        List<CtpContentAll> contentList = new ArrayList<CtpContentAll>();
        //表单视图，无流程表单2钟情况下，没有进入正文组件，要单独处理列表
        String getMainbodyList = ContentConfig.getConfig(moduleType).getMainbodyList();
        if ("default".equals(getMainbodyList)) {
            Map params = new HashMap();
            params.put("moduleType", moduleType.getKey());
            params.put("moduleId", moduleId);
            
            /*contentList = contentDao.findByModuleId(moduleType, moduleId);
            if(Strings.isEmpty(contentList)){
            	ContentDao contentDaoFK = (ContentDao)AppContext.getBean("contentDaoFK");
            	if(contentDaoFK != null){
            		contentList = contentDaoFK.findByModuleId(moduleType, moduleId);
            	}
            }*/
			contentList = getContentList(params);
            if(contentList==null||contentList.isEmpty()){
				logger.error("查询不到正文：" + String.valueOf(params));
			}
            String tempRightId = null;
            if(contentList==null||contentList.size()<=0){
            	//老A8升级数据升级没升级上来,尝试重新升级这个表单数据
            	if(Strings.isNotBlank(rightId)&&!"-1".equals(rightId)){
                    //处理基础表单或信息管理
                    if(rightId.indexOf(".")!=-1){
                        String[] authStrs = rightId.split("_");
                        String ids = authStrs[0];
                        if(ids.contains(",")){
                            tempRightId = ids.substring(ids.indexOf(".")+1,ids.indexOf(","));
                        }else{
                            tempRightId = ids.substring(ids.indexOf(".")+1);
                        }
                    }else{
                        tempRightId = rightId;
                    }
            	}
            	if(!StringUtil.checkNull(tempRightId)){
            		FormAuthViewBean auth = formCacheManager.getAuth(Long.parseLong(tempRightId));
            		if(auth!=null){
            			FormViewBean view = formCacheManager.getView(auth.getFormViewId());
                		FormBean b = formCacheManager.getForm(view.getFormBeanId());
                		UpgradeUtil u = new UpgradeUtil();
                		JDBCAgent jdbc = new JDBCAgent(true);
                		try {
							u.upgradeSingleUnflowContentData(jdbc,b);
						} catch (Exception e) {
							logger.error(e.getMessage(),e);
							throw new BusinessException(ResourceUtil.getString("form.exception.datanotexit"));
						} finally{
							jdbc.close();
						}
                		//contentList = DBAgent.findByNamedQuery("ctp_common_content_findContentByModule", params);
						contentList = getContentList("from CtpContentAll cc where cc.moduleType = :moduleType and cc.moduleId = :moduleId",params);
                		if(contentList==null||contentList.size()<=0){
                			throw new BusinessException(ResourceUtil.getString("form.exception.datanotexit"));
                		}
            		}else{
            			throw new BusinessException(ResourceUtil.getString("form.exception.datanotexit"));
            		}
            	}else{
            		throw new BusinessException(ResourceUtil.getString("form.exception.datanotexit"));
            	}
            }
            CtpContentAll tempContent =  contentList.get(0);
            //表单id
            Long formId = tempContent.getContentTemplateId();
            FormBean formBean = null;
            if(tempContent.getContentType() == MainbodyType.FORM.getKey()){//这个地方防护， 待发情况下，删除表单后，打开表单报异常这种测试极其罕见情况
	            formBean = formCacheManager.getForm(formId);
	            /**********************兼容一下a6升级上来的动态表id作为moduleId重复的问题******start*********************/
	            if(Strings.isNotBlank(rightId)&&!"-1".equals(rightId)){
	            	if(StringUtil.checkNull(tempRightId)){
	                    //处理基础表单或信息管理
	                    if(rightId.indexOf(".")!=-1){
	                        String[] authStrs = rightId.split("_");
	                        String ids = authStrs[0];
	                        if(ids.contains(",")){
	                            tempRightId = ids.substring(ids.indexOf(".")+1,ids.indexOf(","));
	                        }else{
	                            tempRightId = ids.substring(ids.indexOf(".")+1);
	                        }
	                    }else{
	                        tempRightId = rightId;
	                    }
	            	}
                    Iterator<CtpContentAll> iteratorList = contentList.iterator();
                    while(iteratorList.hasNext()){
                        CtpContentAll ctpContentAll = iteratorList.next();
                        Long tempFormId = ctpContentAll.getContentTemplateId();
                        FormBean tempFormBean = null;
                        tempFormBean = formCacheManager.getForm(tempFormId);
                        if(tempFormBean != null){
                            String rightIdStr = String.valueOf(this.formCacheManager.getNewOperationId(tempFormId, Long.parseLong(tempRightId)));
                            FormAuthViewBean formAuthViewBean = tempFormBean.getAuthViewBeanById(Long.parseLong(rightIdStr));
                            if(formAuthViewBean != null){
                                formBean = tempFormBean;
                                formId = formBean.getId();
                                tempContent = ctpContentAll;
                                ctpContentAll.putExtraAttr("viewTitle", formBean.getFormView(formAuthViewBean.getFormViewId()).getFormViewName());//视图名称
                            }else{
                                iteratorList.remove();
                            }
                        }
                    }
                }
                /**********************兼容一下a6升级上来的动态表id作为moduleId重复的问题***end************************/
	            if(formBean==null){
	            	throw new BusinessException(ResourceUtil.getString("form.exception.formdatadelete"));
	            }
            }
            //根据rightId中是否包含|来构造多个页签  格式:view1.right1,right2|view2.right3,right4
            if(!StringUtil.checkNull(rightId)&&(rightId.indexOf("_")!=-1||rightId.indexOf(".")!=-1||rightId.indexOf(",")!=-1)){
                contentList.clear();
                String[] authStrs = rightId.split("_");
                for(String authStr:authStrs){
                    if(StringUtil.checkNull(authStr)){
                        continue;
                    }
                    String[] viewAndAuth = authStr.split("[.]");
                    if(viewAndAuth.length<=1){
                    	String[] tviewAndAuth = new String[2];
                    	FormAuthViewBean a = formBean.getAuthViewBeanById(Long.parseLong(viewAndAuth[0]));
                    	tviewAndAuth[0] = String.valueOf(a.getFormViewId());
                    	tviewAndAuth[1] = viewAndAuth[0];
                    	viewAndAuth = tviewAndAuth;
                    }
                    String viewIdStr = viewAndAuth[0];
                    String rightIdStr = viewAndAuth[1];
                    FormAuthViewBean formAuthViewBean = formBean.getAuthViewBeanById(Long.parseLong(rightIdStr));
                    Long viewId = Long.parseLong(viewIdStr);
                    /**********************兼容3.5导出再导入的问题表单数据***************************/
                    if(rightIdStr!=null){
	                    if(rightIdStr.indexOf(",")!=-1){
	                    	String[] rids = rightIdStr.split(",");
	                    	boolean b = false;
	                    	rightIdStr = "";
	                    	for(String rid:rids){
	                    		Long lrid = Long.parseLong(rid);
	                    		rightIdStr += String.valueOf(this.formCacheManager.getNewOperationId(formId, lrid))+",";
	                    		if(!b){
	                    			viewId = formBean.getAuthViewBeanById(lrid).getFormViewId();
	                    			b = true;
	                    		}
	                    	}
	                    	rightIdStr = StringUtils.replaceLast(rightIdStr, ",", "");
	                    }else{
		                    rightIdStr = String.valueOf(this.formCacheManager.getNewOperationId(formId, Long.parseLong(rightIdStr)));
		                    viewId = formBean.getAuthViewBeanById(Long.parseLong(rightIdStr)).getFormViewId();
	                    }
                    }
                    /**********************兼容3.5导出再导入的问题表单数据end************************/
                    CtpContentAll myContent = new CtpContentAll();
                    myContent.setId(tempContent.getId());
                    myContent.setContent(tempContent.getContent());
                    myContent.setContentDataId(tempContent.getContentDataId());
                    myContent.setContentTemplateId(tempContent.getContentTemplateId());
                    myContent.setContentType(tempContent.getContentType());
                    myContent.setCreateDate(tempContent.getCreateDate());
                    myContent.setCreateId(tempContent.getCreateId());
                    myContent.setModifyDate(tempContent.getModifyDate());
                    myContent.setModifyId(tempContent.getModifyId());
                    myContent.setModuleId(tempContent.getModuleId());
                    myContent.setModuleTemplateId(tempContent.getModuleTemplateId());
                    myContent.setModuleType(tempContent.getModuleType());
                    myContent.setSort(tempContent.getSort());
                    FormViewBean formViewBean = formAuthViewBean.getViewBean(formBean, true);
                    myContent.putExtraAttr("isLightForm", formViewBean.isPhone());
                    myContent.putExtraAttr("viewTitle", formBean.getFormView(viewId).getFormViewName());//视图名称
                    myContent.setTitle(tempContent.getTitle());//正文标题
                    myContent.putExtraAttr("rightId", rightIdStr);
                    contentList.add(myContent);
                }
            }else if(Strings.isNotBlank(rightId) && rightId.matches("-?\\d+$") && formBean != null){
                //OA-108613微协同：待发、已发单击查看表单，不管是否设置了移动视图，都显示原样表单
            	
                FormAuthViewBean formAuthViewBean = formBean.getAuthViewBeanById(Long.parseLong(rightId));
                
                if(formAuthViewBean != null){
                	 FormViewBean formViewBean = formAuthViewBean.getViewBean(formBean, true);
                     //设置移动表单参数
                	 if(formViewBean != null){
                		 for(CtpContentAll myContent : contentList){
                             myContent.putExtraAttr("isLightForm", formViewBean.isPhone());
                         }
                	 }
                }
            }
        } else {
            Method m = getContentListMap.get(getMainbodyList);
            try {
                if (m == null) {
                    int idx = getMainbodyList.lastIndexOf('.');
                    if (idx != -1) {
                        String clsName = getMainbodyList.substring(0, idx);
                        String methodName = getMainbodyList.substring(idx + 1);
                        Class cls;
                        Object mgr = null;
                        if (clsName.indexOf('.') == -1) {
                            mgr = AppContext.getBean(clsName);
                            cls = mgr.getClass();
                            getContentListMgrMap.put(getMainbodyList, mgr);
                        } else {
                            cls = Class.forName(clsName);
                        }
                        Class[] types = { ModuleType.class, Long.class };
                        Method mm = cls.getDeclaredMethod(methodName, types);
                        if (mm != null && mm.getReturnType() == List.class) {
                            m = mm;
                            getContentListMap.put(getMainbodyList, m);
                        }
                    }
                }
                if (m != null) {
                    Object[] datas = { moduleType, moduleId };
                    contentList = (List<CtpContentAll>) m.invoke(getContentListMgrMap.get(getMainbodyList), datas);
                } else
                    throw new BusinessException("Method not found:" + getMainbodyList);
            } catch (Exception e) {
                throw new BusinessException("Error occured while find method:" + getMainbodyList, e);
            }
        }
        return contentList;
    }
    @Override
    public List<CtpContentAll> getContentListByModuleIdAndModuleType(ModuleType moduleType, Long moduleId){
    	return getContentListByModuleIdAndModuleType(moduleType, moduleId, true);
    }
    
    @Override
    public List<CtpContentAll> getContentListByModuleIdAndModuleType(ModuleType moduleType, Long moduleId, boolean needSetTitle) {
        List<CtpContentAll> contentList = getContentListByModuleIdAndModuleType(moduleType, CommonTools.newArrayList(moduleId));
        if (needSetTitle && AppContext.getThreadContext("contentTitle") != null) {
            for (CtpContentAll c : contentList) {
                c.setTitle(String.valueOf(AppContext.getThreadContext("contentTitle")));//协同那边生成的标题，如果在同一个事物中查询正文，查询出来还是没有提交事物的数据
            }
        }
        return contentList;
    }
    
    public List<CtpContentAll> getContentListByModuleIdAndModuleType(ModuleType moduleType, List<Long> moduleIds) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("moduleType", moduleType.getKey());
        params.put("moduleIds", moduleIds);
        String hql = "from CtpContentAll cc where cc.moduleType = :moduleType and cc.moduleId in(:moduleIds)";
        //return DBAgent.find(hql, params);
		return getContentList(hql, params);
    }
    @Override
	public List<CtpContentAll> getContentListByCreateTime(ModuleType moduleType, int contentType, Date before, Date after)
			throws BusinessException {
    	Map<String, Object> params = new HashMap<String, Object>();
        params.put("moduleType", moduleType.getKey());
		params.put("contentType",contentType);
    	params.put("before", before);
    	params.put("after", after);
        String hql = "from CtpContentAll cc where cc.moduleType = :moduleType and contentType = :contentType and cc.createDate >= :before and cc.createDate <= :after and cc.contentDataId <> null";
		//return DBAgent.find(hql, params);
		return getContentList(hql, params);
    }

	@Override
	public List<CtpContentAll> getContentListByFlipInfo(FlipInfo flipInfo, Map<String,Object> param) throws BusinessException {
		String sql = "from CtpContentAll cca where cca.moduleType in (:moduleType) and cca.contentType = :contentType and cca.createDate >= :starDate and cca.createDate <= :endDate and cca.contentDataId <> null";
		return DBAgent.find(sql, param, flipInfo);
	}

	@Override
    public List<CtpContentAll> getContentListByContentDataIdAndModuleType(int moduleType, Long contentDataId){
        List<CtpContentAll> contentList = new ArrayList<CtpContentAll>();
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("moduleType", moduleType);
        params.put("contentDataId", contentDataId);
        //contentList = DBAgent.findByNamedQuery("ctp_common_content_findContentByContentDataId", params);
		//String sql = "from CtpContentAll cc where cc.moduleType = :moduleType and cc.contentDataId = :contentDataId";
		contentList = getContentList(params);
        return contentList;    	
    }

    @Override
    public List<CtpContentAll> getUnflowContentListByContentDataId(int contentType, Long contentDataId){
    	List<CtpContentAll> contentList = new ArrayList<CtpContentAll>();
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("contentType", contentType);
        params.put("contentDataId", contentDataId);
        //contentList = DBAgent.find("from CtpContentAll cc where (cc.moduleType="+ ModuleType.unflowBasic.getKey()+" or cc.moduleType="+ ModuleType.unflowInfo.getKey()+") and cc.contentType = :contentType and cc.contentDataId = :contentDataId", params);

		String sql = "from CtpContentAll cc where (cc.moduleType="+ ModuleType.unflowBasic.getKey()+" or cc.moduleType="+ ModuleType.unflowInfo.getKey()+") and cc.contentType = :contentType and cc.contentDataId = :contentDataId";
		contentList = getContentList(sql, params);

        return contentList;
    }

	/**
	 * 根据参数查询ctpContentALl，传入的参数map，其键值必须是ctpContentALL的属性，因为要将key作为属性来组装hql语句，这一点切记
	 * 默认分库查询
	 *
	 * @param params 传入的查询参数
	 */
	public List<CtpContentAll> getContentList(Map<String, Object> params) {
		return getContentList(params, true);
	}

	/**
	 * 根据参数查询ctpContentALl，传入的参数map，其键值必须是ctpContentALL的属性，因为要将key作为属性来组装hql语句，这一点切记
	 *
	 * @param params      传入的查询参数
	 * @param needQueryFk 是否需要查询分库
	 */
	public List<CtpContentAll> getContentList(Map<String, Object> params, boolean needQueryFk) {
		List<CtpContentAll> contentList = contentDao.getContentList(params);
		if (needQueryFk && AppContext.hasPlugin("fk") && Strings.isEmpty(contentList)) {
			ContentDao contentDaoFK = (ContentDao) AppContext.getBean("contentDaoFK");
			if (contentDaoFK != null) {
				contentList = contentDaoFK.getContentList(params);
			}
		}
		return contentList;
	}

	/**
	 * 根据传入的sql语句和参数查询cptContentAll 此方法用于需要增加默认的查询条件的时候使用，
	 * 传入的参数map，其键值必须是ctpContentALL的属性，因为要将key作为属性来组装hql语句，这一点切记
	 * 默认分库查询
	 *
	 * @param sql    已经组装好的hql语句
	 * @param params 传入的查询参数
	 */
	public List<CtpContentAll> getContentList(String hql, Map<String, Object> params) {
		return getContentList(hql, params, true);
	}

	/**
	 * 根据传入的sql语句和参数查询cptContentAll 此方法用于需要增加默认的查询条件的时候使用，
	 * 传入的参数map，其键值必须是ctpContentALL的属性，因为要将key作为属性来组装hql语句，这一点切记
	 *
	 * @param sql         已经组装好的hql语句
	 * @param params      传入的查询参数
	 * @param needQueryFk 是否需要查询分库
	 */
	public List<CtpContentAll> getContentList(String sql, Map<String, Object> params, boolean needQueryFk) {
		List<CtpContentAll> contentList = contentDao.getContentList(sql, params);
		if (needQueryFk && AppContext.hasPlugin("fk") && Strings.isEmpty(contentList)) {
			ContentDao contentDaoFK = (ContentDao) AppContext.getBean("contentDaoFK");
			if (contentDaoFK != null) {
				contentList = contentDaoFK.getContentList(sql, params);
			}
		}
		return contentList;
	}

    public boolean transContentSaveOrUpdateWithoutDB(CtpContentAllBean content) throws BusinessException {
        return transContentSaveOrUpdate(content);
    }
    public boolean transContentSaveOrUpdate(CtpContentAllBean content) throws BusinessException {
    	Date currentDate = DateUtil.currentTimestamp();
    	User user = AppContext.getCurrentUser();
    	Long id = content.getId();
    	boolean isNew = false;
    	MainbodyHandler handler = getContentHandler(content.getContentType());
    	if (id == null || id == -1l || id == 0l ){//新建正文
    		isNew = true;
    	    Long moduleTemplateId =(Long)content.getExtraMap().get("moduleTemplateId");
            if(null != moduleTemplateId){
                content.setModuleTemplateId(moduleTemplateId);
            }
    		content.setCreateDate(content.getCreateDate() == null ? currentDate : content.getCreateDate());
    		content.setCreateId((content.getCreateId() == null || content.getCreateId().longValue() == 0) ? AppContext.currentUserId() : content.getCreateId());
			 //TODO 支持多正文之后sort需要修改
    		content.setSort(0);
    		content.setId(UUIDUtil.getUUIDLong());
    		//设置正文状态为新建保存
    		content.setStatus(MainbodyStatus.STATUS_POST_SAVE);
    	}else{//修改正文
    		isNew = false;
    		content.setModifyId(user.getId());
            content.setModifyDate(currentDate);
            //设置正文状态为修改保存
            content.setStatus(MainbodyStatus.STATUS_POST_UPDATE);
    	}
    	handler.beforeSaveContent(content);
    	//各种类型的正文自身逻辑保存成功后，才会执行正文组件的保存
        if(handler.handleContentSaveOrUpdate(content)){
	        CtpContentAll contentAll = content.toContentAll();
	        
	        Long moduleId = contentAll.getModuleId();
	        if(moduleId != null && moduleId.intValue() == -1){
	            throw new IllegalArgumentException("错误的moduleId");
	        }
			String info ="isNew:" + String.valueOf(isNew) +  " ID:" + String.valueOf(contentAll.getId()) + " module_id:" + String.valueOf(contentAll.getModuleId()) + " content_data_id:" + String.valueOf(contentAll.getContentDataId());
	        if(isNew){
	            DBAgent.save(contentAll);
				logger.info("保存正文，" + info);
	        }
	        else{
	            DBAgent.update(contentAll);
				logger.info("修改正文，" + info);
	        }
	        handler.afterSaveContent(content);
        }else{return false;}
        return true;
    }

    public MainbodyHandler getContentHandler(Integer contentType) throws BusinessException {
    	if(!initTag){
			this.init();
		}
        MainbodyHandler handler = contentHandlerMap.get(MainbodyType.getEnumByKey(contentType));
        if (handler == null)
            throw new BusinessException("不支持的正文类型：" + contentType);
        return handler;
    }

    @Override
    public void saveOrUpdateContentAll(CtpContentAll contentAll) throws BusinessException {
        DBAgent.saveOrUpdate(contentAll);
    }

    @Override
    public void deleteContentAllByModuleId(ModuleType moduleType, Long moduleId) throws BusinessException {
        DBAgent.bulkUpdate("delete from CtpContentAll cc where moduleId = ? and moduleType = ?", moduleId,
                moduleType.getKey());
    }

    /* (non-Javadoc)
     * @see com.seeyon.ctp.common.mainbody.ContentManager#testContentList(com.seeyon.ctp.util.FlipInfo, java.util.Map)
     */
    public FlipInfo testContentList(FlipInfo fi, Map paramsIn) throws BusinessException {
        List<CtpContentAllBean> contentList = new ArrayList<CtpContentAllBean>();
        Map params = new HashMap();
        params.put("moduleType", ParamUtil.getInt(paramsIn, "moduleType", ModuleType.collaboration.getKey()));
        List<CtpContentAll> contentAllList = DBAgent.findByNamedQuery("ctp_common_content_findContentByModuleType",
                params, fi);
        for (CtpContentAll contentAll : contentAllList) {
            CtpContentAllBean content = new CtpContentAllBean(contentAll);
            contentList.add(content);
        }
        return fi;
    }

    /**
     * @return the formCacheManager
     */
    public FormCacheManager getFormCacheManager() {
        return formCacheManager;
    }

    /**
     * @param formCacheManager the formCacheManager to set
     */
    public void setFormCacheManager(FormCacheManager formCacheManager) {
        this.formCacheManager = formCacheManager;
    }

    @Override
    public int updateContentTitle(Long id, String title) {
        Map<String,Object> param = new HashMap<String,Object>();
        param.put("id", id);
        param.put("title", title);
        return DBAgent.bulkUpdate("update CtpContentAll c set c.title=:title where c.id=:id", param);
    }
    
    public void deleteById(Long id)throws BusinessException {
    	 Map<String,Object> param = new HashMap<String,Object>();
    	 param.put("id", id);
    	 List<CtpContentAll> contents = DBAgent.find("from CtpContentAll c where c.id=:id", param);
    	 if(contents.size()>0){
    		 CtpContentAll content = contents.get(0);
    		 if(null!=content){
    			 try {
    				 boolean isDeleteFormData = Integer.valueOf(20).equals(content.getContentType());
    				 MainbodyService.getInstance().deleteContentAllByModuleId(ModuleType.getEnumByKey(content.getModuleType()), content.getModuleId(),isDeleteFormData);
    			 } catch (SQLException e) {
    				 throw new BusinessException(e);
    			 }
    		 }
    	 }
    }

	public Map getByModuleIdAndType(Map<String, Object> map) throws BusinessException {
		Map<String, Object> param = new HashMap<String, Object>();
		//String hql = " from CtpContentAll c  where c.moduleType=:moduleType and c.moduleId=:moduleId";
		param.put("moduleType", (Integer) map.get("moduleType"));
		param.put("moduleId", Long.valueOf((String) map.get("moduleId")));
		//List<CtpContentAll> find = DBAgent.find(hql, param);
		List<CtpContentAll> find = getContentList(param);
		Map reMap = new HashMap();
		if (!Strings.isEmpty(find)) {
			reMap.put("contentId", find.get(0).getId());
		} else {
			reMap.put("contentId", 0);
		}
		return reMap;
	}

	@Override
	public CtpContentAll getContentById(Long id) throws BusinessException {
		Map<String,Object> param = new HashMap<String,Object>();
		//String hql =" from CtpContentAll c  where c.id=:id";
		param.put("id",id);
		//List<CtpContentAll> find = DBAgent.find(hql, param);
		List<CtpContentAll> find = getContentList(param);
		CtpContentAll contentAll = null;
		if(find != null && !find.isEmpty()){
			contentAll = find.get(0);
		}
		return contentAll;
	}

    @Override
    public boolean checkRight(CtpContentAllBean content, HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        MainbodyHandler handler = getContentHandler(content.getContentType());
        ApplicationCategoryEnum e = handler.getCategoryEnum(content);
        if (e == null) {
            return true;
        }
        String relObjId = ReqUtil.getString(request, "relObjId", "");
        if (Strings.isNotBlank(relObjId)) {
            if (AccessControlBean.getInstance().isAccess(e, relObjId, AppContext.currentUserId())) {
				AccessControlBean.getInstance().addAccessControl(e, content.getModuleId().toString(), AppContext.currentUserId());
                return true;
            }
        }
        if (AccessControlBean.getInstance().isAccess(e, content.getModuleId().toString(), AppContext.currentUserId())) {
            return true;
        }
        boolean result = handler.checkRight(content, request, response);
        if (!result) {
            showAlert(request, response, AppContext.getCurrentUser());
        } else {
            AccessControlBean.getInstance().addAccessControl(e, content.getModuleId().toString(), AppContext.currentUserId());
        }
        return result;
    }

    private void showAlert(HttpServletRequest request, HttpServletResponse response, User user) {
        StringBuffer msg = new StringBuffer();
        msg.append("用户[").append(user.getLoginName()).append(", ").append(
                user.getRemoteAddr()).append("]试图访问无权查看的主题:");
        if ("GET".equals(request.getMethod())) {
            msg.append(request.getQueryString());
        } else {
            Enumeration e = (Enumeration) request.getParameterNames();
            while (e.hasMoreElements()) {
                String parName = (String) e.nextElement();
                msg.append(parName + ":" + request.getParameter(parName) + "|");
            }
        }
        logger.warn(msg.toString());
        boolean isM1 = AppContext.getCurrentUser() != null && AppContext.getCurrentUser().isFromM1();
        if(!isM1){
            showAlert(response, "您无权查看该主题!");
        }
    }

    private static void showAlert(HttpServletResponse response, String msg) {
        try {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert('" + msg + "');");
            out.println("try{");
            out.println("if(window.parentDialogObj && window.parentDialogObj['dialogDealColl']){");
            out.println(" window.parentDialogObj['dialogDealColl'].close();");
            out.println("}else if(window.dialogArguments){"); //弹出
            out.println("  window.close();");
            out.println("}else{");
            out.println(" window.parent.close();");
            out.println("}");
            out.print("}catch(e){}");
            out.println("</script>");
        } catch (IOException e1) {
            logger.error("",e1);
        }
    }
    
    @Override
    public Integer updateTitleByModuleId(String title, Long moduleId) {
    	Map<String,Object> param = new HashMap<String,Object>();
    	param.put("moduleId", moduleId);
    	param.put("title", title);
    	return DBAgent.bulkUpdate("update CtpContentAll c set c.title=:title where c.moduleId=:moduleId", param);
    }

    public AttachmentManager getAttachmentManager() {
		return attachmentManager;
	}

	public void setAttachmentManager(AttachmentManager attachmentManager) {
		this.attachmentManager = attachmentManager;
	}

	public ContentDao getContentDao() {
		return contentDao;
	}

	public void setContentDao(ContentDao contentDao) {
		this.contentDao = contentDao;
	}
	
}