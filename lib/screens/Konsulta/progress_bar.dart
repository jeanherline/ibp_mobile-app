import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CustomProgressBar(
      {required this.currentStep, required this.totalSteps, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        bool isCurrentStep = index == currentStep;
        bool isCompletedStep = index < currentStep;
        return Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: isCurrentStep || isCompletedStep
                  ? Colors.amber
                  : Colors.grey[300],
            ),
            if (index != totalSteps - 1)
              Container(
                width: 30,
                height: 2,
                color: isCompletedStep ? Colors.amber : Colors.grey[300],
              ),
          ],
        );
      }),
    );
  }
}
