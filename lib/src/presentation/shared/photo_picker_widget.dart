import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/errors/auth_error.dart';

/// Modern photo picker widget with avatar display
class PhotoPickerWidget extends StatefulWidget {
  final Uint8List? selectedImage;
  final ValueChanged<Uint8List?>? onImageSelected;
  final AuthError? error;
  final VoidCallback? onClearError;
  final bool enabled;
  final String? placeholder;

  const PhotoPickerWidget({
    super.key,
    this.selectedImage,
    this.onImageSelected,
    this.error,
    this.onClearError,
    this.enabled = true,
    this.placeholder,
  });

  @override
  State<PhotoPickerWidget> createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.error != null;

    return Column(
      children: [
        Text(
          'Profile Photo',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasError
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: widget.selectedImage != null
                      ? Image.memory(
                          widget.selectedImage!,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        )
                      : Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.person_rounded,
                            size: 60,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: InkWell(
                    onTap: widget.enabled ? _showImageSourceDialog : null,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.selectedImage != null
                            ? Icons.edit_rounded
                            : Icons.add_a_photo_rounded,
                        color: theme.colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.selectedImage != null
              ? 'Tap to change photo'
              : 'Tap to add photo (optional)',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 12),
          _buildErrorMessage(),
        ],
      ],
    );
  }

  Future<void> _showImageSourceDialog() async {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Select Photo',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSourceOption(
                            context,
                            'Camera',
                            Icons.camera_alt_rounded,
                            () => _pickImage(ImageSource.camera),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSourceOption(
                            context,
                            'Gallery',
                            Icons.photo_library_rounded,
                            () => _pickImage(ImageSource.gallery),
                          ),
                        ),
                      ],
                    ),
                    if (widget.selectedImage != null) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: _removeImage,
                          icon: const Icon(Icons.delete_rounded),
                          label: const Text('Remove Photo'),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // Close the bottom sheet
    
    if (widget.error != null) {
      widget.onClearError?.call();
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        widget.onImageSelected?.call(imageBytes);
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeImage() {
    Navigator.pop(context); // Close the bottom sheet
    widget.onImageSelected?.call(null);
  }

  Widget _buildErrorMessage() {
    final theme = Theme.of(context);
    final error = widget.error!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: error.severity.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: error.severity.color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              error.severity.icon,
              size: 16,
              color: error.severity.color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error.userMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: error.severity.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}