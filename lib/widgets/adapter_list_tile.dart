import 'package:fluent_ui/fluent_ui.dart';

typedef AdapterTrailingBuilder =
    Widget Function(BuildContext context, bool isCompact);

class AdapterListTile extends StatelessWidget {
  const AdapterListTile({
    super.key,
    this.tileColor,
    this.shape = kDefaultListTileShape,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.trailingBuilder,
    this.onPressed,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.cursor,
    this.contentAlignment = CrossAxisAlignment.center,
    this.contentPadding = kDefaultListTilePadding,
    this.margin = kDefaultListTileMargin,
    this.compactBreakpoint = 560,
    this.compactSpacing = 8,
    this.stretchTrailingOnCompact = true,
    this.compactTrailingAlignment = Alignment.centerRight,
  }) : assert(
         !(subtitle != null) || title != null,
         'To have a subtitle, there must be a title',
       );

  final WidgetStateColor? tileColor;
  final ShapeBorder shape;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final AdapterTrailingBuilder? trailingBuilder;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;
  final MouseCursor? cursor;
  final CrossAxisAlignment contentAlignment;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry? margin;
  final double compactBreakpoint;
  final double compactSpacing;
  final bool stretchTrailingOnCompact;
  final Alignment compactTrailingAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompact = constraints.maxWidth < compactBreakpoint;
        final Widget? resolvedTrailing =
            trailingBuilder?.call(context, isCompact) ?? trailing;

        if (!isCompact || resolvedTrailing == null) {
          return ListTile(
            tileColor: tileColor,
            shape: shape,
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: resolvedTrailing,
            onPressed: onPressed,
            focusNode: focusNode,
            autofocus: autofocus,
            semanticLabel: semanticLabel,
            cursor: cursor,
            contentAlignment: contentAlignment,
            contentPadding: contentPadding,
            margin: margin,
          );
        }

        Widget compactTrailing = Align(
          alignment: compactTrailingAlignment,
          child: resolvedTrailing,
        );
        if (stretchTrailingOnCompact) {
          compactTrailing = SizedBox(
            width: double.infinity,
            child: compactTrailing,
          );
        }

        return ListTile(
          tileColor: tileColor,
          shape: shape,
          leading: leading,
          title: _CompactTileContent(
            title: title,
            subtitle: subtitle,
            trailing: compactTrailing,
            compactSpacing: compactSpacing,
          ),
          onPressed: onPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          semanticLabel: semanticLabel,
          cursor: cursor,
          contentAlignment: contentAlignment,
          contentPadding: contentPadding,
          margin: margin,
        );
      },
    );
  }
}

class _CompactTileContent extends StatelessWidget {
  const _CompactTileContent({
    required this.trailing,
    required this.compactSpacing,
    this.title,
    this.subtitle,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget trailing;
  final double compactSpacing;

  @override
  Widget build(BuildContext context) {
    final TextStyle subtitleStyle =
        FluentTheme.of(context).typography.caption ?? const TextStyle();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title case final Widget titleWidget) titleWidget,
        if (subtitle case final Widget subtitleWidget)
          Padding(
            padding: EdgeInsets.only(top: title == null ? 0 : 4),
            child: DefaultTextStyle.merge(
              style: subtitleStyle,
              child: subtitleWidget,
            ),
          ),
        SizedBox(height: compactSpacing),
        trailing,
      ],
    );
  }
}
