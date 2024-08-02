import 'dart:async';
import 'package:mysql1/mysql1.dart';

class Student {
  int id;
  String name;
  String phone;

  Student({required this.id, required this.name, required this.phone});
}

class DatabaseHelper {
  var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '123456',
      db: 'studentDb',
      timeout: Duration(seconds: 30));

  Future<MySqlConnection> getConnection() async {
    try {
      return await MySqlConnection.connect(settings);
    } catch (e) {
      print('Khong the ket noi DB');
      rethrow;
    }
  }

  Future<void> createStudent(Student student) async {
    MySqlConnection? connection;
    connection = await getConnection();

    await connection.query('insert into student(name, phone) values(?,?)',
        [student.name, student.phone]);

  }

  Future<List<Student>> getStudents() async {
    MySqlConnection? connection;
    connection = await getConnection();
    var results = await connection.query('select * from student');
    List<Student> students = [];
    for (var row in results) {
      students.add(Student(id: row[0], name: row[1], phone: row[2]));
    }
    return students;
  }

  /* Delete */
  Future<void> deleteStudent(int id) async {
    MySqlConnection? connection;
    connection = await getConnection();
    await connection.query('delete from student where id = ?', [id]);
  }

  Future<void> updateStudent(Student student) async {
    MySqlConnection? connection;
    connection = await getConnection();
    await connection.query(
        'update Student set name = ? , phone = ? where id = ?',
        [student.name, student.phone, student.id]);
  }
}

void main() async {
  DatabaseHelper databaseHelper = DatabaseHelper();

  /* Add new student */
  Student student = Student(id: 0, name: 'Cuong', phone: '123456789');

  await databaseHelper.createStudent(student);
  print('Đã thêm sinh viên mới');

  /* Display student */
  List<Student> students = await databaseHelper.getStudents();
  for (var student in students) {
    print('${student.id} - ${student.name} - ${student.phone}');
  }

  /* Delete student */
  await databaseHelper.deleteStudent(1);

  /* Update student */
  Student update = students.last;

}