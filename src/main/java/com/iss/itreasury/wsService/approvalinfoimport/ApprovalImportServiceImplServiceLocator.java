/**
 * ApprovalImportServiceImplServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.iss.itreasury.wsService.approvalinfoimport;

public class ApprovalImportServiceImplServiceLocator extends org.apache.axis.client.Service implements com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportServiceImplService {

    public ApprovalImportServiceImplServiceLocator() {
    }


    public ApprovalImportServiceImplServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public ApprovalImportServiceImplServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for ApprovalImportServiceImplPort
    private java.lang.String ApprovalImportServiceImplPort_address = "http://100.16.12.44:7001/itms_sme_xinda/cxfservice/ApprovalImportService";

    public java.lang.String getApprovalImportServiceImplPortAddress() {
        return ApprovalImportServiceImplPort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String ApprovalImportServiceImplPortWSDDServiceName = "ApprovalImportServiceImplPort";

    public java.lang.String getApprovalImportServiceImplPortWSDDServiceName() {
        return ApprovalImportServiceImplPortWSDDServiceName;
    }

    public void setApprovalImportServiceImplPortWSDDServiceName(java.lang.String name) {
        ApprovalImportServiceImplPortWSDDServiceName = name;
    }

    public com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportService getApprovalImportServiceImplPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(ApprovalImportServiceImplPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getApprovalImportServiceImplPort(endpoint);
    }

    public com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportService getApprovalImportServiceImplPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportServiceImplServiceSoapBindingStub _stub = new com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportServiceImplServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getApprovalImportServiceImplPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setApprovalImportServiceImplPortEndpointAddress(java.lang.String address) {
        ApprovalImportServiceImplPort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportService.class.isAssignableFrom(serviceEndpointInterface)) {
                com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportServiceImplServiceSoapBindingStub _stub = new com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportServiceImplServiceSoapBindingStub(new java.net.URL(ApprovalImportServiceImplPort_address), this);
                _stub.setPortName(getApprovalImportServiceImplPortWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("ApprovalImportServiceImplPort".equals(inputPortName)) {
            return getApprovalImportServiceImplPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://approvalinfoimport.wsService.itreasury.iss.com/", "ApprovalImportServiceImplService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://approvalinfoimport.wsService.itreasury.iss.com/", "ApprovalImportServiceImplPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("ApprovalImportServiceImplPort".equals(portName)) {
            setApprovalImportServiceImplPortEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
