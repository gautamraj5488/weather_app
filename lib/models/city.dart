class City {
  bool isSelected;
  final String city;
  final String country;
  final bool isDefault;

  City({
    required this.isSelected,
    required this.city,
    required this.country,
    required this.isDefault,
  });

  // List of Indian Cities data
  static List<City> citiesList = [
    City(isSelected: false, city: 'Mumbai', country: 'India', isDefault: true),
    City(isSelected: false, city: 'Delhi', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Bengaluru', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Hyderabad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Ahmedabad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Chennai', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Kolkata', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Surat', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Pune', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Jaipur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Lucknow', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Kanpur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Nagpur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Indore', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Thane', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Bhopal', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Visakhapatnam', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Pimpri-Chinchwad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Patna', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Vadodara', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Ghaziabad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Ludhiana', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Agra', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Nashik', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Faridabad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Meerut', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Rajkot', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Kalyan-Dombivli', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Vasai-Virar', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Varanasi', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Srinagar', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Aurangabad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Dhanbad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Amritsar', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Navi Mumbai', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Allahabad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Howrah', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Ranchi', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Gwalior', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Jabalpur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Coimbatore', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Vijayawada', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Jodhpur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Madurai', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Raipur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Kota', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Chandigarh', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Guwahati', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Solapur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Hubli-Dharwad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Mysore', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Tiruchirappalli', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Bareilly', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Aligarh', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Tiruppur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Moradabad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Jalandhar', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Bhubaneswar', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Salem', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Warangal', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Mira-Bhayandar', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Thiruvananthapuram', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Bhiwandi', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Saharanpur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Guntur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Amravati', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Bikaner', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Noida', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Jamshedpur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Bhilai', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Cuttack', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Firozabad', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Kochi', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Bhavnagar', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Dehradun', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Durgapur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Asansol', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Nanded', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Kolhapur', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Ajmer', country: 'India', isDefault: false),
    City(isSelected: false, city: 'Gulbarga', country: 'India', isDefault: false),
  ];

  // Get the selected cities
  static List<City> getSelectedCities() {
    return citiesList.where((city) => city.isSelected).toList();
  }
}