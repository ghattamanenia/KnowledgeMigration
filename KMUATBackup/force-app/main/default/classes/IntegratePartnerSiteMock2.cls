@isTest
global class IntegratePartnerSiteMock2 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('displayName', 'test');
        gen.writeStringField('access_token', 'test');
        gen.writeStringField('instance_url', 'test');
        gen.writeEndObject();
        res.setBody(gen.getAsString());
        // ステータスNG
        res.setStatusCode(500);
        return res;
    }
}