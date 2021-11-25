vlocity.cardframework.registerModule.controller('vlocityAssistantActionsCtrl', ['$scope', '$rootScope', 'timeStampInSeconds','actionService', 'pageService', '$localizable', 'performAction', '$log', function($scope, $rootScope, timeStampInSeconds, actionService, pageService, $localizable, performAction, $log) {
    // alert("hey");
    // console.log("data", $scope.obj);
    // debugger;
    // var assistantLayoutNameListener = $scope.$on("layoutName", function(event, data) {
    //     // console.log('received products-main-update, broadcasting down now');
    //     //broadcast event down to products layout
    //     console.log("Layout Name:", data);

    // });
    //     debugger;

    // $scope.$on("$destroy", function() {
    //     if(assistantLayoutNameListener) assistantLayoutNameListener(); 
    // });
    $scope.showCard = ($scope.session.Tab != undefined && $scope.session.Tab == $rootScope.sVars.Tab) || ($scope.session.Type != undefined && $scope.session.Type == $scope.params.type);
}]);