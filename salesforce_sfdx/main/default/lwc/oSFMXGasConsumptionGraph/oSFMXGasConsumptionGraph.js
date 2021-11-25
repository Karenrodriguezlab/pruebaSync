import { LightningElement, api, track } from "lwc";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";

//Tabla INICIO
const COLUMNS = [
    { label: 'Nombre Cliente',initialWidth:160, fieldName: 'nombre_cliente', type:'text'},
    { label: 'Nombre Suministro SAP',initialWidth:160,fieldName: 'nombre_suministro', type:'text' },
    { label: 'Año',initialWidth:160,fieldName: 'anio', type:'text' },
    { label: 'Mes',initialWidth:160,fieldName: 'mes', type:'text' },
    { label: 'Consumo Facturado GJ',initialWidth:160,fieldName: 'consumo_facturado_gj_format', type:'text', cellAttributes: { alignment: 'center' }},
    { label: 'Estado',initialWidth:160, fieldName: 'estado_desc', type:'text' },
    { label: 'Sociedad',initialWidth:180, fieldName: 'sociedad_desc', type:'text' },
    { label: 'Tipo Cliente',initialWidth:160, fieldName: 'tipo_cliente_desc', type:'text' },
    { label: 'Número BP SAP', initialWidth:160,fieldName: 'b_partner', type:'text' },
    { label: 'Contrato SAP',initialWidth:160, fieldName: 'contrato_gas', type:'text' },
    { label: 'Instalación Suministro SAP',initialWidth:160, fieldName: 'instal_suministro'}    
  ];
//Tabla FIN

export default class oSFMXGasConsumptionGraph extends LightningElement {
  error;
  chart;
  chartjsInitialized = false;
  consumosFiltrados;
  _consumos;
  @api  get consumos() {
    return this._consumos;
  }
  set consumos(val) {
    if (val) {
      this._consumos = val;
    }
  }

  states=[];  
  p_suministros = [];  
  s_engies = [];  
  t_solutions = [];  
  periods = [];    
  filtros={valueState:"Todos",
          valueSuministros: "Todos",
          valueEngies:"Todos",
          valueSolutions: "Todos",
          valuePeriods:"Todos"
        };
 
