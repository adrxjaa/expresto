import 'package:expresto/core/theme/app_colors.dart';
import 'package:expresto/data/mock/bystander_mock_data.dart';
import 'package:expresto/models/bystander_data.dart';
import 'package:expresto/widgets/camera_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BystanderPage extends StatefulWidget {
  const BystanderPage({super.key});

  @override
  State<BystanderPage> createState() => _BystanderPageState();
}

class _BystanderPageState extends State<BystanderPage> {
  late final TextEditingController _messageController;
  bool _showAvatar = true;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(
      text: bystanderMockData.operatorMessage,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const data = bystanderMockData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF090B10), Color(0xFF040507)],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              children: [
                _Header(
                  title: data.title,
                  onExit: () => Navigator.pop(context),
                ),
                const SizedBox(height: 16),
              
                _BystanderCameraPanel(data: data, showAvatar: _showAvatar),
                const SizedBox(height: 14),
                _TranscriptPanel(data: data),
                const SizedBox(height: 14),
                _MessageComposer(
                  controller: _messageController,
                  label: 'SEND MESSAGE TO AVATAR',
                  hintText: data.inputHint,
                  onSend: () {
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message sent to avatar.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                _AvatarPanel(
                  showAvatarLabel: data.showAvatarLabel,
                  value: _showAvatar,
                  onChanged: (value) => setState(() => _showAvatar = value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onExit});

  final String title;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.groups_rounded, color: AppColors.blue, size: 26),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
        ),
        TextButton(
          onPressed: onExit,
          style: TextButton.styleFrom(
            backgroundColor: AppColors.panel,
            foregroundColor: AppColors.textMuted,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Exit'),
        ),
      ],
    );
  }
}

class _AlertStrip extends StatelessWidget {
  const _AlertStrip({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0C2340),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1C69B8)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.blue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF79BAFF),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.data});

  final BystanderData data;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      borderColor: AppColors.emergencyBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notification_important_rounded,
                color: AppColors.emergency,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                data.summaryTitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(data.summaryItems.length, (index) {
            final item = data.summaryItems[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: index == data.summaryItems.length - 1
                      ? BorderSide.none
                      : const BorderSide(color: AppColors.divider),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    item.value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF153421),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_hospital_rounded,
                  color: AppColors.textPrimary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.arrivalMessage,
                    style: const TextStyle(
                      color: Color(0xFF3AE06C),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BystanderCameraPanel extends StatelessWidget {
  const _BystanderCameraPanel({required this.data, required this.showAvatar});

  final BystanderData data;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      borderColor: const Color(0xFF1B5CA7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.videocam_rounded, color: AppColors.blue, size: 18),
              const SizedBox(width: 8),
              const Text(
                'LIVE CAMERA',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  letterSpacing: 2.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Text(
                'LIVE',
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CameraPreviewWidget(
            height: 400,
            fallbackText: 'CAMERA ACTIVE — LIVE VIEW',
            overlay: showAvatar
                ? const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 12, bottom: 12),
                      child: _BystanderAvatarPiP(),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class _BystanderAvatarPiP extends StatelessWidget {
  const _BystanderAvatarPiP();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF1D1D28).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F62A8), width: 2),
      ),
      child: const Center(
        child: Icon(
          Icons.interpreter_mode_rounded,
          color: AppColors.textPrimary,
          size: 34,
        ),
      ),
    );
  }
}

class _TranscriptPanel extends StatelessWidget {
  const _TranscriptPanel({required this.data});

  final BystanderData data;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.chat_bubble_rounded,
                color: AppColors.textMuted,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'TRANSCRIPT',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  letterSpacing: 2.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(data.instructions.length, (index) {
            final isDeafMessage = index.isEven;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDeafMessage ? const Color(0xFF122A45) : const Color(0xFF161B26),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDeafMessage ? const Color(0xFF1C69B8) : AppColors.shellBorder,
                  ),
                ),
                child: Text(
                  data.instructions[index],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.onSend,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: const Color(0xFF0C0F17),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.shellBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.shellBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.blue),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onSend,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Send'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPanel extends StatelessWidget {
  const _AvatarPanel({
    required this.showAvatarLabel,
    required this.value,
    required this.onChanged,
  });

  final String showAvatarLabel;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.shellBorder),
            ),
            child: const Icon(
              Icons.interpreter_mode_rounded,
              color: AppColors.textPrimary,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              showAvatarLabel,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.blue,
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.borderColor});

  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.panelSoft,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor ?? AppColors.shellBorder),
      ),
      child: child,
    );
  }
}
