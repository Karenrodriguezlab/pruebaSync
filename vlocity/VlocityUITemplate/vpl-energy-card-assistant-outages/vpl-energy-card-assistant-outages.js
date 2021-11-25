vlocity.cardframework.registerModule.controller('outagesAssistantCtrl', ['$scope', '$rootScope', 'timeStampInSeconds','actionService', 'pageService', '$localizable', 'performAction', '$log','$timeout', function($scope, $rootScope, timeStampInSeconds, actionService, pageService, $localizable, performAction, $log, $timeout) {
    $scope.showCard = $scope.session.Tab == $rootScope.sVars.Tab;


    $scope.miles = $scope.obj.miles;
    $scope.address = $scope.obj.address;
    
    console.log("address",$scope.address);
    console.log("google",google);
    
    var geocoder = new google.maps.Geocoder();
    var lat;
    var lng;
    
    

    geocoder.geocode( { "address": $scope.address }, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK && results.length > 0) {
            var location = results[0].geometry.location,
                lat      = location.lat(),
                lng      = location.lng();

            var map;
            var centerPosition = new google.maps.LatLng(lat,lng);
            var options = {
                 'scrollwheel': true,
                'center': centerPosition,
                'zoom': 15,
                'disableDefaultUI': true,
            };

            map = new google.maps.Map(document.getElementById('map-canvas'), options);

            var circle = new google.maps.Circle({
                strokeColor: '#fbd2d2',
                strokeOpacity: 0.7,
                strokeWeight: 2,
                fillColor: '#fbd2d2',
                fillOpacity: 0.7,
                map: map,
                center: centerPosition,
                radius: ($scope.miles * 1609.34)
            });
        
        }
    });    

    
}]);