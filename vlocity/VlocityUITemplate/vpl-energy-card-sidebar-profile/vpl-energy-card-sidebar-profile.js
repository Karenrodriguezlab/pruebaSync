vlocity.cardframework.registerModule
    .controller('viaLeftProfileController',
                ['$scope', '$rootScope', 'timeStampInSeconds','actionService', 'pageService', '$localizable', 'performAction', '$log','$timeout', '$http', function($scope, $rootScope, timeStampInSeconds, actionService, pageService, $localizable, performAction, $log, $timeout, $http) {
        var self = this;

        self.getPhotoUrl = function(obj) {
            if (obj.PhotoUrl) {
                if ($rootScope.instanceUrl) {
                    return $rootScope.instanceUrl + obj.PhotoUrl;
                } else {
                    return obj.PhotoUrl;
                }
            }
        };

        self.getSentiment = function(obj) {
            var nsPrefix = window.nsPrefix || window.ns || localStorage.getItem('nsPrefixDotNotation').replace('.', '__');
            if (nsPrefix) {
                if (nsPrefix.length > 1 && !/__$/.test(nsPrefix)) {
                    nsPrefix += '__';
                }
                if (obj[nsPrefix + 'CustomerValue__c']) {
                    return obj[nsPrefix + 'CustomerValue__c'].toLowerCase();
                } else if (obj[nsPrefix + 'CustomerSentiment__c']) {
                    return obj[nsPrefix + 'CustomerSentiment__c'].toLowerCase();
                }
            }
            // hide by default
            return 'ng-hide';
        };
    //console.log('billing address',$scope.obj.billingAddress)
    $scope.miles = .09;
    console.log('%vlocity_namespace%__CalculatedAddress__c address',$scope.obj.%vlocity_namespace%__CalculatedAddress__c)
    if($scope.obj.%vlocity_namespace%__CalculatedAddress__c !='undefined' || $scope.obj.%vlocity_namespace%__CalculatedAddress__c !='null' ){
        $scope.obj.%vlocity_namespace%__CalculatedAddress__c=$scope.obj.%vlocity_namespace%__CalculatedAddress__c.replace('<br>', ' ');
    }
    $scope.address = $scope.obj.%vlocity_namespace%__CalculatedAddress__c;
    console.log("address",$scope.obj);
    console.log("address",$scope.address);
    console.log("extra ",$scope.obj);
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
            console.log(centerPosition);
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
                center: centerPosition//,
                //radius: ($scope.miles * 1609.34)
            });
        
        }
    }); //*/   

    

    }]);