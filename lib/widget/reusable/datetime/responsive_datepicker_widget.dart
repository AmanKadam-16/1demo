// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:time_attendance/controller/reusable_widget_controller/date_picker_controller.dart';
// class ResponsiveDatePickerWidget extends StatelessWidget {
//   const ResponsiveDatePickerWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<DatePickerController>(
//       init: DatePickerController(),
//       builder: (controller) {
//         return LayoutBuilder(
//           builder: (context, constraints) {
//             // Determine if it's a mobile or desktop layout
//             bool isMobile = constraints.maxWidth < 600;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 if (isMobile) _buildMobileDatePickers(controller)
//                 else _buildDesktopDatePickers(controller),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildMobileDatePickers(DatePickerController controller) {
//     return Column(
//       children: [
//         _buildDatePickerField(
//           context: Get.context!,
//           label: 'Start Date *',
//           date: controller.formattedStartDate,
//           onTap: () => _selectDate(
//             context: Get.context!, 
//             initialDate: controller.startDate.value, 
//             onDateSelected: controller.updateStartDate
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildDatePickerField(
//           context: Get.context!,
//           label: 'End Date *',
//           date: controller.formattedEndDate,
//           onTap: () => _selectDate(
//             context: Get.context!, 
//             initialDate: controller.endDate.value, 
//             onDateSelected: controller.updateEndDate
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDesktopDatePickers(DatePickerController controller) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildDatePickerField(
//             context: Get.context!,
//             label: 'Start Date *',
//             date: controller.formattedStartDate,
//             onTap: () => _selectDate(
//               context: Get.context!, 
//               initialDate: controller.startDate.value, 
//               onDateSelected: controller.updateStartDate
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: _buildDatePickerField(
//             context: Get.context!,
//             label: 'End Date *',
//             date: controller.formattedEndDate,
//             onTap: () => _selectDate(
//               context: Get.context!, 
//               initialDate: controller.endDate.value, 
//               onDateSelected: controller.updateEndDate
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDatePickerField({
//     required BuildContext context,
//     required String label,
//     required String date,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//             ),
//             Text(
//               date,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate({
//     required BuildContext context,
//     required DateTime initialDate,
//     required Function(DateTime) onDateSelected,
//   }) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null) {
//       onDateSelected(picked);
//     }
//   }
// }