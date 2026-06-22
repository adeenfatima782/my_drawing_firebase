import 'package:flutter/material.dart';

class AnimatedBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  AnimatedBottomNav({required this.currentIndex, required this.onTap});

  @override
  _AnimatedBottomNavState createState() => _AnimatedBottomNavState();
}

class _AnimatedBottomNavState extends State<AnimatedBottomNav> {
  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home, label: "Home"),
      _NavItem(icon: Icons.photo_library, label: "Gallery"),
      _NavItem(icon: Icons.brush, label: "Draw"),
      _NavItem(icon: Icons.grid_view, label: "Templates"),
      _NavItem(icon: Icons.auto_awesome, label: "AI"),
      _NavItem(icon: Icons.person, label: "Profile"),
    ];

    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0,6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final it = entry.value;
          final selected = widget.currentIndex == idx;
          return Expanded(
            child: InkWell(
              onTap: () => widget.onTap(idx),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  color: selected ? Colors.white.withOpacity(0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: selected ? 1.15 : 1.0,
                      duration: Duration(milliseconds: 300),
                      child: Icon(it.icon, size: 22, color: selected ? Theme.of(context).primaryColor : Colors.white70),
                    ),
                    SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: selected ? 12 : 0,
                        color: selected ? Theme.of(context).primaryColor : Colors.transparent,
                        fontWeight: FontWeight.w600,
                      ),
                      child: Text(it.label),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}
