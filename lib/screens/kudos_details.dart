import 'package:flutter/material.dart';
import 'package:taskly/models/kudos.dart';

class KudosDetails extends StatefulWidget {
  final Kudos kudos;
  final VoidCallback onClose;
  const KudosDetails({super.key, required this.kudos, required this.onClose});

  @override
  State<KudosDetails> createState() => _KudosDetailsState();
}

class _KudosDetailsState extends State<KudosDetails> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Kudos: ${widget.kudos.score}", style: const TextStyle(fontSize: 24)),
                  ListView.builder(
                    itemCount: widget.kudos.history.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(widget.kudos.history[index][0]),
                        trailing: Text(widget.kudos.history[index][1]),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Close Button at the Top Right
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onClose,
            ),
          ),
        ],
      ),
    );
  }
}
