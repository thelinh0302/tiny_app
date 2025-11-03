import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

/// A swipe-to-action button.
/// - Drag the knob to the right to complete.
/// - Calls onComplete when threshold reached.
class SwipeToActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onComplete;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color progressColor;
  final Color knobColor;
  final Color textColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final IconData knobIcon;
  final Duration resetDuration;
  final double? width;

  const SwipeToActionButton({
    super.key,
    required this.text,
    required this.onComplete,
    this.height = AppSizes.buttonHeightLarge,
    this.borderRadius = AppSpacing.radiusLarge,
    this.backgroundColor = AppColors.white,
    this.progressColor = AppColors.mainGreen,
    this.knobColor = AppColors.white,
    this.textColor = AppColors.white,
    this.borderColor,
    this.borderWidth = AppSizes.borderWidthThin,
    this.padding = const EdgeInsets.all(4),
    this.knobIcon = Icons.arrow_forward,
    this.resetDuration = const Duration(milliseconds: 220),
    this.width,
  });

  @override
  State<SwipeToActionButton> createState() => _SwipeToActionButtonState();
}

class _SwipeToActionButtonState extends State<SwipeToActionButton>
    with SingleTickerProviderStateMixin {
  final GlobalKey _trackKey = GlobalKey();
  double _dragX = 0;
  bool _completed = false;

  // Idle animation (breathing) for knob when at rest
  late final AnimationController _idleCtrl;
  late final Animation<double> _idleScale;

  double get _knobSize => widget.height - (widget.padding.vertical);
  double _maxDrag(double trackWidth) =>
      trackWidth - widget.padding.horizontal - _knobSize;

  void _onPanStart(DragStartDetails d) {
    if (_completed) return;
    if (_idleCtrl.isAnimating) {
      _idleCtrl.stop();
    }
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_completed) return;
    final RenderBox? box =
        _trackKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final trackWidth = box.size.width;
    final max = _maxDrag(trackWidth);
    setState(() {
      _dragX = (_dragX + d.delta.dx).clamp(0, max);
    });
  }

  void _onPanEnd(DragEndDetails d) {
    final RenderBox? box =
        _trackKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final trackWidth = box.size.width;
    final max = _maxDrag(trackWidth);
    // Complete if beyond 85% of track
    final threshold = max * 0.85;
    if (_dragX >= threshold) {
      setState(() {
        _dragX = max;
        _completed = true;
      });
      // Give a short frame for UI, then callback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onComplete();
        // Optionally reset after a delay or keep completed state
        Future.delayed(const Duration(milliseconds: 250), () {
          if (!mounted) return;
          setState(() {
            _dragX = 0;
            _completed = false;
          });
        });
      });
    } else {
      // Animate back
      _animateBack();
    }
  }

  void _animateBack() async {
    final int steps = 12;
    final dt = widget.resetDuration.inMilliseconds ~/ steps;
    final start = _dragX;
    for (int i = 1; i <= steps; i++) {
      await Future.delayed(Duration(milliseconds: dt));
      if (!mounted) return;
      setState(() {
        _dragX = start * (1 - i / steps);
      });
    }
    // restart idle animation when knob returns to start and not completed
    if (!_completed && _dragX <= 0) {
      _idleCtrl.repeat(reverse: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _idleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _idleScale = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _idleCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _idleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? double.infinity;

    return SizedBox(
      width: width,
      height: widget.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: _onPanStart,
        onHorizontalDragUpdate: _onPanUpdate,
        onHorizontalDragEnd: _onPanEnd,
        child: Container(
          key: _trackKey,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border:
                widget.borderColor != null
                    ? Border.all(
                      color: widget.borderColor!,
                      width: widget.borderWidth,
                    )
                    : null,
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Progress fill
              LayoutBuilder(
                builder: (context, constraints) {
                  final max = _maxDrag(constraints.maxWidth);
                  final progress =
                      max <= 0 ? 0.0 : (_dragX + _knobSize) / (max + _knobSize);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 50),
                    width: constraints.maxWidth * progress,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      // color: widget.progressColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                  );
                },
              ),
              // Centered text
              Center(
                child: IgnorePointer(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Draggable knob
              Positioned(
                left: widget.padding.left + _dragX,
                child: ScaleTransition(
                  scale: _idleScale,
                  child: Container(
                    width: _knobSize,
                    height: _knobSize,
                    decoration: BoxDecoration(
                      color: widget.knobColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        // Stronger drop shadow
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                        // Soft brand glow for emphasis
                        BoxShadow(
                          color: AppColors.mainGreen.withOpacity(0.15),
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Icon(widget.knobIcon, color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
