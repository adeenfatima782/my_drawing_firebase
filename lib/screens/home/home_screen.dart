import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider add kiya
import '../../controllers/auth_controller.dart'; // Auth check ke liye
import '../../models/tool_model.dart';
import '../../widgets/tool_card.dart';
import '../draw/canvas_screen.dart';
import 'gallery_screen.dart';
import '../profile/user_profile_screen.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  // Screens list
  final List<Widget> _pages = [
    const ToolsPage(),
    const GalleryScreen(),
    const UserProfileScreen(),
  ];

  void _onFabTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CanvasScreen(toolId: 'pencil'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AuthController ko watch karein taake user load hote hi UI refresh ho
    final auth = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xff0B1120),
      // Agar auth load ho raha hai toh loader dikhayein
      body: auth.loading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : _pages[_index],

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: _onFabTap,
        child: const Icon(Icons.brush, color: Colors.white),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _index,
        onTap: (i) {
          setState(() {
            _index = i;
          });
          // Jab Profile ya Gallery par jayen toh data refresh karein
          if (i == 1 || i == 2) {
            auth.loadCurrentUser();
          }
        },
      ),
    );
  }
}

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  final List<ToolModel> tools = const [
    ToolModel(id: 'pencil', name: 'Pencil', imagePath: 'assets/pencil.png', description: 'Sketch ideas and outlines.'),
    ToolModel(id: 'marker', name: 'Marker', imagePath: 'assets/marker.png', description: 'Bold outlines and markers.'),
    ToolModel(id: 'eraser', name: 'Eraser', imagePath: 'assets/eraser.png', description: 'Erase mistakes seamlessly.'),
    ToolModel(id: 'colors', name: 'Colors', imagePath: 'assets/colors.png', description: 'Pick vibrant colors and palettes.'),
    ToolModel(id: 'brush', name: 'Brush', imagePath: 'assets/brush.png', description: 'Smooth brush strokes.'),
    ToolModel(id: 'ai_sketch', name: 'AI Magic', imagePath: 'assets/canvas.png', description: 'Enhance with AI.'),
    ToolModel(id: 'palette', name: 'Palette', imagePath: 'assets/palette.png', description: 'Professional mixing.'),
    ToolModel(id: 'sketch', name: 'Sketchbook', imagePath: 'assets/sketchbook.png', description: 'Store your ideas.'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Explore Tools',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Spacer(),
                // Gallery Shortcut
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const GalleryScreen()));
                  },
                  icon: const Icon(Icons.photo_library, color: Colors.white),
                ),
              ],
            ),
            const Text(
              'Select a tool to start your masterpiece',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: tools.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, i) {
                  final t = tools[i];
                  return ToolCard(
                    name: t.name,
                    imagePath: t.imagePath,
                    description: t.description,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => CanvasScreen(toolId: t.id),
                      ));
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}