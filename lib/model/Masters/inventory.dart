class Inventory
{
  String _InventoryID=""  ;
  String _InventoryName="";

  String get InventoryID => _InventoryID;
  set InventoryID(strInventoryID){_InventoryID=strInventoryID;}
  String get InventoryName => _InventoryName;
  set InventoryName(strInventoryName){_InventoryName=strInventoryName;}

  Inventory({ String InventoryID='',String InventoryName=''})
  {
    _InventoryID=InventoryID  ;
    _InventoryName=InventoryName;
  }

  Inventory.fromJson(dynamic json) {
    _InventoryID=json['InventoryID']  ;
    _InventoryName=json['InventoryName'];
  }
  Map<String, dynamic> toJson()
  {    final map = <String, dynamic>{};
  map['InventoryID']= _InventoryID ;
  map['InventoryName']=_InventoryName;
  return map;
  }
}