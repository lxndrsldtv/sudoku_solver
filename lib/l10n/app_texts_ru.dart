// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_texts.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get btnLabelImage => 'Выбрать изображение';

  @override
  String get btnLabelCamera => 'Сделать фото';

  @override
  String get btnLabelSolve => 'Решить';

  @override
  String get btnLabelRestart => 'Заново';

  @override
  String get btnLabelSettings => 'Настройки';

  @override
  String get dlgSettings_Title => 'Настройки';

  @override
  String get dlgSettings_lblShowImgInCellCorner => 'Показывать изображение в ячейке';

  @override
  String get dlgSetCellValue_Title => 'Присвоить ячейке значение';

  @override
  String get dlgSetCellValue_lblCellValue => 'Значение ячейки:';

  @override
  String get dlgSetCellValue_lblCellImage => 'Изображение ячейки:';

  @override
  String get btnPad_btnClearCell => 'Очистить ячейку';

  @override
  String get txtProcessingImage => 'Обработка изображения...';
}
