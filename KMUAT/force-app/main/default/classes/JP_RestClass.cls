/**
 * Retrieve Data with a Custom POST Method
 * --------------------------------------------------------
 * URI : /services/apexrest/query
 * prm : {"q" : "SELECT Id FROM Account"}
 * --------------------------------------------------------
 */

@RestResource(urlMapping='/query/*')
global with sharing class JP_RestClass{

    @HttpPost
    global static List<sObject> getRec(String q){

        List<SObject> recList = new List<SObject>();
        recList = Database.query(q);

        return recList;
    }
}