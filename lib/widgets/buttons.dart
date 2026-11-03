import 'package:flutter/material.dart';

import '../theme/colors.dart';

/// Bouton d'action forte : pilule en dégradé, pastille blanche avec flèche au bout.
class GradientButton extends StatelessWidget {
  const GradientButton({super.key, required this.label, required this.onPressed, this.loading = false, this.expand = true});

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return Semantics(
      button: true,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: DowraColors.gradient,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [BoxShadow(color: DowraColors.neon.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: enabled ? onPressed : null,
              child: SizedBox(
                height: 56,
                width: expand ? double.infinity : null,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 24, end: 7),
                  child: Row(
                    mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: expand ? 1 : 0,
                        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: loading
                            ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2.5, color: DowraColors.mauve600))
                            : const Icon(Icons.arrow_forward_rounded, color: DowraColors.mauve600, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bouton secondaire au contour fin.
class OutlinePillButton extends StatelessWidget {
  const OutlinePillButton({super.key, required this.label, required this.onPressed, this.icon, this.color, this.foreground});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final fg = foreground ?? context.palette.text;
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: fg,
          side: BorderSide(color: color ?? context.palette.line, width: 1.5),
          shape: const StadiumBorder(),
          textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ]),
      ),
    );
  }
}

/// Pastille à choisir (langue, mode d'affichage, envie).
class ChoicePill extends StatelessWidget {
  const ChoicePill({super.key, required this.label, required this.selected, required this.onTap, this.leading});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? DowraColors.mauve600 : palette.surface,
        shape: StadiumBorder(side: BorderSide(color: selected ? Colors.transparent : palette.line)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(leading == null ? 16 : 6, 7, 16, 7),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (leading != null) ...[leading!, const SizedBox(width: 8)],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: selected ? Colors.white : palette.text))),
            ]),
          ),
        ),
      ),
    );
  }
}
