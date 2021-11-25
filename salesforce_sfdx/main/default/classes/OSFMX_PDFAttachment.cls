global class OSFMX_PDFAttachment implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String method, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        Boolean res = true;
        if(method == 'attachPDF') {
            res = attachPDF(input,output,options);
        }
        return res;
    }
    
    private static Boolean attachPDF(Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        try {
            String parentId = (String) options.get('contextId');
            String docId    = (String) options.get('docId');
            String docName  = (String) options.get('docName');
            
            savePDF(parentId, docId, docName);           
            return true;
        } catch(Exception e) {
            output.put('Error', e.getMessage());
            return false;
        }
    }
    
    @future(callout=true)
    private static void savePDF(String parentId, String docId, String docName) {
        vlocity_cmt.ObjectDocumentCreationController.savePdf(parentId, docId, docName);
    }

}