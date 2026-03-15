import 'package:equatable/equatable.dart';

class HotelState extends Equatable {
  final bool isCardExpanded;
  final String activeTab;
  final double priceValue;
  final bool isBookingAnimating;

  const HotelState({
    this.isCardExpanded = false,
    this.activeTab = 'offers',
    this.priceValue = 0.5,
    this.isBookingAnimating = false,
  });

  HotelState copyWith({
    bool? isCardExpanded,
    String? activeTab,
    double? priceValue,
    bool? isBookingAnimating,
  }) {
    return HotelState(
      isCardExpanded: isCardExpanded ?? this.isCardExpanded,
      activeTab: activeTab ?? this.activeTab,
      priceValue: priceValue ?? this.priceValue,
      isBookingAnimating: isBookingAnimating ?? this.isBookingAnimating,
    );
  }

  @override
  List<Object> get props => [isCardExpanded, activeTab, priceValue, isBookingAnimating];
}