({
	showError: function (component, message) {
        $A.createComponents([
            ["ui:message",{
                "title" : "Error",
                "severity" : "error",
            }],
            ["ui:outputText",{
                "value" : message
            }]
        ],
        function (components, status){
            var messageComponent = components[0];
            var outputText = components[1];
            // ui:messageにui:outputTextの内容をセット
            messageComponent.set ("v.body", outputText);
            // divタグにメッセージを表示
            var div1 = component.find ("msg");
            div1.set ("v.body", messageComponent);
        });
    },
    getQuotationHeader : function(component){
        const quotationHeaderId = component.get("v.recordId");

        if($A.util.isEmpty(quotationHeaderId) === false){
            const action = component.get("c.getQuotationHeader");
            action.setStorable();
            action.setParams({
                'quotationHeaderId' : quotationHeaderId
            });
            action.setCallback(
                this
                ,function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        let quotationHeader = response.getReturnValue();

                        component.set("v.opportunity", quotationHeader.JP_OpportunityNo__c);

                    }
                    else{
                        this.handleFailedResponse("getOpportunity()", response);
                    }
                }
            );
            $A.enqueueAction(action);
        }
    },
    /*
    * 通信失敗時処理
    */
    handleFailedResponse : function(functionName, actionResponse){
        var state = actionResponse.getState();
        if (state === "ERROR") {
            var responseErrors = actionResponse.getError();
            if ($A.util.isEmpty(responseErrors) === false) {
                let errorObj = responseErrors[0];
                if (errorObj && errorObj.message) {
                    alert(functionName + " にエラーが発生しました: " + errorObj.message);
                }
            }
        }
        else{
            alert( functionName + " 処理失敗。 state: " + state);
        }
    },
})