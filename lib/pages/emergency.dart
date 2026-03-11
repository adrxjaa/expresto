import 'package:expresto/core/theme/app_colors.dart';
import 'package:expresto/data/mock/emergency_mock_data.dart';
import 'package:expresto/models/emergency_session_data.dart';
import 'package:expresto/pages/bystander.dart';
import 'package:flutter/material.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cameraGlowController;

  @override
  void initState() {
    super.initState();
    _cameraGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cameraGlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const data = emergencyMockData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF090B10), Color(0xFF040507)],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.shell,
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(color: AppColors.shellBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x44000000),
                      blurRadius: 28,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _EmergencyHeader(data: data),
                      const SizedBox(height: 18),
                      Text(
                        data.callState,
                        style: const TextStyle(
                          color: AppColors.emergency,
                          fontSize: 29,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _CameraPanel(
                        animation: _cameraGlowController,
                        data: data,
                      ),
                      const SizedBox(height: 12),
                      _UrgencyPanel(data: data),
                      const SizedBox(height: 10),
                      _OperatorPanel(data: data),
                      const SizedBox(height: 10),
                      _ActionsPanel(data: data),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _BottomActionButton(
                              icon: '🚫',
                              label: 'Silent',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Silent mode screen comes next.',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _BottomActionButton(
                              icon: '👥',
                              label: 'Bystander',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BystanderPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyHeader extends StatelessWidget {
  const _EmergencyHeader({required this.data});

  final EmergencySessionData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Text('🚨', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                data.headerTag,
                style: const TextStyle(
                  color: AppColors.emergency,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        Text(
          data.timer,
          style: const TextStyle(
            color: AppColors.emergency,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _CameraPanel extends StatelessWidget {
  const _CameraPanel({required this.animation, required this.data});

  final Animation<double> animation;
  final EmergencySessionData data;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(animation.value);
        final glowColor =
            Color.lerp(const Color(0xFF0B5B37), const Color(0xFF1CFF8A), t) ??
            AppColors.success;

        return Container(
          height: 270,
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF0C7948)),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF04191A), Color(0xFF03151B), Color(0xFF071114)],
            ),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.22),
                blurRadius: 34,
                spreadRadius: -3,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        );
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🤟', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    data.liveIndicator,
                    style: const TextStyle(
                      color: Color(0xFF15DF6D),
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 160,
              height: 118,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF13C86C), width: 2),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(top: 74),
              child: _AvatarPreview(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Text(
                data.cameraHint,
                style: const TextStyle(
                  color: Color(0xFF1CFF8A),
                  fontSize: 18,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF1D1D28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF36354C), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Center(child: Text('🎭', style: TextStyle(fontSize: 30))),
    );
  }
}

class _UrgencyPanel extends StatelessWidget {
  const _UrgencyPanel({required this.data});

  final EmergencySessionData data;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      borderColor: AppColors.emergencyBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.urgencyLabel,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F1D29),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4F59),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      data.urgencyStatus,
                      style: const TextStyle(
                        color: Color(0xFFFF4F59),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${data.urgencyPercent}%',
            style: const TextStyle(
              color: AppColors.emergency,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.urgencyBars
                  .map(
                    (bar) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          height: bar * 3.2,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8E3249),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OperatorPanel extends StatelessWidget {
  const _OperatorPanel({required this.data});

  final EmergencySessionData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF096E3E)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF021B14), Color(0xFF03110D), Color(0xFF041810)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🗣️', style: TextStyle(fontSize: 14)),
              SizedBox(width: 6),
              Text(
                'OPERATOR RESPONSE',
                style: TextStyle(
                  color: Color(0xFF1CFF8A),
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '🚑 ${data.operatorTitle}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.0,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '⏱ ${data.operatorEta}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsPanel extends StatelessWidget {
  const _ActionsPanel({required this.data});

  final EmergencySessionData data;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✅ ${data.actionsTitle}',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(data.actions.length, (index) {
            final action = data.actions[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: index == data.actions.length - 1
                      ? BorderSide.none
                      : const BorderSide(color: AppColors.divider),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    child: Text(
                      action.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      action.label,
                      style: const TextStyle(
                        color: Color(0xFFC9C9DA),
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _BottomActionButton extends StatelessWidget {
  const _BottomActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.panelSoft,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.shellBorder.withValues(alpha: 0.7),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({this.borderColor, required this.child});

  final Color? borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.panelSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor ?? AppColors.shellBorder),
      ),
      child: child,
    );
  }
}
