import { LightningElement, api, wire, track } from 'lwc';

import searchUSPS from '@salesforce/apex/uspsAddressVerifier.uspsAddressSearch';

export default class UspsLWC extends LightningElement {
    @api fullAddress;
    @track data;
    @track error;

        handleSearch(event) {

            console.log("BOOTING UP!")

            var inputAddressOne = this.template.querySelector('lightning-input[data-name="AL1"]').value;
            let eAddress = encodeURIComponent(inputAddressOne);
            console.log(eAddress);
            var inputAddressTwo = this.template.querySelector('lightning-input[data-name="AL2"]').value;
            let eAddress2 = encodeURIComponent(inputAddressTwo);
            console.log(eAddress2);
            var inputCity = this.template.querySelector('lightning-input[data-name="City"]').value;
            let eCity = encodeURIComponent(inputCity);
            console.log(eCity);
            var inputState = this.template.querySelector('lightning-input[data-name="State"]').value;
            let eState = encodeURIComponent(inputState);
            console.log(eState);
            var inputZipFive = this.template.querySelector('lightning-input[data-name="Zip5"]').value;
            console.log(inputZipFive);
            var inputZipFour = this.template.querySelector('lightning-input[data-name="Zip4"]').value;
            console.log(inputZipFour);

            this.fullAddress = eAddress + "/" + eAddress2 + "/" + eCity + "/" + eState + "/" + inputZipFive + "/" + inputZipFour + "/end";
            console.log(this.fullAddress);
        }

        @wire(searchUSPS, {urlAddress: '$fullAddress'})

        uspsData({error, data}) {
            if (data) {
                this.error = undefined;
                this.data = data;
                console.log(this.data);
            } else if (error) {
                this.error = error;
                this.data = undefined;
                console.log(this.error);
            }
        }

}