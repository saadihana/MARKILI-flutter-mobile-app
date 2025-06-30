import 'package:flutter/material.dart';

void showCustomBottomDrawer(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Mon Profile'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Mes Rendez-vous'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Historiques'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Déconnexion'),
              titleTextStyle: TextStyle(color: Colors.red),
              trailing: Icon(Icons.chevron_right, color: Colors.red),
              onTap: () {
// Add your logout functionality here
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
