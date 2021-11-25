/***********************************************************************************
    Developed by:   Roberto Rodriguez Anaya
    Author      :   Roberto Rodriguez Anaya
    Project     :   OSFMX
    Description :   OSFMX_DeleteInvoiceBatch
   ================================================================================
    No.     Date                 Author                    Description      Comment
    1.0     21-Feb-2021          Roberto Rodriguez Anaya   Creation         ........


************************************************************************************/
global class OSFMX_DeleteInvoiceBatch implements Database.Batchable<sObject>, Database.Stateful {
// instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        DateTime fecha = system.now();
        System.debug('##### OSFMX_DeleteInvoiceBatch - start() - Fecha: ' + fecha);
        return Database.getQueryLocator(
            [
                SELECT Id,OSFMX_CuentaContrato__c
                FROM OSFMX_ContractAccountForBilling__c
            ]
        );
    }
    
    global void execute(Database.BatchableContext bc, List<OSFMX_ContractAccountForBilling__c> records){
        System.debug('##### OSFMX_DeleteInvoiceBatch - execute - INICIO');
        recordsProcessed+=records.size();
        DELETE records;
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('##### OSFMX_DeleteInvoiceBatch - finish() - Se actualizaron ' + recordsProcessed + ' registros.');
    }
}