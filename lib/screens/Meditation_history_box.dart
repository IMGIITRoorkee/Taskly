import 'package:flutter/material.dart';
import 'package:taskly/storage/meditation_history_storage.dart';

class MeditationHistory extends StatefulWidget {
  final VoidCallback onClose;
  const MeditationHistory({super.key, required this.onClose});

  @override
  State<MeditationHistory> createState() => _MeditationHistoryState();
}

class _MeditationHistoryState extends State<MeditationHistory> {
  Future<List<Map<String, dynamic>>>? history =
      MeditationHistoryStorage.getHistory();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: history,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          var meditationHistory = snapshot.data;
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.black,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Meditation History',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (meditationHistory!.isNotEmpty)
                          TextButton(
                            onPressed: () async {
                              await MeditationHistoryStorage.clearHistory();
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Clear all"),
                          ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          itemCount: meditationHistory?.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade800,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 5,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  "${meditationHistory?[index]["time"]} minutes",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  "${meditationHistory?[index]["diff"]} seconds",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: Text(
                                  meditationHistory?[index]["date"],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: widget.onClose,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
