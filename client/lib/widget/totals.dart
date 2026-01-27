import 'package:flutter/material.dart';
import '../repository.dart';

const textStyle = TextStyle(fontWeight: FontWeight.bold);

class Totals extends StatelessWidget {

  const Totals(this._repository, {super.key});

  final Repository _repository;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            Text('            '),
            Expanded(child: Text('Total:', style: textStyle)),
            Text(_repository.total(), style: textStyle),
            Text(' ')
          ]
      )
    );
  }

}