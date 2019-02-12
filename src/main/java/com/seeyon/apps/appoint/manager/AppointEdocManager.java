package com.seeyon.apps.appoint.manager;

import com.seeyon.v3x.edoc.domain.EdocSummary;

public interface AppointEdocManager {
	public Boolean push(EdocSummary summary);
	public void rePushAllUnSuccess();

}
