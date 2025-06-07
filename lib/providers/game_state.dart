import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scenario.dart';

class GameState extends ChangeNotifier {
  int _currentRound = 1;
  int _score = 0;
  List<String> _feedback = [];
  List<Scenario> _scenarios = [];
  bool _loading = true;

  int get currentRound => _currentRound;
  int get score => _score;
  List<String> get feedback => _feedback;
  bool get loading => _loading;
  List<Scenario> get scenarios => _scenarios;

  Future<void> fetchScenarios() async {
    _loading = true;
    notifyListeners();
    final snapshot = await FirebaseFirestore.instance
        .collection('scenarios')
        .orderBy('round')
        .get();
    _scenarios = snapshot.docs
        .map((doc) => Scenario.fromMap(doc.data()))
        .toList();
    _loading = false;
    notifyListeners();
  }

  Scenario? getCurrentScenario() {
    if (_scenarios.isEmpty) return null;
    return _scenarios.firstWhere(
      (scenario) => scenario.round == _currentRound,
      orElse: () => _scenarios[0],
    );
  }

  void makeChoice(GameOption option) {
    _score += option.score;
    _feedback.add(option.feedback);
    _currentRound++;
    notifyListeners();
  }

  void resetGame() {
    _currentRound = 1;
    _score = 0;
    _feedback = [];
    notifyListeners();
  }

  bool isGameOver() {
    return _currentRound > (_scenarios.isEmpty ? 10 : _scenarios.length);
  }

  String getFinalFeedback() {
    if (_score >= 150) {
      return "Excepcional! Você é um consultor de primeira linha que toma decisões estratégicas brilhantes!";
    } else if (_score >= 100) {
      return "Muito bom! Suas decisões foram geralmente acertadas e estratégicas.";
    } else if (_score >= 50) {
      return "Bom trabalho! Há espaço para melhorias, mas você mostrou potencial.";
    } else {
      return "Você precisa desenvolver melhor suas habilidades de consultoria. Continue aprendendo!";
    }
  }
}
