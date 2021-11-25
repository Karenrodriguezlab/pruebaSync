trigger vlcContentDistribution on ContentDistribution (after update) {

    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            
            Set<String> setIds = new Set<String>();
            for(ContentDistribution cd : Trigger.New) {
                setIds.add(cd.Id);
            }
            
            List<ContentDistribution> lCD = [SELECT Id, Name, RelatedRecordId, DistributionPublicUrl FROM ContentDistribution WHERE Id IN: setIds];
            System.debug('--> ::: lCD ' + lCD);
            
            Map<String,String> mapParentUrl = new Map<String,String>();
            for(ContentDistribution cd : lCD) {
                mapParentUrl.put(cd.RelatedRecordId, cd.DistributionPublicUrl);
            }
            System.debug('--> :: mapParentUrl' + mapParentUrl);
            
            /*Se acota funcionalidad solo a objeto OSFMX_URL__c*/
            List<OSFMX_URL__c> reportesExistentes = [SELECT Id FROM OSFMX_URL__c WHERE Id IN :mapParentUrl.keySet() ORDER BY CreatedDate DESC];
            
            List<OSFMX_URL__c> reportes = new List<OSFMX_URL__c>();
            //for(String reportId : mapParentUrl.keySet()) {
            for(OSFMX_URL__c reportItem : reportesExistentes) {
                if(String.isNotBlank(mapParentUrl.get(reportItem.Id))) {
                	OSFMX_URL__c reporte = new OSFMX_URL__c();
                    reporte.Id = reportItem.Id;
                    reporte.OSFMX_URL_PDF__c = mapParentUrl.get(reportItem.Id);
                    reportes.add(reporte);
                }
            }
            
            if(!reportes.isEmpty()) {
                update reportes;
            }
            System.debug('--> :: reportes ' + reportes);
            if(!reportesExistentes.isEmpty()){
                OSFMX_UpdateURLSubscriptionBatch myBatchObject = new OSFMX_UpdateURLSubscriptionBatch(reportesExistentes.get(0).Id); 
        		Id batchId = Database.executeBatch(myBatchObject);
        		System.debug('##### Trigger vlcContentDistribution - execute() - batchId: ' + batchId);
            }
        }
    }
}