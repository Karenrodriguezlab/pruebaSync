/**
 * @Description        : Prueba unitaria de la clase "OSFMX_UpdateURLSubscriptionBatch".
 * @Modification Log   : 
 * Ver       Date            	Author      		    Modification
 * 1.0    02/07/2021   		Edgar Maldonado     	Initial Version.
**/
@isTest
public class OSFMX_UpdateURLSubscriptionBatchTest {
	static testmethod void testExecuteBatch() {
        OSFMX_URL__c documentUrl = new OSFMX_URL__c(Name='OSFMX_UpdateURLSubscriptionBatchTest');
        INSERT documentUrl;
        OSFMX_Subscription__c subscription = new OSFMX_Subscription__c(OSFMX_SubscriptionEmail__c='test@mail.com',OSFMX_Subscription__c='SI');
        INSERT subscription;
        
        Test.startTest();
        OSFMX_UpdateURLSubscriptionBatch myBatchObject = new OSFMX_UpdateURLSubscriptionBatch(documentUrl.Id); 
       	Id batchId = Database.executeBatch(myBatchObject);
        Test.stopTest();
        
        // check that the scheduled job has executed
        List<OSFMX_Subscription__c> quoteList3 = new List<OSFMX_Subscription__c>(
            [
                SELECT Id,Name,OSFMX_ReportWeekly__c
                FROM OSFMX_Subscription__c
            ]
        );
        System.assertEquals(documentUrl.Id, 
                            quoteList3.get(0).OSFMX_ReportWeekly__c,
                            'Los registros de OSFMX_Subscription__c no fueron actualizados.');
    }
}