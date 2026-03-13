import 'package:expresto/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SignKitAvatarPiP extends StatelessWidget {
  const SignKitAvatarPiP({
    super.key,
    required this.assetPath,
    this.predictedSign,
  });

  final String assetPath;
  final String? predictedSign;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: Color(0xFF0F1620),
                child: Center(
                  child: Icon(
                    Icons.interpreter_mode_rounded,
                    color: AppColors.textPrimary,
                    size: 34,
                  ),
                ),
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.06),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.32),
                ],
              ),
            ),
          ),
          if (predictedSign != null && predictedSign!.trim().isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: Colors.black.withValues(alpha: 0.52),
                child: Text(
                  predictedSign!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
