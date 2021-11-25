import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

const COLUMNSECONOMICGROUP = [
    { label: 'Nombre de la Cuenta',fieldName: 'DuplicateName', type:'text' },
    { label: 'Nombre del propietario', fieldName: 'DuplicateOwner', type:'text' },
  ]

const COLUMNSSERVICEACCOUNT = [
    { label: 'Nombre de la Cuenta',fieldName: 'DuplicateName', type:'text' },
    { label: 'Cuenta principal', fieldName: 'DuplicateParent', type:'text' },
    { label: 'Ciudad', fieldName: 'DuplicateCity', type:'text' },
    { label: 'Estado', fieldName: 'DuplicateState', type:'text' },
    { label: 'Nombre del propietario', fieldName: 'DuplicateOwner', type:'text' },
  ]

const COLUMNSBUSINESSACCOUNT = [
    { label: 'Nombre de la Cuenta',fieldName: 'DuplicateName', type:'text' },
    { label: 'Razón social', fieldName: 'DuplicateRazonSocial', type:'text' },
    { label: 'RFC', fieldName: 'DuplicateRFC', type:'text' },
    { label: 'Nombre del propietario', fieldName: 'DuplicateOwner', type:'text' },
  ]

const COLUMNSCONTACT = [
    { label: 'Nombre del contacto',fieldName: 'DuplicateName', type:'text' },
    { label: 'Correo', fieldName: 'DuplicateEmail', type:'text' },
    { label: 'Nombre de la cuenta', fieldName: 'DuplicateAccount', type:'text' },
    { label: 'Nombre del propietario', fieldName: 'DuplicateOwner', type:'text' },
  ]

export default class OsfmxContactAccountValidation extends OmniscriptBaseMixin(LightningElement) {
    columns
    data
    _listInformation
    _typevalidation

    @api 
    get listinformation() {
        return this._listInformation;
    }
    set listinformation(val) {
        if (val) {
          this._listInformation = val;
        }
    }

    @api 
    get typevalidation() {
        return this._typevalidation;
    }
    set typevalidation(val) {
        if (val) {
          this._typevalidation = val;
        }
    }

    connectedCallback(){
        this.initValues();
    }
  
    initValues(){                
        if(this._listInformation){ 
            let dataParse = JSON.parse(JSON.stringify(this._listInformation));           
            if (Array.isArray(dataParse)){
               this.data = dataParse;
            } else{
                this.data = new Array(dataParse);
            }           
        }
        if (this._typevalidation){
            console.log('PASO1::::'+this._typevalidation)
            this.type = JSON.parse(JSON.stringify(this._typevalidation))
            console.log('PASO2::::'+this.type)

            if (this.type==='EconomicGroup'){
                this.columns = COLUMNSECONOMICGROUP;
            }
            else if (this.type==='ServiceAccount'){
                this.columns = COLUMNSSERVICEACCOUNT;
            }
            else if (this.type==='BusinessAccount'){
                this.columns = COLUMNSBUSINESSACCOUNT;
            }
            else if (this.type==='Contact'){
                this.columns = COLUMNSCONTACT;
            }

        }

        
    }

}