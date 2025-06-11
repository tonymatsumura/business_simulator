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
        .map((doc) {
          final scenario = Scenario.fromMap(doc.data());
          scenario.options.shuffle(); // Shuffle options for each scenario
          return scenario;
        })
        .toList();
    _scenarios.shuffle(); // Randomize the order of scenarios
    _loading = false;
    notifyListeners();
  }

  Scenario? getCurrentScenario() {
    if (_scenarios.isEmpty) return null;
    // Use the current round as an index into the shuffled list
    if (_currentRound - 1 < _scenarios.length && _currentRound > 0) {
      return _scenarios[_currentRound - 1];
    }
    return null;
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
    _scenarios.shuffle(); // Shuffle scenarios for a new random order
    notifyListeners();
  }

  bool isGameOver() {
    return _currentRound > 10;
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
