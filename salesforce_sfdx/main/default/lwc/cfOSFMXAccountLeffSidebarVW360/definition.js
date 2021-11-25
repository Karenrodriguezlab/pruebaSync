let definition =
      {"states":[{"fields":[],"conditions":{"id":"state-condition-object","isParent":true,"group":[]},"definedActions":{"actions":[]},"name":"Active","isSmartAction":false,"smartAction":{},"styleObject":{"padding":[{"type":"around","size":"x-small","label":"around:x-small"}],"margin":[{"type":"bottom","size":"x-small","label":"bottom:x-small"}],"container":{"class":"slds-card"},"size":{"isResponsive":false,"default":"12"},"sizeClass":"slds-size_12-of-12 ","class":"slds-card slds-border_top slds-p-around_x-small slds-m-bottom_x-small ","background":{"color":"","image":"","size":"","repeat":"","position":""},"border":{"type":"border_top","width":"2","color":"#cccccc","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","style":"     border-color:#cccccc; border-width:2px;   height:500px;    ","height":"500px"},"components":{"layer-0":{"children":[{"name":"Block","element":"block","size":{"isResponsive":false,"default":"12"},"stateIndex":0,"class":"slds-col ","property":{"label":"Block","collapsible":false,"record":"{record}","collapsedByDefault":false,"card":"{card}"},"type":"block","styleObject":{"padding":[{"type":"around","size":"x-small","label":"around:x-small"}],"class":"slds-p-around_x-small ","sizeClass":"slds-size_12-of-12 ","margin":[],"background":{"color":"","image":"https://engielatam--devmexico--c.visualforce.com/resource/1618432565000/OSFMXAccMapa","size":"","repeat":"","position":""},"size":{"isResponsive":false,"default":"12"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","style":" background-image:url(https://engielatam--devmexico--c.visualforce.com/resource/1618432565000/OSFMXAccMapa);        height:100px;    ","height":"100px"},"children":[],"elementLabel":"Block-0"},{"name":"Field","element":"outputField","size":{"isResponsive":false,"default":"12"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"output","record":"{record}","type":"text","card":"{card}","fieldName":"NombreCliente","styles":{"label":{"fontSize":""},"value":{"fontSize":"26px","fontFamily":""}}},"type":"element","styleObject":{"sizeClass":"slds-size_12-of-12","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":false,"default":"12"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"styles":{"label":{"fontSize":""},"value":{"fontSize":"26px","fontFamily":""}}},"text":{"align":"","color":""},"inlineStyle":""},"elementLabel":"Field-1"},{"name":"Field","element":"outputField","size":{"isResponsive":false,"default":"12"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"output","record":"{record}","type":"text","card":"{card}","fieldName":"TipoCliente"},"type":"element","styleObject":{"sizeClass":"slds-size_12-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":false,"default":"12"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"             "},"elementLabel":"Field-2"},{"name":"Icon","element":"flexIcon","size":{"isResponsive":false,"default":"1"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","iconType":"Salesforce SVG","iconName":"custom:custom108","size":"x-small","extraclass":"slds-icon_container slds-icon-custom-custom108 ","variant":"inverse","imgsrc":"","data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-46","field":"TipoCliente","operator":"==","value":"Cuenta de Negocio","type":"custom"}]}},"type":"element","styleObject":{"size":{"isResponsive":false,"default":"1"},"sizeClass":"slds-size_1-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"center","color":""},"inlineStyle":"","class":"slds-text-align_center ","style":"             "},"elementLabel":"Icon-3"},{"name":"Text","element":"outputField","size":{"isResponsive":false,"default":"11"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","mergeField":"%3Cdiv%3EID%20SAP:%20%7BIDSAP%7D%3C/div%3E","card":"{card}","data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-128","field":"TipoCliente","operator":"==","value":"Cuenta de Negocio","type":"custom"}]}},"type":"text","styleObject":{"size":{"isResponsive":false,"default":"11"},"sizeClass":"slds-size_11-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"             "},"elementLabel":"Text-6"},{"name":"Icon","element":"flexIcon","size":{"isResponsive":false,"default":"1"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","iconType":"Salesforce SVG","iconName":"standard:avatar","size":"x-small","extraclass":"slds-icon_container slds-icon-standard-avatar ","variant":"inverse","imgsrc":""},"type":"element","styleObject":{"size":{"isResponsive":false,"default":"1"},"sizeClass":"slds-size_1-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"center","color":""},"inlineStyle":"","class":"slds-text-align_center ","style":"             "},"elementLabel":"Icon-5"},{"name":"Field","element":"outputField","size":{"isResponsive":false,"default":"11"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"","record":"{record}","type":"text","card":"{card}","fieldName":"NombreContacto"},"type":"element","styleObject":{"sizeClass":"slds-size_11-of-12 ","size":{"isResponsive":false,"default":"11"}},"elementLabel":"Field-7"},{"name":"Icon","element":"flexIcon","size":{"isResponsive":false,"default":"1"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","iconType":"Salesforce SVG","iconName":"custom:custom28","size":"x-small","extraclass":"slds-icon_container slds-icon-custom-custom28 ","variant":"inverse","imgsrc":""},"type":"element","styleObject":{"size":{"isResponsive":false,"default":"1"},"sizeClass":"slds-size_1-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"center","color":""},"inlineStyle":"","class":"slds-text-align_center ","style":"             "},"elementLabel":"Icon-8"},{"name":"Field","element":"outputField","size":{"isResponsive":false,"default":"11"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"","record":"{record}","type":"text","card":"{card}","fieldName":"Telefono"},"type":"element","styleObject":{"sizeClass":"slds-size_11-of-12 ","size":{"isResponsive":false,"default":"11"}},"elementLabel":"Field-9"},{"name":"Icon","element":"flexIcon","size":{"isResponsive":false,"default":"1"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","iconType":"Salesforce SVG","iconName":"custom:custom105","size":"x-small","extraclass":"slds-icon_container slds-icon-custom-custom105 ","variant":"inverse","imgsrc":""},"type":"element","styleObject":{"size":{"isResponsive":false,"default":"1"},"sizeClass":"slds-size_1-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"center","color":""},"inlineStyle":"","class":"slds-text-align_center ","style":"             "},"elementLabel":"Icon-10"},{"name":"Field","element":"outputField","size":{"isResponsive":false,"default":"11"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"","record":"{record}","type":"text","card":"{card}","fieldName":"Email"},"type":"element","styleObject":{"sizeClass":"slds-size_11-of-12 ","size":{"isResponsive":false,"default":"11"}},"elementLabel":"Field-11"},{"name":"Icon","element":"flexIcon","size":{"isResponsive":false,"default":"1"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","iconType":"Salesforce SVG","iconName":"custom:custom24","size":"x-small","extraclass":"slds-icon_container slds-icon-custom-custom24 ","variant":"inverse","imgsrc":"","data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-9","field":"TipoCliente","operator":"==","value":"Cuenta de Negocio","type":"custom"}]}},"type":"element","styleObject":{"size":{"isResponsive":false,"default":"1"},"sizeClass":"slds-size_1-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"center","color":""},"inlineStyle":"","class":"slds-text-align_center ","style":"             "},"elementLabel":"Icon-12"},{"name":"Text","element":"outputField","size":{"isResponsive":false,"default":"11"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","mergeField":"%3Cdiv%3E%7BCountServiceAccount%7D%3C/div%3E","card":"{card}","data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-0","field":"TipoCliente","operator":"==","value":"Cuenta de Negocio","type":"custom"}]}},"type":"text","styleObject":{"size":{"isResponsive":false,"default":"11"},"sizeClass":"slds-size_11-of-12 "},"elementLabel":"Text-13"},{"name":"Icon","element":"flexIcon","size":{"isResponsive":false,"default":"1"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","iconType":"Salesforce SVG","iconName":"standard:opportunity","size":"x-small","extraclass":"slds-icon_container slds-icon-standard-opportunity ","variant":"inverse","imgsrc":"","data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-28","field":"TipoCliente","operator":"==","value":"Cuenta de Negocio","type":"custom"}]}},"type":"element","styleObject":{"size":{"isResponsive":false,"default":"1"},"sizeClass":"slds-size_1-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"center","color":""},"inlineStyle":"","class":"slds-text-align_center ","style":"             "},"elementLabel":"Icon-14"},{"name":"Text","element":"outputField","size":{"isResponsive":false,"default":"11"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","mergeField":"%3Cdiv%3E%3Cspan%20style=%22font-size:%2010pt;%22%3E%7BCountOpp%7D%3C/span%3E%3C/div%3E","card":"{card}","data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-53","field":"TipoCliente","operator":"==","value":"Cuenta de Negocio","type":"custom"}]}},"type":"text","styleObject":{"size":{"isResponsive":false,"default":"11"},"sizeClass":"slds-size_11-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"             "},"elementLabel":"Text-15"},{"name":"Icon","element":"flexIcon","size":{"isResponsive":false,"default":"1"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","iconType":"Salesforce SVG","iconName":"standard:contact_list","size":"x-small","extraclass":"slds-icon_container slds-icon-standard-contact-list ","variant":"inverse","imgsrc":"","data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-127","field":"TipoCliente","operator":"==","value":"Cuenta de Negocio","type":"custom"}]}},"type":"element","styleObject":{"size":{"isResponsive":false,"default":"1"},"sizeClass":"slds-size_1-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"center","color":""},"inlineStyle":"","class":"slds-text-align_center ","style":"             "},"elementLabel":"Icon-16"},{"name":"Text","element":"outputField","size":{"isResponsive":false,"default":"11"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","mergeField":"%3Cdiv%3E%3Cspan%20style=%22font-size:%2010pt;%22%3E%7BCountCase%7D%3C/span%3E%3C/div%3E","card":"{card}","data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-152","field":"TipoCliente","operator":"==","value":"Cuenta de Negocio","type":"custom"}]}},"type":"text","styleObject":{"size":{"isResponsive":false,"default":"11"},"sizeClass":"slds-size_11-of-12 "},"elementLabel":"Text-17"},{"name":"Icon","element":"flexIcon","size":{"isResponsive":false,"default":"1"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","iconType":"Salesforce SVG","iconName":"custom:custom17","size":"x-small","extraclass":"slds-icon_container slds-icon-custom-custom17 ","variant":"inverse","imgsrc":"","data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-226","field":"TipoCliente","operator":"==","value":"Cuenta de Negocio","type":"custom"}]}},"type":"element","styleObject":{"size":{"isResponsive":false,"default":"1"},"sizeClass":"slds-size_1-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"center","color":""},"inlineStyle":"","class":"slds-text-align_center ","style":"             "},"elementLabel":"Icon-18"},{"name":"Text","element":"outputField","size":{"isResponsive":false,"default":"11"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","mergeField":"%3Cdiv%3E%7BCountTask%7D%3C/div%3E","card":"{card}","data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-243","field":"TipoCliente","operator":"==","value":"Cuenta de Negocio","type":"custom"}]}},"type":"text","styleObject":{"size":{"isResponsive":false,"default":"11"},"sizeClass":"slds-size_11-of-12 "},"elementLabel":"Text-19"}]}},"childCards":[],"actions":[],"omniscripts":[]}],"dataSource":{"type":"IntegrationProcedures","value":{"resultVar":"[\"AccountLeffSidebar360VW\"]","ipMethod":"OSFMX_GetAccountLeffSidebar360VW","vlocityAsync":false,"inputMap":{"AccountId":"{recordId}"}},"orderBy":{"name":"","isReverse":false},"contextVariables":[{"name":"recordId","val":"001c0000038mVzCAAU","id":1}]},"title":"OSFMXAccountLeffSidebarVW360","enableLwc":true,"isFlex":true,"theme":"slds","lwc":{"DeveloperName":"cfOSFMXAccountLeffSidebarVW360_1_GlobantRRA","Id":"0Rbc0000000DFMrCAO","MasterLabel":"cfOSFMXAccountLeffSidebarVW360_1_GlobantRRA","NamespacePrefix":"c"},"Id":"a5Jc0000000I3E1EAK","GlobalKey__c":"OSFMXAccountLeffSidebarVW360/GlobantRRA/1/1619062847896","IsChildCard__c":false};
  export default definition