/***********************************************************************************
    Developed by:   Roberto Rodriguez Anaya
    Author      :   Roberto Rodriguez Anaya
    Project     :   OSFMX
    Description :   Prueba unitaria de la clase OSFMX_DeleteInvoiceSchedulable
   ================================================================================
    No.     Date                 Author                    Description      Comment
    1.0     21-Feb-2021          Roberto Rodriguez Anaya   Creation         ........


************************************************************************************/
@isTest
public class OSFMX_DeleteInvoiceSchedulable_test {
	// Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testmethod void testScheduledJob() {
        OSFMX_ContractAccountForBilling__c contrAcc = new OSFMX_ContractAccountForBilling__c(OSFMX_CuentaContrato__c='1234567890');
        INSERT contrAcc;
		OSFMX_360ViewInvoice__c invoiceItem = new OSFMX_360ViewInvoice__c(OSFMX_ContractAccountForBilling__c=contrAcc.Id);
        INSERT invoiceItem;
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('OSFMX_DeleteInvoiceSchedulable',
                                       CRON_EXP, 
                                       new OSFMX_DeleteInvoiceSchedulable());
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
        System.debug('##### OSFMX_DeleteInvoiceSchedulable - cron: ' + cron);
        System.assertEquals('OSFMX_DeleteInvoiceSchedulable', 
                            cron.CronJobDetail.Name, 
                            'La clase Apex no fué programada correctamente.');
    }
}