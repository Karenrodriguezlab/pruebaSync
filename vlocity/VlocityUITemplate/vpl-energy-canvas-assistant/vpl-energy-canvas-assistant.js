vlocity.cardframework.registerModule.controller('vlocityAssistantCtrl', ['$scope', '$rootScope', 'timeStampInSeconds','actionService', 'pageService', '$localizable', 'performAction', '$log','$timeout', function($scope, $rootScope, timeStampInSeconds, actionService, pageService, $localizable, performAction, $log, $timeout) {
    $scope.records = $scope.records || {};
    angular.extend($scope.records, $rootScope.sVars);
}]);