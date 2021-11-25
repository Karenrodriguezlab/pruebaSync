/***********************************************************************************
    Developed by:   Roberto Rodriguez Anaya
    Author      :   Roberto Rodriguez Anaya
    Project     :   OSFMX
    Description :   OSFMX_DelteInvoiceSchedulable
   ================================================================================
    No.     Date                 Author                    Description      Comment
    1.0     21-Feb-2021          Roberto Rodriguez Anaya   Creation         ........


************************************************************************************/
global class OSFMX_DeleteInvoiceSchedulable implements Schedulable {
    global void execute(SchedulableContext ctx) {
        OSFMX_DeleteInvoiceBatch myBatchObject = new OSFMX_DeleteInvoiceBatch(); 
        Id batchId = Database.executeBatch(myBatchObject);
        System.debug('##### OSFMX_DeleteInvoiceSchedulable - execute() - batchId: ' + batchId);
    }
}