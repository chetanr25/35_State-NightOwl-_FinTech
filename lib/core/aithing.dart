import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> getInvestmentRecommendations({
  required String smeId,
  required String smeDescription,
  required List<String> smeTags,
  required String smeIndustry,
  required double fundingGoal,
  required List<Map<String, dynamic>> pendingInvestments,
  required List<Map<String, dynamic>> investments,
}) async {
  // final firestore = FirebaseFirestore.instance;

  // Get all investors' data
  // final investorsData = await Future.wait(
  //   pendingInvestments.map((investment) async {
  //     final investorEmail = investment['investor'];
  //     final investorDoc = await firestore
  //         .collection('investors')
  //         .where('email', isEqualTo: investorEmail)
  //         .get();

  //     if (investorDoc.docs.isNotEmpty) {
  //       final investorData = investorDoc.docs.first.data();
  //       return {
  //         ...investment,
  //         'expertise': investorData['industryExpertise'] ?? [],
  //         'investmentHistory': investorData['investmentHistory'] ?? [],
  //         'rating': investorData['rating'] ?? 0,
  //       };
  //     }
  //     return investment;
  //   }),
  // );

  // Construct prompt for Gemini
  final prompt = '''
  As an AI investment advisor, analyze the following SME and investor data to provide recommendations on which investors to approve:

  SME Details:
  - Industry: $smeIndustry
  - Description: $smeDescription
  - Tags: ${smeTags.join(', ')}
  - Funding Goal: \$$fundingGoal

  Pending Investors:
  ${investments.map((investor) => '''
  
    Amount Offered: \$${investor['amount']}
    Status: ${investor['status']}
    Industry Expertise: ${(investor['industryExpertise'] as List).join(', ')}
  ''').join('\n')}

  Please analyze the alignment between the SME's needs and each investor's expertise and provide recommendations on which investors would be the best fit. Consider:
  1. Industry expertise match
  2. Investment amount relative to funding goal
  3. Past investment performance
  4. Strategic value beyond just funding

  Provide a ranked list of investors with brief justification for each recommendation.
  ''';

  // Call Gemini API
  final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: dotenv.env['GEMINI_API_KEY']!,
  );

  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  return response.text;
}
