package com.iss.itreasury.wsService.approvalinfoimport;

public class ApprovalImportServiceProxy implements com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportService {
  private String _endpoint = null;
  private com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportService approvalImportService = null;
  
  public ApprovalImportServiceProxy() {
    _initApprovalImportServiceProxy();
  }
  
  public ApprovalImportServiceProxy(String endpoint) {
    _endpoint = endpoint;
    _initApprovalImportServiceProxy();
  }
  
  private void _initApprovalImportServiceProxy() {
    try {
      approvalImportService = (new com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportServiceImplServiceLocator()).getApprovalImportServiceImplPort();
      if (approvalImportService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)approvalImportService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)approvalImportService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (approvalImportService != null)
      ((javax.xml.rpc.Stub)approvalImportService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportService getApprovalImportService() {
    if (approvalImportService == null)
      _initApprovalImportServiceProxy();
    return approvalImportService;
  }
  
  public java.lang.String importApprovalService(java.lang.String xmlData) throws java.rmi.RemoteException, com.iss.itreasury.wsService.approvalinfoimport.Exception{
    if (approvalImportService == null)
      _initApprovalImportServiceProxy();
    return approvalImportService.importApprovalService(xmlData);
  }
  
  
}