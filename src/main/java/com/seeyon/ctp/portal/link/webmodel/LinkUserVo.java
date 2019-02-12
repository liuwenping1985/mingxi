package com.seeyon.ctp.portal.link.webmodel;

import com.seeyon.ctp.portal.po.PortalLinkOption;
import com.seeyon.ctp.portal.po.PortalLinkOptionValue;

public class LinkUserVo {
    private PortalLinkOption      linkOption;
    private PortalLinkOptionValue linkOptionValue;
    private boolean               password;
    private boolean               defaultValue;

    public boolean isPassword() {
        return password;
    }

    public void setPassword(boolean password) {
        this.password = password;
    }

    public PortalLinkOption getLinkOption() {
        return linkOption;
    }

    public void setLinkOption(PortalLinkOption linkOption) {
        this.linkOption = linkOption;
    }

    public PortalLinkOptionValue getLinkOptionValue() {
        return linkOptionValue;
    }

    public void setLinkOptionValue(PortalLinkOptionValue linkOptionValue) {
        this.linkOptionValue = linkOptionValue;
    }

    public boolean isDefaultValue() {
        return defaultValue;
    }

    public void setDefaultValue(boolean defaultValue) {
        this.defaultValue = defaultValue;
    }
}
