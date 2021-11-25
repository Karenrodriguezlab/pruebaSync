@isTest
public class IntegrationProcedureInvocableTest {
    @isTest
    static void testRunIntegrationServiceInvocable() {
        IntegrationProcedureInvocable ipInvoc = new IntegrationProcedureInvocable();
        List<IntegrationProcedureInvocable.IntegrationProcedureInput> inputList = new List<IntegrationProcedureInvocable.IntegrationProcedureInput>();
        List<IntegrationProcedureInvocable.IntegrationProcedureOutput> outputList;
        IntegrationProcedureInvocable.IntegrationProcedureInput input = new IntegrationProcedureInvocable.IntegrationProcedureInput();
        
        input.procedureAPIName = 'TestIPName';
        input.input = '{"QuoteId":"abcde123"}';
        inputList.add(input);
        outputList = IntegrationProcedureInvocable.runIntegrationServiceInvocable(inputList);
        System.debug('##### IntegrationProcedureInvocableTest - testRunIntegrationServiceInvocable: '
                     + outputList);
        String response = outputList.get(0).output;
        System.assert(response.contains(input.procedureAPIName), 'vlocity_cmt.IntegrationProcedureService.runIntegrationService no retornó lo esperado.');
    }
}