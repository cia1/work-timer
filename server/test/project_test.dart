import 'package:test/test.dart';
import 'package:timer_lib/timer_lib.dart';

void main() {

  test('Project.create()', () {
    Project project = Project.create({'id': 1, 'title': 'First', 'rate': 12.5});
    expect(project.title, 'First');
    expect(project.id, 1);
    expect(project.rate, 12.5);

    expect(() => Project.create({'title': 'Second'}), throwsA(isA<FormatException>()));
  });

}