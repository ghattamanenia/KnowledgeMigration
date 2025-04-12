/*
    This is a generic class used for getting field details for SFDC object .
    SchemaDetailsHelper.getFieldDetails('ObjectName');
*/
public class ATFE_SchemaDetailsHelper {

	 public static String getFieldDetails(String ObjName){
        //get object and field describe info
        //System.debug('Object Name :'+ObjName);
        Map<String,Schema.Sobjectfield> fieldMap =  Schema.getGlobalDescribe().get(ObjName).getDescribe().fields.getMap(); 
   		List<String> fieldList = getFieldList(fieldMap,true);
    	String fieldNames = getFieldNamesFromList(fieldList);
    	//System.debug('FieldList :'+fieldNames);
    	return fieldNames ;
    } 
    
	public static List<String> getFieldList( Map<String,Schema.SObjectField> fieldMap, Boolean selectAllFields){
    	List<String> fieldList = new List<String>();
    	for (String fieldKey : fieldMap.keySet()) {
        	Schema.SObjectField fsObj = fieldMap.get(fieldKey);
        	Schema.DescribeFieldResult f = fsObj.getDescribe();
        	String fieldName = f.getName();

	        if (selectAllFields) {
	            fieldList.add(fieldName);
	        } else {
	            if (f.getName()=='Id' || f.isNameField() || f.isCustom()) {
	                fieldList.add(fieldName);
	            }
        	}
    	}
    	return fieldList;
	} 
	
	public static String getFieldNamesFromList(List<String> fieldList) {
	    String fieldNames = '';
    	for (String field : fieldList) {
	        if (fieldNames.length()>0) {
	            fieldNames += ',';
	        }
	        fieldNames += field;
	    }
	    return fieldNames;
	}
}