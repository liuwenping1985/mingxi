package com.seeyon.apps.cinda.authority.manager;

import java.util.List;

import com.seeyon.apps.cinda.authority.domain.UmAuthority;
import com.seeyon.apps.cinda.authority.domain.UmRole;
import com.seeyon.apps.taskcenter.bo.TaskCenterResource;
import com.seeyon.ctp.common.authenticate.domain.User;

public interface CindaAuthorityManager {

	public List<TaskCenterResource> getTaskCenterResource(User user, String rootCode);
	public List<TaskCenterResource> getTaskList4Section(User user, String rootCode, int count);
}
