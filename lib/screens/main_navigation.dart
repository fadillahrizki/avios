import 'package:avios/constants/custom_color.dart';
import 'package:avios/screens/done.dart';
import 'package:avios/screens/home.dart';
import 'package:avios/services/firebase_service.dart';
import 'package:avios/services/task_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'waiting.dart';
import 'package:flutter/material.dart';

import '../../components/custom_button.dart';
import '../../components/custom_dialog.dart';
import '../../components/custom_text_field.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Waiting(),
    Done(),
  ];

  String title = "Home";
  Color _selectedColor = CustomColor().primary;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  createTask() async {
    await TaskService.createTask(titleController.text,
        descriptionController.text, _selectedIndex > 1 ? 'done' : 'waiting');
    if (context.mounted) {
      Navigator.pop(context);
      titleController.clear();
      descriptionController.clear();
    }
  }
  
  final adUnitId = "ca-app-pub-3940256099942544/6300978111";
  BannerAd? _bannerAd;
  bool isBannerReady = false;

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void loadAd() {
    BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            isBannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isBannerReady = false;
          ad.dispose();
        },
      ),
    ).load();
  }

  void _onItemTapped(int index) async {
    if (index == 3) {
      await FirebaseService.logout();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      setState(() {
        _selectedIndex = index;
        switch (index) {
          case 1:
            title = "Waiting";
            _selectedColor = Colors.amber;
            break;
          case 2:
            title = "Done";
            _selectedColor = Colors.green;
            break;
          default:
            title = "Home";
            _selectedColor = CustomColor().primary;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor().background,
      appBar: AppBar(
        actions: const <Widget>[],
        backgroundColor: _selectedColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            isBannerReady
                ? SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  )
                : Container(),
            const SizedBox(height: 12),
            _widgetOptions.elementAt(_selectedIndex),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CustomDialog(
              content: [
                CustomTextField(
                  label: "Title",
                  controller: titleController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: "Description",
                  controller: descriptionController,
                  maxLines: 10,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: "Close",
                        type: "secondary",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        onPressed: () async {
                          await createTask();
                        },
                        label: "Create",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        foregroundColor: CustomColor().white,
        backgroundColor: CustomColor().primary,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            label: 'Waiting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
