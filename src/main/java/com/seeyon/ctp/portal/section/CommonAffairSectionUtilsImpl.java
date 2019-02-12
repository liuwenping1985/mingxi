package com.seeyon.ctp.portal.section;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.bo.SimpleEdocSummary;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.common.taglibs.functions.Functions;

public class CommonAffairSectionUtilsImpl implements CommonAffairSectionUtils{
	private static final Log LOG = LogFactory.getLog(TrackSection.class);
	private EdocApi edocApi;
	private CollaborationApi collaborationApi;
	
	public EdocApi getEdocApi() {
		return edocApi;
	}

	public void setEdocApi(EdocApi edocApi) {
		this.edocApi = edocApi;
	}

	public CollaborationApi getCollaborationApi() {
		return collaborationApi;
	}

	public void setCollaborationApi(CollaborationApi collaborationApi) {
		this.collaborationApi = collaborationApi;
	}

	public  String parseCurrentNodesInfo(Timestamp completeTime,String nodeInfo, Map<Long, String> members) {
		if(nodeInfo == null){
			return "";
		}
		//if(null == completeTime ){//流程未结束   客开 gxy 20180627  屏蔽 栏目待办人显示  已结束 start
			StringBuilder currentNodsInfo = new StringBuilder();
			int allCount=0;
			if(Strings.isNotBlank(nodeInfo) && !"null".equals(nodeInfo.toLowerCase())){
				String[] nodeArr=nodeInfo.split(";"); //人员ID&节点权限;人员ID&节点权限
				allCount=nodeArr.length;
				int count=0;
				for(String node:nodeArr){
					//if(Strings.isNotBlank(node)&&count<2){//显示两个处理人信息
					if(Strings.isNotBlank(node)){//客开 gxy 20180716 显示所有处理人信息	
						String userIdStr=nodeArr[count];
						
						Long memberId = Long.valueOf(userIdStr);
						
						String memberName = members.get(memberId);
						if(memberName == null){
						    memberName = Functions.showMemberName(memberId);
						}
						
						if(memberName == null || currentNodsInfo.toString().indexOf(memberName)!=-1){//去重复
							count--;
						}else{
								if(currentNodsInfo.length()==0){
									currentNodsInfo.append(memberName);
								}else{
									currentNodsInfo.append("、"+memberName);
								}
							
						}
					}
					count++;
				}
			}else{
				return "";
			}
			if("null".equals(currentNodsInfo.toString().toLowerCase()))return "";
			//多于2个人拼接...
			//客开 gxy 20180716 显示所有处理人信息	start
			/*if(allCount >= 3) {
				currentNodsInfo.append("...");
			}*/
			//客开 gxy 20180716 显示所有处理人信息	end
			return currentNodsInfo.toString();
		
		//客开 gxy 20180627  屏蔽 栏目待办人显示  已结束 start
		/*}
		else{//流程结束
			return ResourceUtil.getString("collaboration.list.finished.label");
		}*/
		//客开 gxy 20180627  屏蔽 栏目待办人显示  已结束 end
	}
	
	public Map<Long, String> parseCurrentNodeInfos(List<CtpAffair> affairs) {
		List<Long> summaryIds = new ArrayList<Long>();
		List<Long> edocIds = new ArrayList<Long>();
		Map<Long, String> currentNodeInfos = new HashMap<Long, String>();
		if (Strings.isNotEmpty(affairs)) {

			// 当前处理人
			List<Integer> edocApps = new ArrayList<Integer>();
			edocApps.add(ApplicationCategoryEnum.edocSend.getKey());// 发文 19
			edocApps.add(ApplicationCategoryEnum.edocRec.getKey());// 收文 20
			edocApps.add(ApplicationCategoryEnum.edocSign.getKey());// 签报21
			edocApps.add(ApplicationCategoryEnum.exSend.getKey());// 待发送公文22
			edocApps.add(ApplicationCategoryEnum.exSign.getKey());// 待签收公文 23
			edocApps.add(ApplicationCategoryEnum.edocRegister.getKey());// 待登记公文
																		// 24
			edocApps.add(ApplicationCategoryEnum.edocRecDistribute.getKey());// 收文分发34

			for (CtpAffair a : affairs) {
				if (a.getApp() == ApplicationCategoryEnum.collaboration.key()) {

					summaryIds.add(a.getObjectId());
				}
				else if (edocApps.contains(a.getApp())) {

					edocIds.add(a.getObjectId());
				}
			}

			if (AppContext.hasPlugin("collaboration")) {
				try {
					List<ColSummary> summarys = collaborationApi.findColSummarys(summaryIds);
					if (Strings.isNotEmpty(summarys)) {
						for (ColSummary s : summarys) {
							currentNodeInfos.put(s.getId(), ColUtil.parseCurrentNodesInfo(s));
						}
					}
				} catch (BusinessException e) {
					LOG.error("", e);
				}
			}
			if (AppContext.hasPlugin("edoc")) {
				try {
					List<SimpleEdocSummary> summarys = edocApi.findSimpleEdocSummarysByIds(edocIds);
					if (Strings.isNotEmpty(summarys)) {
						for (SimpleEdocSummary s : summarys) {
							String currentNodeInfo = parseCurrentNodesInfo(s.getCompleteTime(),
									s.getCurrentNodesInfo(), Collections.<Long, String> emptyMap());
							currentNodeInfos.put(s.getId(), currentNodeInfo);
						}
					}
				} catch (BusinessException e) {
					LOG.error("", e);
				}

			}
		}
		return currentNodeInfos;
	}
}
