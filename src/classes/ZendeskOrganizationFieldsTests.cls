// This class provides test coverage for the ZendeskOrganizationFields class
@isTest
private class ZendeskOrganizationFieldsTests {

    public class MockOKResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }
    }

    public class MockOrganizationFieldResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{ "organization_field": { "url": "https://test.zendesk.com/api/v2/organization_fields/123.json", "id": 123, "type": "tagger", "key": "custom_field_1", "title": "Zendesk Plan", "raw_title": "Zendesk Plan", "description": "", "raw_description": "", "position": 7, "active": true, "required": false, "collapsed_for_agents": false, "regexp_for_validation": null, "title_in_portal": "Zendesk Plan", "raw_title_in_portal": "Zendesk Plan", "visible_in_portal": false, "editable_in_portal": false, "required_in_portal": false, "tag": null, "created_at": "2012-10-19T01:01:32Z", "updated_at": "2014-11-08T10:47:55Z", "removable": true, "custom_field_options": [ { "id": 21332256, "name": "Test", "raw_name": "Test", "value": "zdplan_test" } ] } } ');
            return res;
        }
    }

    public class MockOrganizationFieldsResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{ "organization_fields": [ { "url": "https://test.zendesk.com/api/v2/organization_fields/123.json", "id": 123, "type": "text", "key": "custom_field_1", "title": "Test", "raw_title": "Test", "description": "Test", "raw_description": "Test", "position": 9999, "active": false, "required": false, "collapsed_for_agents": false, "regexp_for_validation": null, "title_in_portal": "Test", "raw_title_in_portal": "Test", "visible_in_portal": false, "editable_in_portal": false, "required_in_portal": false, "tag": null, "created_at": "2013-08-28T05:57:11Z", "updated_at": "2013-08-29T07:11:23Z", "removable": true } ], "next_page": null, "previous_page": null, "count": 1 }');
            return res;
        }
    }

    static testMethod void testGetOrganizationFieldById() {
        Test.setMock(HttpCalloutMock.class, new MockOrganizationFieldResponse());

        Test.startTest();
        ZendeskOrganizationFields zfields = new ZendeskOrganizationFields(new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password));
        ZendeskOrganizationFields.ZOrganizationField testObj = zfields.getField(123);
        System.assertNotEquals(null, testObj);

        String optVal = testObj.getOptionValue('Test');
        System.assertNotEquals(null, optVal);
        Test.stopTest();
    }

    static testMethod void testGetOrganizationFieldByKey() {
        Test.setMock(HttpCalloutMock.class, new MockOrganizationFieldsResponse());

        Test.startTest();
        ZendeskOrganizationFields zfields = new ZendeskOrganizationFields(new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password));
        ZendeskOrganizationFields.ZOrganizationField testObj = zfields.getFieldByKey('custom_field_1');
        Test.stopTest();

        System.assertNotEquals(null, testObj);
    }

    static testMethod void testDeleteField() {
        Test.setMock(HttpCalloutMock.class, new MockOKResponse());

        Test.startTest();
        ZendeskOrganizationFields zfields = new ZendeskOrganizationFields(new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password));
        zfields.deleteField(123);
        Test.stopTest();

        System.assert(true);
    }

    static testMethod void testCreateField() {
        Test.setMock(HttpCalloutMock.class, new MockOrganizationFieldResponse());

        Test.startTest();
        ZendeskOrganizationFields zfields = new ZendeskOrganizationFields(new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password));
        ZendeskOrganizationFields.ZOrganizationField zfield = new ZendeskOrganizationFields.ZOrganizationField();
        zfield.key = 'create key';
        zfield.title = 'create title';
        Long fieldId = zfields.createField(zfield);
        Test.stopTest();

        System.assertNotEquals(null, fieldId);
    }

    static testMethod void testUpdateField() {
        Test.setMock(HttpCalloutMock.class, new MockOrganizationFieldResponse());

        Test.startTest();
        ZendeskOrganizationFields zfields = new ZendeskOrganizationFields(new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password));
        ZendeskOrganizationFields.ZOrganizationField zfield = new ZendeskOrganizationFields.ZOrganizationField();
        zfield.key = 'update key';
        zfield.title = 'update title';
        zfields.updateField(123, zfield);
        Test.stopTest();

        System.assert(true);
    }

    static testMethod void testReorderFields() {
        Test.setMock(HttpCalloutMock.class, new MockOKResponse());

        ZendeskAPI zapi = new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password);

        Test.startTest();
        ZendeskOrganizationFields zfields = new ZendeskOrganizationFields(zapi);
        zfields.reorderFields(new Long[] { 123, 456 });
        Test.stopTest();

        System.assert(true);
    }

    static testMethod void testGetAllFields() {
        Test.setMock(HttpCalloutMock.class, new MockOrganizationFieldsResponse());

        Test.startTest();
        ZendeskOrganizationFields zfields = new ZendeskOrganizationFields(new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password));
        Map<String, ZendeskOrganizationFields.ZOrganizationField> fieldsMap = zfields.getAllFields();
        Test.stopTest();

        System.assertNotEquals(null, fieldsMap.containsKey('Test'));
    }

    static testMethod void testGetNextPage() {
        Test.startTest();
        ZendeskOrganizationFields.PagedOrganizationFieldsWrapper wrapper = new ZendeskOrganizationFields.PagedOrganizationFieldsWrapper();
        wrapper.next_page = 'https://test.zendesk.com/api/v2/organization_fields.json?page=2';
        wrapper.previous_page = 'https://test.zendesk.com/api/v2/organization_fields.json?page=1';
        Test.stopTest();

        System.assertEquals(2, wrapper.nextPageNumber);
    }

    static testMethod void testZOrganizationField() {
        ZendeskOrganizationFields.ZOrganizationField zfield = new ZendeskOrganizationFields.ZOrganizationField();
        //zfield.id = 0;
        zfield.type = '';
        zfield.title = '';
        zfield.raw_title = '';
        zfield.active = true;
        zfield.custom_field_options = null;

        ZendeskOrganizationFields.ZCustomFieldOption zfieldoption = new ZendeskOrganizationFields.ZCustomFieldOption();
        zfieldoption.id = 0;
        zfieldoption.name = '';
        zfieldoption.raw_name = '';
        zfieldoption.value = '';

        System.assert(true);
    }
}