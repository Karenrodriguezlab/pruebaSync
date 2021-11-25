import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';


export default class oSFMXMultiSelectContacts extends OmniscriptBaseMixin(LightningElement) {

    selectedContacts=[];
    optionsContacts=[];
    sumContacts;
    listContacts=[];     

    _contacts;
    _selected;
    @api
    get contacts() {
        return this._contacts;
    }
    set contacts(val) {
        if (val) {
            this._contacts = val;
        }
    }
    @api
    get selected() {
        return this._selected;
    }
    set selected(val) {
        if (val) {
            this._selected = val;
        }
    }    

    @api checkValidity() {         
        if (this.sumContacts>0){
            return true;
        }else{
            return false;
        }
     }
         
    handleChange(event) {
        const changeValue = event.detail.value;        
        this.sumContacts=changeValue.length;
        let jsonResponse=[];
        for (let i=0;i<changeValue.length;i++){
            //arr.find(o => o.name === 'string 1');
            if (Array.isArray(this.listContacts)){
                let objTemp = this.listContacts.find(ele =>ele.ContactId ===changeValue[i]);
                jsonResponse.push({"id":changeValue[i],"email":objTemp['ContactEmail']});            
            }else{
                let objTemp = this.listContacts;
                jsonResponse.push({"id":changeValue[i],"email":objTemp['ContactEmail']});            
            }
            
        }
        this.omniUpdateDataJson(jsonResponse,true);
        this.omniValidate();
        this.reportValidity();
    }

    connectedCallback() {    
        this.initValues();    
    }

    initValues(){
        if (this._contacts){
            this.listContacts = JSON.parse(JSON.stringify(this._contacts));
            //console.log("contacts::"+Array.isArray(this.listContacts));
            if (Array.isArray(this.listContacts)){
                for (let i = 0; i < this.listContacts.length; i++){
                    var contact = this.listContacts[i];
                    var tempContact = { label: contact['ContactName']+' - '+contact['ContactEmail'], value: contact['ContactId'] }
                    this.optionsContacts.push(tempContact);
                }
            }else{
                var contact = this.listContacts;
                var tempContact = { label: contact['ContactName']+' - '+contact['ContactEmail'], value: contact['ContactId'] }
                this.optionsContacts.push(tempContact);
            }
             
        }        
        if (this._selected){
            let listSelectedContacts = JSON.parse(JSON.stringify(this._selected));
            for (let j=0;j<listSelectedContacts.length;j++){
                this.selectedContacts.push(listSelectedContacts[j]['id']);
            }            
            this.sumContacts = this.selectedContacts.length;           
        }else{
            this.sumContacts=0;
        }        
    }

}