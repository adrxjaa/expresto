import 'package:flutter/material.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage>
    with SingleTickerProviderStateMixin {

  final criticalRed = const Color(0xFFDA0D0D);
  final warningOrange = Colors.orange;
  final primaryBlue = const Color(0xFF2563EB);

  late AnimationController glowController;
  late Animation<double> glowAnimation;

  double criticalLevel = 0.8;

  bool gpsActive = false;
  bool contactsContacted = false;
  bool helpDispatched = false;

  @override
  void initState() {
    super.initState();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(begin: 4, end: 18).animate(glowController);
  }

  @override
  void dispose() {
    glowController.dispose();
    super.dispose();
  }

  Widget statusButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? Colors.green : primaryBlue,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.green : primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Color borderColor =
        criticalLevel > 0.5 ? criticalRed : warningOrange;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: criticalRed,
        centerTitle: true,
        title: const Text(
          'Emergency',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Container(
        color: Colors.white,

        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            // GLOWING VIDEO DISPLAY
            AnimatedBuilder(
              animation: glowAnimation,
              builder: (context, child) {
                return Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(
                      color: borderColor,
                      width: 5,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: borderColor.withOpacity(0.7),
                        blurRadius: glowAnimation.value,
                        spreadRadius: glowAnimation.value / 2,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // URGENCY INDEX
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text('urgency score meter'),
              ),
            ),

            const SizedBox(height: 20),

            // OPERATOR TRANSCRIPTION (SCROLLABLE)
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: const [
                  Text('Transcript line'),
                  Text('Older transcript line'),
                  Text('Another transcript line'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // RECOGNIZED SIGNS
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  'recognised signs with their confidence score',
                ),
              ),
            ),

            const SizedBox(height: 25),

            // STATUS BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                statusButton(
                  "GPS",
                  gpsActive,
                  () {
                    setState(() {
                      gpsActive = true;
                    });
                  },
                ),

                statusButton(
                  "Contacts",
                  contactsContacted,
                  () {
                    setState(() {
                      contactsContacted = true;
                    });
                  },
                ),

                statusButton(
                  "Dispatched",
                  helpDispatched,
                  () {
                    setState(() {
                      helpDispatched = true;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}