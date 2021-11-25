@isTest
public class OSFMX_PDFAttachmentTest {

    @isTest
    static void testAttachPDF() {
        OSFMX_PDFAttachment remoteAcc = new OSFMX_PDFAttachment();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String,Object> payload = new Map<String, Object>();
        
        Opportunity opp = new Opportunity(Name='Opp Test', CloseDate=Date.today(), StageName='Stand-by');
        insert opp;
        Quote qt = new Quote(Name='Quote Test', OpportunityId = opp.Id);
        insert qt;
        
        options.put('contextId',qt.Id);
        options.put('docId','00Pc000000IioeDEAR');
        options.put('docName','ENGIE – Oferta Gas Natural Molécula Pura – ' + qt.Id);
        remoteAcc.invokeMethod('attachPDF',inputs,output,options);
        system.debug('OSFMX_PDFAttachmentTest - testAttachPDF - output: ' + output);
        system.assert(output.size()==0);
        options.put('docId',1);
        remoteAcc.invokeMethod('attachPDF',inputs,output,options);
        system.assert(output.size()>0);
    }
}