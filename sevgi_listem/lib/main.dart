import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color deepPink = Color(0xFFE91E63);
    const Color softPink = Color(0xFFFCE4EC); // Pink 50

    return MaterialApp(
      title: 'Sevgi Listem 💖',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: deepPink),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: deepPink,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          color: softPink.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return deepPink;
            }
            return deepPink.withValues(alpha: 0.4);
          }),
        ),
      ),
      home: const RomanticTodoPage(),
    );
  }
}

class TodoTask {
  TodoTask({required this.title, this.isCompleted = false});

  final String title;
  bool isCompleted;
}

class RomanticTodoPage extends StatefulWidget {
  const RomanticTodoPage({super.key});

  @override
  State<RomanticTodoPage> createState() => _RomanticTodoPageState();
}

class _RomanticTodoPageState extends State<RomanticTodoPage> {
  final List<TodoTask> _tasks = <TodoTask>[];
  bool _celebrationShown = false;

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _maybeShowCelebration();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _addTask() async {
    final TextEditingController controller = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Yeni Görev Ekle 💘',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Bugün ne yapalım, aşkım? 💞',
                  filled: true,
                  fillColor: const Color(0xFFFCE4EC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isEmpty) return;
                  setState(() {
                    _tasks.add(TodoTask(title: value.trim()));
                  });
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  final String value = controller.text.trim();
                  if (value.isEmpty) return;
                  setState(() {
                    _tasks.add(TodoTask(title: value));
                  });
                  Navigator.of(ctx).pop();
                },
                icon: const Icon(Icons.add),
                label: const Text('Ekle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _maybeShowCelebration() {
    if (_completedCount >= 5 && !_celebrationShown) {
      _celebrationShown = true;
      showDialog<void>(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Tebrikler 💖'),
            content: const Text(
              'Aşkım, seninle hayat daha güzel 💞',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Kapat'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color gradientStart = Color(0xFFFCE4EC); // soft pink
    const Color gradientEnd = Color(0xFFF3E5F5); // soft purple

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Bugünün Görevleri 💖'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[gradientStart, gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            child: _tasks.isEmpty
                ? _EmptyState(onAddTap: _addTask)
                : ListView.separated(
                    itemCount: _tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      final TodoTask task = _tasks[index];
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              task.isCompleted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: task.isCompleted
                                  ? const Color(0xFFE91E63)
                                  : const Color(0xFFE91E63).withValues(alpha: 0.5),
                            ),
                            onPressed: () => _toggleTask(index),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: Colors.black38,
                              decorationThickness: 2,
                            ),
                          ),
                          onTap: () => _toggleTask(index),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.black54,
                            onPressed: () => _deleteTask(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Sevgi Listem 💖',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hadi birlikte küçük hedefler koyalım ✨',
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAddTap,
            icon: const Icon(Icons.add),
            label: const Text('İlk görevini ekle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
