import 'dart:io';
import 'package:collection/collection.dart';

class Student{
  int id;
  String name;
  String phone;

  Student(this.id, this.name, this.phone);

  @override
  String toString() {
    return 'Id: $id, Name: $name, Phone:$phone';
  }

}