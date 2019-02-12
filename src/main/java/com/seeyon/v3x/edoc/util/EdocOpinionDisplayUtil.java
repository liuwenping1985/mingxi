package com.seeyon.v3x.edoc.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.po.OrgMember;
import com.seeyon.ctp.organization.po.OrgPost;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.edoc.constants.EdocOpinionDisplayEnum.OpinionDateFormatSetEnum;
import com.seeyon.v3x.edoc.constants.EdocOpinionDisplayEnum.OpinionShowNameTypeEnum;
import com.seeyon.v3x.edoc.domain.EdocOpinion;
import com.seeyon.v3x.edoc.domain.EdocOpinion.OpinionType;
import com.seeyon.v3x.edoc.manager.EdocHelper;
import com.seeyon.v3x.edoc.webmodel.EdocOpinionBO;
import com.seeyon.v3x.edoc.webmodel.EdocOpinionModel;
import com.seeyon.v3x.edoc.webmodel.FormOpinionConfig;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;
import com.seeyon.v3x.system.signet.enums.V3xHtmSignatureEnum;
import com.seeyon.v3x.system.signet.manager.V3xHtmDocumentSignatManager;

public class EdocOpinionDisplayUtil {
	private static final Log LOGGER = LogFactory.getLog(EdocOpinionDisplayUtil.class);

	private static String getAttitude(Integer opinionType,int attitude){

		String attitudeStr=null;
		String attitudeI18nLabel = "";

		//查找国际化标签。
		if (attitude > 0) {
			if(OpinionType.backOpinion.ordinal() == opinionType.intValue()){
				attitudeI18nLabel="stepBack.label";
			}
			//OA-18228 待办中进行终止操作，终止后到已办理查看，态度显示仍然是普通的，不是终止
			else if(OpinionType.stopOpinion.ordinal() == opinionType.intValue()){
			    attitudeI18nLabel="stepStop.label";
			}
			//OA-19935  客户bug验证：流程是gw1，gw11，m1，串发，m1撤销，gw1在待发直接查看（不是编辑态），文单上丢失了撤销的意见
			else if(OpinionType.repealOpinion.ordinal() == opinionType.intValue()){
                attitudeI18nLabel="edoc.repeal.2.label";
            }else if(OpinionType.transferOpinion.ordinal() == opinionType.intValue()){//移交
            	attitudeI18nLabel="edoc.transfer.label";
            }
			else{
			    EnumManager enumManager = (EnumManager)AppContext.getBean("enumManagerNew");
				attitudeI18nLabel = enumManager.getEnumItemLabel(EnumNameEnum.collaboration_attitude, 
						Integer.toString(attitude));
			}
		}

		//查找用于显示的前台态度字符串
		if (Strings.isNotBlank(attitudeI18nLabel)) {

			attitudeStr = ResourceUtil.getString(attitudeI18nLabel);
		} else if ( attitude == com.seeyon.v3x.edoc.util.Constants.EDOC_ATTITUDE_NULL) {
			attitudeStr = null;
		}

		if (opinionType == EdocOpinion.OpinionType.senderOpinion.ordinal()) attitudeStr = null;

		return attitudeStr;
	}
	/**
	 * 取公文单显示的时候的人名
	 * @param userId
	 * @param proxyName
	 * @param orgManager
	 * @param popUserInfo 是否新增用户信息选项卡连接 true 添加， false 不添加
	 * @param attitude 
	 * @param openFrom 
	 * @return
	 */
	private static String getOpinionUserName(Long userId,String proxyName,OrgManager orgManager, FormOpinionConfig displayConfig,
	        EdocOpinion edocOpinion, boolean popUserInfo, String attitude, String openFrom){
		String doUserName = "";
		try {
			V3xOrgMember member = orgManager.getMemberById(userId);
			doUserName = member.getName();

			//只有在文单内才显示签名
			if(edocOpinion.isBound() && OpinionShowNameTypeEnum.SIGN.getValue().equals(displayConfig.getShowNameType())){//电子签名显示方式
			    V3xHtmDocumentSignatManager htmSignetManager = (V3xHtmDocumentSignatManager)AppContext.getBean("htmSignetManager");
			    V3xHtmDocumentSignature vSign = htmSignetManager.getBySummaryIdAffairIdAndType(edocOpinion.getEdocSummary().getId(),
	                    edocOpinion.getAffairId(),
	                    V3xHtmSignatureEnum.HTML_SIGNATURE_EDOC_FLOW_INSCRIBE.getKey());
			    if(vSign != null){
			        String path = SystemEnvironment.getContextPath();
			        if(displayConfig.isNameAndDateNotInline()) {
			        	doUserName += (attitude + "&nbsp;");
			        }
			        doUserName = "<IMG alt=\""+Strings.toHTML(doUserName)+"\" style=\"vertical-align: text-bottom;\" src=\""+path+"/edocController.do?method=showInscribeSignetPic&id="+vSign.getId()+"\" >";
			    }
			}
			
			if (member.getIsAdmin()) {
				// 如果是管理员终止，不显示管理员名字及时间
				doUserName = "";
			} else if(popUserInfo) {
				if("PC".equals(openFrom) && displayConfig.isNameAndDateNotInline()) {
		        	doUserName = "<span class='link-blue' onclick='javascript:showV3XMemberCard(\""
		        			+ userId
		        			+ "\",parent.window)'>"
		        			+ attitude
		        			+ "&nbsp;"
		        			+ doUserName + "</span>";
		        }else {
		        	doUserName = "<span class='link-blue' onclick='javascript:showV3XMemberCard(\""
		        			+ userId
		        			+ "\",parent.window)'>"
		        			+ doUserName + "</span>";
		        }
			}

			if (!Strings.isBlank(proxyName)) {
				doUserName += ResourceBundleUtil
						.getString(
								"com.seeyon.v3x.edoc.resources.i18n.EdocResource",
								"edoc.opinion.proxy", proxyName);
			}
			//处理人姓名单行显示
			if("PC".equals(openFrom) && displayConfig.isNameAndDateNotInline()) {
				doUserName ="<div>" + doUserName + "</div>";
			}
		} catch (Exception e) {
			LOGGER.error("取公文单显示的时候的人名 抛出异常",e);
		}
		return doUserName;
	}

