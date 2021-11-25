@isTest
public class OSFMX_InsertChatterCommentTest {

    @isTest
    static void testSendPost() {
        OSFMX_InsertChatterComment remoteAcc = new OSFMX_InsertChatterComment();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String,Object> payload = new Map<String, Object>();
        
        Opportunity opp = new Opportunity(Name='Opp Test', CloseDate=Date.today(), StageName='Stand-by');
        insert opp;
        Quote qt = new Quote(Name='Quote Test', OpportunityId = opp.Id);
        insert qt;
        
        options.put('QuoteId',qt.Id);
        options.put('UserId',UserInfo.getUserId());
        options.put('Comentarios','Comentario Prueba Unitaria.');
        remoteAcc.invokeMethod('SendPost',inputs,output,options);
        options.put('QuoteId',0);
        try {
            remoteAcc.invokeMethod('SendPost',inputs,output,options);
        } catch(Exception e) {
            System.debug('OSFMX_InsertChatterCommentTest:testSendPost -> exception: ' + e.getLineNumber());
        }
        
    }
}