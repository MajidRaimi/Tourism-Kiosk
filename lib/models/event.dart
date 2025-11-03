class Event {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String imageUrl;
  final String venue;
  final String venueAr;
  final DateTime startDate;
  final DateTime endDate;
  final String category;
  final double latitude;
  final double longitude;

  Event({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.imageUrl,
    required this.venue,
    required this.venueAr,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.latitude,
    required this.longitude,
  });

  String get dateRange =>
      '${startDate.day}/${startDate.month} - ${endDate.day}/${endDate.month}';

  static List<Event> dummyEvents = [
    Event(
      id: '1',
      name: 'Riyadh Season 2024',
      nameAr: 'موسم الرياض 2024',
      description:
          'World-class entertainment, concerts, and cultural events',
      descriptionAr: 'ترفيه وحفلات وفعاليات ثقافية عالمية المستوى',
      imageUrl: 'https://via.placeholder.com/400x300/004428/FFFFFF?text=Riyadh+Season',
      venue: 'Various venues across Riyadh',
      venueAr: 'مواقع متعددة في الرياض',
      startDate: DateTime(2024, 10, 1),
      endDate: DateTime(2025, 3, 31),
      category: 'festival',
      latitude: 24.7136,
      longitude: 46.6753,
    ),
    Event(
      id: '2',
      name: 'Jeddah Art Week',
      nameAr: 'أسبوع جدة للفن',
      description: 'Contemporary art exhibitions and installations',
      descriptionAr: 'معارض وتركيبات فنية معاصرة',
      imageUrl: 'https://via.placeholder.com/400x300/006B3D/FFFFFF?text=Art+Week',
      venue: 'Jeddah Superdome',
      venueAr: 'قبة جدة الكبرى',
      startDate: DateTime(2024, 12, 15),
      endDate: DateTime(2024, 12, 22),
      category: 'culture',
      latitude: 21.5433,
      longitude: 39.1728,
    ),
    Event(
      id: '3',
      name: 'Saudi International Golf',
      nameAr: 'بطولة السعودية الدولية للجولف',
      description: 'PGA Tour event featuring world-class golfers',
      descriptionAr: 'حدث PGA يضم أفضل لاعبي الجولف في العالم',
      imageUrl: 'https://via.placeholder.com/400x300/00341f/FFFFFF?text=Golf+Tournament',
      venue: 'Royal Greens Golf & Country Club',
      venueAr: 'نادي رويال جرينز للجولف',
      startDate: DateTime(2025, 2, 6),
      endDate: DateTime(2025, 2, 9),
      category: 'sports',
      latitude: 21.6352,
      longitude: 39.1034,
    ),
    Event(
      id: '4',
      name: 'Tech Conference KSA',
      nameAr: 'مؤتمر التقنية السعودية',
      description: 'Leading technology and innovation summit',
      descriptionAr: 'قمة رائدة للتكنولوجيا والابتكار',
      imageUrl: 'https://via.placeholder.com/400x300/0A5A3C/FFFFFF?text=Tech+Conference',
      venue: 'Riyadh International Convention Center',
      venueAr: 'مركز الرياض الدولي للمؤتمرات',
      startDate: DateTime(2024, 11, 20),
      endDate: DateTime(2024, 11, 23),
      category: 'mice',
      latitude: 24.7736,
      longitude: 46.6389,
    ),
    Event(
      id: '5',
      name: 'AlUla Arts Festival',
      nameAr: 'مهرجان العلا للفنون',
      description: 'Desert arts and culture celebration',
      descriptionAr: 'احتفال بفنون وثقافة الصحراء',
      imageUrl: 'https://via.placeholder.com/400x300/004428/FFFFFF?text=AlUla+Festival',
      venue: 'AlUla Old Town',
      venueAr: 'بلدة العلا القديمة',
      startDate: DateTime(2025, 1, 10),
      endDate: DateTime(2025, 1, 31),
      category: 'culture',
      latitude: 26.6084,
      longitude: 37.9216,
    ),
  ];
}