	/**
	 * 将意见对象转化为前台展现的JS串。
	 * @param map
	 * @param signatuers
	 * @param hasSignature
	 * @return
	 */
	public static Map<String,Object> convertOpinionToString(Map<String,EdocOpinionModel> map,
			FormOpinionConfig displayConfig, CtpAffair currentAffair, boolean isFromPending,
			List<V3xHtmDocumentSignature> signatuers) {
		Map<String,Object> jsMap = _convertOpinionToString(map,displayConfig,currentAffair,isFromPending,signatuers,false, true);
		return jsMap;
	}

	public static Map<String,Object> _convertOpinionToString(Map<String,EdocOpinionModel> map,
			FormOpinionConfig displayConfig, CtpAffair currentAffair, boolean isFromPending,
			List<V3xHtmDocumentSignature> signatuers,boolean canSeeMyselfOpinion, boolean pcStyle) {
		Map<Long, StringBuilder> senderAttMap = new HashMap<Long, StringBuilder>();
		List<EdocOpinion> senderOpinions = new ArrayList<EdocOpinion>();

		Map<String,Object> jsMap = new HashMap<String,Object>();
		StringBuilder fileUrlStr = new StringBuilder();
		for(Iterator<String> it = map.keySet().iterator();it.hasNext();){
			//公文单上元素位置
			String element = it.next();
			EdocOpinionModel model = map.get(element);
			List<EdocOpinion> opinions = model.getOpinions();
			for(EdocOpinion opinion : opinions) {
				//取回或者暂存待办的意见回写到意见框中，所以要跳过；其他情况下显示到意见区域
				if (opinion.getOpinionType().intValue() == EdocOpinion.OpinionType.provisionalOpinoin.ordinal()
						|| opinion.getOpinionType().intValue() == EdocOpinion.OpinionType.draftOpinion.ordinal()) {
					if(currentAffair!=null && canSeeMyselfOpinion){
						if(opinion.getAffairId() != currentAffair.getId()){
							continue;
						}
					}else{
						continue;
					}
				}


				//公文单不显示暂存待办意见
				StringBuilder sb  = new StringBuilder();
				String value = (String)jsMap .get(element);
				if(value!=null){
					sb.append(value);
				}
				//BUG_OA-69755_普通_V5_V5.1sp1_南宁明和信息技术有限公司_公文单中，意见之间的间隔较大_20141105004371_2014-11-11
				//if(sb.length()>0){
				//	sb.append("<br>");
				//}
				boolean hasSignature=false;
				if(signatuers!=null&&signatuers.size()>0){
					for (V3xHtmDocumentSignature signature:signatuers) {
						if(signature!=null){
							if(null!=signature.getAffairId()&&signature.getAffairId().equals(opinion.getAffairId())){
								hasSignature=true;
								break;
							}
						}
					}
				}
				User user = AppContext.getCurrentUser();
				if("pc".equals(user.getUserAgentFrom()) || pcStyle){
					sb.append(displayOpinionContent(displayConfig, opinion, hasSignature, true));
				}else{
					sb.append(displayOpinionContentM3(displayConfig, opinion, hasSignature, true));
				}
				//附件显示
				List<Attachment> tempAtts = null;
				if(null != opinion.getPolicy() && opinion.getPolicy().equals(EdocOpinion.FEED_BACK)){
					Long subOpinionId = opinion.getSubOpinionId();
					if(subOpinionId != null){
						tempAtts = EdocHelper.getOpinionAttachmentsNotRelationDoc(opinion.getSubEdocId(),subOpinionId);
					}
				}else{
					tempAtts = opinion.getOpinionAttachments();
				}
				if (tempAtts != null) {
					StringBuilder attSb = new StringBuilder();
					attSb.append("<div style='clear:both;'>");
					for (Attachment att : tempAtts) {
						// 不管文件名有多长，显示整体的文件名。yangzd
						//sb.append("<br>");//前端附件使用的是DIV，会自动换行
						fileUrlStr.append(att.getFileUrl());
						fileUrlStr.append(",");
						String s = com.seeyon.ctp.common.filemanager.manager.Util.AttachmentToHtmlWithShowAllFileName(att,true, false);
						sb.append(s);
						attSb.append(s);
					}
					attSb.append("</div>");

					if("senderOpinion".equals(element)) {
					   senderAttMap.put(opinion.getId(), attSb);
					}
				}

				//发起人附言如果没有绑定不向前台显示。前台页面通过下面的对象，有代码+标签的形式展示。
				if("senderOpinion".equals(element)) {
					senderOpinions.add(opinion);
					continue;
				}
				
				jsMap.put(element, Strings.replaceNbspLO(sb.toString()));
			}
		}
		if(fileUrlStr.length()>0){
			fileUrlStr.deleteCharAt(fileUrlStr.length() - 1);
		}
		try{
			AppContext.putRequestContext("fileUrlStr", fileUrlStr);
		}catch(Exception e){
			//TODO REST接口调用进来没有注入request
		}

		jsMap.put("senderOpinionAttStr",senderAttMap );
		jsMap.put("senderOpinionList", senderOpinions);
		return jsMap;
	}

