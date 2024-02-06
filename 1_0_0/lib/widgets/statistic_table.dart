import 'package:flutter/material.dart';

import '../models/word.dart';

class StatisticTable extends StatelessWidget {
List<Word> words;
StatisticTable({
  super.key,
  required this.words});

  @override
  Widget build(BuildContext context){
    return SizedBox(
        width: 360,
        child: Table(
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade500,
                borderRadius: BorderRadius.circular(5)),
                children: [
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('Слово',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  )),
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('Переводы',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  )),
                ]
            ),
            ...(List.generate(words.length, (word_index) => TableRow(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(5),
                color: Colors.blueGrey.shade200),
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(words[word_index].getName,
                      style: TextStyle(fontSize: 16),),
                    )),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(words[word_index].getTranslations.length, 
                        (translate_index) => Text(words[word_index].getTranslations[translate_index].getName,
                        style: TextStyle(fontSize: 16), 
                        )),
                        ),
                    ))
                ]
            )))
            ]),
            );
  }
}