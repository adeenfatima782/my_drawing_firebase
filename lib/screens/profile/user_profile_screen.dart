import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/drawing_controller.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isDarkMode = true; // Theme toggle ke liye

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final dCtrl = context.watch<DrawingController>();
    final user = auth.currentUser;

    final userDrawings = dCtrl.drawings.where((d) => d.ownerId == user?.id).toList();

    return Scaffold(
      // Theme change logic
      backgroundColor: isDarkMode ? const Color(0xff060912) : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("ARTIST PROFILE",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87
            )),
        centerTitle: true,
        actions: [
          // --- THEME TOGGLE BUTTON ---
          IconButton(
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
            icon: Icon(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: Colors.amber,
            ),
          ),
          IconButton(
            onPressed: () => auth.signOut(),
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- USER AVATAR ---
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              backgroundImage: (user?.imageUrl != null && user!.imageUrl!.isNotEmpty)
                  ? NetworkImage(user.imageUrl!)
                  : null,
              child: (user?.imageUrl == null || user!.imageUrl!.isEmpty)
                  ? const Icon(Icons.person_rounded, size: 60, color: Colors.blueAccent)
                  : null,
            ),

            const SizedBox(height: 15),

            // --- USER INFO & JOINED DATE ---
            Text(
                user?.username ?? "Artist",
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                )
            ),
            const SizedBox(height: 4),
            Text(
                "Member since: Dec 2025", // Joined Date
                style: TextStyle(color: isDarkMode ? Colors.white38 : Colors.black45, fontSize: 12)
            ),
            const SizedBox(height: 2),
            Text(
                user?.email ?? "artist@magic.com",
                style: TextStyle(color: isDarkMode ? Colors.white24 : Colors.black38, fontSize: 11)
            ),

            // --- MODERN STATS DASHBOARD ---
            Container(
              margin: const EdgeInsets.all(25),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: isDarkMode ? Colors.white10 : Colors.black12),
                boxShadow: isDarkMode ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat("ARTS", userDrawings.length.toString()),
                  _buildDivider(),
                  _buildStat("RANK", userDrawings.length >= 5 ? "PRO" : "ROOKIE"),
                  _buildDivider(),
                  _buildStat("XP", (userDrawings.length * 100).toString()),
                ],
              ),
            ),

            // --- MASTERPIECES GRID ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("MY MASTERPIECES",
                    style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 11
                    )),
              ),
            ),

            userDrawings.isEmpty
                ? const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text("No drawings yet.", style: TextStyle(color: Colors.white24)),
            )
                : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: userDrawings.length,
              itemBuilder: (context, index) {
                final drawing = userDrawings[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: isDarkMode ? Colors.white10 : Colors.black12),
                    image: DecorationImage(
                      image: NetworkImage(drawing.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: isDarkMode ? Colors.white38 : Colors.black45, fontSize: 10, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: isDarkMode ? Colors.white10 : Colors.black12);
  }
}