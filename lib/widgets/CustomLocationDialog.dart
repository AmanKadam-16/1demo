

// import 'package:flutter/material.dart';
// import '../Models/Masters/talocation.dart';

// class Constants{
//   Constants._();
//   static const double padding =20;
//   static const double avatarRadius =45;
// }
// class CustomLocationDialogBox extends StatefulWidget {
//   const CustomLocationDialogBox({super.key,required this.mLocationInfo});
//    final TALocation mLocationInfo;



//   @override
//   _CustomLocationDialogBoxState createState() => _CustomLocationDialogBoxState();
// }

// class _CustomLocationDialogBoxState extends State<CustomLocationDialogBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(Constants.padding),
//       ),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: contentBox(context),
//     );
//   }
//   contentBox(context){
//     return Stack(
//       children: <Widget>[
//         Container(
//           padding: const EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
//               + Constants.padding, right: Constants.padding,bottom: Constants.padding
//           ),
//           margin: const EdgeInsets.only(top: Constants.avatarRadius),
//           decoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(Constants.padding),
//               boxShadow: const [
//                 BoxShadow(color: Colors.black,offset: Offset(0,10),
//                     blurRadius: 10
//                 ),
//               ]
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text(widget.mLocationInfo.LocationName,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
//               const SizedBox(height: 15,),
//               Text("Latitude:"+ widget.mLocationInfo.Latitude  +'\n'+ "Longitude:"+ widget.mLocationInfo.Longitude
//                   +"\nAddress: "+ widget.mLocationInfo.Address,style: const TextStyle(fontSize: 14),textAlign: TextAlign.center,),
//               const SizedBox(height: 22,),
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: TextButton(
//                     onPressed: (){
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('Ok',style: TextStyle(fontSize: 18,color: Colors.blueAccent,fontWeight: FontWeight.bold  ),)),
//               ),
//             ],
//           ),
//         ),

//       ],
//     );
//   }
// }