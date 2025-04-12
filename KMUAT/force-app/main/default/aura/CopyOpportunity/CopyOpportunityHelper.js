({
    helperMethod1 : function(component, event) {
        console.log("helperMethod1");
        var isChkOLI = component.find("OpportunityLineItem").get("v.checked");
        var isChkP = component.find("Partner").get("v.checked");
        var isChkOCR = component.find("OpportunityContactRole").get("v.checked");
        var isChkOT = component.find("OpportunityTeam").get("v.checked");
        var isChkPN = component.find("JP_Project__c").get("v.checked");
        var isChkPT = component.find("JP_Partner1__c").get("v.checked");
        
        console.log("isChkOLI:", isChkOLI);
        console.log("isChkP:", isChkP);
        console.log("isChkOCR:", isChkOCR);
        console.log("isChkOT:", isChkOT);
        console.log("isChkPN:", isChkPN);
        console.log("isChkPT:", isChkPT);
        
        var action = component.get("c.doCopyRec");

        action.setParams({
            recordId: component.get("v.recordId"),
            isChkOLI: isChkOLI,
            isChkP: isChkP,
            isChkOCR: isChkOCR,
            isChkOT: isChkOT,
            isChkPN: isChkPN,
            isChkPT: isChkPT
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log("Success");
                console.log(response.getReturnValue());
                var result = response.getReturnValue();
                if(result !== undefined && result !== null){
                    console.log("return null");
                    this.helperMethod2(result);
                }else{
                    
                    //20241029 ALLIEDTELESIS-510 terrasky mod start
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        "type": "error",
                        "title": "エラー：",
                        "message": "商談のコピーに失敗しました"
                    });
                    
                    toastEvent.fire();
                    
                    /*$A.createComponents([
                        ["ui:message",{
                            "title" : "Error",
                            "severity" : "error",
                        }],
                        ["ui:outputText",{
                            "value" : result
                        }]
                    ],
					function(components, status){
                        if (status === "SUCCESS") {
							var message = components[0];
							var outputText = components[1];
							// ui:messageにui:outputTextの内容をセット
							message.set("v.body", outputText);
							// divタグにメッセージを表示
							var div1 = component.find("msg");
							div1.set("v.body", message);
						}
					});*/
                    //20241029 ALLIEDTELESIS-510 terrasky mod end
                }
            }else if (state === "ERROR") {
                console.log("ERROR");
                var errors = response.getError();
                if (errors) {
                    
                    //20241029 ALLIEDTELESIS-510 terrasky mod start
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        "type": "error",
                        "title": "エラー：",
                        "message": "商談のコピーに失敗しました"
                    });
                    
                    toastEvent.fire();
                    
                    /*if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        $A.createComponents([
                            ["ui:message",{
                                "title" : "Error",
                                "severity" : "error",
                            }],
                            ["ui:outputText",{
                                "value" : result
                            }]
                        ])
                    }*/
                    //20241029 ALLIEDTELESIS-510 terrasky mod end
                    
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    helperMethod2 : function(recordId) {
        console.log("helperMethod2");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": recordId,
          "slideDevName": "related"
        });
        navEvt.fire();
    }
})