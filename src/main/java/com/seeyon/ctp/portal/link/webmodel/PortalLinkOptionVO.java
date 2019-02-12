package com.seeyon.ctp.portal.link.webmodel;

import com.seeyon.ctp.portal.po.PortalLinkOption;
import com.seeyon.ctp.portal.po.PortalLinkOptionValue;

public class PortalLinkOptionVO {
    private PortalLinkOption      option;
    private PortalLinkOptionValue value;

    public PortalLinkOptionVO(PortalLinkOption option, PortalLinkOptionValue value) {
        this.option = option;
        this.value = value;
    }

    public PortalLinkOption getOption() {
        return option;
    }

    public void setOption(PortalLinkOption option) {
        this.option = option;
    }

    public PortalLinkOptionValue getValue() {
        return value;
    }

    public void setValue(PortalLinkOptionValue value) {
        this.value = value;
    }
}
