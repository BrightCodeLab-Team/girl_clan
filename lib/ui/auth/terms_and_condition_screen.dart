import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';

class TermsScreen extends StatelessWidget {
  final String title;

  TermsScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<String>(
          future: rootBundle.loadString(
            'assets/static_assets/terms_and_conditions.txt',
          ),
          builder: (context, snapshot) {
            final text = snapshot.data ?? '';

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Our community commitment", style: style18B),
                Text("Terms & Conditions", style: style25B),
                8.verticalSpace,
                Text(
                  "Last Updated: April 2026",
                  style: style16.copyWith(color: Colors.grey),
                ),
                16.verticalSpace,
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: thinGreyColor),
                    ),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Text(
                          text.isEmpty
                              ? "Loading Terms & Conditions..."
                              : text,
                          style: style16.copyWith(
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                16.verticalSpace,
                CustomButton(
                  onTap: () {
                    Get.back(result: true);
                  },
                  text: 'Agree and Continue',
                  backgroundColor: secondaryColor,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
