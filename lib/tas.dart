import 'package:flutter/material.dart';

class EditWatchlistPage extends StatefulWidget {
  const EditWatchlistPage({super.key});

  @override
  State<EditWatchlistPage> createState() => _EditWatchlistPageState();
}

class _EditWatchlistPageState extends State<EditWatchlistPage> {
  final TextEditingController nameController =
  TextEditingController(text: "Goldfinacse loan");

  final TextEditingController newStockController = TextEditingController();

  List<String> stocks = [
    'Shriram Finance',
    'IIFL Finance',
    'Muthoot Finance',
    'Manappuram Finance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Edit WatchList"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // Clear the list
              setState(() {
                stocks.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter Watchlist Name",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
              ),
            ),
          ),

          // Add new stock
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newStockController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Add Stock",
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final newStock = newStockController.text.trim();
                    if (newStock.isNotEmpty &&
                        !stocks.contains(newStock)) {
                      setState(() {
                        stocks.add(newStock);
                        newStockController.clear();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Reorderable List
          Expanded(
            child: ReorderableListView.builder(
              itemCount: stocks.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = stocks.removeAt(oldIndex);
                  stocks.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final stock = stocks[index];
                return Dismissible(
                  key: ValueKey(stock),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() {
                      stocks.removeAt(index);
                    });
                  },
                  child: Draggable<String>(
                    data: stock,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 64,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          stock,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    childWhenDragging:
                    Opacity(opacity: 0.4, child: buildStockTile(stock)),
                    child: buildStockTile(stock),
                  ),
                );
              },
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Saved: ${stocks.toString()}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Save", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStockTile(String stock) {
    return Container(
      key: ValueKey(stock),
      color: Colors.transparent,
      child: ListTile(
        leading: const Icon(Icons.drag_handle, color: Colors.white70),
        title: Text(stock, style: const TextStyle(color: Colors.white)),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.white60),
          onPressed: () {
            setState(() {
              stocks.remove(stock);
            });
          },
        ),
      ),
    );
  }
}
