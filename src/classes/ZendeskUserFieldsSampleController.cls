public with sharing class ZendeskUserFieldsSampleController {

	public String subdomain {get;set;}
	public String username {get;set;}
	public String pwdOrToken {get;set;}
	public String authType {get;set;}

	public String pageMessage {get;set;}
	public String searchText {get;set;}
	public Map<String, ZendeskUserFields.ZUserField> fieldsMap {get;set;}

	public ZendeskUserFieldsSampleController() {}

	public PageReference getFields() {
		pageMessage = '';
		try {
			ZendeskAPI zapi = new ZendeskAPI(subdomain, username, pwdOrToken, (authType=='Password' ? ZendeskAPI.AuthType.Password : ZendeskAPI.AuthType.Token));
			ZendeskUserFields zfields = new ZendeskUserFields(zapi);

			fieldsMap = zfields.getAllFields();
		}
		catch(Exception e) {
			pageMessage = e.getMessage();
		}
		return null;
	}

	public PageReference findFieldByName() {
		pageMessage = '';
		try {
			ZendeskAPI zapi = new ZendeskAPI(subdomain, username, pwdOrToken, (authType=='Password' ? ZendeskAPI.AuthType.Password : ZendeskAPI.AuthType.Token));
			ZendeskUserFields zfields = new ZendeskUserFields(zapi);

			fieldsMap = new Map<String, ZendeskUserFields.ZUserField>();
			ZendeskUserFields.ZUserField field = zfields.getUserField(searchText);
			if (field != null) {
				fieldsMap.put(field.raw_title, field);
			}
			else {
				throw new ZendeskException('Field "' + searchText + '" not found');
			}
		}
		catch(Exception e) {
			pageMessage = e.getMessage();
		}
		return null;
	}
}