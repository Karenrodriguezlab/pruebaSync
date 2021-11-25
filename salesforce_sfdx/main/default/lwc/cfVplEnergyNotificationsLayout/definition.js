let definition = 
                {"Cards":["vplEnergyNotificationsCard"],"GlobalKey__c":"vplEnergyNotificationsLayout/1/Accenture India/1594891605237","componentName":"cfVplEnergyNotificationsLayout","dataSource":{"contextVariables":[{"name":"params.id","val":"0015Y00002ZPdL5AAL"}],"type":"IntegrationProcedures","value":{"body":"{\n\t\"Bill Notification\":\"Email\",\n\t\"Payment Reminders and Notifications\":\"Phone\",\n\t\"Outage Notifications\":\"Text\",\n\t\"Offers and Promotions\":\"Do Not Contact\",\n\t\"Work Order Notifications\":\"Phone\",\n\t\"DNDTime\":\"10:02 AM - 05:48 PM\",\n\"NotifPreferenceExists\": \"true\"\n}","inputMap":{"Id":"{{params.id}}"},"ipMethod":"VPL_GetAccountNotificationPrefDetails","optionsMap":{"vlcClass":"vlocity_cmt.IntegrationProcedureService"},"resultVar":"['AccountNotificationPreference']"}},"enableLwc":true,"lwc":{"DeveloperName":"veeEnergyCardCanvas1x","Id":"0Rb5Y000000kUXbCAC","MasterLabel":"veeEnergyCardCanvas1xLWC","name":"veeEnergyCardCanvas1x"},"previewType":"runTime","repeatCards":false,"sessionVars":[],"workspace":["vplEnergyNotificationsCard/Accenture India/1/1594891657697"],"xmlObject":{"apiVersion":46,"isExplicitImport":false,"isExposed":true,"masterLabel":"vplEnergyNotificationsLayout-v1","runtimeNamespace":"vlocity_cmt","targetConfig":[{"objects":[],"property":[{"name":"debug","value":{"name":"debug","selectedProp":"debug","type":"Boolean"}},{"name":"recordId","value":{"name":"recordId","selectedProp":"recordId","type":"String"}}],"target":"lightning__AppPage"},{"objects":[],"property":[{"name":"debug","value":{"name":"debug","selectedProp":"debug","type":"Boolean"}},{"name":"theme","value":{"name":"theme","selectedProp":"name","type":"String"}}],"target":"lightning__RecordPage"}],"targetConfigs":"CiAgICAgICAgICAgICAgICAgICAgICA8dGFyZ2V0Q29uZmlnIHRhcmdldHM9ImxpZ2h0bmluZ19fQXBwUGFnZSI+CiAgICAgICAgICAgICAgICAgICAgICA8cHJvcGVydHkgbmFtZT0iZGVidWciIHR5cGU9IkJvb2xlYW4iICAvPgogICAgICAgICAgICAgICAgICAgICAgICA8cHJvcGVydHkgbmFtZT0icmVjb3JkSWQiIHR5cGU9IlN0cmluZyIgIC8+CiAgICAgICAgICAgICAgICAgICAgICAgIDwvdGFyZ2V0Q29uZmlnPgogICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgPHRhcmdldENvbmZpZyB0YXJnZXRzPSJsaWdodG5pbmdfX1JlY29yZFBhZ2UiPgogICAgICAgICAgICAgICAgICAgICAgPHByb3BlcnR5IG5hbWU9ImRlYnVnIiB0eXBlPSJCb29sZWFuIiAgLz4KICAgICAgICAgICAgICAgICAgICAgICAgPHByb3BlcnR5IG5hbWU9InRoZW1lIiB0eXBlPSJTdHJpbmciICAvPgogICAgICAgICAgICAgICAgICAgICAgICA8L3RhcmdldENvbmZpZz4KICAgICAgICAgICAgICAgICAgICA=","targets":[{"name":"RecordPage","target":"lightning__RecordPage"},{"name":"AppPage","target":"lightning__AppPage"},{"name":"HomePage","target":"lightning__HomePage"}]}}; 
            export default definition