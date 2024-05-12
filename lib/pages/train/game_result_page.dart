import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import '../../home.dart';
import '../../widgets/statistic_table.dart';
import '../../functions/modify.dart';

class GameResultPage extends StatefulWidget {
  int totalTranslationsCount;
  Map<String, int> usersAttemptNumber;
  Map wordErrors;
  GameResultPage({
    super.key,
    required this.totalTranslationsCount,
    required this.usersAttemptNumber,
    required this.wordErrors});

  @override
  _GameResultPageState createState() => _GameResultPageState();
}

class _GameResultPageState extends State<GameResultPage> {
  late int _totalPercent;
  late List _words;
  int _errorTranlationsCount = 0;
  late int _totalScore;
  List<String> _notes = [
    'Совсем плохо освоен словарь! Попробуйте снова', //redAccent[700]
    'Не совсем хорошо, лучше немного постараться', //orange[900]
    'Хорошо, но можно лучше', //yellow[900]
    'Словарь отлично освоен, совсем немного до 100 баллов', //lime[800]
    'Поздравляем! Словарь превосходно освоен на все слова! Так держать!' //green[800]
  ];
  bool _isBackButtonPressed = false;

  @override
  void initState(){
    super.initState();
    BackButtonInterceptor.add((stopDefaultButtonEvent, routeInfo,) {
      if (routeInfo.ifRouteChanged(context)) {
        return false;
      } else {
        onPopScope(context,_isBackButtonPressed);
          _isBackButtonPressed = true;
          Future.delayed(Duration(seconds: 4), () {
            _isBackButtonPressed = false;
          });
      return true;
      }
    }, name: 'backButton', context: context);
    
    _words = widget.wordErrors.keys.toList();
    _words.forEach((word) => widget.wordErrors[word].forEach((elem) => _errorTranlationsCount++));
    // print(_errorTranlationsCount);
    _totalScore = widget.totalTranslationsCount - _errorTranlationsCount;
    _totalPercent = ((_totalScore/widget.totalTranslationsCount) * 100).round();
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName('backButton');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(_errorTranlationsCount);
    // print(widget.totalTranslationsCount);
    // print(_totalPercent);
    return Scaffold(
      appBar: AppBar(
        title: Text('Итог'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Center(
                child: Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text('Вы набрали $_totalPercent баллов из 100!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.cyan[800]),
                softWrap: true,),),
              ),
              SizedBox(height: 10,),
              if (_totalPercent >= 0 && _totalPercent <= 25)
              Center(
                child: Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(_notes[0], 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.redAccent[700]),
                textAlign: TextAlign.center,),),
              ),
              if (_totalPercent > 25 && _totalPercent <= 50)
              Center(
                child: Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(_notes[1],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.orange[900]),
                textAlign: TextAlign.center,),),
              ),
              if (_totalPercent > 50 && _totalPercent <= 75)
              Center(
                child: Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(_notes[2],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.yellow[900]),
                textAlign: TextAlign.center,),),
              ),
              if (_totalPercent > 75 && _totalPercent < 100)
              Center(
                child: Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(_notes[3],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.lime[800]),
                textAlign: TextAlign.center,),),
              ),
              if (_totalPercent == 100)
              Center(
                child: Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(_notes[4],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green[800]),
                textAlign: TextAlign.center,),),
              ),
              SizedBox(height: 10,),
              if (_totalPercent != 100)
              Text('Вы ошиблись в следующих словах',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.cyan[900]),),
              if (_totalPercent != 100)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
                          )),
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('Переводы',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
                          ))
                        ],
                      ),
                    ...(List.generate(_words.length, (rowIndex) => TableRow(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blueGrey.shade200),
                      children: [
                        TableCell(child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(_words[rowIndex],
                          style: TextStyle(fontSize: 16),),
                        )),
                        TableCell(child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: 
                          List.generate(widget.wordErrors[_words[rowIndex]].length, 
                          (translateIndex) => Text(widget.wordErrors[_words[rowIndex]][translateIndex],
                          style: TextStyle(fontSize: 16),)),),
                        ))
                      ]
                    ))),    
                    ]
                    ),
                  ),
                ),
              )
            ]),
        )),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 48.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
                },
                child: Text('К тренировкам')),
            ),
    );
  }
}