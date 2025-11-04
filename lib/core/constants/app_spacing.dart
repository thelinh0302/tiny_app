import 'package:flutter/material.dart';

/// Application spacing constants
/// Centralized spacing values for consistent UI
class AppSpacing {
  // Horizontal spacing
  static const double horizontalTiny = 4.0;
  static const double horizontalSmall = 8.0;
  static const double horizontalMedium = 16.0;
  static const double horizontalLarge = 24.0;
  static const double horizontalXLarge = 32.0;
  static const double horizontalXXLarge = 48.0;

  // Vertical spacing
  static const double verticalTiny = 4.0;
  static const double verticalSmall = 8.0;
  static const double verticalMedium = 16.0;
  static const double verticalLarge = 24.0;
  static const double verticalXLarge = 32.0;
  static const double verticalXXLarge = 48.0;

  // Padding
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Card/Container padding
  static const EdgeInsets paddingCard = EdgeInsets.all(16.0);
  static const EdgeInsets paddingCardSmall = EdgeInsets.all(12.0);
  static const EdgeInsets paddingCardLarge = EdgeInsets.all(20.0);

  // Screen padding
  static const EdgeInsets paddingScreen = EdgeInsets.all(16.0);
  static const EdgeInsets paddingScreenHorizontal = EdgeInsets.symmetric(
    horizontal: 16.0,
  );
  static const EdgeInsets paddingScreenVertical = EdgeInsets.symmetric(
    vertical: 16.0,
  );

  // List item padding
  static const EdgeInsets paddingListItem = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // Button padding
  static const EdgeInsets paddingButton = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 12.0,
  );

  // Icon padding
  static const double paddingIcon = 8.0;
  static const EdgeInsets paddingIconAll = EdgeInsets.all(8.0);

  // Border radius
  static const double radiusTiny = 4.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 18.0;
  static const double radiusXLarge = 24.0;
  static const double radiusExtraLarge = 40.0;
  static const double radiusCircular = 999.0;

  // BorderRadius objects
  static BorderRadius get borderRadiusTiny => BorderRadius.circular(radiusTiny);
  static BorderRadius get borderRadiusSmall =>
      BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMedium =>
      BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLarge =>
      BorderRadius.circular(radiusLarge);
  static BorderRadius get borderRadiusXLarge =>
      BorderRadius.circular(radiusXLarge);
  static BorderRadius get borderRadiusCircular =>
      BorderRadius.circular(radiusCircular);

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  // SizedBox helpers
  static const SizedBox horizontalSpaceTiny = SizedBox(width: horizontalTiny);
  static const SizedBox horizontalSpaceSmall = SizedBox(width: horizontalSmall);
  static const SizedBox horizontalSpaceMedium = SizedBox(
    width: horizontalMedium,
  );
  static const SizedBox horizontalSpaceLarge = SizedBox(width: horizontalLarge);
  static const SizedBox horizontalSpaceXLarge = SizedBox(
    width: horizontalXLarge,
  );

  static const SizedBox verticalSpaceTiny = SizedBox(height: verticalTiny);
  static const SizedBox verticalSpaceSmall = SizedBox(height: verticalSmall);
  static const SizedBox verticalSpaceMedium = SizedBox(height: verticalMedium);
  static const SizedBox verticalSpaceLarge = SizedBox(height: verticalLarge);
  static const SizedBox verticalSpaceXLarge = SizedBox(height: verticalXLarge);
}
