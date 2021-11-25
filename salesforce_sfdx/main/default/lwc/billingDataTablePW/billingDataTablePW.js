import { LightningElement, track, api } from "lwc";
import { loadStyle } from 'lightning/platformResourceLoader';
import { createRecord } from "lightning/uiRecordApi";

const actionsArray = [
    { label: 'Descargar pdf', fieldName: 'downloadPdf', name: 'downloadPdf' },
    { label: 'Descargar zip', fieldName: 'downloadZip', name: 'downloadZip' },
]

const COLUMNS = [
    { label: 'Nro de Documento', initialWidth: 160, fieldName: 'OSFMX_NumFactura__c', type: 'text' },
    { label: 'Tipo', initialWidth: 160, fieldName: 'OSFMX_TipoDocumento__c', type: 'text' }, {
        label: 'Descargar pdf',
        initialWidth: 160,
        fieldName: 'downloadPdf',
        type: 'button',
        typeAttributes: { label: 'Descargar pdf', title: 'Descargar pdf', name: 'downloadPdf', iconName: 'utility:download', class: 'btn_next' }
    },
    {
        label: 'Descargar zip',
        initialWidth: 160,
        fieldName: 'downloadZip',
        type: 'button',
        typeAttributes: { label: 'Descargar zip', title: 'Descargar zip', name: 'downloadZip', iconName: 'utility:download', class: 'btn_next' }
    }, 
    {
        label: 'Pago',
        initialWidth: 110,
        fieldName: 'payment',
        type: 'button',
        typeAttributes: { 
            label: 'Pagar', 
            title: 'Pagar', 
            name: 'payInvoice', 
            iconName: 'utility:payment_gateway', 
            class: 'btn_next', 
            disabled: { fieldName: 'disabled' }
        }
    },
    {
        label: 'Total',
        initialWidth: 160,
        fieldName: 'montoTotal',
        type: 'text',
        cellAttributes: {
            alignment: 'center'
        }
    },
    { label: 'Emisión', initialWidth: 160, fieldName: 'OSFMX_FechaEmision__c', type: 'text' },
    { label: 'Periodo', initialWidth: 180, fieldName: 'OSFMX_PeriodoConsumo__c', type: 'text' },
    /*{ label: 'Subtotal',initialWidth:160, fieldName: 'monto', type:'text', cellAttributes:{
        alignment: 'center'
    } },*/
    {
        label: 'Estado',
        initialWidth: 160,
        fieldName: 'OSFMX_EstadoFactura__c',
        type: 'text',
        cellAttributes: {
            class: { fieldName: 'stateColor' }
        }
    },
    /*{ label: 'Tipo de Moneda',initialWidth:160, fieldName: 'OSFMX_MonedaCfdi__c', type:'text' },*/
    { label: 'Información', initialWidth: 400, fieldName: 'OSFMX_InfoMultipagos__c', type: 'text' },
    { label: 'Vencimiento', initialWidth: 160, fieldName: 'OSFMX_FechaVencimiento__c', type: 'text' },
    { label: 'Autorización / GUÍA CIE', initialWidth: 200, fieldName: 'OSFMX_MpAuthMultipagos__c', type: 'text', cellAttributes: {alignment: 'center'
        } }
    //{ label: 'Pago',initialWidth:160, fieldName: 'web', type: 'url',typeAttributes: { label:'Pagar factura', value: 'www.google.com'  }  },
    /*{
      label:'Descarga Dcto',
      fixedWidth: 130,
      fieldName:'actions', 
      type: 'action',                
        typeAttributes: {
            rowActions: { fieldName: "rowActions" },
            menuAlignment: 'right',
        }
    },*/
];

