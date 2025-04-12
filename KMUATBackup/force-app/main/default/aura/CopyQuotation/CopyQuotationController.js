/* buttonPressedController.js */
({
    nameThatButton : function(component, event, helper) {
        var whichOne = event.getSource().getLocalId();
        var action = component.get("c.chkError");
        
        action.setParams({
            recordId: component.get("v.recordId"),
            button: whichOne
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log("Success");
                var result = response.getReturnValue();
                if(result === undefined || result === null){
                    console.log("return null");
                    helper.helperMethod1(component, event);
                }else{
                    $A.createComponents([
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
					});
                }
            }else if (state === "ERROR") {
                console.log("ERROR");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        $A.enqueueAction(action);
    }
})