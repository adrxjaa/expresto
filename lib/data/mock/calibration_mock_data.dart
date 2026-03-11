import 'package:expresto/core/theme/app_colors.dart';
import 'package:expresto/models/calibration_data.dart';

const CalibrationData calibrationMockData = CalibrationData(
  currentStep: 2,
  totalSteps: 3,
  progress: 0.67,
  progressText: '67%',
  instructionText: 'We play increasingly urgent sounds. Sign words while listening — this builds your panic profile.',
  
  audioStateIcon: '🚨',
  audioStateText: 'AUDIO PLAYING · HIGH',
  audioBars: [12.0, 20.0, 16.0, 24.0, 14.0, 22.0],

  signPromptLabel: 'SIGN THIS WORD',
  signWord: 'HELP',

  detectionStatusIcon: '✅',
  detectionStatusText: 'Detected! Next word in 3s...',

  changesCardTitle: 'DETECTED CHANGES VS NORMAL',
  detectedChanges: [
    DetectedChange(label: 'Signing speed', value: '2.3× faster ↑', valueColor: AppColors.warning),
    DetectedChange(label: 'Hand tremor', value: '+35% ↑', valueColor: AppColors.warning),
    DetectedChange(label: 'Facial tension', value: 'High ↑', valueColor: AppColors.warning),
    DetectedChange(label: 'Words captured', value: '8/15 ✅', valueColor: AppColors.success),
  ],
);
