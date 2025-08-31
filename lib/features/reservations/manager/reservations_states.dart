abstract class ReservationsStates {}

class ReservationsInitState extends ReservationsStates {}

class GetReservationsLoadingState extends ReservationsStates {}

class GetReservationsSuccessState extends ReservationsStates {}

class GetReservationsErrorState extends ReservationsStates {}

class GetReservationDetailsLoadingState extends ReservationsStates {}

class GetReservationDetailsSuccessState extends ReservationsStates {}

class GetReservationDetailsErrorState extends ReservationsStates {}

class CancelReservationLoadingState extends ReservationsStates {}

class CancelReservationSuccessState extends ReservationsStates {}

class CancelReservationErrorState extends ReservationsStates {}

class AcceptReservationLoadingState extends ReservationsStates {}

class AcceptReservationSuccessState extends ReservationsStates {}

class AcceptReservationErrorState extends ReservationsStates {}

class RatePlayersLoadingState extends ReservationsStates {}

class RatePlayersSuccessState extends ReservationsStates {}

class RatePlayersErrorState extends ReservationsStates {}

class RatePlayerState extends ReservationsStates {}
