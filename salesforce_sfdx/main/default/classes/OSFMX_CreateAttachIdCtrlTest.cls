@isTest
public class OSFMX_CreateAttachIdCtrlTest {
    public OSFMX_CreateAttachIdCtrlTest() {

    }
    @isTest
    public static void Test(){        
        Test.StartTest();        
        
        Test.StopTest();                     
    }
    
    static testMethod void testVF() {
        Opportunity opp = new Opportunity(Name='Opp Test', CloseDate=Date.today(), StageName='	Stand-by');
        insert opp;
        
        Quote qt = new Quote(Name='Quote Test', OpportunityId = opp.Id);
        insert qt;
        
        Test.StartTest(); 		
			ApexPages.StandardController sc = new ApexPages.StandardController(qt);
			OSFMX_CreateAttachIdCtrl objIdCtrl = new OSFMX_CreateAttachIdCtrl(sc);
        	objIdCtrl.createObjId();
		Test.StopTest();
    }

}