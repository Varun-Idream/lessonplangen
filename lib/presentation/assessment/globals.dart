import 'package:flutter/material.dart';
import 'package:lessonplan/models/form_data_models.dart';

ValueNotifier<Board?> selectedBoard = ValueNotifier(null);
ValueNotifier<Grade?> selectedGrade = ValueNotifier(null);
ValueNotifier<Subject?> selectedSubject = ValueNotifier(null);
ValueNotifier<int?> numberOfQuestions = ValueNotifier(null);
ValueNotifier<bool> isValidForm = ValueNotifier(false);
bool isErrorDialogMounted = false;

ValueNotifier<int> mcqsingle = ValueNotifier(0);
ValueNotifier<int> mcqmultiple = ValueNotifier(0);
ValueNotifier<int> truefalse = ValueNotifier(0);
ValueNotifier<int> fillintheblanks = ValueNotifier(0);
ValueNotifier<int> matchthecolumns = ValueNotifier(0);
ValueNotifier<int> veryshortans = ValueNotifier(0);