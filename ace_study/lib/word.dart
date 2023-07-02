import 'package:flutter/material.dart';
import 'api.dart';

class WordView extends StatefulWidget{


  WordView({
    super.key});

  @override
  State<WordView> createState() => WordViewState();
}

class WordViewState extends State<WordView> {

 
  TextEditingController _word_controller = TextEditingController();
  List<TextEditingController> _translation_controllers = [ TextEditingController(), ];

  int _translation_index = 0;
  int _max_count_translation = 10;
  bool _showAddTranslationButton = true;

  final _formKey = GlobalKey<FormState>();

  var connection;

  @override
  void dispose(){
    _translation_controllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание слова'),
        centerTitle: true,),
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // await open_connection();
                  // await connection.query("INSERT INTO test.dictionary (dictionary_name) VALUES ('test_name')");
                },
                child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
            controller: _word_controller,
            decoration: InputDecoration(
              label: Text("Введите слово"),
              border: InputBorder.none
              ),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "Поле не должно быть пустым";
                }
                return null;
              },
              
              ),
              Divider(thickness: 1,),
              ListView.builder(
                itemCount: _translation_controllers.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  _translation_index = index;
                  return TextFormField(
                    controller: _translation_controllers[index],
                    decoration: 
                    _translation_index != 0 ?
                    InputDecoration(
                      label: Text("Перевод ${index + 1}"),
                      border: InputBorder.none,
                      suffixIcon: IconButton(onPressed: () {
                        setState(() {
                          _translation_controllers.removeAt(index);
                          index--;
                          if (index < _max_count_translation)
                          {
                            _showAddTranslationButton = true;
                          }
                        });
                        print(index);
                      },
                      icon: Icon(Icons.highlight_remove)
                      ),
                      
                      ) : 
                      InputDecoration(
                      label: Text("Перевод ${index + 1}"),
                      border: InputBorder.none,
                      
                      ),
                      validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Поле не должно быть пустым";
                      }
                      return null;
                    },
                  );
                }),
                _showAddTranslationButton ?
                TextButton(
                onPressed: () {
                  setState(() {
                    if (_translation_index < _max_count_translation - 2)
                    {
                      _translation_controllers.add(TextEditingController());
                      _translation_index++;
                    } else {
                      _translation_controllers.add(TextEditingController());
                      _translation_index++;
                      _showAddTranslationButton = false;
                    }
                  });
                  // print(_translation_index);
                  // print(_max_count_translation);
                },
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline_sharp),
                    Text('Добавить перевод'),
                  ]),
                  ) : SizedBox.shrink(),
            ],
            )
          
        ),
                  ),
               
            ),
            

          ],
          ),
      )
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            await open_connection(connection);
            await connection.query();
          },
          child: Text("Создать")),),
    );
  }
}