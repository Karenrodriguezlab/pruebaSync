/***********************************************************************************
    Developed by:   Roberto Rodriguez Anaya
    Author      :   Roberto Rodriguez Anaya
    Project     :   OSFMX
    Description :   Clase Test OSFMX_DeleteInvoiceBatch_test

   ================================================================================
    No.     Date                 Author                    Description      Comment
    1.0     21-Feb-2021          Roberto Rodriguez Anaya   Creation         ........


************************************************************************************/
@isTest
public class OSFMX_DeleteInvoiceBatch_test {
    static testmethod void testExecuteBatch() {
        OSFMX_ContractAccountForBilling__c contrAcc = new OSFMX_ContractAccountForBilling__c(OSFMX_CuentaContrato__c='1234567890');
        INSERT contrAcc;
		OSFMX_360ViewInvoice__c invoiceItem = new OSFMX_360ViewInvoice__c(OSFMX_ContractAccountForBilling__c=contrAcc.Id);
        INSERT invoiceItem;
                
        Test.startTest();
        OSFMX_DeleteInvoiceBatch batch = new OSFMX_DeleteInvoiceBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        
        // check that the scheduled job has executed
        List<OSFMX_360ViewInvoice__c> invoiceList = [SELECT Id,OSFMX_NumFactura__c FROM OSFMX_360ViewInvoice__c];
        List<OSFMX_ContractAccountForBilling__c> cAccList = [SELECT Id,OSFMX_CuentaContrato__c FROM OSFMX_ContractAccountForBilling__c];
        System.assertEquals(0, invoiceList.size(), 'Los registrso de OSFMX_360ViewInvoice__c no fueron eliminados');
        System.assertEquals(0, cAccList.size(), 'Los registrso de OSFMX_ContractAccountForBilling__c no fueron eliminados');
    }
}