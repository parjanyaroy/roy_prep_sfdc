import { LightningElement } from 'lwc';
import {
    subscribe,
    unsubscribe,
    onError,
    setDebugFlag,
    isEmpEnabled,
} from 'lightning/empApi';

export default class Authorizetest extends LightningElement {
    channelName = '/event/PassToken__e';
    authorizefirstorg(){
        //alert('Authorize clicked');
        let newWin = window.open('https://login.salesforce.com/services/oauth2/authorize?response_type=token&client_id=3MVG9pRzvMkjMb6kwCmcO.WEm1GmtitUyzDh4HyvlYG8BMcvgdd8WbumCdjdPAvmWgHbYL.G3hGDj8LXr_tMc&redirect_uri=https://d5j000001kixzeaa-dev-ed--c.visualforce.com/apex/gettokenvf','popUpWindow','height=500,width=500,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes');
        console.log(newWin);
    }

    connectedCallback() {
        // Register error listener
        this.registerErrorListener();
        this.handleSubscribe();
    }

    // Handles subscribe button click
    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        const messageCallback = function (response) {
            console.log('New message received: ', JSON.stringify(response));
            alert('Response');
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then((response) => {
            // Response contains the subscription information on subscribe call
            console.log(
                'Subscription request sent to: ',
                JSON.stringify(response.channel)
            );
            //this.subscription = response;
            //this.toggleSubscribeButton(true);
        });
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }


}