// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_texts.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get btnLabelImage => 'Select image';

  @override
  String get btnLabelCamera => 'Take picture';

  @override
  String get btnLabelSolve => 'Solve';

  @override
  String get btnLabelRestart => 'Restart';

  @override
  String get btnLabelSettings => 'Settings';

  @override
  String get dlgSettings_Title => 'Settings';

  @override
  String get dlgSettings_lblShowImgInCellCorner => 'Show image in cell corner';

  @override
  String get dlgSetCellValue_Title => 'Set cell value';

  @override
  String get dlgSetCellValue_lblCellValue => 'Cell value:';

  @override
  String get dlgSetCellValue_lblCellImage => 'Cell image:';

  @override
  String get btnPad_btnClearCell => 'Clear cell';

  @override
  String get txtProcessingImage => 'Processing image...';
}
