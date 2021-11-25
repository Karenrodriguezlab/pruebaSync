/**
 * @Description        : Prueba unitaria de la clase "OSFMX_QuoteExpiredSchedulable".
 * @Modification Log   : 
 * Ver       Date            	Author      		    Modification
 * 1.0    23/03/2021   		Edgar Maldonado     	Initial Version.
**/
@isTest
public class OSFMX_QuoteExpiredSchedulableTest {
	// Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testmethod void testScheduledJob() {
        Opportunity opp = new Opportunity(
        	Name = 'OSFMX_QuoteExpiredBatchTest',
            StageName='Abierta', 
            CloseDate=date.today()
        );
        INSERT opp;
        // Create some out of date Quote records
        List<Quote> quoteList = new List<Quote>();
        Datetime now = system.now();
        DateTime expiredDate = now.addDays(1);
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
        // Schedule the test job
        String jobId = System.schedule('OSFMX_QuoteExpiredSchedulableTest',
                                       CRON_EXP, 
                                       new OSFMX_QuoteExpiredSchedulable());
        // Stopping the test will run the job synchronously
        Test.stopTest();
        
        // check that the scheduled job has executed
        CronTrigger cron = 
            [
                SELECT Id,CronJobDetail.Name,State,TimesTriggered,NextFireTime 
                FROM CronTrigger
                ORDER BY CreatedDate
                DESC LIMIT 1
            ];
        System.debug('##### OSFMX_QuoteExpiredSchedulableTest - cron: ' + cron);
        System.assertEquals('OSFMX_QuoteExpiredSchedulableTest', 
                            cron.CronJobDetail.Name, 
                            'La clase Apex no fué programada correctamente.');
    }
}