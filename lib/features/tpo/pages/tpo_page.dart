import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/widgets/responsive_wrapper.dart';
import '../../../core/constants/app_constants.dart';

class TpoPage extends StatelessWidget {
  const TpoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          _buildNoticeSection(context),
          _buildCoordinatorsSection(context),
          _buildTPOTeamSection(context),
          _buildContactSection(context),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            // University Logo and Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppConstants.neutral100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school,
                    size: 40,
                    color: AppConstants.googleBlue,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GURUGRAM UNIVERSITY, GURUGRAM',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppConstants.neutral900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '(A State Govt. University established under Haryana Act 17 of 2017)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConstants.neutral600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sector-51, Gurugram (Haryana)-122003 Ph: 0124-2788001-05, Fax: 0124-2788010',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.neutral600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Text(
              'TRAINING AND PLACEMENT OFFICE',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: AppConstants.neutral900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Bridging the gap between academia and industry through excellence in training and placement.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                height: 1.6,
                color: AppConstants.neutral700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeSection(BuildContext context) {
    return Container(
      color: AppConstants.googleBlue.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.neutral900.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppConstants.googleBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.announcement,
                          color: AppConstants.googleBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NOTICE',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.googleBlue,
                              ),
                            ),
                            Text(
                              'Ref.No. GUG/TPO/2024/1541-45',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppConstants.neutral600,
                              ),
                            ),
                            Text(
                              'Dated: 20.08.2024',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppConstants.neutral600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'As per order of the Competent Authority, the following individuals have been appointed as Training and Placement Coordinators for their respective departments for the 2024-25 sessions. Their details are given below.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: AppConstants.neutral700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinatorsSection(BuildContext context) {
    final coordinators = [
      {'name': 'Dr. Gulshan Singh', 'department': 'Department of Chemistry', 'position': 'T&P Coordinator-I'},
      {'name': 'Dr. Rahul', 'department': '', 'position': 'T&P Coordinator-II'},
      {'name': 'Dr. Shweta Chaudhary', 'department': 'Department of Media Studies', 'position': 'T&P Coordinator-I'},
      {'name': 'Dr. Anirudh Subhedar', 'department': '', 'position': 'T&P Coordinator-II'},
      {'name': 'Dr. Komal', 'department': 'Department of Law', 'position': 'T&P Coordinator-I'},
      {'name': 'Dr. Farhana', 'department': '', 'position': 'T&P Coordinator-II'},
      {'name': 'Dr. Devika', 'department': 'Department of English & Foreign Language', 'position': 'T&P Coordinator-I'},
      {'name': 'Dr. Anupma Pathak', 'department': '', 'position': 'T&P Coordinator-II'},
      {'name': 'Dr. Deepika', 'department': 'Department of Development Studies', 'position': 'T&P Coordinator-I'},
      {'name': 'Dr. Vinod Kumar', 'department': 'Department of Management', 'position': 'T&P Coordinator-I'},
      {'name': 'Dr. Kanchan Yadav', 'department': '', 'position': 'T&P Coordinator-II'},
      {'name': 'Mr. Vikas Yadav', 'department': '', 'position': 'T&P Coordinator-III'},
      {'name': 'Dr. Charu', 'department': 'Dept. of Engg. & Technology', 'position': 'T&P Coordinator-I'},
      {'name': 'Dr. Sachin Lalar', 'department': '', 'position': 'T&P Coordinator-II'},
      {'name': 'Dr. Balvinder Singh', 'department': 'Dept. of Physics', 'position': 'T&P Coordinator-I'},
      {'name': 'Mr. Ashish', 'department': '', 'position': 'T&P Coordinator-II'},
      {'name': 'Dr. Rakesh Narang', 'department': 'Dept. of Pharmaceutical Sciences, Health and Brain Research', 'position': 'T&P Coordinator-I'},
      {'name': 'Dr. Shivkant', 'department': '', 'position': 'T&P Coordinator-II'},
      {'name': 'Dr. Archna Dixit', 'department': 'Department of Mathematics', 'position': 'T&P Coordinator-I'},
      {'name': 'Mr. Vipin Gupta', 'department': '', 'position': 'T&P Coordinator-II'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            Text(
              'Training & Placement Coordinators (2024-25)',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.neutral900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppConstants.googleBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Sr. No.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.neutral700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.neutral700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Department',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.neutral700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Position',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.neutral700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Coordinators list
                    ...coordinators.asMap().entries.map((entry) {
                      final index = entry.key;
                      final coordinator = entry.value;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppConstants.neutral200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: AppConstants.neutral700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                coordinator['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.neutral900,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                coordinator['department']!,
                                style: TextStyle(
                                  color: AppConstants.neutral700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getPositionColor(coordinator['position']!).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  coordinator['position']!,
                                  style: TextStyle(
                                    color: _getPositionColor(coordinator['position']!),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTPOTeamSection(BuildContext context) {
    final tpoTeam = [
      {
        'name': 'Dr. Charu',
        'designation': 'Training & Placement Officer & Director Employability',
        'email': 'directoremployability@gurugramuniversity.ac.in',
        'hasEmail': true,
      },
      {
        'name': 'Dr. Rakesh Narang',
        'designation': 'Deputy Director Employability',
        'hasEmail': false,
      },
      {
        'name': 'Dr. Neetu Singla',
        'designation': 'Deputy Director-I',
        'hasEmail': false,
      },
      {
        'name': 'Dr. Kanchan Yadav',
        'designation': 'Deputy Director-II',
        'hasEmail': false,
      },
      {
        'name': 'Mr. Sukhbeer',
        'designation': 'Assistant',
        'hasEmail': false,
      },
      {
        'name': 'Sanehal Bansal',
        'designation': 'ETPO',
        'hasEmail': false,
      },
    ];

    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            Text(
              'Training and Placement Officer',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.neutral900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Other Administrative Staff',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppConstants.neutral600,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(4),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    // Header
                    TableRow(
                      decoration: BoxDecoration(
                        color: AppConstants.googleGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      children: [
                        _buildTableHeader('Sr.No'),
                        _buildTableHeader('Name of Employees'),
                        _buildTableHeader('Additional Responsibility/Designation'),
                        _buildTableHeader('Contact'),
                      ],
                    ),
                    // TPO Team members
                    ...tpoTeam.asMap().entries.map((entry) {
                      final index = entry.key;
                      final member = entry.value;
                      return TableRow(
                        children: [
                          _buildTableCell('${index + 1}'),
                          _buildTableCell(
                            member['name'] as String,
                            isName: true,
                          ),
                          _buildTableCell(member['designation'] as String),
                          _buildContactCell(
                            member['hasEmail'] as bool,
                            member['email'] as String?,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.neutral900.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'TPO MESSAGE',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.googleBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '"Welcome to the Training and Placement Office (TPO) of Gurugram University – where dreams and opportunities intertwine. We believe that education is not just about acquiring knowledge; it\'s a stepping stone towards a future of boundless potential. At TPO, we are committed to shaping careers that transcend boundaries. We empower students with the skills, guidance, and connections they need to navigate the dynamic professional landscape. Our mission is to bridge the gap between academia and industry, ensuring that each student emerges as a confident, industry-ready professional. With a relentless focus on innovation and excellence, we are here to ignite aspirations, fuel ambitions, and create pathways to success. Join us in this transformative journey of growth and discovery. Together, we will craft stories of triumph, turning aspirations into achievements, and creating a future of endless possibilities."',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                      color: AppConstants.neutral700,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor(String position) {
    if (position.contains('Coordinator-I')) {
      return AppConstants.googleBlue;
    } else if (position.contains('Coordinator-II')) {
      return AppConstants.googleGreen;
    } else if (position.contains('Coordinator-III')) {
      return AppConstants.googleRed;
    }
    return AppConstants.googleYellow;
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppConstants.neutral700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isName = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isName ? FontWeight.w600 : FontWeight.normal,
          color: isName ? AppConstants.neutral900 : AppConstants.neutral700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildContactCell(bool hasEmail, String? email) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: hasEmail && email != null
          ? GestureDetector(
              onTap: () => _launchEmail(email),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.email,
                    size: 16,
                    color: AppConstants.googleBlue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Email',
                    style: TextStyle(
                      color: AppConstants.googleBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : Text(
              '-',
              style: TextStyle(
                color: AppConstants.neutral500,
                fontSize: 14,
              ),
            ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      color: AppConstants.googleBlue,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _buildContactCard(
                    'Email',
                    'tpoffice@gurugramuniversity.ac.in',
                    Icons.email,
                    () => _launchEmail('tpoffice@gurugramuniversity.ac.in'),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildContactCard(
                    'Phone',
                    '0124-2788001-05',
                    Icons.phone,
                    () => _launchPhone('01242788001'),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildContactCard(
                    'Address',
                    'Sector-51, Gurugram (Haryana)-122003',
                    Icons.location_on,
                    () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(String title, String content, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppConstants.googleBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppConstants.googleBlue,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppConstants.neutral900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.neutral600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
} 