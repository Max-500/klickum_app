import 'package:flutter/material.dart';
import 'package:klicum/config/style/app_style.dart';

class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = AppStyle.primaryColor;

    final miniTitleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700) ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w700);  
    final bodySmallStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis) ?? const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha(35),
          width: 1
        )
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: primary.withAlpha(15),
          highlightColor: primary.withAlpha(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primary.withAlpha(35),
                      width: 1
                    )
                  ),
                  child: Icon(icon, color: primary, size: 20)
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: miniTitleStyle),
                      const SizedBox(height: 3),
                      Text(subtitle, maxLines: 2, style: bodySmallStyle)
                    ]
                  )
                ),
                Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant.withAlpha(6))
              ]
            )
          )
        )
      )
    );
  }
}