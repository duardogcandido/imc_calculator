import 'package:flutter/material.dart';
import 'package:imc_calculator/extensions/imc_extension.dart';
import 'package:imc_calculator/models/imc.dart';

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
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  List<Imc> imcs = [];

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
      body: Form(
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
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      Imc atualImc = Imc(
                          peso: double.parse(pesoController.text),
                          altura: double.parse(alturaController.text));
                      imcs.add(atualImc);

                      setState(() {
                        pesoController.clear();
                        alturaController.clear();
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
      ),
    );
  }
}



