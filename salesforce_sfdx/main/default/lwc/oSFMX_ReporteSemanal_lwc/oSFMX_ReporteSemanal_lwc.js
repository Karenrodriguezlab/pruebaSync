import { LightningElement, api, wire, track } from "lwc";
import getUrlReporte from '@salesforce/apex/OSFMX_ReporteSemanal_cls.getUrlReporte';
import imgResource from '@salesforce/resourceUrl/OSFMX_WeeklyReport';

export default class OSFMX_ReporteSemanal_lwc extends LightningElement {

    url;
    error;
    image = imgResource + '/images/OSFMX_WeeklyReport.png';

    connectedCallback() {
        this.getUrl();
    }

    getUrl(){
        getUrlReporte()
            .then(result => {
                console.log(result);
                this.url = result;
                console.log(this.url);
            })
            .catch(error => {
                this.error = error;
            });
    }

}