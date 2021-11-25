import { LightningElement, api, track } from "lwc";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
//import randomColor from "./randomColor";

const getRandomColor = () => {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
};

const hexToRgb =(hex) => {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
      r: parseInt(result[1], 16),
      g: parseInt(result[2], 16),
      b: parseInt(result[3], 16)
    } : null;
};

const paletaColores =  ["#417dc1", "#6891cb", "#607eac", "#a7bce0", "#6b7fa1", 
    "#a7bce0", "#737f96", "#c5d2eb", "#7b808c", "#c5d2eb", "#818181",  "#e2e8f5",
      "#ffffff", "#417dc1", "#39679e", "#31527c", "#283e5c", "#1e2b3e", "#141922",
       "#000000"];

export default class vlocitySampleChart extends LightningElement {
    error;
    chart;
    chartjsInitialized = false;

    _consumos;
  
    @api
    get consumos() {
      return this._consumos;
    }

    set consumos(val) {
      if (val) {
        this._consumos = val;
      }
    }
    
    renderedCallback() {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;
  
        let resourceUrl = "/resource/1609878335000";
  
        Promise.all([loadScript(this, resourceUrl + "/vlocity_cmt__chartjs")])
            .then(() => {
                this.initValues();
            })
            .catch((error) => {
                this.error = error;
            });
    }
  
    initValues() {

        this.consumos = JSON.parse(JSON.stringify(this._consumos));
        //Pull data from datasource and set individually
     
        var desConcept = [];
        var desConceptUnico = [];
        var periodoInicio = [];
        var periodoInicio2 = [];
        var importes = [];
        var datasetCompletos=[];

  
        for (let i = 0; i < this.consumos.length; i++) {
        /*  descripcion concepto y Fecha emision*/
            desConcept.push(this.consumos[i].DescripcionConcepto);
            periodoInicio.push(this.consumos[i].Periodo); 
        }
  
        periodoInicio2 = periodoInicio.filter((item, index) => {
            return periodoInicio.indexOf(item) === index;
        });
  
        desConceptUnico = desConcept.filter((item, index) => {
            return desConcept.indexOf(item) === index;
        });

        /*var paletaColores = randomColor(
            {   
                luminosity: 'light',
                count:desConceptUnico.length,
                format: 'rgba',
                alpha: 0.5
            }
            );
        console.log(paletaColores);*/

        for (let k = 0; k < desConceptUnico.length; k++) {
            importes.push([]);
        }
  
        for (let j = 0; j < periodoInicio2.length; j++) {
            //genero arreglo temporal con el periodo a unificar
            var arrayTemp = this.consumos.filter(function(item){
                return item.Periodo==periodoInicio2[j];
            });
            //recorro el periodo y busco cada concepto de factura
            for (let k = 0; k < desConceptUnico.length; k++) {
                var arrayConsumo = arrayTemp.filter((item)=>{
                    return item.DescripcionConcepto==desConceptUnico[k];
                });
                var valor=0;
                for (let i = 0; i < arrayConsumo.length; i++) 
                {
                    valor+=arrayConsumo[i].ImporteConcepto;
                }
                
                importes[k].push(valor);
            }
        }
  
        if (desConceptUnico.length>paletaColores.length){
            var extraColores = desConceptUnico.length-paletaColores.length;
            for (let x=0;x<=extraColores;x++){
                var colorNuevo = getRandomColor();
                paletaColores.push(colorNuevo);
            }
        }

        for (let k = 0; k < desConceptUnico.length; k++) {
            //var color = getRandomColor();
            var color = paletaColores[k];
            var colorrgb = hexToRgb(color);
            
            var dataTemp={
                label: desConceptUnico[k],
                data: importes[k],
                borderWidth: 1,
                backgroundColor: "rgba("+colorrgb.r+","+colorrgb.g+","+colorrgb.b+",0.6)",
                borderColor: "rgba(19, 126, 235, .6)",
                borderWidth: 1,
                hoverBackgroundColor: "rgba("+colorrgb.r+","+colorrgb.g+","+colorrgb.b+",0.8)",
                hoverBorderColor: "rgba(19, 126, 235)"
            }
            datasetCompletos.push(dataTemp);
        }
    /*    this.initChart(therms, MonthDay);*/
    this.initChart(
        periodoInicio2,
        datasetCompletos
      );
    }
  
    initChart(periodoInicio2,datasetCompletos) {
        this.lineChart = {
            type: "bar",
            data: {
                datasets: datasetCompletos,
                labels: periodoInicio2
            },
            options: {
                legend: {
                    position: "bottom",
                    labels: {
                        boxWidth: 15
                    }
                },
                tooltips: {
                    mode: "index",
                    caretSize: 0,
                    callbacks: {
                        label: function (tooltipItem, data) {
                            var label = data.datasets[tooltipItem.datasetIndex].label || "";
  
                            if (label) {
                                label += ": ";
                            }
                            //label += Math.round(tooltipItem.yLabel * 100) / 100;
                            var value = Math.round(tooltipItem.yLabel * 100) / 100;
                            var nf = new Intl.NumberFormat('en-EN',{ style: 'currency', currency: 'MXN' }).format(value).replace('MX','') + ' MXN';
                            label += nf;     
                            
                            if (value===0){
                                return null;
                            }else{
                                return label;
                            }
                            
                        }
                    }
                },
                scales: {
                    yAxes: [
                    {
                        id: "A",
                        scaleLabel: {
                            display: true,
                            labelString: " Cargos"
                        },
                        ticks: {
                        // Include a dollar sign in the ticks
                            callback: function (value, index, values) {
                                //var valueForma = Math.round(tooltipItem.yLabel * 100) / 100;
                            var nf = new Intl.NumberFormat('en-EN',{ style: 'currency', currency: 'MXN' }).format(value).replace('MX','') + ' MXN';
                            
                                return nf;
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
                    xAxes: [
                    {
                        stacked: true,
                        gridLines: {
                            display: false
                        },
                        maxBarThickness: 150
                    }
                    ]
                }
            }
        };
  
        window.Chart.platform.disableCSSInjection = true;
        const canvas = document.createElement("canvas");
        this.template.querySelector("div.chart").appendChild(canvas);
        const ctx = canvas.getContext("2d");
        this.chart = new window.Chart(ctx, this.lineChart);
    }
}