export default class DatatableEx12 extends LightningElement {
    columns = COLUMNS
    _consumos;
    transactionRecCuentaContrato="Prueba 01";
    transactionRecRefFactura="Prueba 02";
    /*Solo para probar mientras de construye*/
    //_consumosString = "[{\"attributes\":{\"type\":\"AggregateResult\"},\"OSFMX_FechaEmision__c\":\"2021-08-31\",\"OSFMX_FechaEnvio__c\":null,\"OSFMX_PeriodoConsumo__c\":\"2021-08-01 -- 2021-08-31\",\"OSFMX_NumFactura__c\":\"B00054042\",\"OSFMX_UrlZip__c\":\"https:\/\/emisionservicio.detecno-control.info:43980\/cfdiWebEmision_Servicio33_EngieTest\/asp\/download.aspx?folio=1679108&RFC=XIA190128J61&token=c36462e80bca7d8d048fc49c8f8bca23\",\"OSFMX_UrlPdf__c\":\"https:\/\/emisionservicio.detecno-control.info:43980\/cfdiWebEmision_Servicio33_EngieTest\/asp\/showPDF.aspx?folio=1679108&RFC=XIA190128J61&token=c53a5b128d7d024eeff150ddac69f2ed\",\"OSFMX_EstadoFactura__c\":\"Vencido\",\"monto\":10040.48,\"OSFMX_MonedaCfdi__c\":\"MXN\",\"OSFMX_FechaFinPeriodoConsumo__c\":\"2021-08-31\",\"OSFMX_FechaInicioPeriodoConsumo__c\":\"2021-08-01\",\"OSFMX_FechaVencimiento__c\":\"2021-09-15\",\"OSFMX_TipoDocumento__c\":\"FACTURA\",\"montoTotal\":11646.95,\"OSFMX_MpSignature__c\":\"d093d382b60fc0327a0d2a8d36a6bf4d433b41c5897f1bad8e5eb4b4af04270b\",\"OSFMX_MpAccountMultipagos__c\":\"3882\",\"OSFMX_MpUrlSuccessMultipagos__c\":\"https:\/\/devmexico-b2b-engiemexico.cs14.force.com\/b2b\/s\/pagoexitosomultipagosportal\",\"OSFMX_MpUrlFailureMultipagos__c\":\"https:\/\/devmexico-b2b-engiemexico.cs14.force.com\/b2b\/s\/pagoexitosomultipagosportal\",\"OSFMX_MpReferenceMultipagos__c\":\"005000638756\",\"OSFMX_ReferenciaFactura__c\":\"INFMX02B00054042\",\"OSFMX_MpCustomernameMultipagos__c\":\"edgar.maldonado@globant.com.latam.devmexico\",\"OSFMX_InfoMultipagos__c\":\"Se imprimi\u00f3 ficha de pago en la fecha 11\/10\/2021\",\"OSFMX_MpNodeMultipagos__c\":\"7\"},{\"attributes\":{\"type\":\"AggregateResult\"},\"OSFMX_FechaEmision__c\":\"2021-10-05\",\"OSFMX_FechaEnvio__c\":null,\"OSFMX_PeriodoConsumo__c\":\"2021-08-01 -- 2021-08-15\",\"OSFMX_NumFactura__c\":\"B00054215\",\"OSFMX_UrlZip__c\":\"https:\/\/emisionservicio.detecno-control.info:43980\/cfdiWebEmision_Servicio33_EngieTest\/asp\/download.aspx?folio=1721947&RFC=XIA190128J61&token=1f65ba3c4aa574c8e70cded6c69cc60e\",\"OSFMX_UrlPdf__c\":\"https:\/\/emisionservicio.detecno-control.info:43980\/cfdiWebEmision_Servicio33_EngieTest\/asp\/showPDF.aspx?folio=1721947&RFC=XIA190128J61&token=30c92fadcbe147f1cd26de0c62f2833d\",\"OSFMX_EstadoFactura__c\":\"No pagado\",\"monto\":5020.25,\"OSFMX_MonedaCfdi__c\":\"MXN\",\"OSFMX_FechaFinPeriodoConsumo__c\":\"2021-08-15\",\"OSFMX_FechaInicioPeriodoConsumo__c\":\"2021-08-01\",\"OSFMX_FechaVencimiento__c\":\"2021-10-20\",\"OSFMX_TipoDocumento__c\":\"FACTURA\",\"montoTotal\":5823.48,\"OSFMX_MpSignature__c\":\"7fe36a275d861936ea46657e732312897788b58ed946d5083c9a703256013f1f\",\"OSFMX_MpAccountMultipagos__c\":\"3882\",\"OSFMX_MpUrlSuccessMultipagos__c\":\"https:\/\/devmexico-b2b-engiemexico.cs14.force.com\/b2b\/s\/pagoexitosomultipagosportal\",\"OSFMX_MpUrlFailureMultipagos__c\":\"https:\/\/devmexico-b2b-engiemexico.cs14.force.com\/b2b\/s\/pagoexitosomultipagosportal\",\"OSFMX_MpReferenceMultipagos__c\":\"005000638756\",\"OSFMX_ReferenciaFactura__c\":\"INFMX02B00054215\",\"OSFMX_MpCustomernameMultipagos__c\":\"edgar.maldonado@globant.com.latam.devmexico\",\"OSFMX_InfoMultipagos__c\":null,\"OSFMX_MpNodeMultipagos__c\":\"8\"},{\"attributes\":{\"type\":\"AggregateResult\"},\"OSFMX_FechaEmision__c\":\"2021-10-05\",\"OSFMX_FechaEnvio__c\":null,\"OSFMX_PeriodoConsumo__c\":\"2021-08-01 -- 2021-08-15\",\"OSFMX_NumFactura__c\":\"ZK0054219\",\"OSFMX_UrlZip__c\":\"https:\/\/emisionservicio.detecno-control.info:43980\/cfdiWebEmision_Servicio33_EngieTest\/asp\/download.aspx?folio=1721947&RFC=XIA190128J61&token=1f65ba3c4aa574c8e70cded6c69cc60e\",\"OSFMX_UrlPdf__c\":\"https:\/\/emisionservicio.detecno-control.info:43980\/cfdiWebEmision_Servicio33_EngieTest\/asp\/showPDF.aspx?folio=1721947&RFC=XIA190128J61&token=30c92fadcbe147f1cd26de0c62f2833d\",\"OSFMX_EstadoFactura__c\":\"Pagado\",\"monto\":9020.25,\"OSFMX_MonedaCfdi__c\":\"MXN\",\"OSFMX_FechaFinPeriodoConsumo__c\":\"2021-08-15\",\"OSFMX_FechaInicioPeriodoConsumo__c\":\"2021-08-01\",\"OSFMX_FechaVencimiento__c\":\"2021-10-20\",\"OSFMX_TipoDocumento__c\":\"FACTURA\",\"montoTotal\":9823.48,\"OSFMX_MpSignature__c\":\"7fe36a275d861936ea46657e732312897788b58ed946d5083c9a703256013f1f\",\"OSFMX_MpAccountMultipagos__c\":\"3882\",\"OSFMX_MpUrlSuccessMultipagos__c\":\"https:\/\/devmexico-b2b-engiemexico.cs14.force.com\/b2b\/s\/pagoexitosomultipagosportal\",\"OSFMX_MpUrlFailureMultipagos__c\":\"https:\/\/devmexico-b2b-engiemexico.cs14.force.com\/b2b\/s\/pagoexitosomultipagosportal\",\"OSFMX_MpReferenceMultipagos__c\":\"005000638756\",\"OSFMX_ReferenciaFactura__c\":\"ABCDE000000003\",\"OSFMX_MpCustomernameMultipagos__c\":\"edgar.maldonado@globant.com.latam.devmexico\",\"OSFMX_InfoMultipagos__c\":null,\"OSFMX_MpNodeMultipagos__c\":\"9\"},{\"attributes\":{\"type\":\"AggregateResult\"},\"OSFMX_FechaEmision__c\":\"2021-10-05\",\"OSFMX_FechaEnvio__c\":null,\"OSFMX_PeriodoConsumo__c\":\"2021-08-01 -- 2021-08-15\",\"OSFMX_NumFactura__c\":\"K00054211\",\"OSFMX_UrlZip__c\":\"https:\/\/emisionservicio.detecno-control.info:43980\/cfdiWebEmision_Servicio33_EngieTest\/asp\/download.aspx?folio=1721947&RFC=XIA190128J61&token=1f65ba3c4aa574c8e70cded6c69cc60e\",\"OSFMX_UrlPdf__c\":\"https:\/\/emisionservicio.detecno-control.info:43980\/cfdiWebEmision_Servicio33_EngieTest\/asp\/showPDF.aspx?folio=1721947&RFC=XIA190128J61&token=30c92fadcbe147f1cd26de0c62f2833d\",\"OSFMX_EstadoFactura__c\":\"No pagado\",\"monto\":1000,\"OSFMX_MonedaCfdi__c\":\"MXN\",\"OSFMX_FechaFinPeriodoConsumo__c\":\"2021-08-15\",\"OSFMX_FechaInicioPeriodoConsumo__c\":\"2021-08-01\",\"OSFMX_FechaVencimiento__c\":\"2021-10-20\",\"OSFMX_TipoDocumento__c\":\"FACTURA\",\"montoTotal\":1100,\"OSFMX_MpSignature__c\":\"7fe36a275d861936ea46657e732312897788b58ed946d5083c9a703256013f1f\",\"OSFMX_MpAccountMultipagos__c\":\"3882\",\"OSFMX_MpUrlSuccessMultipagos__c\":\"https:\/\/devmexico-b2b-engiemexico.cs14.force.com\/b2b\/s\/pagoexitosomultipagosportal\",\"OSFMX_MpUrlFailureMultipagos__c\":\"https:\/\/devmexico-b2b-engiemexico.cs14.force.com\/b2b\/s\/pagoexitosomultipagosportal\",\"OSFMX_MpReferenceMultipagos__c\":\"005000638756\",\"OSFMX_ReferenciaFactura__c\":\"FGHIJ000000002\",\"OSFMX_MpCustomernameMultipagos__c\":\"edgar.maldonado@globant.com.latam.devmexico\",\"OSFMX_InfoMultipagos__c\":null,\"OSFMX_MpNodeMultipagos__c\":\"10\"},{\"attributes\":{\"type\":\"AggregateResult\"},\"OSFMX_FechaEmision__c\":\"2021-10-05\",\"OSFMX_FechaEnvio__c\":\"2021-10-05\",\"OSFMX_PeriodoConsumo__c\":\"2021-08-01 -- 2021-08-15\",\"OSFMX_NumFactura__c\":\"Z00054211\",\"OSFMX_UrlZip__c\":\"https:\/\/emisionservicio.detecno-control.info:43980\/cfdiWebEmision_Servicio33_EngieTest\/asp\/download.aspx?folio=1721947&RFC=XIA190128J61&token=1f65ba3c4aa574c8e70cded6c69cc60e\",\"OSFMX_UrlPdf__c\":\"https:\/\/emisionservicio.detecno-control.info:43980\/cfdiWebEmision_Servicio33_EngieTest\/asp\/showPDF.aspx?folio=1721947&RFC=XIA190128J61&token=30c92fadcbe147f1cd26de0c62f2833d\",\"OSFMX_EstadoFactura__c\":\"Pagado\",\"monto\":6020.25,\"OSFMX_MonedaCfdi__c\":\"MXN\",\"OSFMX_FechaFinPeriodoConsumo__c\":\"2021-08-15\",\"OSFMX_FechaInicioPeriodoConsumo__c\":\"2021-08-01\",\"OSFMX_FechaVencimiento__c\":\"2021-10-20\",\"OSFMX_TipoDocumento__c\":\"FACTURA\",\"montoTotal\":6823.48,\"OSFMX_MpSignature__c\":\"7fe36a275d861936ea46657e732312897788b58ed946d5083c9a703256013f1f\",\"OSFMX_MpAccountMultipagos__c\":\"3882\",\"OSFMX_MpUrlSuccessMultipagos__c\":\"https:\/\/devmexico-b2b-engiemexico.cs14.force.com\/b2b\/s\/pagoexitosomultipagosportal\",\"OSFMX_MpUrlFailureMultipagos__c\":\"https:\/\/devmexico-b2b-engiemexico.cs14.force.com\/b2b\/s\/pagoexitosomultipagosportal\",\"OSFMX_MpReferenceMultipagos__c\":\"005000638756\",\"OSFMX_ReferenciaFactura__c\":\"KLMNO000000001\",\"OSFMX_MpCustomernameMultipagos__c\":\"edgar.maldonado@globant.com.latam.devmexico\",\"OSFMX_InfoMultipagos__c\":null,\"OSFMX_MpNodeMultipagos__c\":\"11\"}]";
    //_consumos = JSON.parse(this._consumosString);
    facturasFiltradas;
    tiposDocumento = [];
    filtros = {
        valueTipoDoc: "Todos"
    };
    @api get consumos() {
        return this._consumos;
    }
    set consumos(val) {
        if (val) {
            this._consumos = val;
            /*Solo para probar mientras de construye*/
            //this._consumos = JSON.parse(this._consumosString);
        }
    }
    renderedCallback() {
        let path = "/resource/1629226572000/dataTablecustom";
        loadStyle(this, path).then((res) => {
            console.log('render custom css')
        }).catch(e => {
            console.log('No render custom css')
        })
    }
    handleRowAction(event) {
        let row = event.detail.row;

        let rowS = JSON.parse(JSON.stringify(row));
        console.log('selected rows:' + rowS.Id);
        this.consumos = JSON.parse(JSON.stringify(this._consumos));
        console.log(this.consumos);
        console.log(JSON.stringify(event.detail.action));
        if (event.detail.action.name == 'downloadPdf') {
            window.open(rowS.OSFMX_UrlPdf__c, '_blank');
            console.log('clicked FIRST button');
        } else if (event.detail.action.name == 'downloadZip') {
            window.open(rowS.OSFMX_UrlZip__c, '_blank');
            console.log('clicked SECOND button');
        } else if (event.detail.action.name == 'payInvoice') {
            console.log('clicked Pagar Factura button');
            if (window.confirm("Te re direccionaremos a la plataforma BBVA Multipagos para que realices tu operación. ¿Deseas continuar?")) {
                
                let myPromise = 
                    new Promise(
                        function(resolve, reject) {
                            this.transactionRecCuentaContrato = rowS.OSFMX_MpReferenceMultipagos__c;
                            this.transactionRecRefFactura = rowS.OSFMX_ReferenciaFactura__c;
                            console.log(">>>>>>>>>>>>>>>>>>>>>>>> Promesa Invocada");
                            resolve("OK");
                        }.bind(this)
                    );
                
                myPromise.then(
                    function(result) {
                        console.log(">>>>>>>>>>>>>>>>>>>>>>>> EXITO PROMESA: " + result);
                        let editFormElement = this.template.querySelector('lightning-record-edit-form');
                        editFormElement.submit();
                        
                        let formElement = this.template.querySelector('form');
                        formElement.elements.namedItem("mp_account").value = rowS.OSFMX_MpAccountMultipagos__c;
                        formElement.elements.namedItem("mp_order").value = rowS.OSFMX_ReferenciaFactura__c;
                        formElement.elements.namedItem("mp_reference").value = rowS.OSFMX_MpReferenceMultipagos__c;
                        formElement.elements.namedItem("mp_amount").value = rowS.MontoNumber;
                        formElement.elements.namedItem("mp_customername").value = rowS.OSFMX_MpCustomernameMultipagos__c;
                        formElement.elements.namedItem("mp_signature").value = rowS.OSFMX_MpSignature__c;
                        formElement.elements.namedItem("mp_urlsuccess").value = rowS.OSFMX_MpUrlSuccessMultipagos__c;
                        formElement.elements.namedItem("mp_urlfailure").value = rowS.OSFMX_MpUrlFailureMultipagos__c;
                        formElement.elements.namedItem("mp_node").value = rowS.OSFMX_MpNodeMultipagos__c;
                        //formElement.action = "https://prepro.adquiracloud.mx/clb/endpoint/gdfSuez";
                        formElement.submit();
                    }.bind(this)
                ).catch(
                    function(error) {
                        console.log(">>>>>>>>>>>>>>>>>>>>>>>> ERROR PROMESA: " + error);
                    }
                );
            }
            
        }
    }



