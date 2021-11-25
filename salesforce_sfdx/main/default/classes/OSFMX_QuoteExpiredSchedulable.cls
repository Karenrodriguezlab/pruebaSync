/**
 * @Description        : Interfaz programable para la clase "OSFMX_QuoteExpiredBatch".
 * @Modification Log   : 
 * Ver       Date            	Author      		    Modification
 * 1.0    23/03/2021   		Edgar Maldonado     	Initial Version.
**/
global class OSFMX_QuoteExpiredSchedulable implements Schedulable {
	global void execute(SchedulableContext ctx) {
        OSFMX_QuoteExpiredBatch myBatchObject = new OSFMX_QuoteExpiredBatch(); 
        Id batchId = Database.executeBatch(myBatchObject);
        System.debug('##### OSFMX_QuoteExpiredSchedulable - execute() - batchId: ' + batchId);
    }
}