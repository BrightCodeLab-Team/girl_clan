import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/auth_text_feild.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';

class MainChatScreen extends StatelessWidget {
  const MainChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // People & Groups
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              'Messages',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: false,
                  labelColor: primaryColor,
                  unselectedLabelColor: Colors.black54,
                  indicatorColor: primaryColor,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: const [Tab(text: 'People'), Tab(text: 'Groups')],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                decoration: customHomeAuthField.copyWith(
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            15.verticalSpace,
            // Tab Views
            Expanded(
              child: TabBarView(
                children: [
                  // People Tab
                  ListView.builder(
                    itemCount: 20,
                    shrinkWrap: true,

                    itemBuilder: (BuildContext context, int index) {
                      return ChatItem(
                        imageUrl: AppAssets().appLogo,
                        name: 'shayan zahid',
                        message: 'Hey how are you doing',
                        time: '02:40 PM',
                      );
                    },
                  ),
                  // Groups Tab
                  ListView.builder(
                    itemCount: 20,
                    shrinkWrap: true,

                    itemBuilder: (BuildContext context, int index) {
                      return ChatItem(
                        imageUrl: AppAssets().appLogo,
                        name: 'Hiking Squad',
                        message: 'Hey buddies don\'t be late be on time !',
                        time: '02:40 PM',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Chat Item Widget (for simplicity)
class ChatItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String message;
  final String time;

  const ChatItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(imageUrl),
        ),
        title: Text(name, style: style14B),
        subtitle: Text(
          message,
          style: style12.copyWith(color: blackColor.withOpacity(0.4)),
        ),

        trailing: Text(time, style: style12.copyWith()),
      ),
    );
  }
}
