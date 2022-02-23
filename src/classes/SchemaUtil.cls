/**
 * Created by tko18 on 2022/2/18.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO
*@Authortko18
*@Date 2022/2/18 11:42
*@Version:1.0.0
**/
public class SchemaUtil {
    /*
        通过sObjectName和指定字段获取PickList的value值
    */
    public static Map<String, object> getPicklistValues(String sObjectName, String sFieldName) {
        Map<String, object> picValues = new Map<String, object>();
        Map<String, Schema.SObjectType> sObjectDescribeMap = Schema.getGlobalDescribe();
        if (sObjectDescribeMap.containsKey(sObjectName)) {
            Map<String, Schema.SobjectField> sObjectFieldsMap =
                    sObjectDescribeMap.get(sObjectName).getDescribe().fields.getMap();
            if (sObjectFieldsMap.containsKey(sFieldName)) {
                Schema.DescribeFieldResult sObjectFieldDescribe = sObjectFieldsMap.get(sFieldName).getDescribe();
                List<Schema.PicklistEntry> lPickEntryList = sObjectFieldDescribe.getPicklistValues();
                for (Schema.PicklistEntry tPicklistEntry : lPickEntryList) {
                    picValues.put(tPicklistEntry.getValue(), new Map<String, object>{
                            'value' => tPicklistEntry.getValue(),
                            'isActive' => tPicklistEntry.isActive(),
                            'isDefaultValue' => tPicklistEntry.isDefaultValue(),
                            'label' => tPicklistEntry.getLabel()
                    });
                }
            } else {
                //TODO 不存在此字段的执行
            }
        } else {
            // TODO 不存在此sObject的执行
        }
        return picValues;
    }
}