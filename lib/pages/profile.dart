import 'package:flutter/material.dart';
import 'package:expresto/pages/contacts.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String bloodType = "O";
  String bloodSign = "+";

  final phoneController = TextEditingController(text: "9876543210");

  final List<String> bloodTypes = ["A", "B", "AB", "O"];
  final List<String> signs = ["+", "-"];

  void editPhone() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Phone Number"),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: const InputDecoration(
              hintText: "Enter 10 digit number",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (phoneController.text.length == 10) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person,size:60,color:Colors.white),
              ),
            ),

            const SizedBox(height:20),

            const Center(
              child: Text(
                "FN LN",
                style: TextStyle(fontSize:22,fontWeight:FontWeight.bold),
              ),
            ),

            const SizedBox(height:30),

            // BLOOD GROUP DROPDOWN
            Container(
              height:70,
              padding: const EdgeInsets.symmetric(horizontal:15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text("Blood Group"),

                  Row(
                    children: [

                      DropdownButton<String>(
                        value: bloodType,
                        underline: const SizedBox(),
                        items: bloodTypes
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            bloodType = value!;
                          });
                        },
                      ),

                      const SizedBox(width:10),

                      DropdownButton<String>(
                        value: bloodSign,
                        underline: const SizedBox(),
                        items: signs
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            bloodSign = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height:15),

            // PHONE NUMBER
            GestureDetector(
              onTap: editPhone,
              child: _infoBox("Phone","+91 ${phoneController.text}"),
            ),

            const SizedBox(height:15),

            // EMERGENCY CONTACT
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmergencyContactsPage(),
                  ),
                );
              },
              child: _infoBox("Emergency Contact","Manage"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String title,String value) {
    return Container(
      height:70,
      padding: const EdgeInsets.symmetric(horizontal:15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(title),

          Row(
            children: [
              Text(value,style: const TextStyle(fontWeight:FontWeight.bold)),
              const SizedBox(width:10),
              const Icon(Icons.arrow_forward_ios,size:16)
            ],
          ),
        ],
      ),
    );
  }
}