import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCrudScreen extends StatefulWidget {
  const FirebaseCrudScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseCrudScreen> createState() => _FirebaseCrudScreenState();
}

class _FirebaseCrudScreenState extends State<FirebaseCrudScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _roundController = TextEditingController();
  final List<OptionField> _options = [];
  String? _editingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cenários (Firestore CRUD)'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildScenarioForm(),
            const SizedBox(height: 16),
            Expanded(child: _buildScenarioList()),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _contextController,
                decoration: const InputDecoration(labelText: 'Contexto'),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _roundController,
                decoration: const InputDecoration(labelText: 'Rodada'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _editingId == null ? _addScenario : _updateScenario,
              child: Text(_editingId == null ? 'Adicionar' : 'Atualizar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Opções:'),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _options.add(OptionField());
                });
              },
              child: const Text('Adicionar Opção'),
            ),
          ],
        ),
        ..._options.asMap().entries.map((entry) {
          final idx = entry.key;
          final opt = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: opt.textController,
                    decoration: const InputDecoration(labelText: 'Texto da Opção'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: opt.feedbackController,
                    decoration: const InputDecoration(labelText: 'Feedback'),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: opt.scoreController,
                    decoration: const InputDecoration(labelText: 'Score'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _options.removeAt(idx);
                    });
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildScenarioList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('scenarios').orderBy('round').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum cenário encontrado.'));
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final options = (data['options'] as List?) ?? [];
            return Card(
              child: ListTile(
                title: Text(data['title'] ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contexto: ${data['context'] ?? ''}'),
                    Text('Rodada: ${data['round'] ?? ''}'),
                    const SizedBox(height: 4),
                    ...options.asMap().entries.map((entry) {
                      final opt = entry.value as Map<String, dynamic>;
                      return Text('Opção ${entry.key + 1}: ${opt['text']} (Score: ${opt['score']})');
                    }),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _editScenario(doc.id, data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteScenario(doc.id),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _addScenario() async {
    if (_titleController.text.isEmpty || _contextController.text.isEmpty || _roundController.text.isEmpty) return;
    await FirebaseFirestore.instance.collection('scenarios').add({
      'title': _titleController.text,
      'context': _contextController.text,
      'round': int.tryParse(_roundController.text) ?? 1,
      'options': _options.map((opt) => opt.toMap()).toList(),
    });
    _clearForm();
  }

  Future<void> _updateScenario() async {
    if (_editingId == null) return;
    await FirebaseFirestore.instance.collection('scenarios').doc(_editingId).update({
      'title': _titleController.text,
      'context': _contextController.text,
      'round': int.tryParse(_roundController.text) ?? 1,
      'options': _options.map((opt) => opt.toMap()).toList(),
    });
    setState(() {
      _editingId = null;
    });
    _clearForm();
  }

  Future<void> _deleteScenario(String id) async {
    await FirebaseFirestore.instance.collection('scenarios').doc(id).delete();
    if (_editingId == id) {
      setState(() {
        _editingId = null;
      });
      _clearForm();
    }
  }

  void _editScenario(String id, Map<String, dynamic> data) {
    setState(() {
      _editingId = id;
      _titleController.text = data['title'] ?? '';
      _contextController.text = data['context'] ?? '';
      _roundController.text = data['round']?.toString() ?? '';
      _options.clear();
      final options = (data['options'] as List?) ?? [];
      for (final opt in options) {
        _options.add(OptionField.fromMap(opt as Map<String, dynamic>));
      }
    });
  }

  void _clearForm() {
    _titleController.clear();
    _contextController.clear();
    _roundController.clear();
    _options.clear();
    setState(() {
      _editingId = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contextController.dispose();
    _roundController.dispose();
    for (final opt in _options) {
      opt.dispose();
    }
    super.dispose();
  }
}

class OptionField {
  final TextEditingController textController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();

  OptionField();
  OptionField.fromMap(Map<String, dynamic> map) {
    textController.text = map['text'] ?? '';
    feedbackController.text = map['feedback'] ?? '';
    scoreController.text = map['score']?.toString() ?? '';
  }
  Map<String, dynamic> toMap() => {
        'text': textController.text,
        'feedback': feedbackController.text,
        'score': int.tryParse(scoreController.text) ?? 0,
      };
  void dispose() {
    textController.dispose();
    feedbackController.dispose();
    scoreController.dispose();
  }
}
