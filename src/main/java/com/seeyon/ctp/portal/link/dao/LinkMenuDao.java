/**
 * $Author: leikj $
 * $Rev: 6983 $
 * $Date:: 2012-11-05 10:40:41 +#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.portal.link.dao;

import java.util.List;

import com.seeyon.ctp.portal.po.PortalLinkMenu;

public interface LinkMenuDao {
    public PortalLinkMenu selectLinkMenu(long menuId);

    public List<PortalLinkMenu> selectLinkMenuBySystemId(long linkSystemId);

    public boolean checkSameLinkMenu(long linkSystemId, String mname);
}
