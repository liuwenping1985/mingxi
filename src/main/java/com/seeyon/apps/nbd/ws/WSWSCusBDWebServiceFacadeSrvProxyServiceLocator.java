/**
 * WSWSCusBDWebServiceFacadeSrvProxyServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.seeyon.apps.nbd.ws;

public class WSWSCusBDWebServiceFacadeSrvProxyServiceLocator extends org.apache.axis.client.Service implements com.seeyon.apps.nbd.ws.WSWSCusBDWebServiceFacadeSrvProxyService {

    public WSWSCusBDWebServiceFacadeSrvProxyServiceLocator() {
    }


    public WSWSCusBDWebServiceFacadeSrvProxyServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public WSWSCusBDWebServiceFacadeSrvProxyServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for WSWSCusBDWebServiceFacade
    private java.lang.String WSWSCusBDWebServiceFacade_address = "http://10.42.1.210:6888/ormrpc/services/WSWSCusBDWebServiceFacade";

    public java.lang.String getWSWSCusBDWebServiceFacadeAddress() {
        return WSWSCusBDWebServiceFacade_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String WSWSCusBDWebServiceFacadeWSDDServiceName = "WSWSCusBDWebServiceFacade";

    public java.lang.String getWSWSCusBDWebServiceFacadeWSDDServiceName() {
        return WSWSCusBDWebServiceFacadeWSDDServiceName;
    }

    public void setWSWSCusBDWebServiceFacadeWSDDServiceName(java.lang.String name) {
        WSWSCusBDWebServiceFacadeWSDDServiceName = name;
    }

    public com.seeyon.apps.nbd.ws.WSWSCusBDWebServiceFacadeSrvProxy getWSWSCusBDWebServiceFacade() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(WSWSCusBDWebServiceFacade_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getWSWSCusBDWebServiceFacade(endpoint);
    }

    public com.seeyon.apps.nbd.ws.WSWSCusBDWebServiceFacadeSrvProxy getWSWSCusBDWebServiceFacade(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.seeyon.apps.nbd.ws.WSWSCusBDWebServiceFacadeSoapBindingStub _stub = new com.seeyon.apps.nbd.ws.WSWSCusBDWebServiceFacadeSoapBindingStub(portAddress, this);
            _stub.setPortName(getWSWSCusBDWebServiceFacadeWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setWSWSCusBDWebServiceFacadeEndpointAddress(java.lang.String address) {
        WSWSCusBDWebServiceFacade_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.seeyon.apps.nbd.ws.WSWSCusBDWebServiceFacadeSrvProxy.class.isAssignableFrom(serviceEndpointInterface)) {
                com.seeyon.apps.nbd.ws.WSWSCusBDWebServiceFacadeSoapBindingStub _stub = new com.seeyon.apps.nbd.ws.WSWSCusBDWebServiceFacadeSoapBindingStub(new java.net.URL(WSWSCusBDWebServiceFacade_address), this);
                _stub.setPortName(getWSWSCusBDWebServiceFacadeWSDDServiceName());
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
        if ("WSWSCusBDWebServiceFacade".equals(inputPortName)) {
            return getWSWSCusBDWebServiceFacade();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://10.10.10.98/ormrpc/services/WSWSCusBDWebServiceFacade", "WSWSCusBDWebServiceFacadeSrvProxyService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://10.10.10.98/ormrpc/services/WSWSCusBDWebServiceFacade", "WSWSCusBDWebServiceFacade"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("WSWSCusBDWebServiceFacade".equals(portName)) {
            setWSWSCusBDWebServiceFacadeEndpointAddress(address);
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
