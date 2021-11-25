vlocity.cardframework.registerModule.controller('canvasAssistantCtrl', ['$scope', '$rootScope', 'timeStampInSeconds','actionService', 'pageService', '$localizable', 'performAction', '$log','$timeout', function($scope, $rootScope, timeStampInSeconds, actionService, pageService, $localizable, performAction, $log, $timeout) {
    $rootScope.sVars = $scope.session;

    // if($scope.data.sessionVars[0].val) {
    //     $scope.tabData = {"Tab":$scope.data.sessionVars[0].val};
    // }
    
    function getUrlVars() {
        var vars = {};
        var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
            vars[key] = value;
        });
        return vars;
    }       

    // $scope.OSType = getUrlVars()["type"];
    // if($scope.OSType) {
    //     if($scope.OSType.includes("+")){$scope.OSType = {"Type": getUrlVars()["type"].split("+").join(" ")};}
    // }

    // if($scope.data.sessionVars[0].val == "OmniScript"){
    //     $scope.tabData = $scope.OSType;
    // }


}]);