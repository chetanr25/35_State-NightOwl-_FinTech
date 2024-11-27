final List<String> industries = [
  'Technology',
  'Manufacturing',
  'Healthcare',
  'Agribusiness',
  'Renewable-Energy',
  'Education',
  'E-commerce',
  'Infrastructure',
  'Financial-Services',
  'Consumer-Goods',
  'Artisanal-Crafts',
  'Social-Enterprise',
  'Real-Estate',
  'Tourism-Hospitality',
  'Logistics',
  'Food-Beverage',
  'Media-Entertainment',
  'Professional-Services',
  'Retail',
  'Construction',
  'Automotive',
  'Textile-Apparel',
  'Waste-Management',
  'Digital-Marketing',
  'Clean-Technology',
  'Biotechnology',
  'AI-Machine-Learning',
  'Telecommunications',
  'Mining-Resources',
  'Sports-Recreation',
  'Beauty-Wellness',
  'Agriculture-Tech',
  'Fin-Tech',
  'Ed-Tech',
  'Health-Tech',
  'Green-Energy',
];

enum PitchStatus {
  draft, // Initial state when creating
  pending, // Submitted but not reviewed
  underReview, // Being reviewed by admin
  approved, // Approved for investor viewing
  funded, // Received full funding
  partiallyFunded, // Received partial funding
  rejected, // Rejected by admin
  closed // Closed by SME or admin
}

Map<PitchStatus, String> statusDescriptions = {
  PitchStatus.draft: 'Draft - Complete your application',
  PitchStatus.pending: 'Pending - Awaiting review',
  PitchStatus.underReview: 'Under Review - Being evaluated',
  PitchStatus.approved: 'Approved - Visible to investors',
  PitchStatus.funded: 'Funded - Goal reached',
  PitchStatus.partiallyFunded: 'Partially Funded',
  PitchStatus.rejected: 'Rejected - See feedback',
  PitchStatus.closed: 'Closed',
};
