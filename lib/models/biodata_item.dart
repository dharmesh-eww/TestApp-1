class BiodataItem {
  final String id;
  final String fullName;
  final String gender;
  final int age;
  final String height;
  final String education;
  final String profession;
  final String city;
  final String caste;
  final String templateName;
  final DateTime lastModified;
  final bool isCompleted;

  const BiodataItem({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.age,
    required this.height,
    required this.education,
    required this.profession,
    required this.city,
    required this.caste,
    required this.templateName,
    required this.lastModified,
    this.isCompleted = true,
  });

  static List<BiodataItem> sampleData() {
    return [
      BiodataItem(
        id: '1',
        fullName: 'Aarav Sharma',
        gender: 'Male',
        age: 28,
        height: "5' 10\"",
        education: 'B.Tech - Computer Science',
        profession: 'Senior Software Engineer at Google',
        city: 'Bengaluru, Karnataka',
        caste: 'Brahmin',
        templateName: 'Royal Traditional',
        lastModified: DateTime.now().subtract(const Duration(hours: 3)),
        isCompleted: true,
      ),
      BiodataItem(
        id: '2',
        fullName: 'Pooja Patel',
        gender: 'Female',
        age: 26,
        height: "5' 4\"",
        education: 'M.Com, Chartered Accountant',
        profession: 'Finance Manager at Deloitte',
        city: 'Ahmedabad, Gujarat',
        caste: 'Patel (Kadva)',
        templateName: 'Elegance Floral',
        lastModified: DateTime.now().subtract(const Duration(days: 1)),
        isCompleted: true,
      ),
      BiodataItem(
        id: '3',
        fullName: 'Rohan Verma',
        gender: 'Male',
        age: 29,
        height: "5' 11\"",
        education: 'MBA Marketing',
        profession: 'Product Marketing Lead',
        city: 'Mumbai, Maharashtra',
        caste: 'Kshatriya',
        templateName: 'Modern Minimalist',
        lastModified: DateTime.now().subtract(const Duration(days: 3)),
        isCompleted: false,
      ),
    ];
  }
}
