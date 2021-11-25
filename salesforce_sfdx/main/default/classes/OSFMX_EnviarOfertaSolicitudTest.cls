@isTest
public class OSFMX_EnviarOfertaSolicitudTest {
    
    static testMethod void testSendPost() {
        Opportunity opp = new Opportunity(Name='Opp Test', CloseDate=Date.today(), StageName='Stand-by');
        insert opp;
        
        Quote qt = new Quote(Name='Quote Test', OpportunityId = opp.Id);
        insert qt;
        
        String methodName='SendPost';
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('contextId',qt.Id); 
        Map<String, Object> outMap = null;
        Map<String, Object> options = null;
        Test.StartTest(); 					
			OSFMX_EnviarOfertaSolicitud quoteTest = new OSFMX_EnviarOfertaSolicitud();
            quoteTest.invokeMethod(methodName, inputMap, outMap, options);
        
        for (Quote qtassert : [SELECT Status,OSFMX_SubEstatus__c FROM Quote WHERE Name='Quote Test']){
            System.assertEquals('Proceso', qtassert.Status);
            System.assertEquals('Solicitud', qtassert.OSFMX_SubEstatus__c);
        }
        Test.StopTest();
    }
    
    static testMethod void testAuthorizeQuoteByGasUser() {
        Opportunity opp = new Opportunity(Name='Opp Test', CloseDate=Date.today(), StageName='Stand-by');
        insert opp;
        
        Quote qt = new Quote(Name='Quote Test 2', OpportunityId = opp.Id);
        insert qt;
        
        String methodName='AuthorizeQuoteByGasUser';
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('contextId',qt.Id); 
        Map<String, Object> outMap = null;
        Map<String, Object> options = null;
        Test.StartTest();
        OSFMX_EnviarOfertaSolicitud quoteTest = new OSFMX_EnviarOfertaSolicitud();
        quoteTest.invokeMethod(methodName, inputMap, outMap, options);
        for (Quote qtassert : [SELECT Status,OSFMX_SubEstatus__c FROM Quote WHERE Name='Quote Test 2']){
            System.assertEquals('Proceso', qtassert.Status);
            System.assertEquals('Producto', qtassert.OSFMX_SubEstatus__c);
        }
        Test.StopTest();
    }
    
    static testMethod void testSendQuoteMoleculaTransporteByGasUser() {
        Opportunity opp = new Opportunity(Name='Opp Test', CloseDate=Date.today(), StageName='Stand-by');
        insert opp;
        
        Quote qt = new Quote(Name='Quote Test 3', OpportunityId = opp.Id);
        insert qt;
        
        String methodName='SendQuoteMoleculaTransporteByGasUser';
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('contextId',qt.Id); 
        Map<String, Object> outMap = null;
        Map<String, Object> options = null;
        Test.StartTest();
        OSFMX_EnviarOfertaSolicitud quoteTest = new OSFMX_EnviarOfertaSolicitud();
        quoteTest.invokeMethod(methodName, inputMap, outMap, options);
        for (Quote qtassert : [SELECT Status,OSFMX_SubEstatus__c FROM Quote WHERE Name='Quote Test 3']){
            System.assertEquals('Proceso', qtassert.Status);
            System.assertEquals('Factibilidad Mexcom', qtassert.OSFMX_SubEstatus__c);
        }
        Test.StopTest();
    }
    
    static testMethod void testSendDistributionQuoteToApproval() {
        Opportunity opp = new Opportunity(Name='Opp Test', CloseDate=Date.today(), StageName='Stand-by');
        insert opp;
        
        Quote qt = new Quote(Name='Quote Test 4', OpportunityId = opp.Id);
        insert qt;
        
        String methodName='SendDistributionQuoteToApproval';
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('contextId',qt.Id); 
        Map<String, Object> outMap = null;
        Map<String, Object> options = null;
        Test.StartTest();
        OSFMX_EnviarOfertaSolicitud quoteTest = new OSFMX_EnviarOfertaSolicitud();
        quoteTest.invokeMethod(methodName, inputMap, outMap, options);
        for (Quote qtassert : [SELECT Status,OSFMX_SubEstatus__c FROM Quote WHERE Name='Quote Test 4']){
            System.assertEquals('Proceso', qtassert.Status);
            System.assertEquals('Autorización', qtassert.OSFMX_SubEstatus__c);
        }
        Test.StopTest();
    }
    
    static testMethod void testSendOpportunityToStandBy() {
        Opportunity opp = new Opportunity(Name='Opp Test 5', CloseDate=Date.today(), StageName='Stand-by');
        insert opp;
        
        String methodName='SendOpportunityToStandBy';
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('contextId',opp.Id);
        Map<String, Object> outMap = null;
        Map<String, Object> options = null;
        Test.StartTest();
        OSFMX_EnviarOfertaSolicitud quoteTest = new OSFMX_EnviarOfertaSolicitud();
        quoteTest.invokeMethod(methodName, inputMap, outMap, options);
        for (Opportunity oppassert : [SELECT Id,StageName FROM Opportunity WHERE Name='Opp Test 5']){
            System.assertEquals('Stand-by', oppassert.StageName);
        }
        Test.StopTest();
    }

    static testMethod void testSendOpportunityToProcess() {
        Opportunity opp = new Opportunity(Name='Opp Test 6', CloseDate=Date.today(), StageName='Stand-by');
        insert opp;
        
        String methodName='SendOpportunityToProcess';
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('contextId',opp.Id);
        Map<String, Object> outMap = null;
        Map<String, Object> options = null;
        Test.StartTest();
        OSFMX_EnviarOfertaSolicitud quoteTest = new OSFMX_EnviarOfertaSolicitud();
        quoteTest.invokeMethod(methodName, inputMap, outMap, options);
        for (Opportunity oppassert : [SELECT Id,StageName FROM Opportunity WHERE Name='Opp Test 6']){
            System.assertEquals('En proceso', oppassert.StageName);
        }
        Test.StopTest();
    }
}