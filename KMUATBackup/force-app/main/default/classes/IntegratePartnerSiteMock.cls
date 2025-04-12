@isTest
global class IntegratePartnerSiteMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('displayName', 'test');
        gen.writeStringField('password', 'test');
        gen.writeEndObject();
        res.setBody(gen.getAsString());
        // ステータスOK
        res.setStatusCode(200);
        return res;
    }
}