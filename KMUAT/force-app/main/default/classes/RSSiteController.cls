global with sharing class RSSiteController {

    global String username {get; set;}
    global String password {get; set;}

    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, '/apex/BMCServiceDesk__SelfServiceHome?fromSiteUrl=true');
    }
    
    global RSSiteController () {}
    


}