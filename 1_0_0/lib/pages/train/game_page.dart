import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../models/word.dart';
import '../../models/user.dart';
import '../../config/config.dart';
import '../../utils/validators.dart';
import '../../functions/api.dart';
import '../../functions/modify.dart';
import 'game_result_page.dart';

class GamePage extends StatefulWidget {
  int userId;
  int vocabularyId;
  int? groupId;
  int translationsCount;
  Map<String, int> usersAttemptNumber;
  List<Word> words;
  GamePage({
    super.key,
    required this.userId,
    required this.vocabularyId,
    required this.groupId,
    required this.translationsCount,
    required this.usersAttemptNumber,
    required this.words});

  @override
  _GamePageState createState() => _GamePageState();
}


class _GamePageState extends State<GamePage> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  // Создаем список _formKeys, чтобы TextFormField не пропадал при переходе на след страницу
  List _formKeys = [];
  TextEditingController _translateController = TextEditingController();
  bool _isNextPageButton = false;
  bool _isFillTranslateList = true;
  bool _isNextButtonIsActive = true;
  // bool _isScrollBoxVisible = false;
  int _totalScore = 0;
  List<String> _currentTranslations = [];
  List<String> _currentUserTranslations = [];
  List<int> _currentUserTranslationsLengths = [];
  Map<String, List<String>> _wordErrors = {};
  List<MaterialColor> _checkAnswerColor = [];
  User _user = User();
  Config _config = Config();
 

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

  bool _isTranslationsLengthsMore(int length, List<int> translationsLengths) {
    for (int translationLength in translationsLengths)
    {
      if (translationLength > length)
      {
        return true;
      }
    }
    return false;
  }

  void _scrollDown() {
  _scrollController.animateTo(
    _scrollController.position.maxScrollExtent,
    duration: Duration(seconds: 1),
    curve: Curves.easeInOut,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тренировка'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),
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
              widget.words[pageIndex].getTranslations.forEach((e) {
                _currentTranslations.add(e.getName);
                // _currentTranslationsLengths.add(e.getName.length);
                });
            }
            // print(str.length);
            // print(_isTranslationsLengthsMore(_config.getMaxAvailableTranslateWordLength, _currentUserTranslationsLengths));
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
                    if (_isTranslationsLengthsMore(_config.getMaxAvailableTranslateWordLength, _currentUserTranslationsLengths))
                    SizedBox(
                      width: double.infinity,
                      height: 140,
                      child: _currentTranslations.length <= 3 ? 
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _currentUserTranslations.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (_currentUserTranslations[index].length <= _config.getMaxAvailableTranslateWordLength)
                            {
                              return _UserTranslationContainer(
                                width: 170, 
                                translation: _currentUserTranslations[index], 
                                answerColor: _checkAnswerColor[index], 
                                isMarquee: false);
                            } else if (_currentUserTranslations[index].length > _config.getMaxAvailableTranslateWordLength
                            && _currentUserTranslations[index].length <= _config.getMaxAvailableTranslatePhraseLength)
                            {
                              return _UserTranslationContainer(
                                width: 340, 
                                translation: _currentUserTranslations[index], 
                                answerColor: _checkAnswerColor[index], 
                                isMarquee: false);
                            } else if (_currentUserTranslations[index].length > _config.getMaxAvailableTranslatePhraseLength
                            && _currentUserTranslations[index].length <= _config.getMaxAvailableTranslateLongPhraseLength)
                            {
                              return _UserTranslationContainer(
                                width: 340, 
                                translation: _currentUserTranslations[index], 
                                answerColor: _checkAnswerColor[index], 
                                isMarquee: true);
                            }
                      })
                      :
                      Scrollbar(
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: _currentUserTranslations.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (_currentUserTranslations[index].length <= _config.getMaxAvailableTranslateWordLength)
                            {
                              return Column(
                                children: [
                                  _UserTranslationContainer(
                                    width: 170, 
                                    translation: _currentUserTranslations[index], 
                                    answerColor: _checkAnswerColor[index], 
                                    isMarquee: false),
                                    if (index == _currentUserTranslations.length - 1)
                                    SizedBox(height: 40,)
                                ],
                              );
                            } else if (_currentUserTranslations[index].length > _config.getMaxAvailableTranslateWordLength
                            && _currentUserTranslations[index].length <= _config.getMaxAvailableTranslatePhraseLength)
                            {
                              return Column(
                                children: [
                                  _UserTranslationContainer(
                                    width: 340, 
                                    translation: _currentUserTranslations[index], 
                                    answerColor: _checkAnswerColor[index], 
                                    isMarquee: false),
                                    if (index == _currentUserTranslations.length - 1)
                                    SizedBox(height: 40,)
                                ],
                              );
                            } else if (_currentUserTranslations[index].length > _config.getMaxAvailableTranslatePhraseLength
                            && _currentUserTranslations[index].length <= _config.getMaxAvailableTranslateLongPhraseLength)
                            {
                              return Column(
                                children: [
                                  _UserTranslationContainer(
                                    width: 340, 
                                    translation: _currentUserTranslations[index], 
                                    answerColor: _checkAnswerColor[index], 
                                    isMarquee: true),
                                    if (index == _currentUserTranslations.length - 1)
                                    SizedBox(height: 40,)
                                ],
                              );
                            }
                        }),
                      ),
                    )
                    else if (_currentUserTranslations.length == 1)
                    SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: _UserTranslationContainer(
                          width: 170,
                          translation: _currentUserTranslations[0],
                          answerColor: _checkAnswerColor[0],
                          isMarquee: false,),),
                    )
                    else
                    SizedBox(
                      width: double.infinity,
                      height: 180,
                      child:
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 6.0,
                        children: List.generate(_currentUserTranslations.length,
                        (index) => _UserTranslationContainer(
                          width: 170, 
                          translation: _currentUserTranslations[index], 
                          answerColor: _checkAnswerColor[index], 
                          isMarquee: false)
                        ),)
                    ),
                    SizedBox(
                      height: 130,
                      child: _isNextPageButton ? SizedBox.shrink()
                      : 
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
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
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(label: Text('Перевод')),
                          validator: (text) {
                            if (Validator.checkIsTextIsEmpty(text)) {
                              return 'Поле не должно быть пустым';
                            }
                            if (Validator.checkTranslateLongPhraseLength(text!)){
                              return 'Допускается только длина ${_config.getMaxAvailableTranslateLongPhraseLength} символов';
                            }
                          },
                        )),
                          ],
                        ),
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
                            widget.groupId, 
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
                              _currentUserTranslationsLengths.add(enteredWord.length);
                            });  
                          } else {
                            _checkAnswerColor.add(Colors.red);
                            setState(() {
                              _currentUserTranslations.add(enteredWord);
                              _currentUserTranslationsLengths.add(enteredWord.length);
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
                              _currentUserTranslationsLengths.add(enteredWord.length);
                            });  
                          } else {
                            _checkAnswerColor.add(Colors.red);
                            setState(() {
                              _currentUserTranslations.add(enteredWord);
                              _currentUserTranslationsLengths.add(enteredWord.length);
                            });
                          }
                          _translateController.clear();
                          setState(() {
                            _isNextPageButton = true;
                          });
                       
                        }
                        // print(_currentTranslations);
                        // Future.delayed(Duration(microseconds: 500));
                        // print(_scrollController.hasClients);
                        if (_currentUserTranslations.length > 3)
                            {
                              _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(microseconds: 300),
                              curve: Curves.easeInOut,
                              );
                            }
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

class _UserTranslationContainer extends StatelessWidget {
  double width;
  String translation;
  MaterialColor answerColor;
  bool isMarquee;
  _UserTranslationContainer({
    super.key,
    required this.width,
    required this.translation,
    required this.answerColor,
    required this.isMarquee,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
          color: Colors.black,
          width: 1)),
        child: Center(
          child: isMarquee ?
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Marquee(
              text: translation,
              style: TextStyle(fontSize: 18, 
            fontWeight: FontWeight.w500,
            color: answerColor),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 20.0,
              velocity: 100.0,
              pauseAfterRound: Duration(seconds: 1),
              startPadding: 10.0,
              accelerationDuration: Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,),
          )
          : 
          Text(translation,
          style: TextStyle(fontSize: 18, 
          fontWeight: FontWeight.w500,
          color: answerColor),
          softWrap: true,
          ),
        ),
      ),
    );
  }
}