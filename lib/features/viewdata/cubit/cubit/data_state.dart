
part of 'data_cubit.dart';

abstract class DataState {}

class DataInitial extends DataState {}

class DataDeleted extends DataState {}

class AllDataDeleted extends DataState {}
class DataDeletionError
 extends DataState {}
class DataDeletedSuccessfully extends DataState {}
class AllDataDeletedSuccessfully extends DataState {}
class DataLoaded extends DataState {}