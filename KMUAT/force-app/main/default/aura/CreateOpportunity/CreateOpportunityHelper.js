({

    helperDoChack : function(component, event) {
        let isDisable = true;
        component.set("v.isdisabled", isDisable);
        
        var action = component.get("c.getManagementNo");
        action.setParams({recordId: component.get("v.recordId")}); 

        action.setCallback(this, function(response) {
            var state = response.getState();
            var isError = false;
            var outputMessege = "";
            if(state === "SUCCESS") {
                console.log("SUCCESS");
                var result = response.getReturnValue();
                if (undefined !== result.JP_Opportunity__c && null !== result.JP_Opportunity__c) {
                    isError = true;
                    outputMessege = "商談は既に作成されています。";
                } else if ("NoPrefectures" === result.JP_User_Address__c) {
                    isError = true;
                    outputMessege = "お客様住所に都道府県が含まれていません。";
                } else {
                    outputMessege = "以下の項目は未入力です。\n";
                    if (undefined === result.JP_StaYmd__c || null === result.JP_StaYmd__c) {
                        isError = true;
	                    outputMessege += "・契約期間（開始）\n";
					}
                    if (undefined === result.JP_Claim_Name__c || null === result.JP_Claim_Name__c) {
                        isError = true;
	                    outputMessege += "・お客/代理店（請求書先）\n";
					}
                    if (undefined === result.JP_User_Address__c || null === result.JP_User_Address__c) {
                        isError = true;
	                    outputMessege += "・お客様住所";
					}
				}

                if (isError) {
                    $A.createComponents([
                        ["ui:message",{
                            "title" : "Error",
                            "severity" : "error",
                        }],
                        ["ui:outputText",{
                            "value" : outputMessege
                        }]
                    ],
					function(components, status){
                        var message = components[0];
                        var outputText = components[1];
                        message.set("v.body", outputText);
                        var div1 = component.find("msg");
                        div1.set("v.body", message);
 					});
                }
            } else if (state === "ERROR") {
                console.log("ERROR");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        $A.createComponents([
                            ["ui:message",{
                                "title" : "Error",
                                "severity" : "error",
                            }],
                            ["ui:outputText",{
                                "value" : "エラーが発生しました。システム管理者に連絡してください。" + errors[0].message
                            }]
                        ],
                        function(components, status){
                            var message = components[0];
                            var outputText = components[1];
                            message.set("v.body", outputText);
                            var div1 = component.find("msg");
                            div1.set("v.body", message);
                        });
                    }
                }
            } else {
                console.log("Unknown error");
            }
        });
        $A.enqueueAction(action);
	},

    helperCreateNew : function(component, event) {
        var div1 = component.find("msg");
        var message = div1.get("v.body");
        if ($A.util.isEmpty(message) === false) {
        	alert("画面のエラー内容のご確認をお願いいたします。");
        } else { 
            var action = component.get("c.createNew");
            action.setParams({recordId: component.get("v.recordId")});
            
            action.setCallback(this, function(response) {
            	var state = response.getState();
            	if(state === "SUCCESS") {
            	    console.log("SUCCESS");
                    const retVal = action.getReturnValue();
                    console.log(retVal);
                    if (retVal.message) {
                         $A.createComponents([
                            ["ui:message",{
                                "title" : "Error",
                                "severity" : "error",
                            }],
                            ["ui:outputText",{
                                "value" : retVal.message
                            }]
                        ],
                        function(components, status){
                            var message = components[0];
                            var outputText = components[1];
                            message.set("v.body", outputText);
                            var div1 = component.find("msg");
                            div1.set("v.body", message);
                        });
                    } else {
            	       this.helperRedraw(retVal.opportunityId);
                    }
                 } else if (state === "ERROR") {
                	console.log("ERROR");
                	var errors = response.getError();
               		if (errors) {
                        if (errors[0] && errors[0].message) {
                            $A.createComponents([
                                ["ui:message",{
                                    "title" : "Error",
                                    "severity" : "error",
                                }],
                                ["ui:outputText",{
                                    "value" : "エラーが発生しました。システム管理者に連絡してください。" + errors[0].message
                                }]
                            ],
                            function(components, status){
                                var message = components[0];
                                var outputText = components[1];
                                message.set("v.body", outputText);
                                var div1 = component.find("msg");
                                div1.set("v.body", message);
                            });
                        }
                    }
                } else {
                    console.log("Unknown error");
                }
            });
            $A.enqueueAction(action); 
        }
    },
        
    helperCreateUpdate : function(component, event) {
        var div1 = component.find("msg");
        var message = div1.get("v.body");
        if ($A.util.isEmpty(message) === false) {
        	alert("画面のエラー内容のご確認をお願いいたします。");
        } else {
        
        var action = component.get("c.createUpdate");
        action.setParams({recordId: component.get("v.recordId")}); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log("SUCCESS");
                const retVal = action.getReturnValue();
                console.log(retVal);
                if (retVal.message) {
                    $A.createComponents([
                        ["ui:message",{
                            "title" : "Error",
                            "severity" : "error",
                        }],
                        ["ui:outputText",{
                            "value" : retVal.message
                        }]
                    ],
                    function(components, status){
                        var message = components[0];
                        var outputText = components[1];
                        message.set("v.body", outputText);
                        var div1 = component.find("msg");
                        div1.set("v.body", message);
                    });
                } else {
                    this.helperRedraw(retVal.opportunityId);
                }
            } else if (state === "ERROR") {
                console.log("ERROR");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        $A.createComponents([
                            ["ui:message",{
                                "title" : "Error",
                                "severity" : "error",
                            }],
                            ["ui:outputText",{
                                "value" : "エラーが発生しました。システム管理者に連絡してください。" + errors[0].message
                            }]
                        ],
                        function(components, status){
                            var message = components[0];
                            var outputText = components[1];
                            message.set("v.body", outputText);
                            var div1 = component.find("msg");
                            div1.set("v.body", message);
                        });
                    }
                }
            } else {
                console.log("Unknown error");
            }
        });
        $A.enqueueAction(action);
        }
    },
    
    helperRedraw : function(recordId) {
        console.log("helperRedraw");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": recordId,
          "slideDevName": "detail"
        });
        navEvt.fire();
    }
})