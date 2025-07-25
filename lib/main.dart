import 'package:flutter/material.dart';
import 'package:imc_calculator/extensions/imc_extension.dart';
import 'package:imc_calculator/models/imc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        brightness: Brightness.dark
      ),
      home: const MyHomePage(title: 'Calculadora IMC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController pesoController;
  late TextEditingController alturaController;
  late SharedPreferences prefs;
  ImcProvider _imcProvider = ImcProvider();
  List<Imc> imcs = [];

  Future<String> initImcs() async{
    _imcProvider.open();
    prefs = await SharedPreferences.getInstance();
    final String? nome = prefs.getString('nome');
    final String? altura = prefs.getString('altura');
    nomeController = TextEditingController(text: nome ?? '');
    pesoController = TextEditingController();
    alturaController = TextEditingController(text: altura ?? '');
    await _imcProvider.getImcs().then((value) => imcs = value);

    return nome ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: initImcs(),
        builder: (context, asyncSnapshot) {
          if(asyncSnapshot.hasData){
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Text('Digite seu peso e sua altura para calcular seu IMC')
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          labelText: 'Nome',
                        ),
                        keyboardType: TextInputType.text,
                        controller: nomeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu nome';
                          }
                          return null;
                        },
                      )
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          labelText: 'Peso',
                        ),
                        keyboardType: TextInputType.number,
                        controller: pesoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu peso';
                          }
                          return null;
                        },
                      )
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          labelText: 'Altura',
                        ),
                        keyboardType: TextInputType.number,
                        controller: alturaController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua altura';
                          }
                          return null;
                        },
                      )
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                          ),
                          onPressed: () async{
                            if(_formKey.currentState!.validate()){
                              await calcularImcESalvar();
                              setState(() {
                                pesoController.clear();
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('IMC calculado com sucesso!'),
                                  )
                              );
                            }
                          },
                          child: Text('Calcular'.toUpperCase())
                      )
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: imcs.length,
                        shrinkWrap: false,
                        controller: ScrollController(),
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index){
                          final imc = imcs[index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Peso: ${imc.peso}'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Altura: ${imc.altura}'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      children: [
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('IMC: ${imc.getImcValue().toStringAsFixed(1)}'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Classificação: ${imc.getClassificacao()}'),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider()
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }

  Future<void> calcularImcESalvar() async{
    await prefs.setString('altura', alturaController.text);
    await prefs.setString('nome', nomeController.text);
    Imc atualImc = Imc(
        peso: double.parse(pesoController.text),
        altura: double.parse(alturaController.text));

    await _imcProvider.insert(atualImc);

    imcs.add(atualImc);
  }
}



