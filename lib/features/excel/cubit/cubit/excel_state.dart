// ignore_for_file: camel_case_types

part of 'excel_cubit.dart';

@immutable
sealed class ExcelState {}

final class ExcelInitial extends ExcelState {}
final class ExcelDownloadSuccess extends ExcelState {}
final class ExcelDownloadFailed extends ExcelState {}