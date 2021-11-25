import { LightningElement } from "lwc";
import omniscriptFile from "vlocity_cmt/omniscriptFile";
import template from "./osfmxOmniScriptSingleFile.html"
export default class osfmxOmniScriptSingleFile extends omniscriptFile{
    
  _habilitar=false;

  countFiles(){       
    if (this._value.length===1){
      return true;
    }
    else{
      return false;
    }       
  }
  
  render(){
      this._habilitar = this.countFiles();
      return template;
  }
}