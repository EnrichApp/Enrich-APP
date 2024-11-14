import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  void _simulateInvestment() {
    // Exemplo simples de simulação, adaptado para lógica personalizada
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
      appBar: AppBar(
        title: Text('Simulações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_initialInvestmentController,
                'Qual será o seu aporte inicial?', 'Ex.: R\$200.00'),
            _buildTextField(
                _monthlyInvestmentController,
                'Quanto dinheiro você pretende investir mensalmente?',
                'Ex.: R\$200.00'),
            _buildTextField(
                _expectedReturnRateController,
                'Qual taxa de rendimento mensal você espera com seus investimentos?',
                'Ex.: 1%'),
            _buildTextField(
                _targetDateController,
                'Para qual mês e ano você deseja simular resultados?',
                'Ex.: 12/2025'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simulateInvestment,
              child: Text('Simular resultados'),
            ),
            SizedBox(height: 20),
            if (_showResults)
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Projeção de Retorno Mensal'),
                  series: <CartesianSeries>[
                    LineSeries<_ChartData, String>(
                      dataSource: _chartData,
                      xValueMapper: (_ChartData data, _) => data.month,
                      yValueMapper: (_ChartData data, _) => data.returnValue,
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _ChartData {
  final String month;
  final double returnValue;

  _ChartData(this.month, this.returnValue);
}
