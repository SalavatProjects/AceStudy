part of 'page_bloc.dart';

@immutable
abstract class PageEvent {}

// ignore: must_be_immutable
class PageChangeEvent extends PageEvent{
  String page_name;
  PageChangeEvent({required this.page_name});
}