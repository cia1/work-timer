import 'package:test/test.dart';
import 'package:timer_lib/timer_lib.dart';

void main() {

  test('Project.fromJson()', () {
    Project project = Project.fromJson({'id': 1, 'title': 'First', 'rate': 12.5});
    expect(project.title, 'First');
    expect(project.id, 1);
    expect(project.rate, 12.5);

    expect(() => Project.fromJson({'title': 'Second'}), throwsA(isA<FormatException>()));
  });

}