import { BaseCard } from "vlocity_cmt/baseCard";                    import { LightningElement, api, track } from "lwc";                    import data from "./definition";                    export default class cfVplEnergyNotificationsCard extends BaseCard(LightningElement) {                        connectedCallback() {                            this.setDefinition(data);                        }                    }