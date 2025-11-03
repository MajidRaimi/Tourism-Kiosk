class Attraction {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String imageUrl;
  final String category;
  final double distance;
  final String openingHours;
  final String openingHoursAr;
  final double latitude;
  final double longitude;

  Attraction({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.imageUrl,
    required this.category,
    required this.distance,
    required this.openingHours,
    required this.openingHoursAr,
    required this.latitude,
    required this.longitude,
  });

  static List<Attraction> dummyAttractions = [
    Attraction(
      id: '1',
      name: 'Al-Masjid an-Nabawi',
      nameAr: 'المسجد النبوي',
      description: 'The Prophet\'s Mosque in Medina, one of the largest mosques in the world',
      descriptionAr: 'المسجد النبوي في المدينة المنورة، أحد أكبر المساجد في العالم',
      imageUrl: 'https://via.placeholder.com/400x300/004428/FFFFFF?text=Masjid+Nabawi',
      category: 'heritage',
      distance: 2.5,
      openingHours: 'Open 24 hours',
      openingHoursAr: 'مفتوح 24 ساعة',
      latitude: 24.4672,
      longitude: 39.6111,
    ),
    Attraction(
      id: '2',
      name: 'Diriyah Historic District',
      nameAr: 'حي الطريف التاريخي',
      description: 'UNESCO World Heritage site and birthplace of the Saudi state',
      descriptionAr: 'موقع تراث عالمي لليونسكو ومسقط رأس الدولة السعودية',
      imageUrl: 'https://via.placeholder.com/400x300/006B3D/FFFFFF?text=Diriyah',
      category: 'heritage',
      distance: 5.2,
      openingHours: '9:00 AM - 9:00 PM',
      openingHoursAr: '9:00 صباحاً - 9:00 مساءً',
      latitude: 24.7333,
      longitude: 46.5750,
    ),
    Attraction(
      id: '3',
      name: 'Edge of the World',
      nameAr: 'نهاية العالم',
      description: 'Dramatic cliff formation offering breathtaking views',
      descriptionAr: 'تكوين صخري مذهل يوفر إطلالات خلابة',
      imageUrl: 'https://via.placeholder.com/400x300/00341f/FFFFFF?text=Edge+of+World',
      category: 'nature',
      distance: 95.0,
      openingHours: 'Open daily (daylight hours)',
      openingHoursAr: 'مفتوح يومياً (ساعات النهار)',
      latitude: 24.9347,
      longitude: 46.1436,
    ),
    Attraction(
      id: '4',
      name: 'Al Balad Historic District',
      nameAr: 'حي البلد التاريخي',
      description: 'Historic area of Jeddah with traditional architecture',
      descriptionAr: 'منطقة تاريخية في جدة بعمارة تقليدية',
      imageUrl: 'https://via.placeholder.com/400x300/0A5A3C/FFFFFF?text=Al+Balad',
      category: 'heritage',
      distance: 12.8,
      openingHours: '10:00 AM - 10:00 PM',
      openingHoursAr: '10:00 صباحاً - 10:00 مساءً',
      latitude: 21.4858,
      longitude: 39.1925,
    ),
    Attraction(
      id: '5',
      name: 'Kingdom Centre Tower',
      nameAr: 'برج المملكة',
      description: 'Iconic skyscraper with sky bridge observation deck',
      descriptionAr: 'ناطحة سحاب شهيرة مع جسر سماوي للمراقبة',
      imageUrl: 'https://via.placeholder.com/400x300/004428/FFFFFF?text=Kingdom+Tower',
      category: 'landmark',
      distance: 3.1,
      openingHours: '9:00 AM - 11:00 PM',
      openingHoursAr: '9:00 صباحاً - 11:00 مساءً',
      latitude: 24.7114,
      longitude: 46.6753,
    ),
  ];
}
