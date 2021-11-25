let definition =
      {"dataSource":{"type":"IntegrationProcedures","value":{"ipMethod":"OSFMX_ConsultGasBillingIP","vlocityAsync":false,"inputMap":{"AccountId":"{recordId}"},"resultVar":""},"orderBy":{"name":"","isReverse":false},"contextVariables":[{"name":"recordId","val":"0011900000xiwmlAAA","id":10}]},"enableLwc":true,"isFlex":true,"isRepeatable":true,"lwc":{"DeveloperName":"cfOSMXBillingParent_1_Globant","Id":"0Rb190000008jpFCAQ","MasterLabel":"cfOSMXBillingParent_1_Globant","NamespacePrefix":"c"},"osSupport":false,"states":[{"actions":[],"childCards":["OSMXLastBilling","OSMXBillingGraph","OSMXBillingDataTable"],"components":{"layer-0":{"children":[{"name":"FlexCard","element":"childCardPreview","size":{"isResponsive":false,"default":"12"},"stateIndex":0,"class":"nds-col ","property":{"cardName":"OSMXLastBilling","recordId":"{recordId}","cardNode":"","selectedState":"Active","isChildCardTrackingEnabled":false,"parentAttribute":{"cuentaContrato":"{cuenta_contrato}"}},"type":"element","styleObject":{"sizeClass":"nds-size_12-of-12"},"elementLabel":"FlexCard-0"},{"class":"nds-col ","element":"childCardPreview","elementLabel":"FlexCard-1","name":"FlexCard","property":{"cardName":"OSMXBillingGraph","cardNode":"","isChildCardTrackingEnabled":false,"parentAttribute":{"cuentaContrato":"{cuenta_contrato}"},"recordId":"{recordId}","selectedState":"Active"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"size":{"default":"12","isResponsive":false},"sizeClass":"nds-size_12-of-12 "},"type":"element"},{"class":"nds-col ","element":"childCardPreview","elementLabel":"FlexCard-2","name":"FlexCard","property":{"cardName":"OSMXBillingDataTable","cardNode":"","isChildCardTrackingEnabled":false,"recordId":"{recordId}","selectedState":"Active","parentAttribute":{"cuentaContrato":"{cuenta_contrato}"}},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"nds-size_12-of-12"},"type":"element"}]}},"conditions":{"group":[],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"fields":[],"isSmartAction":false,"name":"Active","omniscripts":[],"smartAction":{},"styleObject":{"class":"nds-card nds-p-around_x-small nds-m-bottom_x-small","container":{"class":"nds-card"},"margin":[{"size":"x-small","type":"bottom"}],"padding":[{"size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"nds-size_12-of-12"}}],"theme":"nds","title":"OSMX Billing Parent","Id":"a5J19000000EPa1EAG","GlobalKey__c":"OSMXBillingParent/Globant/1/1614616962968","IsChildCard__c":false};
  export default definition