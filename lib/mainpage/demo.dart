import 'package:flutter/material.dart';



class LocationSearchUI extends StatefulWidget {
  @override
  _LocationSearchUIState createState() => _LocationSearchUIState();
}

class _LocationSearchUIState extends State<LocationSearchUI> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> allLocations = [
    "Malappuram, Kerala, India",
    "Malaprabha, Karnataka, India",
    "Malappattam, Kerala, India",
    "Malapatan, Sarangani, Philippines",
    "Malapie Hill, Nevada, United States",
  ];

  List<String> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final query = _controller.text.toLowerCase();
      setState(() {
        filteredLocations = allLocations
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 274.0, left: 23.0, right: 23.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TextFormField
                Container(
                  width: 324,
                  height: 38.58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextFormField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search location',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Dropdown list
                if (_controller.text.isNotEmpty && filteredLocations.isNotEmpty)
                  Container(
                    width: 324,
                    constraints: BoxConstraints(maxHeight: 180),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredLocations.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredLocations[index]),
                          onTap: () {
                            _controller.text = filteredLocations[index];
                            setState(() => filteredLocations.clear());
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
