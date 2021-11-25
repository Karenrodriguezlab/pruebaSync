/****************************************************************************************************
    Author:         Luis Licona
    Company:        Globant
    Project:        OSFMX - ENGIE
    Description:    Test class to OSFMX_PagoExitosoMultipagos

    Information about changes (versions)
    -------------------------------------
    Number    Dates                 Author                       	Description
    ------    --------              --------------------------   	-----------
    1.0       08-OCTOBER-2022       Luis Licona  					Creation Class
*****************************************************************************************************/
@isTest
public class  OSFMX_PagoExitosoMultipagosTst {

    /*---------------------------------------------------------------------
    @description:   TestMethod for execute init and redirect url
    ---------------------------------------------------------------------*/
    @isTest
    static void testInitRedirectMethods() {        

		Test.startTest();
            String urlTest = 'https://testUrl/?mp_amount=199.99&mp_order=4TST&mp_contract=18&mp_responsemsgcomplete=EN%20TEST&mp_response=00&mp_responsemsg=TEST&mp_paymentMethod=TST&&mp_reference=400&mp_responsecomplete=00&mp_authorization=00&mp_signature=TST';
            Pagereference pageR = new PageReference(urlTest);
            pageR.getHeaders().put('Referer', urlTest);
            Test.setCurrentPage(pageR);
            OSFMX_PagoExitosoMultipagos ctrl = new OSFMX_PagoExitosoMultipagos();
            PageReference pReference = ctrl.init();
            System.assertEquals(pReference == null, true);

            PageReference prFinal = ctrl.urlRedirection();   
            System.assertEquals(prFinal != null, true);         

        Test.stopTest();
    }
}