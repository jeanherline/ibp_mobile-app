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
      });
    }
  }

  void _showDisclaimerModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Disclaimer'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Our app, IBP - ELSA Malolos, is independent of Jur.ph. Jur.ph retains sole ownership of their content, and our app maintains a separate identity. By including their website, we aim to offer essential legal information and resources as a public service.\n\n'
                  'Thank you for accessing or using our app, Integrated Bar of the Philippines Electronic Legal Services and Access Malolos Chapter (IBP - ELSA Malolos), which serves as an appointment booking system for IBP Malolos. Additionally, our app offers web viewing of Jur.ph, an AI-Powered Legal Research Platform in the Philippines. By incorporating Jur.ph into our app, we aim to provide a valuable public service that significantly benefits our users by granting access to essential legal information and resources.\n\n'
                  'Please take the time to read the contents herein for your information and awareness as they are part of the terms and conditions for your access, use, or continued access/use of the Service.\n\n'
                  '1) Legal Disclaimer\n'
                  'All information is for educational purposes and general information only. These should not be taken as professional legal advice or opinion. No lawyer-client relationship is intended. Please consult a competent lawyer to address your specific concerns. The statements or opinions of the author are his own and do not reflect that of any organization he may be connected to.\n\n'
                  'a. No legal advice is given\n\n'
                  'No professional nor legal advice/opinion is given in any of our Content.\n\n'
                  'The Content is intended to be a resource or reference materials for learning about Philippine laws. They are neither intended nor considered to be professional nor legal advice, particularly for questions that may be answered. The answering of questions is for the purpose of education, illustration, or for general additional information.\n\n'
                  'If you have legal questions (a) which may require attention to protect your rights and interests, as well as protect you from lawsuits or liabilities, or (b) which may affect your rights or obligations, it is strongly recommended that you consult competent lawyers. Before giving you appropriate legal advice which may be unique to your circumstances, competent lawyers are trained to first ask you a series of questions, review all available pieces of evidence such as documentary or object evidence, and carefully analyze your case or situation. These are obviously neither observed, available, nor contemplated in making our Content.\n\n'
                  'b. No lawyer-client relationship is intended\n\n'
                  'Similarly, in the process of asking submitted questions, there is no lawyer-client relationship that is being created nor intended to be created. For the avoidance of doubt and clarity, no lawyer-client relationship is contemplated in answering questions. The intent and purpose of answering questions is for educational purposes and general information only. The questions provide for a good opportunity to further elaborate on certain topics or be a springboard for discussions, particularly on whether a law may or may not apply in given hypothetical circumstances or situations.\n\n'
                  'c. Individual statements\n\n'
                  'In all their Content, the statements or comments of the authors or speakers are solely their own. Their statements or comments do not reflect our views nor those of this Service, nor of any organization which they may belong to or be associated with.\n\n'
                  '2) Content Disclaimer\n'
                  'While we strive for accuracy and reliability, we do not make any claims, representations, or warranties that their Content is fully and completely accurate at any given time. It is because the nature of the law is such that it continues to grow and develop via new legislation, regulations, or jurisprudence, and in the course thereof, there may appear conflicts, including previous ones which remain unresolved.\n\n'
                  'Thus, our users are strongly advised to verify and research independently on their own to be updated with current legislation, regulations, or jurisprudence. Our Content may serve as a starting point for your research to see if there have been developments since its publication or posting date.\n\n'
                  '3) Distinct Identity and Branding\n'
                  'Our app, Integrated Bar of the Philippines Electronic Legal Services and Access Malolos Chapter (IBP - ELSA Malolos), is not directly affiliated with Jur.ph. All content from Jur.ph is solely theirs, and we have no involvement in their website content. We maintain the distinct identity and branding of both our application and Jur.ph. By incorporating their website into our app, we aim to offer a valuable public service that will significantly benefit our users by providing access to essential legal information and resources.\n\n'
                  '4) Specific Objective\n'
                  'By incorporating/web viewing Jur.ph into our app, we aim to:\n\n'
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
                          title:
                              '|  Mag-book ng appointment para sa Legal Aid:',
                          description:
                              'Mag-book ng inyong mga appointment online gamit ang aming bagong scheduling module! Pinadadali nito ang proseso sa pamamagitan ng pagbibigay ng malinaw na impormasyon tungkol sa mga kinakailangan, available na oras, at iskedyul.',
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
                          color: Color.fromARGB(255, 201, 175, 6),
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
                              // Text(
                              //   'Tingnan lahat',
                              //   style: TextStyle(
                              //     color: Color(0xFF407CE2),
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
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
