import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (index) {
            return CircleAvatar(
              radius: 18,
              backgroundColor:
                  index <= currentStep
                      ? Colors.green
                      : Colors.grey.shade300,
              child: Text(
                "${index + 1}",
                style: TextStyle(
                  color:
                      index <= currentStep
                          ? Colors.white
                          : Colors.black54,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}