	/**
	 *
	 * @Description : 将字符串替换成空格，双字节替换成全角空格，单字节替换成半角空格
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月14日上午1:04:43
	 * @param src : 需要替换的字符串
	 * @param defualt : 如果字符串为null或为空时默认返回字符串
	 * @return
	 */
	private static String replaceStr2Blank(String src, String defualt){

	    StringBuilder ret = new StringBuilder();
	    
	    if(Strings.isBlank(src) && defualt != null){
	        ret.append(defualt);
	    }else {
	        for(int i = 0; i < src.length(); i++){
	            char c = src.charAt(i);
	            if((int)c > 0 && (int)c < 255){//普通字符0x00 ~ 0xff
	                ret.append(" ");//半角空格
	            }else {
                    ret.append("　");//全角空格
                }
	        }
        }
	    return ret.toString();
	}

	/**
	 *
	 * @Date        : 2015年5月19日下午5:48:53
	 * @param displayConfig
	 * @param opinion
	 * @param hasSignature
	 * @param popUserInfo 是否新增用户信息选项卡连接 true 添加， false 不添加
	 * @return
	 * @throws BusinessException
	 */
	private static String displayOpinionContent(FormOpinionConfig displayConfig, EdocOpinion opinion, boolean hasSignature, boolean popUserInfo)  {

	    OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
	    
		StringBuilder sb = new StringBuilder();

		//显示内容：态度，用户名，意见类型，意见
		String attribute = getAttitude(opinion.getOpinionType(), opinion.getAttribute());
		String userName = getOpinionUserName(opinion.getCreateUserId(),opinion.getProxyName(),orgManager, displayConfig, opinion, popUserInfo,"","");
		String content = opinion.getContent();
		sb.append("<div id='"+opinion.getAffairId()+"' style='clear:both;'>");

		V3xOrgMember member = getMember(opinion.getCreateUserId(),orgManager);

		boolean newLine = displayConfig.isInscriberNewLine();

		if(newLine){//设置落款换行显示
            sb.append("<div>");
        }
		// 客开-start 添加一级部门
//		User user = AppContext.getCurrentUser();
//	    long depId = user.getDepartmentId();
//	    String fieldValue="";
//	    try {
//         fieldValue=orgManager.getParentDepartment(depId).getName();
//         LOGGER.info("fieldValue:"+fieldValue);
//      } catch (BusinessException e) {
//        e.printStackTrace();
//      }
		if (!member.getIsAdmin()) {
		  //客开 增加部门、岗位信息start
          if(displayConfig.isShowUnit() && !(displayConfig.isHideInscriber() && hasSignature)){
               sb.append("&nbsp;").append(opinion.getAccountName()).append(":");
          }
          if (displayConfig.isShowDept() && !(displayConfig.isHideInscriber() && hasSignature)) {
      	      long depId = member.getOrgDepartmentId();
      	      String fieldValue="";
      	      try
      	      {
      	    	  if (orgManager.getParentDepartment(depId) != null)
      	    	  {
      	    		  fieldValue = orgManager.getParentDepartment(depId).getName();
      	    	  }
      	    	  else
      	    	  {
      	    		  if (orgManager.getDepartmentById(depId) != null)
        	    	  {
        	    		  fieldValue = orgManager.getDepartmentById(depId).getName();
        	    	  }
      	    	  }
      	      } catch (Exception e)
      	      {
      	    	e.printStackTrace();
      	    	LOGGER.info("get the department error for member id="+member.getId());
      	      }
              sb.append("&nbsp;").append(fieldValue).append(":");
          }

          //姓名
          if(!(displayConfig.isHideInscriber() && hasSignature)){
            sb.append("&nbsp;&nbsp;").append(userName);
          }

		}
		//上报意见不显示态度
		String attrStr = null;
		if (attribute != null && (null != opinion.getPolicy() && !opinion.getPolicy().equals(EdocOpinion.REPORT))) {
		    attrStr = "【"+ attribute+"】";
			sb.append(attrStr);
			// 意见排序 ：【态度】 意见 部门 姓名 时间
			sb.append("&nbsp;").append(Strings.toHTML(content));
		}else{
			//没有态度的时候首行不要缩进
			sb.append("&nbsp;&nbsp;").append(Strings.toHTML(content));
		}
		if(newLine){//设置落款换行显示
            sb.append("</div>");
        }
		
		String defualt = "　　";//默认两个全角空格
		attrStr = replaceStr2Blank(attrStr, defualt);
		attrStr = Strings.toHTML(attrStr);
		if(newLine){//设置落款换行显示, 跳过态度，与意见对齐,没有态度则两个汉字宽度，兼容国际化
		    sb.append("<div>");
		    if(!displayConfig.isNameAndDateNotInline()){
		        sb.append(attrStr);
		    }
		}else {
		    if(Strings.isNotBlank(content)){
		      //意见内容和后面的部门或者人员名称隔开几个空格
	            //sb.append("&nbsp;");
		    }
        }

		//设置了【文单签批后不显示系统落款 】，如果没有签批内容，则也需要显示系统落款。也就是，系统落款和签批内容至少要有一个
		//下面是追加显示单位名称-------魏俊标--2011-10-12
		//客开 start
		/*if(displayConfig.isShowUnit() && !(displayConfig.isHideInscriber() && hasSignature)){
		     sb.append("&nbsp;").append(opinion.getAccountName());
		}
		if (displayConfig.isShowDept() && !(displayConfig.isHideInscriber() && hasSignature)) {
		    sb.append("&nbsp;").append(opinion.getDepartmentName());
		}*/
		//客开 end
		// 如果是管理员终止，不显示管理员名字及时间
		//V3xOrgMember member = getMember(opinion.getCreateUserId(),orgManager);

		if (!member.getIsAdmin()) {
		   /* if(!(displayConfig.isHideInscriber() && hasSignature)){
		      sb.append("&nbsp;").append(userName);
		    }*/
		    //客开 增加部门、岗位信息start
		    /*if(displayConfig.isShowUnit() && !(displayConfig.isHideInscriber() && hasSignature)){
	             sb.append("&nbsp;").append(opinion.getAccountName());
	        }
	        if (displayConfig.isShowDept() && !(displayConfig.isHideInscriber() && hasSignature)) {
	            sb.append("&nbsp;").append(opinion.getDepartmentName());
	        }*/
		    OrgMember m = DBAgent.get(OrgMember.class, opinion.getCreateUserId());
	        OrgPost post = DBAgent.get(OrgPost.class, m.getOrgPostId());
	        /*if(post!=null){
	          if(StringUtils.equals(post.getName(), ".")){
	            sb.append("&nbsp;");
	          }else{
	            sb.append("&nbsp;").append(post.getName());
	          }
	        }*/
  		    //客开 end
			if (OpinionDateFormatSetEnum.DATETIME.getValue().equals(displayConfig.getShowDateType())) {
			    sb.append("&nbsp;").append(Datetimes.formatDatetimeWithoutSecond(opinion.getCreateTime()));
			} else if (OpinionDateFormatSetEnum.DATE.getValue().equals(displayConfig.getShowDateType())) {
			    sb.append("&nbsp;").append(Datetimes.formatDate(opinion.getCreateTime()));
			}
		}
		//客开 start
		else{
  		  if(displayConfig.isShowUnit() && !(displayConfig.isHideInscriber() && hasSignature)){
            sb.append("&nbsp;").append(opinion.getAccountName());
          }
          if (displayConfig.isShowDept() && !(displayConfig.isHideInscriber() && hasSignature)) {
            sb.append("&nbsp;").append(opinion.getDepartmentName());
          }
          OrgMember m = DBAgent.get(OrgMember.class, opinion.getCreateUserId());
          OrgPost post = DBAgent.get(OrgPost.class, m.getOrgPostId());
          if(post!=null){
            if(StringUtils.equals(post.getName(), ".")){
              sb.append("&nbsp;");
            }else{
              sb.append("&nbsp;").append(post.getName());
            }
          }
		}
		//客开 end
		if(newLine){//设置落款换行显示
            sb.append("</div>");
        }
		sb.append("</div>");
		return sb.toString();
	}

