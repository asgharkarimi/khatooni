import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonType type;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    
    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: type == ButtonType.primary ? Colors.white : Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(icon, size: 24),
          ),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );

    if (isFullWidth) {
      buttonChild = Center(child: buttonChild);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 56,
        width: isFullWidth ? double.infinity : null,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        ),
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        );
      
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.primary),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        );
        
      case ButtonType.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.primary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        );
    }
  }
}

enum ButtonType {
  primary,
  secondary,
  text,
} 