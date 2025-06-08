import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_state.dart';
import '../models/scenario.dart';
import 'firebase_crud_screen.dart'; // Import the FirebaseCrudScreen

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int? selectedOptionIndex;
  bool optionChosen = false;

  @override
  void initState() {
    super.initState();
    // Busca os cenários do Firestore ao iniciar a tela
    Provider.of<GameState>(context, listen: false).fetchScenarios();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        if (gameState.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (gameState.scenarios.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Nenhum cenário encontrado ou erro de conexão com o banco de dados.')),
          );
        }
        if (gameState.isGameOver()) {
          return _buildGameOverScreen(context, gameState);
        }

        final scenario = gameState.getCurrentScenario();
        if (scenario == null) return Container();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Vortex Solutions Simulator',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.blue[900],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.login),
                  title: Text('Login'),
                  onTap: () {
                    // TODO: Implement navigation to Login screen
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Config'),
                  onTap: () {
                    // TODO: Implement navigation to Config screen
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Firebase CRUD'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FirebaseCrudScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRoundInfo(gameState),
                SizedBox(height: 16),
                _buildScenarioCard(scenario),
                SizedBox(height: 24),
                _buildOptions(context, scenario, gameState),
                SizedBox(height: 16),
                if (gameState.feedback.isNotEmpty)
                  _buildFeedbackSection(gameState),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoundInfo(GameState gameState) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rodada ${gameState.currentRound}/10',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Pontuação: ${gameState.score}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(Scenario scenario) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scenario.title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 16),
            Text(
              scenario.context,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(
    BuildContext context,
    Scenario scenario,
    GameState gameState,
  ) {
    return Column(
      children: scenario.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = selectedOptionIndex == index;
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: isSelected
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : SizedBox(width: 24),
              label: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${String.fromCharCode(65 + index)}. ${option.text}',
                  style: GoogleFonts.poppins(fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: isSelected ? Colors.green[50] : Colors.white,
                foregroundColor: Colors.blue[900],
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.blue[900]!),
                ),
              ),
              onPressed: optionChosen
                  ? null
                  : () {
                      setState(() {
                        selectedOptionIndex = index;
                        optionChosen = true;
                      });
                      Future.delayed(Duration(milliseconds: 600), () {
                        gameState.makeChoice(option);
                        setState(() {
                          selectedOptionIndex = null;
                          optionChosen = false;
                        });
                      });
                    },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeedbackSection(GameState gameState) {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feedback da última decisão:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              gameState.feedback.last,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverScreen(BuildContext context, GameState gameState) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fim de Jogo!',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Pontuação Final: ${gameState.score}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    gameState.getFinalFeedback(),
                    style: GoogleFonts.poppins(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                onPressed: () {
                  Provider.of<GameState>(context, listen: false).resetGame();
                  setState(() {
                    selectedOptionIndex = null;
                    optionChosen = false;
                  });
                },
                child: Text(
                  'Jogar Novamente',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
