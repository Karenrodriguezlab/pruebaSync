global with sharing class OSFMX_EnviarOfertaSolicitud implements vlocity_cmt.VlocityOpenInterface{
    
    public Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;        
        try {
            switch on methodName
            {
                when 'SendPost' {
                    SendPost(inputMap, outMap, options);
                }
                when 'AuthorizeQuoteByGasUser'{
                    AuthorizeQuoteByGasUser(inputMap, outMap, options);
                }
                when 'SendQuoteMoleculaTransporteByGasUser'{
                    SendQuoteMoleculaTransporteByGasUser(inputMap, outMap, options);
                }
                when 'SendDistributionQuoteToApproval'{
                    SendDistributionQuoteToApproval(inputMap, outMap, options);
                }
                when 'SendOpportunityToStandBy'{
                    SendOpportunityToStandBy(inputMap, outMap, options);
                }
                when 'SendOpportunityToProcess'{
                    SendOpportunityToProcess(inputMap, outMap, options);
                }
                when 'SendToAuthorization'{
                    SendToAuthorization(inputMap, outMap, options);
                }
                when 'SendToAuthorizationElectricityMulti'{
                    SendToAuthorizationElectricityMulti(inputMap, outMap, options);
                }
                when 'SendToAuthorizationGasMulti'{
                    SendToAuthorizationGasMulti(inputMap, outMap, options);
                }
            }
            result = false;
        } catch(Exception e) {
            System.debug('OSFMX_EnviarOfertaSolicitud:invokeMethod -> exception: ' + e.getLineNumber());
            throw e;
        }
        return result;
    }
    
    public void SendPost(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{            
            Id QuoteId = (Id) input.get('contextId');
            Quote temp = new Quote();
            temp.Id = QuoteId;
            temp.Status = 'Proceso';
            temp.OSFMX_SubEstatus__c = 'Solicitud';
            upsert temp;
        }        
        catch(Exception ex) {
            System.debug('OSFMX_EnviarOfertaSolicitud SendPost - ex: ' + ex);
            throw ex;
        }
    }
    
    public void AuthorizeQuoteByGasUser(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{            
            Id QuoteId = (Id) input.get('contextId');
            Quote temp = new Quote();
            temp.Id = QuoteId;
            temp.Status = 'Proceso';
            temp.OSFMX_SubEstatus__c = 'Producto';
            upsert temp;
        }        
        catch(Exception ex) {
            System.debug('OSFMX_EnviarOfertaSolicitud AuthorizeQuoteByGasUser - ex: ' + ex);
            throw ex;
        }
    }
    
    public void SendQuoteMoleculaTransporteByGasUser(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{            
            Id QuoteId = (Id) input.get('contextId');
            Quote temp = new Quote();
            temp.Id = QuoteId;
            temp.Status = 'Proceso';
            temp.OSFMX_SubEstatus__c = 'Factibilidad Mexcom';
            temp.OSFMX_TransportValidation__c = false;
            temp.OSFMX_MoleculeValidation__c = false;
            upsert temp;
        }        
        catch(Exception ex) {
            System.debug('OSFMX_EnviarOfertaSolicitud SendQuoteMoleculaTransporteByGasUser - ex: ' + ex);
            throw ex;
        }
    }

    public void SendDistributionQuoteToApproval(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{            
            Id QuoteId = (Id) input.get('contextId');
            Quote temp = new Quote();
            temp.Id = QuoteId;
            temp.Status = 'Proceso';
            temp.OSFMX_SubEstatus__c = 'Autorización';          
            upsert temp;
        }        
        catch(Exception ex) {
            System.debug('OSFMX_EnviarOfertaSolicitud SendDistributionQuoteToApproval - ex: ' + ex);
            throw ex;
        }
    }

    public void SendOpportunityToStandBy(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{            
            Id OpportunityId = (Id) input.get('contextId');
            Opportunity temp = new Opportunity();
            temp.Id = OpportunityId;
            temp.StageName = 'Stand-by';                
            upsert temp;
        }        
        catch(Exception ex) {
            System.debug('OSFMX_EnviarOfertaSolicitud SendOpportunityToStandBy - ex: ' + ex);
            throw ex;
        }
    }

    public void SendOpportunityToProcess(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{            
            Id OpportunityId = (Id) input.get('contextId');
            Opportunity temp = new Opportunity();
            temp.Id = OpportunityId;
            temp.StageName = 'En proceso';                
            upsert temp;
        }        
        catch(Exception ex) {
            System.debug('OSFMX_EnviarOfertaSolicitud SendOpportunityToProcess - ex: ' + ex);
            throw ex;
        }
    }

    public void SendToAuthorization(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{            
            Id QuoteId = (Id) input.get('contextId');
            Quote temp = new Quote();
            temp.Id = QuoteId;
            temp.Status = 'Proceso';
            temp.OSFMX_SubEstatus__c = 'Autorización';          
            upsert temp;
        }        
        catch(Exception ex) {
            System.debug('OSFMX_EnviarOfertaSolicitud SendToAuthorization - ex: ' + ex);
            throw ex;
        }
    }

    public void SendToAuthorizationElectricityMulti(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{            
            Id QuoteId = (Id) input.get('contextId');
            Quote temp = new Quote();
            temp.Id = QuoteId;
            temp.Status = 'Proceso';
            temp.OSFMX_SubEstatus__c = 'Solicitud';
            
            List<Quote> listQuote = [SELECT Id, Status,OSFMX_SubEstatus__c FROM Quote WHERE vlocity_cmt__ParentQuoteId__c = :QuoteId];
            for (Quote childQuote : listQuote) {
                childQuote.Status = 'Proceso';
                childQuote.OSFMX_SubEstatus__c = 'Solicitud';
            }
            listQuote.add(temp);
            upsert listQuote;
        }        
        catch(Exception ex) {
            System.debug('OSFMX_EnviarOfertaSolicitud SendToAuthorizationElectricityMulti - ex: ' + ex);
            throw ex;
        }
    }

    public void SendToAuthorizationGasMulti(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{            
            Id QuoteId = (Id) input.get('contextId');
            Quote temp = new Quote();
            temp.Id = QuoteId;
            temp.Status = 'Proceso';
            temp.OSFMX_SubEstatus__c = 'Autorización';
            
            List<Quote> listQuote = [SELECT Id, Status,OSFMX_SubEstatus__c FROM Quote WHERE vlocity_cmt__ParentQuoteId__c = :QuoteId];
            for (Quote childQuote : listQuote) {
                childQuote.Status = 'Proceso';
                childQuote.OSFMX_SubEstatus__c = 'Autorización';
            }
            listQuote.add(temp);
            upsert listQuote;
        }        
        catch(Exception ex) {
            System.debug('OSFMX_EnviarOfertaSolicitud SendToAuthorizationGasMulti - ex: ' + ex);
            throw ex;
        }
    }
   

}