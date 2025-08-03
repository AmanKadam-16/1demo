

enum UserInsigniaForms
{


  TA_Masters ,//menu
  TA_Masters_Company ,//form // Branch ToDo: 
  TA_Masters_Department ,//form
  TA_Masters_Designation ,//form
  TA_Masters_Location ,//form
  TA_Masters_Holiday ,//form

  TA_Additional,//menu
  TA_EmployeeType,//form // Employee Type -- Interns , Full-time,Casual,Leased employees,Apprentices  etc, add  edit delete // currently implementation pending
  TA_Inventory , //form //Company Resources items (add update delete)  which will assigned to employees // currently implementation pending

  TA_Shift ,//menu
  TA_Shift_Shift ,//form
  TA_Shift_ShiftPattern ,//form

  TA_Leave, //menu
  TA_Leave_LeaveType,//form
  TA_Leave_LeavePolicy,//form

  TA_Employee ,//menu
  TA_Employee_Details ,//form
  TA_Employee_Setting ,//form // this should be small group of settings assigned to selected employees (now entire setting updated -need to divide in small groups)
  TA_EmployeeShift_RegularTemporaryOrCSV ,//form //regular or Temporary and Temporary CSV will be merged together later
  TA_EmployeeWeeklyOff_RegularRotationalOrCSV ,//form//regular or Rotational and Rotational CSV will be merged together later

  TA_EmployeeAdditionalSetting ,//menu
  TA_Employee_BulkAddEditDelete ,//form // upload, edit and delete will marge in One form later
  TA_Employee_EmployeeLogin ,//form //edit password, rights geo Locations etc
  TA_Employee_EmployeeNonBiometricSettings ,//form //mobile phone users approval etc
  TA_Employee_Inventory ,//form //Cpmoany Resources allocated to Employee

  TA_DataEntry ,//menu
  TA_Leave_EmpLeavePolicy,// sub menu
  TA_Leave_EmpLeavePolicyBulk ,//form
  TA_Leave_EmpLeavePolicyIndividual , //form
  TA_Leave_LeaveApplication , //sub menu
  TA_Leave_EmpLeaveApplication ,//form // create approve or reject according to rights
  TA_Leave_EmpLeaveApplicationApproval ,//form // quick approve or reject according to rights. here leave application can not be edited
  TA_Leave_EmpLeaveCarryforward,// form //leave carry forwards

  TA_EmployeeManual ,//sub menu
  TA_EmployeeManual_Create ,//form
  TA_EmployeeManual_Approval ,//form
  TA_EmployeeManual_BulkAssignment ,//form

  TA_EmployeeOutDoor,//sub menu
  TA_EmployeeOutDoor_Create,//form  // out door is actually punch record added in Log table for considering that punch in attendance calculation
  TA_EmployeeOutDoor_Approval ,//form

  TA_EmployeeTour ,   // sub menu
  TA_EmployeeTour_Create , // form// pending,
  TA_EmployeeTour_Approval ,// form// pending


  TA_HouseKeeping ,//menu
  TA_HouseKeeping_Device ,//form
  TA_HouseKeeping_DownloadLogsDeviceUsbOrCSV ,//form
  TA_HouseKeeping_DataProcessing , //form

  TA_MenuAdmin ,//menu
  TA_Admin_User ,//form

  TA_Reports ,//menu
  TA_Reports_Master ,//form  // will include reports of inventory items and Employee Type
  TA_Reports_Shift ,//form
  TA_Reports_Leave ,//form //Leave policy , leave Balance , Leave Type details  not related to employee
  TA_Reports_Employee,  //form // employee details personal, inventory,
  TA_Reports_Attendance , //form // will also include employees Leave application, rejected and OD and Tour reports etc
  TA_Reports_Miscellaneous,// form // Log each thing in Db, create , edit update by which login , every thing in detail, status -- working

  TA_About// menu  // insignia Details copy rights

}
