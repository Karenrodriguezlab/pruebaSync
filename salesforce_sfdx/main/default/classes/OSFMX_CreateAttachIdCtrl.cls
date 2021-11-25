public class OSFMX_CreateAttachIdCtrl {
    public Id contextId {get;set;}
    
    public OSFMX_CreateAttachIdCtrl(ApexPages.StandardController ctrl) {
        Quote qt = (Quote) ctrl.getRecord();
        contextId = qt.Id;
    }
    
    public PageReference createObjId() {
        PageReference vfPDF = null;
        String pdfName = 'Formato de Oferta';
        
        if(String.isNotBlank(this.contextId)) {
            String path = 'OSFMX_CreateObjectDocument';
            Map<String,Object> input   = new Map<String,Object>{'contextId'  => contextId};
            Map<String,Object> options = new Map<String,Object>();
            
            Map<String, Object> output = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(path, input, options);  
            
            String templateId = (String) output.get('templateId');
            String docId      = (String) output.get('docId');
            System.debug('--> docId ' + docId + ' ::: templateId ' + templateId);
            
            if(String.isNotBlank(docId)) {
                vfPDF = new PageReference('/apex/ObjectDocumentCreation3?id='+docId+'&templateId='+templateId+'&documentName='+pdfName+'&contextId='+contextId);
                vfPDF.setRedirect(true);
            }
        }
        return vfPDF;
    }


}