import 'package:flutter/material.dart';
import '../../models/classification_result.dart';
import '../theme/app_theme.dart';
import 'clay.dart';

String binName(String category) {
  return switch (category.toLowerCase()) {
    'organik' => 'Wadah hijau',
    'non-organik' => 'Wadah kuning',
    _ => 'Wadah merah atau abu-abu',
  };
}

class ResultTicket extends StatelessWidget {
  const ResultTicket({super.key, required this.result});

  final ClassificationResult result;

  @override
  Widget build(BuildContext context) {
    final accent =
        Theme.of(context).extension<BinColors>()!.forCategory(result.category);
    final scheme = Theme.of(context).colorScheme;

    return ClaySurface(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TicketHeader(result: result, accent: accent),
          const SizedBox(height: 14),
          _TicketSteps(steps: result.instructions, accent: accent, scheme: scheme),
        ],
      ),
    );
  }
}

class _TicketHeader extends StatelessWidget {
  const _TicketHeader({required this.result, required this.accent});

  final ClassificationResult result;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final percent = (result.confidence * 100).round();

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${binName(result.category)} \u00b7 ${result.category}',
                  style: textTheme.labelLarge?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  result.subcategory,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$percent%',
                style: textTheme.headlineMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text('keyakinan', style: textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _TicketSteps extends StatelessWidget {
  const _TicketSteps({
    required this.steps,
    required this.accent,
    required this.scheme,
  });

  final List<String> steps;
  final Color accent;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cara membuang',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          for (final (index, step) in steps.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent.withAlpha(40),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: textTheme.labelMedium?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: textTheme.bodyMedium?.copyWith(height: 1.4),
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
