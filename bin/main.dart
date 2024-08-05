import 'dart:io';
import 'AppD5.dart';
import 'package:mysql1/mysql1.dart';
import 'package:cli_table/cli_table.dart';

void main() async {
  var settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '123456',
    db: 'studentDb',
    timeout: Duration(seconds: 30),
  );

  final conn = await MySqlConnection.connect(settings);

  List<Student> students = [];

  while (true) {
    stdout.write('''
    Menu:
    1. Thêm sinh viên
    2. Hiển thị danh sách sinh viên
    3. Sửa sinh viên
    4. Xóa sinh viên
    5. Tim sinh vien
    6. Thoát
    Vui lòng chọn số: ''');

    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        await addStudent(conn, students);
        break;
      case '2':
        await displayStudent(conn, students);
        break;
      case '3':
        await updateStudent(conn, students);
        break;
      case '4':
        await deleteStudent(conn, students);
        break;
        case '5':
        await findStudent(conn, students);
        break;
      case '6':
        print('Thoát chương trình');
        await conn.close();
        exit(0);
      default:
        print('Chọn sai, vui lòng chọn lại');
    }
  }
}

Future<void> addStudent(MySqlConnection conn, List<Student> students) async {
  stdout.write('Nhập id sinh viên: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('ID không được trống hoăc không hợp lệ');
    return;
  }

  stdout.write('Nhập tên sinh viên: ');
  String? name = stdin.readLineSync();
  if (name == null || name.isEmpty || !isAlphabet(name)) {
    print('Tên không được để trống hoặc có kí tự đặc biệt');
    return;
  }

  stdout.write('Nhập số điện thoại: ');
  String? phone = stdin.readLineSync();
  if (phone == null || phone.isEmpty || !isPhone(phone)) {
    print('Số điện thoại không để trống hoặc có chữ hay kí tự đặc biệt');
    return;
  }

  students.add(Student(id, name, phone));

  await conn.query('INSERT INTO Student (id, name, phone) VALUES (?, ?, ?)', [id, name, phone]);
  print('Đã thêm sinh viên');
}

Future<void> displayStudent(MySqlConnection conn, List<Student> students) async {
  final table = Table(
      header: ['ID', 'Student Name ',"Phone"],
      columnWidths: [10, 20, 30],
    style: TableStyle(
      header:['Crimson'],
      border: ['Black']
    )
  );
  var results = await conn.query("SELECT id, name, phone FROM Student");
  students.clear();
  for (var row in results) {
    students.add(Student(row['id'], row['name'], row['phone']));
  }
  if (students.isEmpty) {
    print('Danh sách sinh viên trống');
  } else {
    print('Danh sách sinh viên:');
    for (var student in students) {
      table.add([student.id,student.name,student.phone]);
    }
    print(table.toString());
  }
}

Future<void> updateStudent(MySqlConnection conn, List<Student> students) async {
  stdout.write('Nhập id sinh viên cần sửa: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('ID không được trống hoăc không hợp lệ');
    return;
  }

  stdout.write('Nhập tên mới của sinh viên: ');
  String? name = stdin.readLineSync();
  if (name == null || name.isEmpty || !isAlphabet(name)) {
    print('Tên không được để trống hoặc có số kí tự đặc biệt');
    return;
  }

  stdout.write('Nhập số điện thoại mới: ');
  String? phone = stdin.readLineSync();
  if (phone == null || phone.isEmpty || !isPhone(phone)) {
    print('Số điện thoại không để trống hoặc có chữ hay kí tự đặc biệt');
    return;
  }

  await conn.query('UPDATE Student SET name = ?, phone = ? WHERE id = ?', [name, phone, id]);
  print('Đã update thông tin sinh viên');
}

Future<void> deleteStudent(MySqlConnection conn, List<Student> students) async {
  stdout.write('Nhập id sinh viên cần xóa: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('ID không được trống hoăc không hợp lệ');
    return;
  }

  var isDelete = await conn.query('DELETE FROM Student WHERE id = ?', [id]);
  if (isDelete.affectedRows! > 0) {
    print('Xóa thành công');
    return;
  }
  print('Không tìm thấy sinh viên!');
}

Future<void> findStudent(MySqlConnection conn, List<Student> students) async {
  final table = Table(
      header: ['ID', 'Student Name ',"Phone"],
      columnWidths: [10, 20, 30],
      style: TableStyle(
          header:['Crimson'],
          border: ['Black']
      )
  );
  stdout.write('Nhập id sinh viên cần tìm: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('ID không được trống hoăc không hợp lệ');
    return;
  }
  await conn.query('SELECT * FROM Student WHERE id = ?',[id]);
  for (var student in students) {
    table.add([student.id,student.name,student.phone]);
  }
  print(table.toString());

}

bool isAlphabet(String str) {
  RegExp alphabet = RegExp(r'^[A-Za-z]+$');
  return alphabet.hasMatch(str);
}

bool isPhone(String str) {
  RegExp phone = RegExp(r'^(?:[+0]9)?[0-9]{10,12}$');
  return phone.hasMatch(str);
}
