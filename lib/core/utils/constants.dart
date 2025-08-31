import 'package:dakeh_service_provider/core/data/cities_model.dart';
import 'package:dakeh_service_provider/features/auth/data/user_model.dart';
import 'package:dakeh_service_provider/features/reservations/data/const_list_model.dart';

class AppConstants {
  static const kIsOnBoardingSharedPref = 'skippedOnBoard';
  static const String kBaseURL = 'https://dakkah1.com/';
  static List<City> cities = [];
  static User? user;
  static List<ConstListItem> rateLevel = [
    ConstListItem(
      id: 'none',
      titleAR: 'تقييم المستوى',
      titleEN: 'Rate level',
    ),
    ConstListItem(
      id: 'new',
      titleAR: 'لاعب جديد',
      titleEN: 'New player',
    ),
    ConstListItem(
      id: 'beginner',
      titleAR: 'لاعب مبتدئ',
      titleEN: 'Beginner player',
    ),
    ConstListItem(
      id: 'intermediate',
      titleAR: 'لاعب متوسط',
      titleEN: 'Intermediate player',
    ),
  ];
  static List<ConstListItem> highestLevel = [
    ConstListItem(
      id: 'none',
      titleAR: 'اعلى مستوى تنافست عليه',
      titleEN: 'Highest level competed at',
    ),
    ConstListItem(
      id: 'friendly',
      titleAR: 'مباريات ودية',
      titleEN: 'Friendlies matches',
    ),
    ConstListItem(
      id: 'local',
      titleAR: 'مباريات محلية',
      titleEN: 'Local matches',
    ),
    ConstListItem(
      id: 'no',
      titleAR: 'لم أتنافس',
      titleEN: 'I didn\'t compete',
    ),
  ];
  static List<ConstListItem> yearsOfPlaying = [
    ConstListItem(
      id: 'none',
      titleAR: 'سنوات اللعب',
      titleEN: 'Years of playing',
    ),
    ConstListItem(
      id: 'less than one',
      titleAR: 'اقل من سنة',
      titleEN: 'Less than a year',
    ),
    ConstListItem(
      id: 'two',
      titleAR: 'سنتين',
      titleEN: 'Two years',
    ),
    ConstListItem(
      id: 'more two',
      titleAR: 'اكثر من سنتين',
      titleEN: 'More than two years',
    ),
  ];
  static List<ConstListItem> matchesPerMonth = [
    ConstListItem(
      id: 'none',
      titleAR: 'عدد المباريات في الشهر',
      titleEN: 'Count of matches per month',
    ),
    ConstListItem(
      id: 'empty',
      titleAR: 'لا يوجد',
      titleEN: 'There isn\'t any',
    ),
    ConstListItem(
      id: 'one',
      titleAR: 'مبارة واحدة',
      titleEN: 'One match',
    ),
    ConstListItem(
      id: 'two',
      titleAR: 'مبارتين',
      titleEN: 'Two matches',
    ),
  ];
  static List<ConstListItem> numOfChampionships = [
    ConstListItem(
      id: 'none',
      titleAR: 'عدد البطولات',
      titleEN: 'Count of championships',
    ),
    ConstListItem(
      id: 'empty',
      titleAR: 'لا يوجد',
      titleEN: 'There isn\'t any',
    ),
    ConstListItem(
      id: 'one',
      titleAR: 'بطولة واحدة',
      titleEN: 'One championship',
    ),
    ConstListItem(
      id: 'more',
      titleAR: 'اكثر من بطولة',
      titleEN: 'More than one championship',
    ),
  ];
  static List<ConstListItem> gamesList = [
    ConstListItem(
      id: 'none',
      titleAR: 'اللعبة المفضلة',
      titleEN: 'Favourite game',
    ),
    ConstListItem(
      id: '1',
      titleAR: 'بلياردو',
      titleEN: 'Billiard',
    ),
    ConstListItem(
      id: '2',
      titleAR: 'بلوت',
      titleEN: 'Baloot',
    ),
    ConstListItem(
      id: '3',
      titleAR: 'شطرنج',
      titleEN: 'Chess',
    ),
  ];
}
