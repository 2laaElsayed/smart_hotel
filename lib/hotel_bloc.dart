import 'package:flutter_bloc/flutter_bloc.dart';
import 'hotel_event.dart';
import 'hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  HotelBloc() : super(const HotelState()) {
    on<ToggleCardEvent>((event, emit) => emit(state.copyWith(isCardExpanded: !state.isCardExpanded)));

    on<ChangeTabEvent>((event, emit) => emit(state.copyWith(activeTab: event.tab)));

    on<UpdatePriceEvent>((event, emit) {
      double percentage = (event.price / 10000).clamp(0.0, 1.0);
      emit(state.copyWith(priceValue: percentage));
    });

    on<PressBookNowEvent>((event, emit) => emit(state.copyWith(isBookingAnimating: event.isPressed)));
  }
}