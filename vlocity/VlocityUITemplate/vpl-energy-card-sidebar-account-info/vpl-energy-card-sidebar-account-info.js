vlocity.cardframework.registerModule.controller('sidebarAccountCtrl', ['$scope', '$rootScope', 'timeStampInSeconds','actionService', 'pageService', '$localizable', 'performAction', '$log', function($scope, $rootScope, timeStampInSeconds, actionService, pageService, $localizable, performAction, $log) {
    if($scope.obj.%vlocity_namespace%__CalculatedAddress__c !='undefined' || $scope.obj.%vlocity_namespace%__CalculatedAddress__c !='null' ){
        $scope.obj.%vlocity_namespace%__CalculatedAddress__c=$scope.obj.%vlocity_namespace%__CalculatedAddress__c.replace('<br>', ' ');
    }
}]);