	/**
	 *
	 * @Date        : 2016年8月29日17:09:56
	 * @param displayConfig
	 * @param opinion
	 * @param hasSignature
	 * @param popUserInfo 是否新增用户信息选项卡连接 true 添加， false 不添加
	 * @return
	 */
	private static String displayOpinionContentM3(FormOpinionConfig displayConfig, EdocOpinion opinion, boolean hasSignature, boolean popUserInfo) {

	    OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");

		StringBuffer sb = new StringBuffer();

		//显示内容：态度，用户名，意见类型，意见
		String attribute = getAttitude(opinion.getOpinionType(), opinion.getAttribute());
		String userName = getOpinionUserName(opinion.getCreateUserId(),opinion.getProxyName(),orgManager, displayConfig, opinion, popUserInfo,"","M3");
		String content = opinion.getContent();
		sb.append("<div id='"+opinion.getAffairId()+"' class='opinion-wrap-div' style='clear:both; padding-top:7px; background-color:#f0f0f0;'>");
		
		sb.append("<div class='script-div none-border' style='padding-bottom:8px; background-color:white;'>");
		//上报意见不显示态度
		String attrStr = null;
		if (attribute != null && (null != opinion.getPolicy() && !opinion.getPolicy().equals(EdocOpinion.REPORT))) {
			sb.append("<span style='float:right; color:#4A90E2;'>");
			sb.append(attribute);
			sb.append("</span>");
		}
		
		//设置了【文单签批后不显示系统落款 】，如果没有签批内容，则也需要显示系统落款。也就是，系统落款和签批内容至少要有一个
		//下面是追加显示单位名称-------魏俊标--2011-10-12
		String accountName = "", departmengName = "";
		if(displayConfig.isShowUnit() && !(displayConfig.isHideInscriber() && hasSignature)){
			accountName = opinion.getAccountName();
		}
		if (displayConfig.isShowDept() && !(displayConfig.isHideInscriber() && hasSignature)) {
			departmengName = opinion.getDepartmentName();
		}

		sb.append("<div style='float:left; width:75%;'>");
		if(accountName != "" && departmengName != ""){
			sb.append("<span class='cmp-ellipsis cmp-pull-left' style='width:37%; min-width:75px;'>");
			sb.append(accountName);
			sb.append("</span>");
			sb.append("<span class='cmp-ellipsis cmp-pull-left' style='width:20%; margin-left:10px;'>");
			sb.append(departmengName);
			sb.append("</span>");
		}else if(accountName != "" && departmengName == ""){
			sb.append("<span class='cmp-ellipsis cmp-pull-left' style='width:60%;'>");
			sb.append(accountName);
			sb.append("</span>");
		}else if(accountName == "" && departmengName != ""){
			sb.append("<span class='cmp-ellipsis cmp-pull-left' style='width:60%;'>");
			sb.append(departmengName);
			sb.append("</span>");
		}

		// 如果是管理员终止，不显示管理员名字及时间
		V3xOrgMember member = getMember(opinion.getCreateUserId(),orgManager);

		if (!member.getIsAdmin()) {
			if(!(displayConfig.isHideInscriber() && hasSignature)){
				sb.append("<span class='cmp-ellipsis cmp-pull-left' style='width:25%; min-width:80px;'>");
			    sb.append(userName);
				sb.append("</span>");
			}
		}
		sb.append("</div>");
		sb.append("</div>");

		// 意见内容
		sb.append("<div class='script-div none-border' style='background-color:white; color:#333333; font-size:16px; padding-bottom:2px;'>");
		sb.append(Strings.toHTML(content,false));
		sb.append("</div>");

		sb.append("<div id='attLabel"+opinion.getAffairId()+"'></div>");

		if (OpinionDateFormatSetEnum.DATETIME.getValue().equals(displayConfig.getShowDateType()) ||
				OpinionDateFormatSetEnum.DATE.getValue().equals(displayConfig.getShowDateType())) {
			sb.append("<div style='background-color:white; padding:0px 15px 2px 15px;'>");
			sb.append("<span class='script-time' style='color:#999999; font-size:12px;'>");
			sb.append(EdocUtil.showDate(opinion.getCreateTime()));
			sb.append("</span>");
			sb.append("</div>");
		}

		sb.append("</div>");
		return sb.toString();
	}

