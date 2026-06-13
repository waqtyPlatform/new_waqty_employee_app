enum ChangePinStep { currentPin, newPin, confirmPin }

class ChangePinStepData {
  final ChangePinStep step;
  final int stepIndex;
  final String titleKey;
  final String subtitleKey;
  final String hintKey;
  final List<String> visibleDigits;
  final int activeInputIndex;

  const ChangePinStepData({
    required this.step,
    required this.stepIndex,
    required this.titleKey,
    required this.subtitleKey,
    required this.hintKey,
    required this.visibleDigits,
    required this.activeInputIndex,
  });

  factory ChangePinStepData.fromStep(ChangePinStep step) {
    switch (step) {
      case ChangePinStep.currentPin:
        return const ChangePinStepData(
          step: ChangePinStep.currentPin,
          stepIndex: 0,
          titleKey: 'changePin.currentPin',
          subtitleKey: 'changePin.currentPinSubtitle',
          hintKey: 'changePin.currentPinHint',
          visibleDigits: ['', '', '', ''],
          activeInputIndex: -1,
        );
      case ChangePinStep.newPin:
        return const ChangePinStepData(
          step: ChangePinStep.newPin,
          stepIndex: 1,
          titleKey: 'changePin.newPin',
          subtitleKey: 'changePin.newPinSubtitle',
          hintKey: 'changePin.newPinHint',
          visibleDigits: ['1', '2', '3', ''],
          activeInputIndex: 3,
        );
      case ChangePinStep.confirmPin:
        return const ChangePinStepData(
          step: ChangePinStep.confirmPin,
          stepIndex: 2,
          titleKey: 'changePin.confirmPin',
          subtitleKey: 'changePin.confirmPinSubtitle',
          hintKey: 'changePin.confirmPinHint',
          visibleDigits: ['1', '2', '3', ''],
          activeInputIndex: 3,
        );
    }
  }
}
