vlocity.cardframework.registerModule.controller('itemController', ['$scope','$rootScope', function($scope, $rootScope) {
    $scope.itemsLimit  = $scope.session.initItemsShown || 2;
    $scope.itemsShown = $scope.itemsLimit;
    if($scope.obj.items.length > $scope.itemsLimit) $scope.hasMore = true;

    $scope.showHideTips = function() {
        $scope.itemsShown = $scope.itemsShown == $scope.itemsLimit ? $scope.obj.items.length : $scope.itemsLimit;
    }

    $scope.showCard = $scope.session.Tab == $rootScope.sVars.Tab;
}]);