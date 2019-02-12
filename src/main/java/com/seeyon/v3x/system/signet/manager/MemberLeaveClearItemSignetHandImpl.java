package com.seeyon.v3x.system.signet.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.memberleave.bo.MemberLeaveDetail;
import com.seeyon.ctp.organization.memberleave.manager.MemberLeaveClearItemInterface;
import com.seeyon.v3x.system.signet.domain.V3xSignet;

/**
 * 印章 签名
 */
public class MemberLeaveClearItemSignetHandImpl implements MemberLeaveClearItemInterface {

	private SignetManager signetManager;
	private OrgManager orgManager;

	public void setSignetManager(SignetManager signetManager) {
		this.signetManager = signetManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	@Override
	public List<MemberLeaveDetail> getItems(long memberId) throws BusinessException {
		List<MemberLeaveDetail> result=new ArrayList<MemberLeaveDetail>();
		List<V3xSignet> signetList = signetManager.findSignetByMemberId(memberId);
		if(null!=signetList){
			MemberLeaveDetail memberLeaveDetail = null;
			Map<Long,String> map =new HashMap<Long,String>();
			String accountName="";
			for (V3xSignet signet : signetList) {
				if(map.containsKey(signet.getOrgAccountId())){
					accountName=map.get(signet.getOrgAccountId());
				}else{
					Long accountId=signet.getOrgAccountId();
					V3xOrgAccount v3xOrgAccount = orgManager.getAccountById(accountId);
					accountName=v3xOrgAccount.getName();
					map.put(accountId, accountName);
				}
				String content="";
				if(signet.getMarkType()==1){
					content=ResourceUtil.getString("member.leave.signet.title");
				}else if(signet.getMarkType()==0){
					content=ResourceUtil.getString("member.leave.sign.title");
				}
				memberLeaveDetail= new MemberLeaveDetail();
				memberLeaveDetail.setType(ResourceUtil.getString("member.leave.Electronicsignet.title"));
				memberLeaveDetail.setAccountName(accountName);
				memberLeaveDetail.setContent(content);
				memberLeaveDetail.setTitle(signet.getMarkName());
				result.add(memberLeaveDetail);
			}
		}
		return result;
	}
	
	@Override
	public Integer getSortId() {
		return 115;
	}

	@Override
	public Category getCategory() {
		return Category.other;
	}

}