  configGraph= {
    type: 'bar',
    data: {
        datasets: [
            {
              yAxisID: 'A',
              label: 'Consumo de Gas',
              data: null,
              borderWidth: 1,
              backgroundColor: 'rgba(19, 126, 235, .6)',
              borderColor: 'rgba(19, 126, 235, .6)',
              borderWidth: 1,
              hoverBackgroundColor: "rgba(19, 126, 235)",
              hoverBorderColor: "rgba(19, 126, 235)"
            }
        ],
        labels: null
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
                    //var value = Math.round(tooltipItem.yLabel * 100) / 100;
                    //var nf = new Intl.NumberFormat('es-MX').format(value);
                    
                    //var nf = new Intl.NumberFormat('en-EN',{ style: 'currency', currency: 'MXN' }).format(value).replace("MX$", "");
                    var nf = tooltipItem.yLabel.toFixed(3);
                    label += nf;
                    label += " GJ";
                    return label;
                }
            }
        },
        scales: {
            yAxes: [
                {
                    id: 'A',
                    scaleLabel: {
                        display: true,
                        labelString: 'Gigajoules'
                    },
                    ticks: {                       
                        callback: function(value, index, values) {
                          var nf = new Intl.NumberFormat('es-MX').format(value);
                            return nf
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

                stacked: true,
                gridLines: {
                    display: false
                },
                maxBarThickness: 150
            }]
        }
    }
  }
  
  cambiarFiltro = (evt) =>{           
    const nombreFiltro=evt.target.name;
    const valorFiltro = evt.target.value
    this.filtros[nombreFiltro]=valorFiltro;
    this.aplicarFiltro();    
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
    this.consumos.sort((a, b) => 0 - (new Date(a.fecha_consumo_hasta) > new Date(b.fecha_consumo_hasta) ? -1 : 1));
    this.consumosFiltrados=this.consumos;
    //Pull data from datasource and set individually
    let dates = [];
    let dataset = [];
    let LabelMonthDay = [];
    let months = [];
    let years = [];
    this.states = [];
    this.p_suministros = [];
    this.s_engies = [];
    this.t_solutions = [];
    this.periods = [];
    
    for (let i = 0; i < this.consumos.length; i++) {
      dates.push(this.consumos[i].fecha_consumo_hasta);
      months.push(this.consumos[i].mes);
      years.push(this.consumos[i].anio);
      let index = this.states.findIndex(
        (record) => record === this.consumos[i].estado_desc
      );
      if (index < 0) {
        this.states.push(this.consumos[i].estado_desc);
      }
      //Inicia Filtro Punto de Suministro
      let indexPS = this.p_suministros.findIndex(
        (record) => record === this.consumos[i].nombre_suministro
      );
      if (indexPS < 0) {
        this.p_suministros.push(this.consumos[i].nombre_suministro);
      }
      //Finaliza Filtro Punto de Suministro
      //Inicia Filtro solucion Engie
      let indexSE = this.s_engies.findIndex(
        (record) => record === this.consumos[i].sociedad_desc
      );
      if (indexSE < 0) {
        this.s_engies.push(this.consumos[i].sociedad_desc);
      }
      //Finaliza Filtro solucion Engie
      //Inicia Filtro tipo de solucion
      let indexTS = this.t_solutions.findIndex(
        (record) => record === this.consumos[i].tipo_cliente_desc
      );
      if (indexTS < 0) {
        this.t_solutions.push(this.consumos[i].tipo_cliente_desc);
      }
      //Finaliza Filtro tipo de solucion
      //Inicia Filtro Periodo
      let periodString = this.consumos[i].mes + "-" + this.consumos[i].anio;
      
      this.consumos[i]["periodoCompleto"]=periodString;
      
      let indexP = this.periods.findIndex((record) => record === periodString);
      if (indexP < 0) {
        this.periods.push(periodString);
      }
      //Finaliza Filtro Periodo
      //INICIO Sumar Meses
      if (indexP < 0) {
        LabelMonthDay.push(this.consumos[i].mes + " " + this.consumos[i].anio);
        dataset.push(this.consumos[i].consumo_facturado_gj);
      } else {
        dataset[indexP] =
          dataset[indexP] + this.consumos[i].consumo_facturado_gj;
      }
      //FIN Sumar Meses
      /*this.consumos[i].consumo_facturado_gj_format = 
        new Intl.NumberFormat('en-EN',{ style: 'currency', currency: 'MXN' }).format(this.consumos[i].consumo_facturado_gj).replace("MX$", "");*/
    this.consumos[i].consumo_facturado_gj_format = this.consumos[i].consumo_facturado_gj.toFixed(3);
    }
    this.configGraph["data"]["datasets"][0]["data"]=dataset;
    this.configGraph["data"]["labels"]=LabelMonthDay;
    this.initChart();
  }

  aplicarFiltro(){    
    let consumosTemp = [...this.consumos];
    
    if (this.filtros['valuePeriods']!=="Todos"){     
      consumosTemp = consumosTemp.filter((item)=>{
        return item.periodoCompleto==this.filtros['valuePeriods'];
      });
    }
    if (this.filtros['valueState']!=="Todos"){
      consumosTemp = consumosTemp.filter((item)=>{
        return item.estado_desc==this.filtros['valueState'];
      });
    }
    if (this.filtros['valueSuministros']!=="Todos"){
      consumosTemp = consumosTemp.filter((item)=>{
        return item.nombre_suministro==this.filtros['valueSuministros'];
      });
    }
    if (this.filtros['valueEngies']!=="Todos"){
      consumosTemp = consumosTemp.filter((item)=>{
        return item.sociedad_desc==this.filtros['valueEngies'];
      });
    }
    if (this.filtros['valueSolutions']!=="Todos"){
      consumosTemp = consumosTemp.filter((item)=>{
        return item.tipo_cliente_desc==this.filtros['valueSolutions'];
      });
    }    
        
    let periodosFiltrado=[];
    let labelPeriodos=[];
    let datasetFiltrado=[];    
    
    for (let i = 0; i < consumosTemp.length; i++) {
      
      let periodString = consumosTemp[i].mes + "-" + consumosTemp[i].anio;
      let indexP = periodosFiltrado.findIndex((record) => record === periodString);
      if (indexP < 0) {
        periodosFiltrado.push(periodString);
      }
           
      if (indexP < 0) {
        labelPeriodos.push(consumosTemp[i].mes + " " + consumosTemp[i].anio);
        datasetFiltrado.push(consumosTemp[i].consumo_facturado_gj);
      } else {
        datasetFiltrado[indexP] =
        datasetFiltrado[indexP] + consumosTemp[i].consumo_facturado_gj;
      }
     
    }
    this.configGraph["data"]["datasets"][0]["data"]=datasetFiltrado;
    this.configGraph["data"]["labels"]=labelPeriodos;
    this.consumosFiltrados=consumosTemp;
    this.initChart();
  }

  initChart(){  
    //console.log("inicial::",this.configGraph);  
    window.Chart.platform.disableCSSInjection = true;        
    const canvas = document.createElement("canvas");
    const chartContainer = this.template.querySelector('div.chart');
    while(chartContainer.firstChild) {
        chartContainer.removeChild(chartContainer.firstChild);
    }
    chartContainer.appendChild(canvas);
    const ctx = canvas.getContext("2d");
    this.chart = new window.Chart(ctx, this.configGraph);        
  }

