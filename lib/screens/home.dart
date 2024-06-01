import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ibp_app_ver2/navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController(initialPage: 0);
  String _firstName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot users = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _firstName = users['display_name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF580049),
      appBar: AppBar(
        backgroundColor: const Color(0xFF580049),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Magandang Araw, $_firstName',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        const Text(
                          'Kumusta Ka?',
                          style: TextStyle(color: Colors.white, fontSize: 31),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        _buildPageItem(
                          title: '|  Palawakin ang Iyong Kaalaman: ',
                          description:
                              'Mag-access ng mga artikulo, FAQs, at mga mapagkukunan sa mga karaniwang legal na katanungan, at manatiling updated sa mundo ng batas.',
                          color: const Color(0xFFB73CA8),
                        ),
                        _buildPageItem(
                          title: '| Mag-book ng abogado para sa iyong kaso:',
                          description:
                              'Mag-book ng mga abogado na mayroong napatunayang kakayahan at karanasan upang matugunan ang iyong mga legal na pangangailangan.',
                          color: const Color(0xFF221F1F),
                        ),
                        _buildPageItem(
                          title: '|  Mag-email sa amin para sa tulong:',
                          description:
                              'I-email ang aming koponan para sa iyong mga alalahanin. Huwag mag-atubiling makipag-ugnayan sa amin para sa karagdagang impormasyon o tulong sa anumang oras.',
                          color: const Color(0xFFD8C02E),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        expansionFactor: 3,
                        spacing: 8,
                        radius: 16,
                        dotWidth: 16,
                        dotHeight: 8,
                        dotColor: Color(0xFFC0E0FF),
                        activeDotColor: Color(0xFFD8C54F),
                        paintStyle: PaintingStyle.fill,
                      ),
                      onDotClicked: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildIconOption(
                              icon: Icons.gavel_rounded,
                              label: 'Konsulta',
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/applicant_profile');
                              },
                            ),
                            _buildIconOption(
                              icon: FontAwesomeIcons.solidNewspaper,
                              label: 'Mga Batas',
                              onTap: () {
                                print('Mga Batas pressed');
                              },
                            ),
                            _buildIconOption(
                              icon: Icons.email_rounded,
                              label: 'FAQs',
                              onTap: () {
                                print('FAQs pressed');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mga Bagong Artikulo',
                                style: TextStyle(
                                  color: Color(0xFF580049),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Tingnan lahat',
                                style: TextStyle(
                                  color: Color(0xFF407CE2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildArticleItem(
                          imageUrl: 'https://picsum.photos/seed/622/600',
                          title:
                              'Mga Karapatan at Proteksyon ng Mamimili: Ang Iyong Legal na Pananggalang bilang Mamimili sa Pilipinas',
                          date: 'Jan 14, 2024',
                        ),
                        _buildArticleItem(
                          imageUrl: 'https://picsum.photos/seed/622/600',
                          title:
                              'Mga Karapatan at Proteksyon ng Mamimili: Ang Iyong Legal na Pananggalang bilang Mamimili sa Pilipinas',
                          date: 'Jan 14, 2024',
                        ),
                        _buildArticleItem(
                          imageUrl: 'https://picsum.photos/seed/622/600',
                          title:
                              'Mga Karapatan at Proteksyon ng Mamimili: Ang Iyong Legal na Pananggalang bilang Mamimili sa Pilipinas',
                          date: 'Jan 14, 2024',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 50), // Add some space above the navigation bar
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const CustomNavigationBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageItem({
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(description, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildIconOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF580049),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildArticleItem({
    required String imageUrl,
    required String title,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 81,
              height: 82,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 5),
                Text(date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
