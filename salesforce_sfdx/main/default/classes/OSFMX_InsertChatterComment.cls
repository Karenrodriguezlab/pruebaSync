global with sharing class OSFMX_InsertChatterComment implements vlocity_cmt.VlocityOpenInterface {
    public Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;
        try {
            switch on methodName
            {
                when 'SendPost' {
                    SendPost(inputMap, outMap, options);
                } 
            }
            result = false;
        } catch(Exception e) {
            System.debug('OSFMX_InsertChatterComment:invokeMethod -> exception: ' + e.getLineNumber());
            throw e;
        }
        return result;
    }
    public void SendPost(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            Id QuoteId = (Id) options.get('QuoteId');
            Id UserId = (Id) options.get('UserId');            
            String body = (String) options.get('Comentarios');
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();           
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            mentionSegmentInput.id = UserId;
            messageBodyInput.messageSegments.add(mentionSegmentInput);            
            
            textSegmentInput.text = ' ' + body;
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = QuoteId;
            
            if (!Test.isRunningTest()){
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            }
            
        }
        catch(Exception ex) {
            System.debug('InsertComment - ex: ' + ex);
            throw ex;
        }
    }

}