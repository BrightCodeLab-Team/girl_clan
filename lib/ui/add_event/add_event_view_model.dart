import 'package:get/get.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/locator.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';

class AddEventViewModel extends BaseViewModel {
  EventModel eventModel = EventModel();
  //List
  final db = locator<DatabaseServices>();

  ///
  ///. add event to database
  ///
  addEvent() async {
    try {
      setState(ViewState.busy);
      await db.addEventsToDataBase(eventModel);

      Get.snackbar('Success', "Add Event Successfully");
      Get.find<HomeViewModel>().refreshAllEvents();
      Get.offAll(() => RootScreen());

      setState(ViewState.idle);
    } catch (e) {
      Get.snackbar('Error', "Failed to add event: $e");
    } finally {
      setState(ViewState.idle);
    }
  }

  ///
  /// validation of all fields
  ///
  ///
  ///  validate event name
  ///
  String? validateEventName(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter event name';
    }

    return null;
  }

  ///
  ///  validate date
  ///
  String? validateDate(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter date';
    }

    return null;
  }

  ///
  ///  validate time
  ///
  String? validateEmail(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter time';
    }

    return null;
  }

  ///
  ///  validate capacity
  ///
  String? validateCapacity(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter capacity';
    }
    return null;
  }

  ///
  ///  validate category
  ///
  String? validateCategory(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter category';
    }

    return null;
  }

  ///
  ///  validate  location
  ///
  String? validateLocation(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter location';
    }

    return null;
  }

  ///
  ///  validate description
  ///
  String? validateDescription(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter description';
    }

    return null;
  }

  ///
  ///  validate time
  ///
  String? validateTime(String? value) {
    if (value!.trim().isEmpty) {
      return 'Enter category';
    }

    return null;
  }
}
