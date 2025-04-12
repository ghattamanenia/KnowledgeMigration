({
    createReturnUrl : function(cmp) {
        // Get the return URL and decode as this will have originated from a URL parameter
        var url = cmp.get("v.retUrl");
        var decodedUrl = decodeURIComponent(url);
        return decodedUrl;
     }
})