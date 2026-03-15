abstract class HotelEvent {}

class ToggleCardEvent extends HotelEvent {}
class ChangeTabEvent extends HotelEvent { final String tab; ChangeTabEvent(this.tab); }
class UpdatePriceEvent extends HotelEvent { final double price; UpdatePriceEvent(this.price); }
class PressBookNowEvent extends HotelEvent { final bool isPressed; PressBookNowEvent(this.isPressed); }