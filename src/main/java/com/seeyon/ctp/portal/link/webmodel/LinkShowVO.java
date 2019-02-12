package com.seeyon.ctp.portal.link.webmodel;

import com.seeyon.ctp.portal.po.PortalLinkSystem;

public class LinkShowVO {
    private PortalLinkSystem linkSystem;

    private String           icon;
    private String           name;
    private String           link;
    private String           showTile;

    public LinkShowVO(PortalLinkSystem linkSystem) {
        this.linkSystem = linkSystem;
        this.name = linkSystem.getLname();
        this.showTile = linkSystem.getLname();
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public PortalLinkSystem getLinkSystem() {
        return linkSystem;
    }

    public void setLinkSystem(PortalLinkSystem linkSystem) {
        this.linkSystem = linkSystem;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getShowTile() {
        return showTile;
    }

    public void setShowTile(String showTile) {
        this.showTile = showTile;
    }

}
