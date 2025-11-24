import 'package:finly_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget? topChild;
  final PreferredSizeWidget? appBar;
  final Widget child;
  final double topHeightRatio;
  final Color topColor;
  final BorderRadiusGeometry borderRadius;
  final bool enableContentScroll;

  const MainLayout({
    super.key,
    this.topChild,
    this.appBar,
    required this.child,
    this.topHeightRatio = 0.4,
    this.topColor = AppColors.mainGreen,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(40),
      topRight: Radius.circular(40),
    ),
    this.enableContentScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double topHeight = size.height * topHeightRatio;

    return Scaffold(
      appBar: appBar,
      backgroundColor: topColor,
      body: Stack(
        children: [
          Container(
            height: topHeight,
            width: double.infinity,
            color: topColor,
            child:
                topChild != null
                    ? SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: topChild!,
                      ),
                    )
                    : null,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height - topHeight * 0.6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: borderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SafeArea(
                  top: false,
                  child:
                      enableContentScroll
                          ? LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                      20,
                                ),
                                child: child,
                              );
                            },
                          )
                          : child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