	private static V3xOrgMember getMember(Long id,OrgManager orgManager){
		V3xOrgMember member = new V3xOrgMember() ;
		try {
			member = orgManager.getMemberById(id);
		} catch (BusinessException e) {
			// TODO Auto-generated catch block
			LOGGER.error("", e);
		}
		return member;
	}

	/*********************************** 唐桂林 公文意见显示 start *************************************/
	@SuppressWarnings("rawtypes")
	public static String optionToJs(Map<String, Object> hs){
        String key="";
        StringBuilder opinionsJs = new StringBuilder();
        opinionsJs.append("var opinions=[");
        Iterator it = hs.keySet().iterator();
        //添加这个变量主要是用来判断是否加，
        boolean isFirst = true;
        String szTemp=null;
        while(it.hasNext()) {
        	key= (String)it.next();
        	//拟文意见
        	if("senderOpinionList".equals(key)||"senderOpinionAttStr".equals(key))
        		continue;
        	if(isFirst) isFirst = false;
        	else opinionsJs.append(",");
        	szTemp = hs.get(key).toString();
        	//V51-4-18 公文单中处理时插入附件全标题显示,公文附件标题元素也全显示
        	//szTemp = subLargerGuanlanWendang(szTemp);//对于文档名过长的过滤
        	szTemp = Strings.escapeJavascript(szTemp);//转js
        	opinionsJs.append("[\"").append(key).append("\",\"").append(szTemp).append("\"]");
        }
        opinionsJs.append("];");
        opinionsJs.append("\r\n");

        String sendOpinionStr = "";
        Object sendOpinionObj = hs.get("senderOpinionList");
        if(sendOpinionObj != null) {
        	sendOpinionStr=sendOpinionObj.toString();
        }
        if("[]".equals(sendOpinionStr)) sendOpinionStr="";
        opinionsJs.append("var sendOpinionStr=\""+sendOpinionStr+"\";");

        return opinionsJs.toString();
	}

