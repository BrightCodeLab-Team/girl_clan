import 'package:get/get.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/others/base_view_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/locator.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';

class AddEventViewModel extends BaseViewModel {
  EventModel eventModel = EventModel();
  //List
  final db = locator<DatabaseServices>();

  ///
  ///. add event to database
  ///
  addEvent() async {
    setState(ViewState.busy);
    await db.addEventsToDataBase(eventModel);

    Get.snackbar('Success', "Add Event Successfully");
    Get.offAll(() => RootScreen());

    setState(ViewState.idle);
  }
}
