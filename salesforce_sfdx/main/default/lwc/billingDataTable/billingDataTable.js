import { LightningElement, track,api } from "lwc";
import { loadStyle } from 'lightning/platformResourceLoader';

const actionsArray = [
    { label: 'Descargar pdf',fieldName:'downloadPdf', name: 'downloadPdf' },
    { label: 'Descargar zip',fieldName:'downloadZip', name: 'downloadZip' },
  ]

const COLUMNS = [
    { label: 'Nro de Documento', initialWidth:160,fieldName: 'OSFMX_NumFactura__c', type:'text' },
    { label: 'Tipo',initialWidth:160,fieldName: 'OSFMX_TipoDocumento__c', type:'text' },
    { label: 'Descargar pdf',initialWidth:160,fieldName: 'downloadPdf', type:'button', 
    typeAttributes:
    { label: 'Descargar pdf', title: 'Descargar pdf', name: 'downloadPdf', iconName: 'utility:download', class: 'btn_next'} },
    
    { label: 'Descargar zip',initialWidth:160,fieldName: 'downloadZip', type:'button',
    typeAttributes:
    { label: 'Descargar zip', title: 'Descargar zip', name: 'downloadZip', iconName: 'utility:download', class: 'btn_next'}    
    },
    { label: 'Total',initialWidth:160, fieldName: 'montoTotal', type:'text',cellAttributes:{
        alignment: 'center'
    } },
    { label: 'Emisión',initialWidth:160, fieldName: 'OSFMX_FechaEmision__c', type:'text' },
    { label: 'Periodo',initialWidth:180, fieldName: 'OSFMX_PeriodoConsumo__c', type:'text' },
    /*{ label: 'Subtotal',initialWidth:160, fieldName: 'monto', type:'text', cellAttributes:{
        alignment: 'center'
    } },*/
    { label: 'Estado',initialWidth:160, fieldName: 'OSFMX_EstadoFactura__c', type:'text',cellAttributes:{
        class:{fieldName:'stateColor'}
    } },
    { label: 'Vencimiento',initialWidth:160, fieldName: 'OSFMX_FechaVencimiento__c', type:'text' }
    //{ label: 'Pago',initialWidth:160, fieldName: 'web', type: 'url',typeAttributes: { label:'Pagar factura', value: 'www.google.com'  }  },
     /*{
        type: 'action',
        label:'Descarga Dcto',
        fixedWidth: 130,
        fieldName:'actions',
        typeAttributes: {
            rowActions: { fieldName: "rowActions" },
            menuAlignment: 'right'
        }
    }*/
  ];

export default class DatatableEx12 extends LightningElement {
  columns = COLUMNS
  _consumos;
  facturasFiltradas;
  tiposDocumento = [];
    filtros={
        valueTipoDoc:"Todos"
    };

  @api get consumos() {
    return this._consumos;
  }
  set consumos(val) {
    if (val) {
      this._consumos = val;
    }
  }
   renderedCallback(){
      let path = "/resource/dataTablecustom";
      loadStyle(this, path).then((res)=>{
          console.log('render custom css')
      }).catch(e=>{
          console.log('No render custom css')
      })
  }
  handleRowAction(event) {
    let row = event.detail.row;

    let rowS = JSON.parse(JSON.stringify(row));
    console.log('selected rows:'+rowS.Id);
    this.consumos = JSON.parse(JSON.stringify(this._consumos));
    console.log(this.consumos);
    console.log(JSON.stringify(event.detail.action));
    if(event.detail.action.name=='downloadPdf') {
        window.open(rowS.OSFMX_UrlPdf__c, '_blank');
        console.log('clicked FIRST button');
    } else if (event.detail.action.name=='downloadZip') {
        window.open(rowS.OSFMX_UrlZip__c, '_blank');
        console.log('clicked SECOND button');
    }
  }

  

  connectedCallback(){
        this.consumos = JSON.parse(JSON.stringify(this._consumos));
        this.facturasFiltradas = this.consumos;
        this.tiposDocumento = [];
        console.log(this.consumos)
         this.consumos.map(item=>{
            if(item.OSFMX_TipoDocumento__c == "NOTA DE CR?DITO"){
                item.notShow="notShow"
            }
            item.montos = "slds-text-align_center"
            if(item.OSFMX_EstadoFactura__c == "Vencido"){
                item.web = [{ webs : "Google" ,urlTarget : "www.google.com"}]
                item.urlTarget = item.url_pdf
                item.notShow="show"
                item.stateColor ="slds-text-color_error"
                item.rowActions = actionsArray
            } else if(item.OSFMX_EstadoFactura__c == "Pagado"){
                item.stateColor ="slds-text-color_success"
                item.notShow="notShow"
                item.rowActions = actionsArray
            } else if(item.OSFMX_EstadoFactura__c == "Cancelado"){
                item.stateColor ="slds-text-color_inverse-weak"
            } else{
                item.stateColor ="yellow"
                item.rowActions = actionsArray
            }
            item.monto = new Intl.NumberFormat('en-EN',{ style: 'currency', currency: 'MXN' }).format(item.monto).replace("MX", "");
            item.montoTotal = new Intl.NumberFormat('en-EN',{ style: 'currency', currency: 'MXN' }).format(item.montoTotal).replace("MX", "");
            let index = this.tiposDocumento.findIndex(
                (record) => record === item.OSFMX_TipoDocumento__c
            );
            if (index < 0) {
                this.tiposDocumento.push(item.OSFMX_TipoDocumento__c);
            }
        })
       
  }

  cambiarFiltro = (evt) =>{           
    const nombreFiltro=evt.target.name;
    const valorFiltro = evt.target.value
    this.filtros[nombreFiltro]=valorFiltro;
    this.aplicarFiltro();    
  }

  aplicarFiltro(){    
    let facturasTemp = [...this.consumos];
    
    if (this.filtros['valueTipoDoc']!=="Todos"){
      facturasTemp = facturasTemp.filter((item)=>{
        return item.OSFMX_TipoDocumento__c==this.filtros['valueTipoDoc'];
      });
    }
    
    this.facturasFiltradas=facturasTemp;
  }

  //Exportar Hacía CSV - INICIO
    downloadCSVFileJS() {
        let fileName = 'FacturasMensuales.csv';
        this.data = this.facturasFiltradas;
        this.csvString = '';
        let rowEnd = '\n';
        let rowData = new Set([
            'OSFMX_NumFactura__c',
            'OSFMX_TipoDocumento__c',
            'montoTotal',
            'OSFMX_FechaEmision__c',
            'OSFMX_PeriodoConsumo__c',
            'OSFMX_EstadoFactura__c',
            'OSFMX_FechaVencimiento__c'
        ]);
        let csvHeader = new Set([
            'Nro de Documento',
            'Tipo',
            'Total',
            'Emisión',
            'Periodo',
            'Estado',
            'Vencimiento'
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
}