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
package com.seeyon.ctp.portal.link.manager;

import java.util.List;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.portal.po.PortalLinkMenu;

public interface LinkMenuManager {
    public PortalLinkMenu selectLinkMenu(long menuId) throws BusinessException;

    public List<PortalLinkMenu> selectLinkMenuBySystemId(long linkSystemId) throws BusinessException;

    public boolean checkSameLinkMenu(long linkSystemId, String mname) throws BusinessException;
}
