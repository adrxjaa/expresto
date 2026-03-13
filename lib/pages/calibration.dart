import 'dart:async';
import 'dart:math' as math;

import 'package:expresto/core/theme/app_colors.dart';
import 'package:expresto/data/mock/calibration_mock_data.dart';
import 'package:expresto/models/calibration_data.dart';
import 'package:expresto/widgets/camera_preview_widget.dart';
import 'package:flutter/material.dart';

class CalibrationPage extends StatefulWidget {
  const CalibrationPage({super.key});

  @override
  State<CalibrationPage> createState() => _CalibrationPageState();
}

class _CalibrationPageState extends State<CalibrationPage> {
  Timer? _waveTimer;
  final List<double> _waveSamples = List<double>.filled(36, 0.08);
  static const double _silenceBaseline = 0.08;
  double _smoothedLevel = 0.42;
  double _targetLevel = 0.42;
  double _waveSpeed = 0.4;
  double _wavePhase = 0;
  bool _isAudioPlaying = true;

  @override
  void initState() {
    super.initState();
    _startWaveTicker();
  }

  void _toggleAudioPlayback() {
    setState(() {
      _isAudioPlaying = !_isAudioPlaying;
      if (_isAudioPlaying) {
        _targetLevel = 0.48;
        _waveSpeed = 0.4;
      } else {
        _targetLevel = _silenceBaseline;
        _waveSpeed = 0;
      }
    });
  }

  void _replayAudio() {
    setState(() {
      _isAudioPlaying = true;
      _wavePhase = 0;
      _targetLevel = 0.52;
      _waveSpeed = 0.42;
    });
  }

  void _startWaveTicker() {
    _waveTimer?.cancel();
    _waveTimer = Timer.periodic(const Duration(milliseconds: 70), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        if (!_isAudioPlaying) {
          for (var i = 0; i < _waveSamples.length; i++) {
            _waveSamples[i] = _silenceBaseline;
          }
          _targetLevel = _silenceBaseline;
          _smoothedLevel = _silenceBaseline;
          _waveSpeed = 0.0;
          return;
        }

        _targetLevel = 0.36 + ((math.sin(_wavePhase * 0.5) + 1) * 0.14);
        _smoothedLevel = (_smoothedLevel * 0.82) + (_targetLevel * 0.18);
        _wavePhase += _waveSpeed;

        for (var i = 0; i < _waveSamples.length; i++) {
          final x = i / (_waveSamples.length - 1);
          final base = 0.1;
          final primary = math.sin((x * 8.5) + _wavePhase) * 0.55;
          final secondary = math.sin((x * 18.0) + (_wavePhase * 1.8)) * 0.28;
          final shimmer = math.sin((x * 33.0) + (_wavePhase * 2.7)) * 0.08;
          final combined = primary + secondary + shimmer;

          final amplitude = (0.12 + (_smoothedLevel * 0.78)).clamp(0.12, 0.95);
          final sample = (base + (combined.abs() * amplitude)).clamp(0.06, 1.0);
          _waveSamples[i] = sample;
        }

      });
    });
  }

  @override
  void dispose() {
    _waveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = calibrationMockData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, data),
            _buildProgressStrip(data),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildIntroCard(data),
                  const SizedBox(height: 12),
                  _buildStressSimulationCard(data),
                  const SizedBox(height: 12),
                  _buildDetectedChangesCard(data),
                  const SizedBox(height: 24),
                  _buildControlButtons(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, CalibrationData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.shellBorder),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.track_changes,
                color: AppColors.textPrimary,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Calibration',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Text(
            '${data.currentStep} / ${data.totalSteps}',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStrip(CalibrationData data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Stress Simulation',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              Text(
                data.progressText,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.shellBorder,
              borderRadius: BorderRadius.circular(100),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: data.progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: const LinearGradient(
                    colors: [AppColors.emergency, AppColors.warning],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard(CalibrationData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.shellBorder),
      ),
      child: Text(
        data.instructionText,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildStressSimulationCard(CalibrationData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _buildAudioIndicator(data),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.shellBorder.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  data.signPromptLabel,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.signWord,
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const CameraPreviewWidget(
            height: 270,
            fallbackText: 'CAMERA ACTIVE — RECOGNIZING',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                data.detectionStatusIcon,
                color: AppColors.success,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                data.detectionStatusText,
                style: const TextStyle(color: AppColors.success, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioIndicator(CalibrationData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.audioStateIcon, color: AppColors.warning, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.audioStateText,
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Text(
                '${(_smoothedLevel * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.warning,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 64,
              color: AppColors.background.withValues(alpha: 0.45),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: CustomPaint(
                painter: _LiveWavePainter(
                  samples: List<double>.from(_waveSamples),
                  color: AppColors.warning,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isAudioPlaying ? 'AUDIO PLAYING' : 'AUDIO PAUSED',
                style: TextStyle(
                  color: _isAudioPlaying ? AppColors.success : AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: _toggleAudioPlayback,
                    child: Text(_isAudioPlaying ? 'Pause Audio' : 'Play Audio'),
                  ),
                  TextButton(
                    onPressed: _replayAudio,
                    child: const Text('Replay Audio'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedChangesCard(CalibrationData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.shellBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.changesCardTitle,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              letterSpacing: 1.5,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 16),
          ...data.detectedChanges.asMap().entries.map((entry) {
            final change = entry.value;
            final isLast = entry.key == data.detectedChanges.length - 1;
            return _buildChangeRow(
              change.label,
              change.value,
              change.valueColor,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChangeRow(
    String label,
    String value,
    Color valueColor, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _toggleAudioPlayback,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.shellBorder),
              ),
              alignment: Alignment.center,
              child: Text(
                _isAudioPlaying ? 'Pause Audio' : 'Resume Audio',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _replayAudio,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.shellBorder.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.shellBorder),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Replay Audio',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LiveWavePainter extends CustomPainter {
  const _LiveWavePainter({required this.samples, required this.color});

  final List<double> samples;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) {
      return;
    }

    final centerY = size.height / 2;
    final widthStep = size.width / (samples.length - 1);
    final path = Path()..moveTo(0, centerY);

    for (var i = 0; i < samples.length; i++) {
      final x = widthStep * i;
      final amplitude = (samples[i] * centerY * 0.95).clamp(2.0, centerY);
      final y = centerY - amplitude;
      path.lineTo(x, y);
    }

    for (var i = samples.length - 1; i >= 0; i--) {
      final x = widthStep * i;
      final amplitude = (samples[i] * centerY * 0.95).clamp(2.0, centerY);
      final y = centerY + amplitude;
      path.lineTo(x, y);
    }

    path.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.75),
          color.withValues(alpha: 0.15),
        ],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..isAntiAlias = true;

    canvas.drawPath(path, fillPaint);

    final topLine = Path()..moveTo(0, centerY);
    for (var i = 0; i < samples.length; i++) {
      final x = widthStep * i;
      final amplitude = (samples[i] * centerY * 0.95).clamp(2.0, centerY);
      topLine.lineTo(x, centerY - amplitude);
    }
    canvas.drawPath(topLine, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _LiveWavePainter oldDelegate) {
    if (oldDelegate.color != color || oldDelegate.samples.length != samples.length) {
      return true;
    }
    for (var i = 0; i < samples.length; i++) {
      if (oldDelegate.samples[i] != samples[i]) {
        return true;
      }
    }
    return false;
  }
}