    connectedCallback() {
        this.consumos = JSON.parse(JSON.stringify(this._consumos));
        this.facturasFiltradas = this.consumos;
        this.tiposDocumento = [];
        console.log(this.consumos)
        this.consumos.map(item => {
            if (item.OSFMX_TipoDocumento__c == "NOTA DE CR?DITO") {
                item.notShow = "notShow"
            }
            if(item.OSFMX_TipoDocumento__c == "FACTURA"){
                if(item.OSFMX_EstadoFactura__c == "Vencido"||item.OSFMX_EstadoFactura__c == "No pagado"){
                    item.disabled = false;
                }else{
                    item.disabled = true;
                }
            }else{
                item.disabled = true;
            }
            item.montos = "slds-text-align_center"
            if (item.OSFMX_EstadoFactura__c == "Vencido") {
                item.web = [{ webs: "Google", urlTarget: "www.google.com" }]
                item.urlTarget = item.url_pdf
                item.notShow = "show"
                item.stateColor = "slds-text-color_error"
                item.rowActions = actionsArray
            } else if (item.OSFMX_EstadoFactura__c == "Pagado") {
                item.stateColor = "slds-text-color_success"
                item.notShow = "notShow"
                item.rowActions = actionsArray
            } else if (item.OSFMX_EstadoFactura__c == "Cancelado") {
                item.stateColor = "slds-text-color_inverse-weak"
            } else {
                item.stateColor = "yellow"
                item.rowActions = actionsArray
            }
            item.MontoNumber = item.montoTotal;
            item.monto = new Intl.NumberFormat('en-EN', { style: 'currency', currency: 'MXN' }).format(item.monto).replace("MX", "") + ' MXN';
            item.montoTotal = new Intl.NumberFormat('en-EN', { style: 'currency', currency: 'MXN' }).format(item.montoTotal).replace("MX", "") + ' MXN';
            let index = this.tiposDocumento.findIndex(
                (record) => record === item.OSFMX_TipoDocumento__c
            );
            if (index < 0) {
                this.tiposDocumento.push(item.OSFMX_TipoDocumento__c);
            }
        })

    }