	/**
	 * 节点类型(shenpi、huitui...)
	 * @param map
	 * @return
	 */
	public static String getEdocOpinionPolicy(Map<String, EdocOpinionModel> map) {
		Set set=null;
        String policy=null;
        if(map!=null&&!map.isEmpty()){
            set=map.entrySet();
            if(set!=null&&!set.isEmpty()){
                Iterator it=set.iterator();
                while(it.hasNext()){
                    Map.Entry entry = (Map.Entry) it.next();
                    if(entry!=null){
                        policy=entry.getKey().toString();
                    }
                }
            }
        }
        return policy;
	}

	public static List<EdocOpinionBO> sortEdocOpinion(List<EdocOpinion> opinions) {
		List<EdocOpinionBO> opinionBOs = new ArrayList<EdocOpinionBO>();
        EdocOpinionBO edocOpinionBO = null;
        try {
        	if(opinions!=null) {
		        for(int i=0; i<opinions.size(); i++) {
		        	edocOpinionBO = new EdocOpinionBO();
		        	org.apache.commons.beanutils.BeanUtils.copyProperties(edocOpinionBO, opinions.get(i));
		        	opinionBOs.add(edocOpinionBO);
		        }
        	}
        } catch(Exception e){
            LOGGER.error("", e);
        }
        return opinionBOs;
	}