//Exportar Hacía CSV - INICIO
    downloadCSVFileJS() {
        let fileName = 'ConsumosMensuales.csv';
        this.data = this.consumosFiltrados;
        this.csvString = '';
        let rowEnd = '\n';
        let rowData = new Set([
            'nombre_cliente',
            'nombre_suministro',
            'anio',
            'mes',
            'consumo_facturado_gj',
            'estado_desc',
            'sociedad_desc',
            'tipo_cliente_desc',
            'b_partner',
            'contrato_gas',
            'instal_suministro'
        ]);
        let csvHeader = new Set([
            'Nombre Cliente',
            'Nombre Suministro SAP',
            'Año',
            'Mes',
            'Consumo Facturado GJ',
            'Estado',
            'Sociedad',
            'Tipo Cliente',
            'Número BP SAP',
            'Contrato SAP',
            'Instalación Suministro SAP'
        ]);

        rowData = Array.from(rowData);

        this.csvString += Array.from(csvHeader).join(',');
        this.csvString += rowEnd;

        for(let i=0; i < this.data.length; i++) {
            let colValue = 0;

            for(let key in rowData) {
                if(rowData.hasOwnProperty(key)) {
                    let rowKey = rowData[key];
                    if(colValue > 0){
                        this.csvString += ',';
                    }
                    let value = this.data[i][rowKey] === undefined ? '' : this.data[i][rowKey];
                    this.csvString += '"'+ value +'"';
                    colValue++;
                }
            }
            this.csvString += rowEnd;
        }       
        this.downloadCSVFile(fileName);
    }
    downloadCSVFile(fileName) {   
        console.log('--> csv ' + this.csvString);
        let universalBOM = "\uFEFF";//Obligar a Excel a tomar el UTF-8

        let downloadElement = document.createElement('a');
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(universalBOM+this.csvString);
        downloadElement.target = '_self';

        downloadElement.download = fileName; 
        document.body.appendChild(downloadElement);
        downloadElement.click(); 
    }
//Exportar Hacía CSV - FIN

//Tabla - INICIO
  columns = COLUMNS;
//Tabla - FIN

}