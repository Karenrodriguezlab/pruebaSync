/**
 * @Description        : Cambia a estatus "Expirada" registros del objeto "Quote".
 * @Modification Log   : 
 * Ver       Date            	Author      		    Modification
 * 1.0    23/03/2021   		Edgar Maldonado     	Initial Version.
 * 1.1	  30/04/2021   		Edgar Maldonado     	Se invierte la validación de fecha.
**/
global class OSFMX_QuoteExpiredBatch implements Database.Batchable<sObject>, Database.Stateful {
// instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        DateTime fecha = system.now();
        System.debug('##### OSFMX_QuoteExpiredBatch - start() - Fecha: ' + fecha);
        return Database.getQueryLocator(
            [
                SELECT Id,Name,Status,vlocity_cmt__ValidationDate__c
                FROM Quote 
                WHERE vlocity_cmt__ValidationDate__c < :fecha
                	AND Status NOT IN ('Rechazada','Imposible','Ganada','Expirada')
            ]
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Quote> records){
        System.debug('##### OSFMX_QuoteExpiredBatch - execute - INICIO');
        recordsProcessed+=records.size();
        for(Quote item: records){
            item.Status ='Expirada';
        }
        UPDATE records;
        System.debug('##### OSFMX_QuoteExpiredBatch - execute() - Registros Actualizados: ' + records);
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('##### OSFMX_QuoteExpiredBatch - finish() - Se actualizaron ' + recordsProcessed + ' registros.');
    }
}