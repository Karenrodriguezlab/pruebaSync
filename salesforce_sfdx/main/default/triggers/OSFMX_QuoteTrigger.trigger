trigger OSFMX_QuoteTrigger on Quote (before update, after update) {
    List<Quote> lstUpdate = new List<Quote>();
    List<Quote> lstMasterUpdate = new List<Quote>();
    RecordType recordTypesId = [select Id from RecordType where DeveloperName = 'OSFMX_OfertaGas' and SobjectType = 'Quote'];
    RecordType masterRecordTypesId = [select Id from RecordType where DeveloperName = 'MasterQuote' and SobjectType = 'Quote'];
    for(Quote q : Trigger.new) {
        if (q.RecordTypeId == recordTypesId.Id) {
            lstUpdate.add(q);
        }
        if (q.RecordTypeId == masterRecordTypesId.Id) {
            lstMasterUpdate.add(q);
        }
    }
    if(Trigger.isBefore){
        if(Trigger.IsUpdate){
            OSFMX_QuoteTriggerHandler.beforeUpdate(Trigger.oldMap, lstUpdate);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.IsUpdate){
            OSFMX_QuoteTriggerHandler.afterUpdate(Trigger.oldMap, lstUpdate);
            OSFMX_QuoteTriggerHandler.afterUpdateMaster(Trigger.oldMap, lstMasterUpdate);
        }
    }
}