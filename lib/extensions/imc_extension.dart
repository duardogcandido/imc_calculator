import 'package:imc_calculator/models/imc.dart';

extension ImcSituacao on Imc{
  double getImcValue(){
    return peso / (altura * altura);
  }

  String getClassificacao(){
    var valor = getImcValue();
    if(valor < 16){
      return 'Magreza grave';
    }else if(valor >= 16 && valor < 17){
      return 'Magreza moderada';
    }else if(valor >= 17 && valor < 18.5){
      return 'Magreza leve';
    }else if(valor >= 18.5 && valor < 25){
      return 'Saudável';
    }else if(valor >= 25 && valor < 30){
      return 'Sobrepeso';
    }else if(valor >= 30 && valor < 35){
      return 'Obesidade Grau I';
    }else if(valor >= 35 && valor < 40){
      return 'Obesidade Grau II (severa)';
    }else{
      return 'Obesidade Grau III (mórbida)';
    }
  }
}