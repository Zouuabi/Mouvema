import 'package:flutter/material.dart';
import '../../core/errors/auth_error.dart';

/// A widget that displays password strength with visual indicators
class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: strength.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: strength.color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security_rounded,
                      size: 16,
                      color: strength.color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Password Strength',
                      style: TextStyle(
                        fontSize: 12,
                        color: strength.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: strength.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        strength.label,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: LinearProgressIndicator(
                    value: _getStrengthValue(),
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(strength.color),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 12),
                _buildRequirements(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getStrengthValue() {
    switch (strength) {
      case PasswordStrength.empty:
        return 0.0;
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.65;
      case PasswordStrength.strong:
        return 1.0;
    }
  }

  Widget _buildRequirements() {
    final requirements = [
      _RequirementItem(
        text: 'At least 8 characters',
        isMet: password.length >= 8,
      ),
      _RequirementItem(
        text: 'Contains uppercase letter',
        isMet: password.contains(RegExp(r'[A-Z]')),
      ),
      _RequirementItem(
        text: 'Contains lowercase letter',
        isMet: password.contains(RegExp(r'[a-z]')),
      ),
      _RequirementItem(
        text: 'Contains number',
        isMet: password.contains(RegExp(r'[0-9]')),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements.map((req) => req).toList(),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  final bool isMet;

  const _RequirementItem({
    required this.text,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                key: ValueKey(isMet),
                size: 16,
                color: isMet ? Colors.green : Colors.grey.shade500,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 12,
                  color: isMet ? Colors.green : Colors.grey.shade600,
                  fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
                ),
                child: Text(text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}