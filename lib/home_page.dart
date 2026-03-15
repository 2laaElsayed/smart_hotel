import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'hotel_bloc.dart';
import 'hotel_event.dart';
import 'hotel_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController priceController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('Smart Hotel Booking',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<HotelBloc, HotelState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => context.read<HotelBloc>().add(ToggleCardEvent()),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    height: state.isCardExpanded ? 350 : 200,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(state.isCardExpanded ? 12 : 30),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Image.asset(
                            'assets/b.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        if (state.isCardExpanded)
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            opacity: 1.0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Grand Hyatt Manila",
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  const Text("Deluxe King Room",
                                      style: TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 10),
                                  Row(children: List.generate(5, (i) =>
                                  const Icon(Icons.star, color: Colors.amber, size: 20))),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                Container(
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Expanded(child: tabButton(context, "Offers", state.activeTab == "Offers")),
                      Expanded(child: tabButton(context, "Guest Reviews", state.activeTab == "Guest Reviews")),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: state.activeTab == "Guest Reviews" ? reviewsSection() : offersBanner(),
                ),

                const SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Price Range:", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter price",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.blue),
                          onPressed: () {
                            double price = double.tryParse(priceController.text) ?? 0;
                            context.read<HotelBloc>().add(UpdatePriceEvent(price));
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        Container(
                          height: 10,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: 10,
                          width: MediaQuery.of(context).size.width * state.priceValue,
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text("\$1"), Text("\$10,000")],
                    )
                  ],
                ),

                const SizedBox(height: 40),

                GestureDetector(
                  onTapDown: (_) => context.read<HotelBloc>().add(PressBookNowEvent(true)),
                  onTapUp: (_) => context.read<HotelBloc>().add(PressBookNowEvent(false)),
                  child: AnimatedScale(
                    scale: state.isBookingAnimating ? 0.9 : 1.0,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceOut,
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.center,
                      child: const Text("Book Now",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget tabButton(BuildContext context, String title, bool isActive) {
    return GestureDetector(
      onTap: () => context.read<HotelBloc>().add(ChangeTabEvent(title)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget offersBanner() {
    return Container(
      key: const ValueKey(1),
      height: 150,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/a.png'),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(20),
      child: const Text("20% off this weekend!",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,)),
    );
  }

  Widget reviewsSection() {
    return Column(
      key: const ValueKey(2),
      children: [
        reviewItem("John D.", "Amazing stay, highly recommend the spa!", 3),
        reviewItem("Sarah K.", "Great service, room was very clean.", 4),
      ],
    );
  }

  Widget reviewItem(String name, String comment, int stars) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(children: List.generate(stars, (i) => const Icon(Icons.star, color: Colors.green, size: 14))),
            ],
          ),
          Text(comment, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}