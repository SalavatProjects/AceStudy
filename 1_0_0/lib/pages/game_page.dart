import 'package:flutter/material.dart';

import '../models/word.dart';
import '../models/user.dart';
import '../utils/validators.dart';
import '../functions/api.dart';
import '../functions/modify.dart';
import 'game_result_page.dart';

class GamePage extends StatefulWidget {
  int userId;
  int vocabularyId;
  int translationsCount;
  Map<String, int> usersAttemptNumber;
  List<Word> words;
  GamePage({
    super.key,
    required this.userId,
    required this.vocabularyId,
    required this.translationsCount,
    required this.usersAttemptNumber,
    required this.words});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final PageController _pageController = PageController();
  // Создаем список _formKeys, чтобы TextFormField не пропадал при переходе на след страницу
  List _formKeys = [];
  TextEditingController _translateController = TextEditingController();
  bool _isNextPageButton = false;
  bool _isFillTranslateList = true;
  bool _isNextButtonIsActive = true;
  int _totalScore = 0;
  List<String> _currentTranslations = [];
  List<String> _currentUserTranslations = [];
  Map<String, List<String>> _wordErrors = {};
  List<MaterialColor> _checkAnswerColor = [];
  User _user = User();
 

  @override
  void initState() {
    super.initState();
    widget.words.shuffle();
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тренировка'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: widget.words.length,
          itemBuilder: (BuildContext context, int pageIndex) {
            //  final String str = '123456789qwezxczx';
            if (_formKeys.isEmpty) {
              for (var i = 0; i < widget.words.length; i++){
              _formKeys.add(GlobalKey<FormState>());
            }
            }
            if (_currentTranslations.isEmpty && _isFillTranslateList)
            {
              widget.words[pageIndex].getTranslations.forEach((e) => _currentTranslations.add(e.getName));
            }
            // print(str.length);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        child: Card(child: Center(child: Text(widget.words[pageIndex].getName,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.w600),))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 140,
                      child: 
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 6.0,
                        children: List.generate(_currentUserTranslations.length,
                        (index) => Container(
                          width: 180,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                            color: Colors.black,
                            width: 1)),
                          child: Center(
                            child: Text(_currentUserTranslations[index],
                            style: TextStyle(fontSize: 18, 
                            fontWeight: FontWeight.w500,
                            color: _checkAnswerColor[index]),
                            softWrap: true,),
                          ),
                        )),)
                    ),
                    SizedBox(
                      height: 120,
                      child: _isNextPageButton ? SizedBox.shrink()
                      : 
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                      child: Text(_currentTranslations.length == 1 ? 'Введите перевод слова ${widget.words[pageIndex].getName}'
                      : 'Введите один из переводов слова ${widget.words[pageIndex].getName}:',
                      style: TextStyle(fontSize: 18),
                      softWrap: true,
                      textAlign: TextAlign.center,),
                    ),
                    Form(
                      key: _formKeys[pageIndex],
                      autovalidateMode: AutovalidateMode.disabled,
                      child: TextFormField(
                        controller: _translateController,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(label: Text('Перевод')),
                        validator: (text) {
                          if (Validator.checkIsTextIsEmpty(text)) {
                            return 'Поле не должно быть пустым';
                          }
                        },
                      )),
                        ],
                      ),
                    ),
                    
                      _isNextPageButton ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(160, 50)
                          ),
                          onPressed: _isNextButtonIsActive ? () async {
                          if (_currentTranslations.isNotEmpty)
                          {
                            _wordErrors[widget.words[pageIndex].getName] = List.from(_currentTranslations);
                          }
                          if (pageIndex < widget.words.length - 1)
                          {
                              _pageController.nextPage(duration: const Duration(milliseconds: 500), 
                              curve: Curves.easeInOut);
                          } else {
                            setState(() {
                              _isNextButtonIsActive = false;
                            });
                            // print(widget.usersAttemptNumber);
                            await Api.insertInStudentMistakes(
                            widget.userId, 
                            widget.vocabularyId, 
                            _wordErrors, 
                            widget.usersAttemptNumber
                            );
                            
                            _user.setVocabulariesCounts(await Api.getUserVocabulariesCounts(_user.getId));
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (BuildContext context) => GameResultPage(
                              totalTranslationsCount: widget.translationsCount, 
                              usersAttemptNumber: widget.usersAttemptNumber, 
                              wordErrors: _wordErrors)));
                          }
                          
                        _translateController.clear();
                        _currentUserTranslations.clear();
                        _currentTranslations.clear();
                        _checkAnswerColor.clear();
                        _isNextPageButton = false;
                        _isFillTranslateList = true;
                        // print(_currentTranslations);
                        // print(_wordErrors);
                        } : null, 
                        child: Text('Далее', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),)),
                      ) :
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(160, 50),
                      ),
                      onPressed: () {
                      if (_formKeys[pageIndex].currentState!.validate()) {
                        String enteredWord = _translateController.text.trim().capitalize();
                        _isFillTranslateList = false;
                        if(_currentUserTranslations.length < widget.words[pageIndex].getTranslations.length - 1){
                          if (_currentTranslations.contains(enteredWord)){
                            _checkAnswerColor.add(Colors.green);
                            _totalScore++;
                            _currentTranslations.removeWhere((element) => element == enteredWord);
                            setState(() {
                              _currentUserTranslations.add(enteredWord);
                            });  
                          } else {
                            _checkAnswerColor.add(Colors.red);
                            setState(() {
                              _currentUserTranslations.add(enteredWord);
                            });
                          }
                          _translateController.clear();
                        } else {
                          if (_currentTranslations.contains(enteredWord)){
                            _checkAnswerColor.add(Colors.green);
                            _totalScore++;
                            _currentTranslations.removeWhere((element) => element == enteredWord);
                            setState(() {
                              _currentUserTranslations.add(enteredWord);
                            });  
                          } else {
                            _checkAnswerColor.add(Colors.red);
                            setState(() {
                              _currentUserTranslations.add(enteredWord);
                            });
                          }
                          _translateController.clear();
                          setState(() {
                            _isNextPageButton = true;
                          });
                       
                        }
                        // print(_currentTranslations);
                      }
                        
                    }, 
                    child: Text('Ввод', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),)),
                  ),
                  ],),
              ),
            );
          })),
    );
  }
}