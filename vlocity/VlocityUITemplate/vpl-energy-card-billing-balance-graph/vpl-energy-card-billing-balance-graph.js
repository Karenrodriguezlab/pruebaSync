vlocity.cardframework.registerModule.controller('billingGraphCtrl', ['$scope','$timeout',  function($scope, $timeout) {

  // ------------------------------------------------------------------------------
    // draws a rectangle with a rounded top
    Chart.helpers.drawRoundedTopRectangle = function(ctx, x, y, width, height, radius) {
      ctx.beginPath();
      ctx.moveTo(x + radius, y);
      // top right corner
      ctx.lineTo(x + width - radius, y);
      ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
      // bottom right	corner
      ctx.lineTo(x + width, y + height);
      // bottom left corner
      ctx.lineTo(x, y + height);
      // top left	
      ctx.lineTo(x, y + radius);
      ctx.quadraticCurveTo(x, y, x + radius, y);
      ctx.closePath();
    };

    Chart.elements.RoundedTopRectangle = Chart.elements.Rectangle.extend({
      draw: function() {
        var ctx = this._chart.ctx;
        var vm = this._view;
        var left, right, top, bottom, signX, signY, borderSkipped;
        var borderWidth = vm.borderWidth;

        if (!vm.horizontal) {
          // bar
          left = vm.x - vm.width / 2;
          right = vm.x + vm.width / 2;
          top = vm.y;
          bottom = vm.base;
          signX = 1;
          signY = bottom > top? 1: -1;
          borderSkipped = vm.borderSkipped || 'bottom';
        } else {
          // horizontal bar
          left = vm.base;
          right = vm.x;
          top = vm.y - vm.height / 2;
          bottom = vm.y + vm.height / 2;
          signX = right > left? 1: -1;
          signY = 1;
          borderSkipped = vm.borderSkipped || 'left';
        }

        // Canvas doesn't allow us to stroke inside the width so we can
        // adjust the sizes to fit if we're setting a stroke on the line
        if (borderWidth) {
          // borderWidth shold be less than bar width and bar height.
          var barSize = Math.min(Math.abs(left - right), Math.abs(top - bottom));
          borderWidth = borderWidth > barSize? barSize: borderWidth;
          var halfStroke = borderWidth / 2;
          // Adjust borderWidth when bar top position is near vm.base(zero).
          var borderLeft = left + (borderSkipped !== 'left'? halfStroke * signX: 0);
          var borderRight = right + (borderSkipped !== 'right'? -halfStroke * signX: 0);
          var borderTop = top + (borderSkipped !== 'top'? halfStroke * signY: 0);
          var borderBottom = bottom + (borderSkipped !== 'bottom'? -halfStroke * signY: 0);
          // not become a vertical line?
          if (borderLeft !== borderRight) {
            top = borderTop;
            bottom = borderBottom;
          }
          // not become a horizontal line?
          if (borderTop !== borderBottom) {
            left = borderLeft;
            right = borderRight;
          }
        }

        // calculate the bar width and roundess
        var barWidth = Math.abs(left - right);
        var roundness = this._chart.config.options.barRoundness || 0.5;
        var radius = barWidth * roundness * 0.5;
        
        // keep track of the original top of the bar
        var prevTop = top;
        
        // move the top down so there is room to draw the rounded top
        top = prevTop + radius;
        var barRadius = top - prevTop;

        ctx.beginPath();
        ctx.fillStyle = vm.backgroundColor;
        ctx.strokeStyle = vm.borderColor;
        ctx.lineWidth = borderWidth;

        // draw the rounded top rectangle
        Chart.helpers.drawRoundedTopRectangle(ctx, left, (top - barRadius + 1), barWidth, bottom - prevTop, barRadius);

        ctx.fill();
        if (borderWidth) {
          ctx.stroke();
        }
        // restore the original top value so tooltips and scales still work
        top = prevTop;
      },
    });

    Chart.defaults.roundedBar = Chart.helpers.clone(Chart.defaults.bar);

    Chart.controllers.roundedBar = Chart.controllers.bar.extend({
      dataElementType: Chart.elements.RoundedTopRectangle
    });  

  // ------------------------------------------------------------------------------


    var labels = [];
    var data = [];
    angular.forEach($scope.obj.Statement, function(value, key) {
      this.push(value.GraphCurrentBalance);   
    }, data);

    angular.forEach($scope.obj.Statement, function(value, key) {
      this.push(value.StartDate);
    }, labels);


  // ------------------------------------------------------------------------------

    //Setup Bar Chart with options
    var ctx = document.getElementById("myChart").getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'roundedBar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Cargos',
                data: data,
                backgroundColor: 'rgba(211, 211, 211)',
                borderColor: 'rgba(211, 211, 211)',
                borderWidth: 1,
                hoverBackgroundColor: "rgba(19, 126, 235)",
                hoverBorderColor: "rgba(19, 126, 235)"         
            }]
        },
        options: {
          "hover": {
            "animationDuration": 0
          },
          "animation": {
            "duration": 1,
            "onComplete": function() {
              var chartInstance = this.chart,
                ctx = chartInstance.ctx;

              ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, Chart.defaults.global.defaultFontStyle, Chart.defaults.global.defaultFontFamily);
              ctx.textAlign = 'center';
              ctx.textBaseline = 'bottom';

              this.data.datasets.forEach(function(dataset, i) {
                var meta = chartInstance.controller.getDatasetMeta(i);
                meta.data.forEach(function(bar, index) {
                  var data = "$" + dataset.data[index];
                  ctx.fillText(data, bar._model.x, bar._model.y - 5);
                });
              });
            }
          }, 
          barRoundness: .2,         
        //   responsive: false,
          tooltips: {
            "enabled": false
          },
          scales: {
              yAxes: [{
                  stacked: true,
                  gridLines: {
                      display: true,
                      drawBorder: false,
                      lineWidth: 2,
                      color:"rgba(220,220,220, .2)"
                  },
                  ticks: {
                      beginAtZero:true,
                      display: false
                  }
              }],
              xAxes: [{
                  gridLines: {
                    display: false
                  },
                  maxBarThickness: 150         
              }]
          }
        }
    });

  
}]);