import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/accessibility_provider.dart';

class AccessibilityScreen extends ConsumerWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(fontSizeProvider);
    final highContrast = ref.watch(highContrastProvider);
    final textToSpeech = ref.watch(textToSpeechProvider);

    return Scaffold(
      appBar: AppBar(
        title: LocaleText('accessibility'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.1),
                    AppTheme.secondaryGreen.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.accessibility_new,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocaleText(
                          'accessibility',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Customize your experience',
                          style: TextStyle(
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Font Size Control
            _AccessibilityCard(
              icon: Icons.text_fields,
              title: 'font_size',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'A',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppTheme.primaryGreen,
                            inactiveTrackColor:
                                AppTheme.primaryGreen.withOpacity(0.3),
                            thumbColor: AppTheme.beigeAccent,
                            overlayColor: AppTheme.beigeAccent.withOpacity(0.2),
                            trackHeight: 6,
                          ),
                          child: Slider(
                            value: fontSize,
                            min: 0.8,
                            max: 1.4,
                            divisions: 6,
                            onChanged: (value) {
                              ref.read(fontSizeProvider.notifier).state = value;
                            },
                          ),
                        ),
                      ),
                      Text(
                        'A',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      'Current size: ${(fontSize * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // High Contrast Toggle
            _AccessibilityCard(
              icon: Icons.contrast,
              title: 'high_contrast',
              child: SwitchListTile(
                value: highContrast,
                onChanged: (value) {
                  ref.read(highContrastProvider.notifier).state = value;
                },
                title: Text(
                  highContrast ? 'Enabled' : 'Disabled',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                subtitle: Text(
                  highContrast
                      ? 'High contrast mode is active'
                      : 'Tap to enable high contrast',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                activeColor: AppTheme.primaryGreen,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 20),

            // Text to Speech Toggle
            _AccessibilityCard(
              icon: Icons.record_voice_over,
              title: 'text_to_speech',
              child: SwitchListTile(
                value: textToSpeech,
                onChanged: (value) {
                  ref.read(textToSpeechProvider.notifier).state = value;
                  if (value) {
                    _showTTSDialog(context);
                  }
                },
                title: Text(
                  textToSpeech ? 'Enabled' : 'Disabled',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                subtitle: Text(
                  textToSpeech
                      ? 'Text-to-speech is active'
                      : 'Tap to enable text-to-speech',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                activeColor: AppTheme.primaryGreen,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 32),

            // Preview Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: highContrast
                    ? Colors.black
                    : AppTheme.primaryGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: highContrast
                      ? Colors.white
                      : AppTheme.primaryGreen.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              highContrast ? Colors.white : AppTheme.primaryGreen,
                          fontSize: 22 * fontSize,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This is how text will appear with your current accessibility settings. Adjust the controls above to customize your experience.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              highContrast ? Colors.white : AppTheme.darkGray,
                          fontSize: 16 * fontSize,
                          height: 1.6,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(fontSizeProvider.notifier).state = 1.0;
                  ref.read(highContrastProvider.notifier).state = false;
                  ref.read(textToSpeechProvider.notifier).state = false;
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset to Default'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTTSDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.record_voice_over, color: AppTheme.primaryGreen),
            SizedBox(width: 12),
            Text('Text-to-Speech'),
          ],
        ),
        content: const Text(
          'Text-to-speech is now enabled. The screen will read content aloud as you navigate.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _AccessibilityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _AccessibilityCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.beigeAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LocaleText(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
