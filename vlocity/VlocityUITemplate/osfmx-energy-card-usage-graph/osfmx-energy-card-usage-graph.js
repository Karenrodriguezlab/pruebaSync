vlocity.cardframework.registerModule.controller('usageGraphCtrl', ['$scope', '$timeout', '$filter', function($scope, $timeout, $filter) {
    //Ordenar Ascendente Por Fecha 
    $scope.obj.consumos.sort((a, b) => 0 - (new Date(a.fecha_consumo_hasta) > new Date(b.fecha_consumo_hasta) ? -1 : 1));

    //$scope.cycleDate = "Dec 1 - Dec 31";
    $scope.switchUsage = true;
    /*$scope.cycleDate = $filter('date')(new Date($scope.obj.consumo[i].Date),'dd MMM')
        +' - '+$filter('date')(new Date($scope.obj.data[$scope.obj.data.length-1].Date),'dd MMM');*/
    $scope.cycleDate = "Ene 2019 - Dic 2019"; //Agregar lógica para obtener fecha mayor y menor

    console.log("* data retrieved by energy usage graph card layout *");
    console.log($scope.obj);

    // ------------------------------------------------------------------------------
    // draws a rectangle with a rounded top
    Chart.helpers.drawRoundedTopRectangle = function(ctx, x, y, width, height, radius) {
        ctx.beginPath();
        ctx.moveTo(x + radius, y);
        // top right corner
        ctx.lineTo(x + width - radius, y);
        ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
        // bottom right   corner
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
                signY = bottom > top ? 1 : -1;
                borderSkipped = vm.borderSkipped || 'bottom';
            } else {
                // horizontal bar
                left = vm.base;
                right = vm.x;
                top = vm.y - vm.height / 2;
                bottom = vm.y + vm.height / 2;
                signX = right > left ? 1 : -1;
                signY = 1;
                borderSkipped = vm.borderSkipped || 'left';
            }

            // Canvas doesn't allow us to stroke inside the width so we can
            // adjust the sizes to fit if we're setting a stroke on the line
            if (borderWidth) {
                // borderWidth shold be less than bar width and bar height.
                var barSize = Math.min(Math.abs(left - right), Math.abs(top - bottom));
                borderWidth = borderWidth > barSize ? barSize : borderWidth;
                var halfStroke = borderWidth / 2;
                // Adjust borderWidth when bar top position is near vm.base(zero).
                var borderLeft = left + (borderSkipped !== 'left' ? halfStroke * signX : 0);
                var borderRight = right + (borderSkipped !== 'right' ? -halfStroke * signX : 0);
                var borderTop = top + (borderSkipped !== 'top' ? halfStroke * signY : 0);
                var borderBottom = bottom + (borderSkipped !== 'bottom' ? -halfStroke * signY : 0);
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

    //Pull data from datasource and set individually
    var dates = [];
    var kWh = [];
    var kWhCost = [];
    var therms = [];
    var thermsCost = [];
    var temp = [];
    var MonthDay = [];
    var months = [];
    var years = [];
    var vm = this; // Prueba
    $scope.states = [];
    $scope.p_suministros = [];
    $scope.s_engies = [];
    $scope.t_solutions = [];
    $scope.periods = [];
    var summTherms = [];
    var sumMonthDay = [];


    for (i = 0; i < $scope.obj.consumos.length; i++) {
        dates.push($scope.obj.consumos[i].fecha_consumo_hasta);
        //kWh.push($scope.obj.consumos[i].kWh);
        //kWhCost.push($scope.obj.consumos[i].kwhcost);
        //therms.push($scope.obj.consumos[i].therms);
        //therms.push($scope.obj.consumos[i].consumo_facturado_gj);
        //thermsCost.push($scope.obj.consumos[i].thermsCost);
        //temp.push($scope.obj.consumos[i].temp);
        months.push($scope.obj.consumos[i].mes);
        years.push($scope.obj.consumos[i].anio);
        let index = $scope.states.findIndex(record => record === $scope.obj.consumos[i].estado_desc);
        console.log("INDEXX::: ", index);
        if (index < 0) {
            $scope.states.push($scope.obj.consumos[i].estado_desc);
        }
        //Inicia Filtro Punto de Suministro
        let indexPS = $scope.p_suministros.findIndex(record => record === $scope.obj.consumos[i].nombre_suministro);
        console.log("INDEXX P SUMINISTRO::: ", indexPS);
        if (indexPS < 0) {
            $scope.p_suministros.push($scope.obj.consumos[i].nombre_suministro);
        }
        //Finaliza Filtro Punto de Suministro

        //Inicia Filtro solucion Engie
        let indexSE = $scope.s_engies.findIndex(record => record === $scope.obj.consumos[i].sociedad_desc);
        console.log("INDEXX S ENGIE::: ", indexSE);
        if (indexSE < 0) {
            $scope.s_engies.push($scope.obj.consumos[i].sociedad_desc);
        }
        //Finaliza Filtro solucion Engie

        //Inicia Filtro tipo de solucion
        let indexTS = $scope.t_solutions.findIndex(record => record === $scope.obj.consumos[i].tipo_cliente_desc);
        console.log("INDEXX T SOLUTION::: ", indexTS);
        if (indexTS < 0) {
            $scope.t_solutions.push($scope.obj.consumos[i].tipo_cliente_desc);
        }
        //Finaliza Filtro tipo de solucion

        //Inicia Filtro Periodo
        let PeriodString = $scope.obj.consumos[i].mes + '-' + $scope.obj.consumos[i].anio;
        let indexP = $scope.periods.findIndex(record => record === PeriodString);
        console.log("INDEXX PERIOD::: ", indexP);
        if (indexP < 0) {
            $scope.periods.push(PeriodString);
        }
        //Finaliza Filtro Periodo

        //INICIO Sumar Meses
        if (indexP < 0) {
            MonthDay.push($scope.obj.consumos[i].mes + ' ' + $scope.obj.consumos[i].anio);
            therms.push($scope.obj.consumos[i].consumo_facturado_gj);
        } else {
            therms[indexP] = therms[indexP] + $scope.obj.consumos[i].consumo_facturado_gj;
        }
        //FIN Sumar Meses
    }
    //grab only month and day for date
    /*for (j = 0; j < dates.length; j++) {
        //MonthDay.push(dates[j].slice(0, -5));
        MonthDay.push(months[j] + ' ' + years[j]);
    }*/

    //Build a mixed chart (bar and line) for electricity usage
    /*REACTIVAR PARA ELECTRICIDAD var ctx = document.getElementById("electrictyUsageChart").getContext('2d');

    var mixedChart = new Chart(ctx, {
    type: 'roundedBar',
    data: {
        datasets: [{
            // Changes this dataset to become a line
            yAxisID: 'A',
            type: 'line',
            label: 'Temperature',
            data: temp,
            //data: [0, 1, 2, 3, 4, 5, 6, 7],
            backgroundColor: "rgb(255, 255, 255, .0)",
            borderWidth: 3,
            borderColor: "rgb(244, 200, 105)",
            pointRadius: 0
        },{
            yAxisID: 'B',
            label: 'Energy use',
            data: kWh,
            borderWidth: 1,  
            backgroundColor: 'rgba(19, 126, 235, .6)',
            borderColor: 'rgba(19, 126, 235, .6)',
            borderWidth: 1,
            hoverBackgroundColor: "rgba(19, 126, 235)",
            hoverBorderColor: "rgba(19, 126, 235)"                         
            }],
        labels: MonthDay
    },
     options: {
        legend: {
            position: 'bottom',
            labels: {
                boxWidth: 15
            }
        },
        tooltips: {
            mode: 'index',
            caretSize: 0
        },    
        scales: {
            //display a left and right Y Axes
            yAxes: [{
                id: 'A',
                type: 'linear',
                position: 'right',
                scaleLabel: {
                    display: true,
                    labelString: 'Temperature'
                },
                gridLines: {
                    display: true,
                    drawBorder: false,
                    lineWidth: 2,
                    color:"rgba(220,220,220, .2)"
                }
                },{
                id: 'B',
                scaleLabel: {
                    display: true,
                    labelString: 'kWh'
                },
                ticks: {
                    // Include a dollar sign in the ticks
                    callback: function(value, index, values) {
                        return value
                    }
                },                       
                stacked: true,
                gridLines: {
                    display: true,
                    drawBorder: false,
                    lineWidth: 2,
                    color:"rgba(220,220,220, .2)"
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
    });*/

    // Custom Code For Change State
    $scope.onChangeState = function() {
        $scope.refreshGraph();
        // Custom Code For Point supply
    }
    $scope.onChangePSuministro = function() {
            $scope.refreshGraphPSum();
        }
        // Custom Code For Engie Solution
    $scope.onChangeSEngie = function() {
            $scope.refreshGraphSEng();
        }
        // Custom Code For type Solution
    $scope.onChangeTypeSolution = function() {
            $scope.refreshGraphTSolu();
        }
        // Custom Code For type period
    $scope.onChangePeriod = function() {
        $scope.refreshGraphPeriod();
    }

    //prueba
    $scope.refreshGraph = function() {
        temp = [];
        therms = [];
        MonthDay = [];
        let months = [];
        let years = [];
        for (i = 0; i < $scope.obj.consumos.length; i++) {
            if ($scope.obj.consumos[i].estado_desc == $scope.stateValue) {
                //temp.push($scope.obj.data[i].temp);
                //therms.push($scope.obj.consumos[i].consumo_facturado_gj);
                //months.push($scope.obj.consumos[i].mes);
                //years.push($scope.obj.consumos[i].anio);
                $scope.summarizeConsumption(i, $scope.obj.consumos, therms);
            }
        }
        /*for (j = 0; j < months.length; j++) {
            //MonthDay.push(dates[j].slice(0, -5));
            MonthDay.push(months[j] + ' ' + years[j]);
        }*/
        //$scope.setUsageGraph(5);
        //$scope.showStateValidation = true;
        $scope.buildGasUsageChart(temp, therms);
    }

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>> INICIO Gráfica Inicial
    var ctx = document.getElementById("gasUsageChart").getContext('2d');

    var mixedChart = new Chart(ctx, {
        type: 'roundedBar',
        data: {
            datasets: [
                /*{
                                yAxisID: 'A',
                                // Changes this dataset to become a line
                                type: 'line',
                                label: 'Temperature',
                                data: temp,
                                backgroundColor: "rgb(255, 255, 255, .0)",
                                borderWidth: 3,
                                borderColor: "rgb(244, 200, 105)",
                                pointRadius: 0
                                },*/
                {
                    yAxisID: 'B',
                    label: 'Consumo de Gas',
                    data: therms,
                    borderWidth: 1,
                    backgroundColor: 'rgba(19, 126, 235, .6)',
                    borderColor: 'rgba(19, 126, 235, .6)',
                    borderWidth: 1,
                    hoverBackgroundColor: "rgba(19, 126, 235)",
                    hoverBorderColor: "rgba(19, 126, 235)"
                }
            ],
            labels: MonthDay
        },
        options: {
            legend: {
                position: 'bottom',
                labels: {
                    boxWidth: 15
                }
            },
            tooltips: {
                mode: 'index',
                caretSize: 0,
                callbacks: {
                    label: function(tooltipItem, data) {
                        var label = data.datasets[tooltipItem.datasetIndex].label || '';

                        if (label) {
                            label += ': ';
                        }
                        label += Math.round(tooltipItem.yLabel * 100) / 100;

                        if (tooltipItem.datasetIndex === 0) {
                            label += " GJ";
                        }
                        return label;
                    }
                }
            },
            scales: {
                //display a left and right Y Axes
                yAxes: [
                    /*{
                                        id: 'A',
                                        type: 'linear',
                                        position: 'right',
                                        scaleLabel: {
                                            display: true,
                                            labelString: 'Temperature'
                                        },
                                        gridLines: {
                                            display: true,
                                            drawBorder: false,
                                            lineWidth: 2,
                                            color:"rgba(220,220,220, .2)"
                                        }
                                    },*/
                    {
                        id: 'B',
                        scaleLabel: {
                            display: true,
                            labelString: 'Gigajoules'
                        },
                        ticks: {
                            // Include a dollar sign in the ticks
                            callback: function(value, index, values) {
                                return value
                            }
                        },
                        stacked: true,
                        gridLines: {
                            display: true,
                            drawBorder: false,
                            lineWidth: 2,
                            color: "rgba(220,220,220, .2)"
                        }
                    }
                ],
                xAxes: [{
                    gridLines: {
                        display: false
                    },
                    maxBarThickness: 150
                }]
            }
        }
    });
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>> FIN Gráfica Inicial

    $scope.refreshGraphPSum = function() {
        therms = [];
        MonthDay = [];
        let months = [];
        let years = [];
        for (i = 0; i < $scope.obj.consumos.length; i++) {
            if ($scope.obj.consumos[i].nombre_suministro == $scope.stateValue) {
                //temp.push($scope.obj.data[i].temp);
                /*therms.push($scope.obj.consumos[i].consumo_facturado_gj);
                months.push($scope.obj.consumos[i].mes);
                years.push($scope.obj.consumos[i].anio);*/
                $scope.summarizeConsumption(i, $scope.obj.consumos, therms);
            }
        }
        for (j = 0; j < months.length; j++) {
            //MonthDay.push(dates[j].slice(0, -5));
            MonthDay.push(months[j] + ' ' + years[j]);
        }
        //$scope.setUsageGraph(5);
        //$scope.showStateValidation = true;
        $scope.buildGasUsageChart(temp, therms);
    }

    $scope.refreshGraphSEng = function() {
        therms = [];
        MonthDay = [];
        let months = [];
        let years = [];
        for (i = 0; i < $scope.obj.consumos.length; i++) {
            if ($scope.obj.consumos[i].sociedad_desc == $scope.stateValue) {
                //temp.push($scope.obj.data[i].temp);
                /*therms.push($scope.obj.consumos[i].consumo_facturado_gj);
                months.push($scope.obj.consumos[i].mes);
                years.push($scope.obj.consumos[i].anio);*/
                $scope.summarizeConsumption(i, $scope.obj.consumos, therms);
            }
        }
        for (j = 0; j < months.length; j++) {
            //MonthDay.push(dates[j].slice(0, -5));
            MonthDay.push(months[j] + ' ' + years[j]);
        }
        //$scope.setUsageGraph(5);
        //$scope.showStateValidation = true;
        $scope.buildGasUsageChart(temp, therms);
    }


    $scope.refreshGraphTSolu = function() {
        therms = [];
        MonthDay = [];
        let months = [];
        let years = [];
        for (i = 0; i < $scope.obj.consumos.length; i++) {
            if ($scope.obj.consumos[i].tipo_cliente_desc == $scope.stateValue) {
                //temp.push($scope.obj.data[i].temp);
                /*therms.push($scope.obj.consumos[i].consumo_facturado_gj);
                months.push($scope.obj.consumos[i].mes);
                years.push($scope.obj.consumos[i].anio);*/
                $scope.summarizeConsumption(i, $scope.obj.consumos, therms);
            }
        }
        for (j = 0; j < months.length; j++) {
            //MonthDay.push(dates[j].slice(0, -5));
            MonthDay.push(months[j] + ' ' + years[j]);
        }
        //$scope.setUsageGraph(5);
        //$scope.showStateValidation = true;
        $scope.buildGasUsageChart(temp, therms);
    }

    $scope.refreshGraphPeriod = function() {
        let splitted = $scope.stateValue.split("-", 2);
        therms = [];
        MonthDay = [];
        for (i = 0; i < $scope.obj.consumos.length; i++) {
            if ($scope.obj.consumos[i].mes == splitted[0] && $scope.obj.consumos[i].anio == splitted[1]) {
                //temp.push($scope.obj.data[i].temp);
                /*therms.push($scope.obj.consumos[i].consumo_facturado_gj);
                MonthDay.push(splitted[0] + ' ' + splitted[1]);*/
                $scope.summarizeConsumption(i, $scope.obj.consumos, therms);
            }
        }
        //$scope.setUsageGraph(5);
        //$scope.showStateValidation = true;
        $scope.buildGasUsageChart(temp, therms);
    }


    $scope.buildGasUsageChart = function(valuesTemp, valuesGas) {
        //Build a mixed chart (bar and line) for natural gas usage
        $('#gasUsageChart').remove(); // this is my <canvas> element
        $('#result-chart').append('<canvas id="gasUsageChart"><canvas>');
        var ctx = document.getElementById("gasUsageChart").getContext('2d');

        var mixedChart = new Chart(ctx, {
            type: 'roundedBar',
            data: {
                datasets: [
                    /*{
                                    yAxisID: 'A',
                                    // Changes this dataset to become a line
                                    type: 'line',
                                    label: 'Temperature',
                                    data: temp,
                                    backgroundColor: "rgb(255, 255, 255, .0)",
                                    borderWidth: 3,
                                    borderColor: "rgb(244, 200, 105)",
                                    pointRadius: 0
                                    },*/
                    {
                        yAxisID: 'B',
                        label: 'Consumo de Gas',
                        data: therms,
                        borderWidth: 1,
                        backgroundColor: 'rgba(19, 126, 235, .6)',
                        borderColor: 'rgba(19, 126, 235, .6)',
                        borderWidth: 1,
                        hoverBackgroundColor: "rgba(19, 126, 235)",
                        hoverBorderColor: "rgba(19, 126, 235)"
                    }
                ],
                labels: MonthDay
            },
            options: {
                legend: {
                    position: 'bottom',
                    labels: {
                        boxWidth: 15
                    }
                },
                tooltips: {
                    mode: 'index',
                    caretSize: 0,
                    callbacks: {
                        label: function(tooltipItem, data) {
                            var label = data.datasets[tooltipItem.datasetIndex].label || '';

                            if (label) {
                                label += ': ';
                            }
                            label += Math.round(tooltipItem.yLabel * 100) / 100;

                            if (tooltipItem.datasetIndex === 0) {
                                label += " GJ";
                            }
                            return label;
                        }
                    }
                },
                scales: {
                    //display a left and right Y Axes
                    yAxes: [
                        /*{
                                            id: 'A',
                                            type: 'linear',
                                            position: 'right',
                                            scaleLabel: {
                                                display: true,
                                                labelString: 'Temperature'
                                            },
                                            gridLines: {
                                                display: true,
                                                drawBorder: false,
                                                lineWidth: 2,
                                                color:"rgba(220,220,220, .2)"
                                            }
                                        },*/
                        {
                            id: 'B',
                            scaleLabel: {
                                display: true,
                                labelString: 'Gigajoules'
                            },
                            ticks: {
                                // Include a dollar sign in the ticks
                                callback: function(value, index, values) {
                                    return value
                                }
                            },
                            stacked: true,
                            gridLines: {
                                display: true,
                                drawBorder: false,
                                lineWidth: 2,
                                color: "rgba(220,220,220, .2)"
                            }
                        }
                    ],
                    xAxes: [{
                        gridLines: {
                            display: false
                        },
                        maxBarThickness: 150
                    }]
                }
            }
        });
    }

    $scope.summarizeConsumption = function(indexConsumo, consumosArray, thermsArray) {
        let PeriodString = consumosArray[i].mes + ' ' + consumosArray[i].anio;
        let indexP = MonthDay.findIndex(record => record === PeriodString);
        //INICIO Sumar Meses
        if (indexP < 0) {
            MonthDay.push(consumosArray[indexConsumo].mes + ' ' + consumosArray[indexConsumo].anio);
            thermsArray.push(consumosArray[indexConsumo].consumo_facturado_gj);
        } else {
            thermsArray[indexP] = thermsArray[indexP] + consumosArray[indexConsumo].consumo_facturado_gj;
        }
        //FIN Sumar Meses
    }

}]);