import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ibp_app_ver2/screens/chat_screen.dart';
import 'package:ibp_app_ver2/screens/laws_jurisprudence.dart';
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
  String _displayName = '';
  String _middleName = '';
  String _lastName = '';
  String _email = '';
  String _userQrCode = '';

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
        _displayName = users['display_name'];
        _middleName = users['middle_name'];
        _lastName = users['last_name'];
        _email = users['email'];
        _userQrCode = users['userQrCode'];
      });
    }
  }

  void _showDisclaimerModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Disclaimer'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Thank you for using our app, Integrated Bar of the Philippines Electronic Legal Services and Access Malolos Chapter (IBP - ELSA Malolos), which serves as an online appointment booking system for IBP Malolos. Additionally, our app offers web viewing of Jur.ph, an AI-Powered Legal Research Platform in the Philippines. By incorporating Jur.ph into our app, we aim to provide a valuable public service that significantly benefits our users by granting access to essential legal information and resources.\n\n'
                  'Our app, IBP - ELSA Malolos, is independent of Jur.ph. Jur.ph retains sole ownership of their content, and our app maintains a separate identity. By including their website, we aim to offer essential legal information and resources as a public service.\n\n'
                  'By incorporating Jur.ph into our app, we aim to:\n\n'
                  'Offer a valuable public service that will significantly benefit our users by providing them with access to essential legal information and resources, including curated laws and jurisprudence in the Philippines.\n\n',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('I Understand'),
              onPressed: () {
                Navigator.pop(context); // Close the modal
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LawsJurisprudence(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showQrCodeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(8.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _userQrCode.isNotEmpty
                      ? Image.network(_userQrCode)
                      : const Text('No QR code available.'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showIBPLogoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(8.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Integrated Bar of the Philippines',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Gat Marcelo H. del Pilar (Bulacan Chapter)',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 16.0),
                      child: Text(
                        'IBP Building, Provincial Capitol Compound,\nMalolos City, Bulacan\n\nTel. No: (044) 662 4786\nCel. No:+63 917 168 9873\nEmail: ibpbulacanchapter@gmail.com',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF580049),
      appBar: AppBar(
        backgroundColor: const Color(0xFF580049),
        automaticallyImplyLeading: false,
        elevation: 0,
        leadingWidth: 150,
        leading: GestureDetector(
          onTap: () {
            _showQrCodeModal(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.qr_code, color: Colors.white),
                const SizedBox(width: 4),
                Expanded(
                  child: const Text(
                    'Personal QR',
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/img/ibp_logo.png'),
            onPressed: () {
              _showIBPLogoModal(context);
            },
          ),
        ],
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
                          title:
                              '|  Mag-book ng appointment para sa Legal Aid:',
                          description:
                              'Mag-book ng inyong mga appointment online gamit ang aming bagong scheduling module! Pinadadali nito ang proseso sa pamamagitan ng pagbibigay ng malinaw na impormasyon tungkol sa mga kinakailangan.',
                          color: const Color(0xFF221F1F),
                        ),
                        _buildPageItem(
                          title: '|  Implementasyon ng QR Code System: ',
                          description:
                              'Gamitin ang aming QR code system para sa verification ng inyong appointment! Pinapalaganap nito ang digitization at binabawasan ang abala sa pre-review ng mga kinakailangan ng legal aid lawyers.',
                          color: const Color(0xFFB73CA8),
                        ),
                        _buildPageItem(
                          title: '|  Palawakin ang kaalaman gamit ang Jur.ph:',
                          description:
                              'Gamitin ang Jur.ph sa aming IBP ELSA app! Makakakuha kayo ng access sa mahahalagang legal na impormasyon at resources. Kasama na rito ang case digests, summaries, jurisprudence, at mga batas.',
                          color: const Color.fromARGB(255, 201, 175, 6),
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
                              label: 'Batas at Hurisprudensiya',
                              onTap: () {
                                _showDisclaimerModal(context);
                              },
                            ),
                            _buildIconOption(
                              icon: FontAwesomeIcons.headset,
                              label: 'Magtanong',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      displayName: _displayName,
                                      middleName: _middleName,
                                      lastName: _lastName,
                                      email: _email,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mga Madalas Itanong (FAQs)',
                                style: TextStyle(
                                  color: Color(0xFF580049),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildFAQItem(
                          question:
                              'Ano ang Integrated Bar of the Philippines?',
                          answer:
                              'Ang Integrated Bar of the Philippines (IBP) ay ang pambansang organisasyon ng mga abogado sa Pilipinas. Ito ang opisyal na asosasyon ng lahat ng mga abugado sa bansa at nasa ilalim ng superbisyon ng Korte Suprema ng Pilipinas.',
                        ),
                        _buildFAQItem(
                          question: 'Saan matatagpuan ang IBP Malolos?',
                          answer:
                              'Ang opisina ng IBP Gat Marcelo H. Del Pilar Bulacan Chapter ay matatagpuan sa ‘VR68+7C5, New IBP Bulacan Office, Capitolio Road, City of Malolos, 3000 Bulacan’.',
                        ),
                        _buildFAQItem(
                          question: 'Tuwing kailan bukas ang IBP Malolos?',
                          answer:
                              'Bukas ang IBP Malolos mula Lunes hanggang Sabado mula 9:00 AM hanggang 5:00 PM. Ngunit ang Legal Aid Office nila ay bukas lamang tuwing Martes at Huwebes mula 1:00 PM hanggang 5:00 PM.',
                        ),
                        _buildFAQItem(
                          question:
                              'Ano ang mga requirements para sa Legal Aid?',
                          answer:
                              'Para makapagsumite ng appointment gamit ang app, mangyaring ihanda ang iyong Certificate of Indigency mula sa Barangay ninyo, Certificate of Indigency mula sa DSWD, at Disqualification Letter mula sa PAO.',
                        ),
                        _buildFAQItem(
                          question:
                              'Ano ang mga klase ng tulong legal na aking maaaring hingin?',
                          answer:
                              'Maaari kang humingi ng tulong mula sa IBP Bulacan Chapter para sa Payong Legal (Legal Advice), Legal na Representasyon (Legal Representation), o tulong para sa paggawa ng Legal na Dokumento (Drafting of Legal Document).',
                        ),
                        _buildFAQItem(
                          question:
                              'Paano ko puwedeng makontak ang IBP Malolos?',
                          answer:
                              'Maaari kang tumawag sa kanilang telepono (044) 662 4786 o sa cellphone number +63 917 168 9873 kung sakaling ikaw ay may ibang katanungan. Maaari ka ring magtanong tungkol sa appointment at sa IBP Malolos gamit ang Chat Inquiries feature ng aming app.',
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(answer,
              style: const TextStyle(
                  color: Color.fromARGB(255, 54, 54, 54), fontSize: 14)),
        ],
      ),
    );
  }
}
