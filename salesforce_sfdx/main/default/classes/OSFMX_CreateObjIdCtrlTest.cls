@isTest
public class OSFMX_CreateObjIdCtrlTest {
    public OSFMX_CreateObjIdCtrlTest() {

    }
    @isTest
    public static void Test(){        
        Test.StartTest();        
        
        Test.StopTest();                     
    }
    
    static testMethod void testVF() {
        Opportunity opp = new Opportunity(Name='Opp Test', CloseDate=Date.today(), StageName='Stand-by');
        insert opp;
        
        Quote qt = new Quote(Name='Quote Test', OpportunityId = opp.Id);
        insert qt;
        
        Test.StartTest(); 		
			ApexPages.StandardController sc = new ApexPages.StandardController(qt);
			OSFMX_CreateObjIdCtrl objIdCtrl = new OSFMX_CreateObjIdCtrl(sc);
        	objIdCtrl.createObjId();
		Test.StopTest();
    }

}