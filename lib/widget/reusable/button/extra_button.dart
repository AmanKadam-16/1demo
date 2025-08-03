import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/reusable_widget_controller/extra_button_controller.dart';
import 'package:time_attendance/model/reusable_widget_model/extra_button_model.dart';

class ExtraButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final int index;
  final ButtonController controller;
  final Color defaultColor;
  final Color hoverColor;
  final Color textColor;
  final Color hoverTextColor;
  
   ExtraButton({
    required this.text,
    required this.onPressed,
    required this.index,
    required this.controller,
    this.width = 150,
    this.height = 50,
    this.defaultColor = Colors.white,
    this.hoverColor = Colors.transparent, // This will be overridden by theme
    this.textColor = Colors.black,
    this.hoverTextColor = Colors.black,
  });
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => MouseRegion(
      onEnter: (_) => controller.setHover(index, true),
      onExit: (_) => controller.setHover(index, false),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.hoverStates[index] 
              ? Theme.of(context).colorScheme.secondaryContainer 
              : Colors.white,
          foregroundColor: controller.hoverStates[index] 
              ? Colors.black
              : Colors.black,
          minimumSize: Size(width, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
              width: 1,
            ),
          ),
          elevation: controller.hoverStates[index] ? 5 : 2,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ));
  }
}

// Usage Example
class ButtonExample extends StatelessWidget {
  ButtonExample({Key? key}) : super(key: key);
  
  final ButtonController buttonController = Get.put(ButtonController());
  
  @override
  Widget build(BuildContext context) {
    final List<ButtonData> buttonData = [
      ButtonData(text: 'Button 1', onPressed: () => print('Button 1 pressed')),
      ButtonData(text: 'Button 2', onPressed: () => print('Button 2 pressed')),
      ButtonData(text: 'Button 3', onPressed: () => print('Button 3 pressed')),
      ButtonData(text: 'Button 4', onPressed: () => print('Button 4 pressed')),
    ];
    
    buttonController.initializeButtons(buttonData.length);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Reusable Buttons'),
      ),
      body: Center(
        child: Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: List.generate(
            buttonData.length,
            (index) => ExtraButton(
              text: buttonData[index].text,
              onPressed: () => buttonData[index].onPressed(),
              index: index,
              controller: buttonController,
              hoverColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}