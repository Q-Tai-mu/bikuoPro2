/**
 * Created by tko18 on 2022/2/11.
 */
/**
*@ClassName:Lin-Tui
*@Description:费用按钮工具类
*@Authortko18
*@Date 2022/2/11 11:54
*@Version:1.0.0
**/
global class CostManagementButtonTool {

    /**
     *@DESCRIPTION 区分用户财务
     * @Version 1.0.0
     * @return
     */
    webService static Boolean getDistinguishBetweenFinancial() {
        String userRoleId = UserInfo.getUserRoleId();
        Boolean whetherExported = false;
        UserRole userRole = [SELECT Name, Id FROM UserRole WHERE Id = :userRoleId];
        if (userRole.Name == '财务会计') {
            whetherExported = true;
        }
        return whetherExported;
    }
}