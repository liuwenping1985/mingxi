
/**
 * BPMServiceCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.4.1  Built on : Aug 13, 2008 (05:03:35 LKT)
 */

    package com.seeyon.apps.checkin.client;

    /**
     *  BPMServiceCallbackHandler Callback class, Users can extend this class and implement
     *  their own receiveResult and receiveError methods.
     */
    public abstract class BPMServiceCallbackHandler{



    protected Object clientData;

    /**
    * User can pass in any object that needs to be accessed once the NonBlocking
    * Web service call is finished and appropriate method of this CallBack is called.
    * @param clientData Object mechanism by which the user can pass in user data
    * that will be avilable at the time this callback is called.
    */
    public BPMServiceCallbackHandler(Object clientData){
        this.clientData = clientData;
    }

    /**
    * Please use this constructor if you don't want to set any clientData
    */
    public BPMServiceCallbackHandler(){
        this.clientData = null;
    }

    /**
     * Get the client data
     */

     public Object getClientData() {
        return clientData;
     }

        
           /**
            * auto generated Axis2 call back method for receiveThirdpartyForm method
            * override this method for handling normal response from receiveThirdpartyForm operation
            */
           public void receiveResultreceiveThirdpartyForm(
                    com.seeyon.apps.checkin.client.BPMServiceStub.ReceiveThirdpartyFormResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from receiveThirdpartyForm operation
           */
            public void receiveErrorreceiveThirdpartyForm(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for launchHtmlCollaboration method
            * override this method for handling normal response from launchHtmlCollaboration operation
            */
           public void receiveResultlaunchHtmlCollaboration(
                    com.seeyon.apps.checkin.client.BPMServiceStub.LaunchHtmlCollaborationResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from launchHtmlCollaboration operation
           */
            public void receiveErrorlaunchHtmlCollaboration(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getFormCollIdsByDateTimeRest method
            * override this method for handling normal response from getFormCollIdsByDateTimeRest operation
            */
           public void receiveResultgetFormCollIdsByDateTimeRest(
                    com.seeyon.apps.checkin.client.BPMServiceStub.GetFormCollIdsByDateTimeRestResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getFormCollIdsByDateTimeRest operation
           */
            public void receiveErrorgetFormCollIdsByDateTimeRest(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getTemplateDefinition method
            * override this method for handling normal response from getTemplateDefinition operation
            */
           public void receiveResultgetTemplateDefinition(
                    com.seeyon.apps.checkin.client.BPMServiceStub.GetTemplateDefinitionResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getTemplateDefinition operation
           */
            public void receiveErrorgetTemplateDefinition(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for launchFormCollaboration method
            * override this method for handling normal response from launchFormCollaboration operation
            */
           public void receiveResultlaunchFormCollaboration(
                    com.seeyon.apps.checkin.client.BPMServiceStub.LaunchFormCollaborationResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from launchFormCollaboration operation
           */
            public void receiveErrorlaunchFormCollaboration(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getFlowState method
            * override this method for handling normal response from getFlowState operation
            */
           public void receiveResultgetFlowState(
                    com.seeyon.apps.checkin.client.BPMServiceStub.GetFlowStateResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getFlowState operation
           */
            public void receiveErrorgetFlowState(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getFormCollIdsByDateTime method
            * override this method for handling normal response from getFormCollIdsByDateTime operation
            */
           public void receiveResultgetFormCollIdsByDateTime(
                    com.seeyon.apps.checkin.client.BPMServiceStub.GetFormCollIdsByDateTimeResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getFormCollIdsByDateTime operation
           */
            public void receiveErrorgetFormCollIdsByDateTime(java.lang.Exception e) {
            }
                


    }
    