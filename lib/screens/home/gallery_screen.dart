import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/drawing_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/art_card.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final auth = Provider.of<AuthController>(context, listen: false);
      final drawing = Provider.of<DrawingController>(context, listen: false);

      if (auth.currentUser == null) await auth.loadCurrentUser();
      if (auth.currentUser != null) {
        drawing.loadUserDrawings(auth.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = context.watch<DrawingController>();

    if (d.loading) {
      return const Scaffold(
        backgroundColor: Color(0xff0B1120),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (d.drawings.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xff0B1120),
        appBar: AppBar(
          title: const Text('Gallery'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: GlassContainer(
            radius: 20,
            padding: const EdgeInsets.all(12),
            onTap: () {},
            child: SizedBox(
              width: 260,
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.photo_library, size: 42, color: Colors.white70),
                  SizedBox(height: 12),
                  Text(
                    'No images yet\nStart drawing to save images.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff0B1120),
      appBar: AppBar(
        title: const Text('Gallery'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: d.drawings.length,
        itemBuilder: (_, i) {
          final item = d.drawings[i];
          final heroTag = '${item.id}_${item.imageUrl}';
          return ArtCard(
            drawing: item,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _ImageViewScreen(
                  imageUrl: item.imageUrl,
                  heroTag: heroTag,
                ),
              ),
            ),
            onDelete: () => d.deleteDrawing(item.id),
          );
        },
      ),
    );
  }
}

class _ImageViewScreen extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const _ImageViewScreen({super.key, required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) =>
            progress == null ? child : const CircularProgressIndicator(),
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white54),
          ),
        ),
      ),
    );
  }
}
