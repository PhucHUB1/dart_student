import 'dart:io';

class Student {
  int id;
  String name;
  String phoneNumber;

  Student(this.id, this.name, this.phoneNumber);
}

void main() {
  List<Student> students = [];
  while (true) {
    stdout.write('''
    Menu:
    1. Thêm sinh viên
    2. Hiển thị danh sách sinh viên
    3. Thoát
    Vui lòng chọn số: ''');

    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        addStudent(students);
        break;
      case '2':
        displayStudent(students);
        break;
      case '3':
        print('Thoát chương trình');
        exit(0);
      default:
        print('Chọn sai, vui lòng chọn lại');
    }
  }
}

void addStudent(List<Student> students) {
  stdout.write('Nhập ID sinh viên: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('ID không hợp lệ');
    return;
  }

  stdout.write('Nhập tên sinh viên: ');
  String? name = stdin.readLineSync();
  if (name == null) {
    print('Name không hợp lệ');
    return;
  }

  if (!isAlphabet(name)) {
    print('Name không được chứa số');
    return;
  }

  stdout.write('Nhập số điện thoại: ');
  String? phoneNumber = stdin.readLineSync();

  if (phoneNumber == null) {
    print('Phone eNumber không hợp lệ');
    return;
  }

  /* Thêm vào danh sách */
  students.add(Student(id, name, phoneNumber));
}

void displayStudent(List<Student> students) {
  if (students.isEmpty) {
    print('Không có sinh viên nào');
  } else {
    print('Danh sách sinh viên: ');
    for (var student in students) {
      print(student);
    }
  }
}

bool isAlphabet(String str) {
  RegExp alphabet = RegExp(r'^[A-Za-z]+$');
  return alphabet.hasMatch(str);
}
