import 'package:flutter/material.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/constants.dart';
import 'package:weather/ui/home.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late List<City> cities;
  List<City> selectedCities = City.getSelectedCities();
  Constants myConstants = Constants();
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    cities = City.citiesList.where((city) => !city.isDefault).toList();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    List<City> dummySearchList =
    City.citiesList.where((city) => !city.isDefault).toList();
    if (query.isNotEmpty) {
      List<City> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.city.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        cities = dummyListData;
      });
    } else {
      setState(() {
        cities = dummySearchList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myConstants.secondaryColor,
        title: Text('${selectedCities.length} Selected Cities'),
        centerTitle: true,
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.search),
        //     onPressed: () async {
        //       await showSearch(
        //         context: context,
        //         delegate: CitySearch(selectedCities),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  onChanged: filterSearchResults,
                  decoration: InputDecoration(
                    hintText: 'Search by city name...',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        filterSearchResults('');
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: cities.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      cities[index].isSelected = !cities[index].isSelected;
                    });
                  },
                  child: Stack(
                    children: [
                      SizedBox(

                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                cities[index].isSelected
                                    ? Icons.location_city
                                    : Icons.location_city_outlined,
                                color: myConstants.primaryColor,
                                size: 50,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                cities[index].city,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: myConstants.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        width: double.infinity,
                      ),
                      if (cities[index].isSelected)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Icon(
                            Icons.check_circle,
                            color: myConstants.secondaryColor,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: myConstants.secondaryColor,
        icon: const Icon(Icons.pin_drop),
        label: const Text('Go to Home'),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CitySearch extends SearchDelegate<String> {
  final List<City> cities;

  CitySearch(this.cities);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<City> searchResults =
    cities.where((city) => city.city.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index].city),
          onTap: () {
            close(context, searchResults[index].city);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<City> suggestionList = query.isEmpty
        ? []
        : cities.where((city) => city.city.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].city),
          onTap: () {
            query = suggestionList[index].city;
            showResults(context);
          },
        );
      },
    );
  }
}