    cambiarFiltro = (evt) => {
        const nombreFiltro = evt.target.name;
        const valorFiltro = evt.target.value
        this.filtros[nombreFiltro] = valorFiltro;
        this.aplicarFiltro();
    }

    aplicarFiltro() {
        let facturasTemp = [...this.consumos];

        if (this.filtros['valueTipoDoc'] !== "Todos") {
            facturasTemp = facturasTemp.filter((item) => {
                return item.OSFMX_TipoDocumento__c == this.filtros['valueTipoDoc'];
            });
        }

        this.facturasFiltradas = facturasTemp;
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

        for (let i = 0; i < this.data.length; i++) {
            let colValue = 0;

            for (let key in rowData) {
                if (rowData.hasOwnProperty(key)) {
                    let rowKey = rowData[key];
                    if (colValue > 0) {
                        this.csvString += ',';
                    }
                    let value = this.data[i][rowKey] === undefined ? '' : this.data[i][rowKey];
                    this.csvString += '"' + value + '"';
                    colValue++;
                }
            }
            this.csvString += rowEnd;
        }
        this.downloadCSVFile(fileName);
    }
    downloadCSVFile(fileName) {
            console.log('--> csv ' + this.csvString);
            let universalBOM = "\uFEFF"; //Obligar a Excel a tomar el UTF-8

            let downloadElement = document.createElement('a');
            downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(universalBOM + this.csvString);
            downloadElement.target = '_self';

            downloadElement.download = fileName;
            document.body.appendChild(downloadElement);
            downloadElement.click();
        }
        //Exportar Hacía CSV - FIN
}