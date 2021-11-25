/**
 * @Description        : Prueba unitaria de la clase "OSFMX_QuoteExpiredBatch".
 * @Modification Log   : 
 * Ver       Date            	Author      		    Modification
 * 1.0    23/03/2021   		Edgar Maldonado     	Initial Version.
 * 1.1	  30/04/2021   		Edgar Maldonado     	Se invierte la validación de fecha.
**/
@isTest
public class OSFMX_QuoteExpiredBatchTest {
	static testmethod void testExecuteBatch() {
        Date fechaActual = date.today();
        Opportunity opp = new Opportunity(
        	Name = 'OSFMX_QuoteExpiredBatchTest',
            StageName='Abierta', 
            CloseDate=fechaActual
        );
        INSERT opp;
        
        // Create some out of date Quote records
        List<Quote> quoteList = new List<Quote>();
        Datetime now = system.now();
        DateTime expiredDate = now.addDays(-1);
        for (Integer i=0; i<10; i++) {
            Quote obj = new Quote(
                Name = 'QuoteExpiredBatch ' + i,
                Status = 'Aprobada',
                vlocity_cmt__ValidationDate__c = expiredDate,
                OpportunityId = opp.Id
            );
            quoteList.add(obj);
        }
        INSERT quoteList;
        
        Test.startTest();
        List<Quote> quoteList2 = new List<Quote>(
            [
                SELECT Id,Name,Status,vlocity_cmt__ValidationDate__c
                FROM Quote
            ]
        );

        OSFMX_QuoteExpiredBatch batch = new OSFMX_QuoteExpiredBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        
        // check that the scheduled job has executed
        List<Quote> quoteList3 = new List<Quote>(
            [
                SELECT Id,Name,Status,vlocity_cmt__ValidationDate__c
                FROM Quote
                WHERE Status='Expirada'
            ]
        );
        System.assertEquals(quoteList3.size(), 
                            quoteList2.size(),
                            'Los registros de Quote no fueron actualizados.');
    }
}