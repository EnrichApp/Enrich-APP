import 'package:enrich/widgets/inputs/month_year_input_formatter.dart';
import 'package:enrich/widgets/inputs/percentage_input_formatter.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:enrich/widgets/inputs/money_input_formatter.dart';
import 'package:flutter/material.dart';

class InvestmentSimulationPage extends StatefulWidget {
  @override
  _InvestmentSimulationPageState createState() =>
      _InvestmentSimulationPageState();
}

class _InvestmentSimulationPageState extends State<InvestmentSimulationPage> {
  final _initialInvestmentController = TextEditingController();
  final _monthlyInvestmentController = TextEditingController();
  final _expectedReturnRateController = TextEditingController();
  final _targetDateController = TextEditingController();
  bool _showResults = false;
  List<_ChartData> _chartData = [];
  double? _selectedEarnings;
  String? _selectedMonth;

  @override
  void initState() {
    super.initState();

    _initialInvestmentController.addListener(() => setState(() {}));
    _monthlyInvestmentController.addListener(() => setState(() {}));
    _expectedReturnRateController.addListener(() => setState(() {}));
    _targetDateController.addListener(() => setState(() {}));
  }


  bool _formularioValido() {
    return _initialInvestmentController.text.trim().isNotEmpty &&
        _monthlyInvestmentController.text.trim().isNotEmpty &&
        _expectedReturnRateController.text.trim().isNotEmpty &&
        _targetDateController.text.trim().isNotEmpty;
  }

  void _simulateInvestment() {
    double initialInvestment =
        double.tryParse(_initialInvestmentController.text) ?? 0;
    double monthlyInvestment =
        double.tryParse(_monthlyInvestmentController.text) ?? 0;
    double expectedReturnRate =
        (double.tryParse(_expectedReturnRateController.text) ?? 0) / 100;

    _chartData = List.generate(12, (index) {
      double totalInvestment = initialInvestment + (monthlyInvestment * index);
      double projectedReturn = totalInvestment * expectedReturnRate;
      return _ChartData('mês ${index + 1}', projectedReturn);
    });

    setState(() {
      _showResults = true;
      // Define o último mês como selecionado por padrão
      _selectedEarnings = _chartData.last.returnValue;
      _selectedMonth = _chartData.last.month;
    });
  }

  void _onBarTapped(_ChartData data) {
    setState(() {
      _selectedEarnings = data.returnValue;
      _selectedMonth = data.month;
    });
  }

  @override
  void dispose() {
    _initialInvestmentController.dispose();
    _monthlyInvestmentController.dispose();
    _expectedReturnRateController.dispose();
    _targetDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 14,
              ),
              SizedBox(
                width: 2,
              ),
              LittleText(
                text: 'Voltar',
                fontSize: 12,
                underlined: true,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleText(
                text: 'Simulações',
                fontSize: 20,
              ),
              buildMoneyField(
                controller: _initialInvestmentController,
                label: 'Qual será o seu aporte inicial?',
              ),
              buildMoneyField(
                controller: _monthlyInvestmentController,
                label: 'Quanto dinheiro você pretende investir mensalmente?',
              ),
              buildPercentField(
                controller: _expectedReturnRateController,
                label: 'Qual taxa de rendimento mensal você espera com seus investimentos?',
              ),
              buildMonthYearPickerField(
                controller: _targetDateController,
                label: 'Para qual mês e ano você deseja simular resultados?',
                context: context,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _formularioValido() ? _simulateInvestment : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos.')),
                  );
                  return;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _formularioValido() ? Theme.of(context).colorScheme.tertiary : Colors.grey, // Cor de fundo azul
                  padding: EdgeInsets.symmetric(
                      vertical: 16), // Espaçamento vertical do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30), // Bordas arredondadas para combinar com o design
                  ),
                ),
                child: Text(
                  'Simular resultados',
                  style: TextStyle(
                    color: Colors.white, // Texto em branco
                    fontWeight: FontWeight.bold, // Texto em negrito
                    fontSize: 16, // Tamanho do texto
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_showResults)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No $_selectedMonth',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    Text(
                      'R\$ ${_selectedEarnings?.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 28, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Container(
  height: 170,
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Scrollbar(
    thumbVisibility: true,
    thickness: 4,
    radius: Radius.circular(10),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _chartData.map((data) {
          final isSelected = data.month == _selectedMonth;

          return GestureDetector(
            onTap: () => _onBarTapped(data),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 40,
                        height: data.returnValue,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.tertiary
                              : Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.month,
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.tertiary
                          : Colors.grey,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ),
  ),
),

                    SizedBox(height: 50),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16, color: Colors.black
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.black, // Cor do texto digitado em preto
            ),
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(30.0), // Bordas arredondadas
                borderSide: BorderSide.none, // Sem borda visível
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 14, horizontal: 20), // Espaço interno ajustado
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  final String month;
  final double returnValue;

  _ChartData(this.month, this.returnValue);
}
