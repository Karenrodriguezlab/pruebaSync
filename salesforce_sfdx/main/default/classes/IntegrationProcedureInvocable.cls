global with sharing class IntegrationProcedureInvocable {
    @InvocableMethod(label = 'Integration Procedure')
    global static List<IntegrationProcedureOutput> runIntegrationServiceInvocable(List<IntegrationProcedureInput> input) {
        System.debug(LoggingLevel.Error, 'IntegrationProcedureInvocable - IntegrationProcedureInvocable - input: ' + JSON.serialize(input));
        IntegrationProcedureOutput result = new IntegrationProcedureOutput();
        //result.output = JSON.serialize(vlocity_cmt.IntegrationProcedureService.runIntegrationService(input[0].procedureAPIName,new Map<String,Object> {'Id' => input[0].input},new Map<String,Object>()));
        /*INICIO - Convertir Input de JSON a Map*/
        Map<String,Object> integProcInput = (Map<String, Object>) JSON.deserializeUntyped(input[0].input);
        System.debug('IntegrationProcedureInvocable - IntegrationProcedureInvocable - Map integProcInput:' + integProcInput);
        result.output = JSON.serialize(vlocity_cmt.IntegrationProcedureService.runIntegrationService(input[0].procedureAPIName,integProcInput,new Map<String,Object>()));
        /*FIN - Convertir Input de JSON a Map*/
        System.debug(LoggingLevel.Error, JSON.serialize(result));
        
        return new List<IntegrationProcedureOutput>{result};        
    }
    
    global class IntegrationProcedureInput {
        @InvocableVariable(label = 'Procedure Name') global String procedureAPIName;
        @InvocableVariable(label = 'Input') global String input;
    }
    global class IntegrationProcedureOutput {
        @InvocableVariable(label = 'Output') global String output;
    }
}