	public static String getAffairReturnState(Map<String,EdocOpinionModel> map, String policy, CtpAffair currentAffair) throws BusinessException {
		List<EdocOpinion> opinions = null;
        EdocOpinionModel edocOpinionModel = null;
        if(map != null) {
            edocOpinionModel=map.get(policy);
        }
        if(edocOpinionModel!=null) {
            opinions = edocOpinionModel.getOpinions();
        }
        return getAffairReturnState(opinions, currentAffair);
	}

	public static String getAffairReturnState(List<EdocOpinion> opinions, CtpAffair currentAffair) throws BusinessException {
		List<EdocOpinionBO> opinionBOs = sortEdocOpinion(opinions);
		AffairManager affairManager = (AffairManager)AppContext.getBean("affairManager");
		String affairState = "";
        if(opinionBOs != null) {
        	EdocOpinionBO edocOpinion = null;
            CtpAffair affair1 = null;
            CtpAffair affair = null;
            int count = opinionBOs.size();
            long currentUserId = AppContext.getCurrentUser().getId();
            for(int i = count-1; i>=0; i--) {
                edocOpinion = opinionBOs.get(i);
                affair1 = affairManager.get(edocOpinion.getAffairId());
                if(affair1 == null)
                	continue;
                /*if(affair1==null || affair1.getActivityId()==null || currentAffair.getActivityId()==null
                		|| !affair1.getActivityId().equals(currentAffair.getActivityId())
                		|| affair1.getMemberId().longValue()!=currentUserId) {//非当前节点的意见过滤出去  当前人 代理人TODO
                	break;
                }
                boolean isCurrentAffair = affair1.getState()==StateEnum.col_pending.key() && (affair1.getSubState()==SubStateEnum.col_pending_ZCDB.key() || affair1.getSubState()==SubStateEnum.col_pending_read.key());
                if(!isCurrentAffair) {//并且当前节点，当前人不是在办状态
                	break;
                }
                */
                boolean isCurrentAffair = affair1.getActivityId()!=null && currentAffair.getActivityId()!=null
                		&& affair1.getActivityId().equals(currentAffair.getActivityId()) //当前节点
                		&& affair1.getMemberId().longValue()==currentUserId;//当前人 代理人TODO
                boolean isCurrentAffairState = affair1.getState()==StateEnum.col_pending.key() && (affair1.getSubState()==SubStateEnum.col_pending_ZCDB.key() || affair1.getSubState()==SubStateEnum.col_pending_read.key());

                if(isCurrentAffair && !isCurrentAffairState) {//并且当前节点，当前人不是在办状态
                	affair = affair1;
                	break;
                }

            }
            if(affair != null){
                affairState = String.valueOf(affair.getState());
            }
        }
        return affairState;
	}
	/*********************************** 唐桂林 公文意见显示 end *************************************/

	//对于关联文档名过长的过滤。
	private static String subLargerGuanlanWendang(String str) {
		int begin=str.indexOf("style='font-size:12px'>");
		int end=str.indexOf("</a>");
		if(begin!=-1||end!=-1)
		{
			String wname=str.substring(begin, end).replace("style='font-size:12px'>", "");
	    	StringBuilder sb=new StringBuilder();
	    	if(wname.length()<30)
	    	{
	    		return str;
	    	}
	    	else
	    	{
	    		sb.append(str.substring(0, begin));
	    		sb.append("style='font-size:12px'>");
	    		//OA-50904
	    		wname = wname.replace("&nbsp;", " ");
	    		if(wname.length() > 30){
	    		    wname = wname.substring(0,30);
	    		}
	    		sb.append(wname);
	    		sb.append("......");
	    		sb.append(str.substring(end));
	    		return sb.toString();
	    	}
		}
		else
		{
			return str;
		}

	}
}
