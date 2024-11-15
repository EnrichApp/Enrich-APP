import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
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
      return _ChartData('Mês ${index + 1}', projectedReturn);
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
              _buildTextField(_initialInvestmentController,
                  'Qual será o seu aporte inicial?', 'Ex.: 200.00'),
              _buildTextField(
                  _monthlyInvestmentController,
                  'Quanto dinheiro você pretende investir mensalmente?',
                  'Ex.: 200.00'),
              _buildTextField(
                  _expectedReturnRateController,
                  'Qual taxa de rendimento mensal você espera com seus investimentos?',
                  'Ex.: 1'),
              _buildTextField(
                  _targetDateController,
                  'Para qual mês e ano você deseja simular resultados?',
                  'Ex.: 12/2025'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simulateInvestment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary, // Cor de fundo azul
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
                        'No mês de $_selectedMonth',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    Text(
                      'R\$ ${_selectedEarnings?.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 28, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 4,
                        radius: Radius.circular(10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _chartData.length,
                          itemBuilder: (context, index) {
                            final data = _chartData[index];
                            final isSelected = data.month == _selectedMonth;
                            
                            return GestureDetector(
                              onTap: () => _onBarTapped(data),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 100, // Altura máxima da barra
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: 40,
                                          height: data.returnValue, // Altura proporcional ao valor
                                          decoration: BoxDecoration(
                                            color: isSelected ? Theme.of(context).colorScheme.tertiary : Colors.blue.shade200,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      data.month,
                                      style: TextStyle(
                                        color: isSelected ? Theme.of(context).colorScheme.tertiary : Colors.grey,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
