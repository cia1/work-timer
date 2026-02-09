import 'dart:convert';
import 'package:test/test.dart';
import 'package:timer_lib/timer_lib.dart';

void main() {

  test('Group()', () {
    Group group = Group(1, 'First');
    expect(group.id, 1);
    expect(group.title, 'First');
    expect(group.rate, null);

    group = Group(2, 'Second', 12.5);
    expect(group.rate, 12.5);
  });

  test('Group.fromJson()', () {
    final group = Group.fromJson({'id': 3, 'title': 'Third', 'rate': 30});
    expect(group.id, 3);
    expect(group.title, 'Third');
    expect(group.rate, 30);
    expect(
      () => Group.fromJson({'id': 2}),
      throwsA(isA<TypeError>()),
    );
  });

  test('Group.toString()', () {
    final group = Group.fromJson({'id': 3, 'title': 'Third', 'rate': 30});
    expect(
      group.toString(),
      jsonEncode({'id': 3, 'title': 'Third', 'rate': 30}),
    );
  });

}