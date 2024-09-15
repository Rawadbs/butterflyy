import 'package:flutter/material.dart';

class HabitListTile extends StatefulWidget {
  final String name;
  final String type;
  final Color color;
  final bool isCompleted;
  final VoidCallback onTap;

  const HabitListTile({
    super.key,
    required this.name,
    required this.type,
    required this.color,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  HabitListTileState createState() => HabitListTileState();
}

class HabitListTileState extends State<HabitListTile> {
  Color _backgroundColor = Colors.transparent;
  Color _borderColor = Colors.transparent;
  bool _isBlack = false;

  @override
  void initState() {
    super.initState();
    _borderColor = widget.color; // Initialize border color based on habit type
    _backgroundColor = widget.isCompleted
        ? widget.color
        : Colors
            .transparent; // Initialize background color based on completion status
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(); // Notify parent widget to toggle completion
        setState(() {
          if (_isBlack) {
            // If currently black, switch back to border-only mode
            _backgroundColor =
                widget.isCompleted ? widget.color : Colors.transparent;
            _borderColor = widget.color;
            _isBlack = false;
          } else {
            if (widget.isCompleted) {
              // If already completed, keep the border and make background transparent
              _backgroundColor = Colors.transparent;
              _borderColor = widget.color;
            } else {
              // If not completed, fill the background with the color
              _backgroundColor = widget.color;
              _borderColor = Colors.transparent;
            }
          }
        });
      },
      onLongPress: () {
        setState(() {
          if (_isBlack) {
            // Switch back to the original color state if it's already black
            _backgroundColor = Colors.transparent;
            _borderColor = widget.color;
            _isBlack = false;
          } else {
            // Turn black on long press
            _backgroundColor = Colors.black;
            _borderColor = Colors.black;
            _isBlack = true;
          }
        });
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: _backgroundColor,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _borderColor, width: 2),
              ),
            ),
          ),
        ),
        title: Text(
          widget.name,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
      ),
    );
  }
}
