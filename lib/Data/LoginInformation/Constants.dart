class ApiConstants
{
    static String baseUrl = 'http://localhost:53197'; //pune office // 'http://192.168.1.6:8000';//My pc 
    static String endpoint_Login='/api/Login';  // get //masters api's
    static String endpoint_Employee='/api/Employee';  // get, get with ID, post , put, delete
    static String endpoint_Branch='/api/Company';  // get, get with ID, post , put, delete
    static String endpoint_Department='/api/Department';  // get,get with ID, post , put, delete
    static String endpoint_Designation='/api/Designation';  // get,get with ID, post , put, delete
    static String endpoint_Holiday='/api/Holiday';  // get,get with ID, post , put, delete
    static String endpoint_Location='/api/Location';  // get,get with ID, post , put, delete
    static String endpoint_Inventory='/api/Inventory';  // get,get with ID, post , put, delete
    static String endpoint_EmpType='/api/EmployeeType';  // get,get with ID, post , put, delete
    static String endpoint_Shift='/api/Shift';  // get,get with ID, post , put, delete
    static String endpoint_ShiftPattern='/api/ShiftPattern';  // get,get with ID, post , put, delete
    static String endpoint_SettingProfile='/api/SettingProfile';  // get,get with ID, post , put, delete
    static String endpoint_EmployeeViewSeachViaRange='/api/EmployeeView/GetListOfEmployeeViewWithRangeByEmployeeView';  // get with range
    static String endpoint_manualAttendance='/api/AttendanceRegularization';  // get, get with ID, post , put, delete
    static String endpoint_Device='/api/Device';  // get, get with ID, post , put, delete
    static String endpoint_ShiftMuster='/api/EmployeeShiftMuster';  // get, get with ID, post , put, delete
    static String endpoint_EmpTemporaryShift='/api/EmpTemporaryShift';  // get, get with ID, post , put, delete
    static String endpoint_EmpRegularShift='/api/EmpRegularShift';  // get, get with ID, post , put, delete
    // EmpRotationalWeeklyOff
    static String endpoint_EmpRotationalWeeklyOff='/api/EmpRotationalWeeklyOff';  // get, get with ID, post , put, delete
}