({
    helperMethod1 : function(component, event) {

        var whichOne = event.getSource().getLocalId();
        var action = component.get("c.copyQuotation");
        
        action.setParams({
            recordId: component.get("v.recordId"),
            button: whichOne
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("SUCCESS");
                this.helperMethod2(response.getReturnValue());
            } else if (response.getState() === "ERROR"){
                console.log("ERROR");
                var errors = response.getError();
                
                $A.createComponents([
                    ["ui:message",{
                        "title" : "Error",
                        "severity" : "error",
                    }],
                    ["ui:outputText",{
                        "value" : errors[0].message
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