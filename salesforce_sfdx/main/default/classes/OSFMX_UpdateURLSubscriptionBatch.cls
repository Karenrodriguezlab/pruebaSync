/**
 * @Description        : Cambia referencia a reporte semanal en registros del objeto "OSFMX_Subscription__c".
 * @Modification Log   : 
 * Ver       Date            	Author      		    Modification
 * 1.0    02/07/2021   		Edgar Maldonado     	Initial Version.
**/
global class OSFMX_UpdateURLSubscriptionBatch implements Database.Batchable<sObject>, Database.Stateful {
	// instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    private String reportURLId;
    
    public OSFMX_UpdateURLSubscriptionBatch(Id strReportURLId) {
        reportURLId = strReportURLId;
        System.debug('##### OSFMX_UpdateURLSubscriptionBatch - constructor() - strReportURLId: ' + strReportURLId);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        DateTime fecha = system.now();
        System.debug('##### OSFMX_UpdateURLSubscriptionBatch - start() - Fecha: ' + fecha);
        return Database.getQueryLocator(
            [
                SELECT Id,OSFMX_ReportWeekly__c 
                FROM OSFMX_Subscription__c 
                WHERE OSFMX_Subscription__c='SI'
            ]
        );
    }
    
    global void execute(Database.BatchableContext bc, List<OSFMX_Subscription__c> records){
        System.debug('##### OSFMX_UpdateURLSubscriptionBatch - execute - INICIO');
        recordsProcessed+=records.size();
        for(OSFMX_Subscription__c item: records){
            item.OSFMX_ReportWeekly__c = reportURLId;
        }
        UPDATE records;
        System.debug('##### OSFMX_UpdateURLSubscriptionBatch - execute() - Registros Actualizados: ' + records);
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('##### OSFMX_UpdateURLSubscriptionBatch - finish() - Se actualizaron ' + recordsProcessed + ' registros.');
    }
}