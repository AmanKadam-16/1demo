import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278217068),
      surfaceTint: Color(4278217068),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4288475635),
      onPrimaryContainer: Color(4278198305),
      secondary: Color(4283065188),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291619048),
      onSecondaryContainer: Color(4278460192),
      tertiary: Color(4283260796),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4292207615),
      onTertiaryContainer: Color(4278590518),
      error: Color.fromARGB(255, 218, 62, 62),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294245370),
      onSurface: Color(4279639325),
      onSurfaceVariant: Color(4282337609),
      outline: Color(4285495673),
      outlineVariant: Color(4290693320),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020978),
      inversePrimary: Color(4286633175),
      primaryFixed: Color(4288475635),
      onPrimaryFixed: Color(4278198305),
      primaryFixedDim: Color(4286633175),
      onPrimaryFixedVariant: Color(4278210385),
      secondaryFixed: Color(4291619048),
      onSecondaryFixed: Color(4278460192),
      secondaryFixedDim: Color(4289776844),
      onSecondaryFixedVariant: Color(4281486156),
      tertiaryFixed: Color(4292207615),
      onTertiaryFixed: Color(4278590518),
      tertiaryFixedDim: Color(4290037737),
      onTertiaryFixedVariant: Color(4281682019),
      surfaceDim: Color(4292205531),
      surfaceBright: Color(4294245370),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916148),
      surfaceContainer: Color(4293521391),
      surfaceContainerHigh: Color(4293126633),
      surfaceContainerHighest: Color(4292732131),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278209357),
      surfaceTint: Color(4278217068),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280516995),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281222984),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284512634),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281418847),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284708244),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294245370),
      onSurface: Color(4279639325),
      onSurfaceVariant: Color(4282074437),
      outline: Color(4283916641),
      outlineVariant: Color(4285758845),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020978),
      inversePrimary: Color(4286633175),
      primaryFixed: Color(4280516995),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278216553),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284512634),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282867809),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4284708244),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4283063674),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205531),
      surfaceBright: Color(4294245370),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916148),
      surfaceContainer: Color(4293521391),
      surfaceContainerHigh: Color(4293126633),
      surfaceContainerHighest: Color(4292732131),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278200104),
      surfaceTint: Color(4278217068),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278209357),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278986279),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281222984),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4279116605),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4281418847),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294245370),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280034854),
      outline: Color(4282074437),
      outlineVariant: Color(4282074437),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020978),
      inversePrimary: Color(4289133309),
      primaryFixed: Color(4278209357),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278203188),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281222984),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4279710001),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4281418847),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4279905608),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205531),
      surfaceBright: Color(4294245370),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916148),
      surfaceContainer: Color(4293521391),
      surfaceContainerHigh: Color(4293126633),
      surfaceContainerHighest: Color(4292732131),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4286633175),
      surfaceTint: Color(4286633175),
      onPrimary: Color(4278204216),
      primaryContainer: Color(4278210385),
      onPrimaryContainer: Color(4288475635),
      secondary: Color(4289776844),
      onSecondary: Color(4279972917),
      secondaryContainer: Color(4281486156),
      onSecondaryContainer: Color(4291619048),
      tertiary: Color(4290037737),
      onTertiary: Color(4280168780),
      tertiaryContainer: Color(4281682019),
      onTertiaryContainer: Color(4292207615),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279112725),
      onSurface: Color(4292732131),
      onSurfaceVariant: Color(4290693320),
      outline: Color(4287206291),
      outlineVariant: Color(4282337609),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292732131),
      inversePrimary: Color(4278217068),
      primaryFixed: Color(4288475635),
      onPrimaryFixed: Color(4278198305),
      primaryFixedDim: Color(4286633175),
      onPrimaryFixedVariant: Color(4278210385),
      secondaryFixed: Color(4291619048),
      onSecondaryFixed: Color(4278460192),
      secondaryFixedDim: Color(4289776844),
      onSecondaryFixedVariant: Color(4281486156),
      tertiaryFixed: Color(4292207615),
      onTertiaryFixed: Color(4278590518),
      tertiaryFixedDim: Color(4290037737),
      onTertiaryFixedVariant: Color(4281682019),
      surfaceDim: Color(4279112725),
      surfaceBright: Color(4281612858),
      surfaceContainerLowest: Color(4278783759),
      surfaceContainerLow: Color(4279639325),
      surfaceContainer: Color(4279902497),
      surfaceContainerHigh: Color(4280625963),
      surfaceContainerHighest: Color(4281349686),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4286896603),
      surfaceTint: Color(4286633175),
      onPrimary: Color(4278196763),
      primaryContainer: Color(4282883488),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4290105552),
      onSecondary: Color(4278196763),
      secondaryContainer: Color(4286289558),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4290366701),
      onTertiary: Color(4278261296),
      tertiaryContainer: Color(4286550705),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279112725),
      onSurface: Color(4294376699),
      onSurfaceVariant: Color(4290956749),
      outline: Color(4288390565),
      outlineVariant: Color(4286285189),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292732131),
      inversePrimary: Color(4278210899),
      primaryFixed: Color(4288475635),
      onPrimaryFixed: Color(4278195221),
      primaryFixedDim: Color(4286633175),
      onPrimaryFixedVariant: Color(4278205759),
      secondaryFixed: Color(4291619048),
      onSecondaryFixed: Color(4278195221),
      secondaryFixedDim: Color(4289776844),
      onSecondaryFixedVariant: Color(4280367675),
      tertiaryFixed: Color(4292207615),
      onTertiaryFixed: Color(4278194472),
      tertiaryFixedDim: Color(4290037737),
      onTertiaryFixedVariant: Color(4280563538),
      surfaceDim: Color(4279112725),
      surfaceBright: Color(4281612858),
      surfaceContainerLowest: Color(4278783759),
      surfaceContainerLow: Color(4279639325),
      surfaceContainer: Color(4279902497),
      surfaceContainerHigh: Color(4280625963),
      surfaceContainerHighest: Color(4281349686),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293591039),
      surfaceTint: Color(4286633175),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4286896603),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293591039),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4290105552),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294703871),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4290366701),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279112725),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294180348),
      outline: Color(4290956749),
      outlineVariant: Color(4290956749),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292732131),
      inversePrimary: Color(4278202417),
      primaryFixed: Color(4288738808),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4286896603),
      onPrimaryFixedVariant: Color(4278196763),
      secondaryFixed: Color(4291882221),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290105552),
      onSecondaryFixedVariant: Color(4278196763),
      tertiaryFixed: Color(4292601855),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4290366701),
      onTertiaryFixedVariant: Color(4278261296),
      surfaceDim: Color(4279112725),
      surfaceBright: Color(4281612858),
      surfaceContainerLowest: Color(4278783759),
      surfaceContainerLow: Color(4279639325),
      surfaceContainer: Color(4279902497),
      surfaceContainerHigh: Color(4280625963),
      surfaceContainerHighest: Color(4281349686),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
