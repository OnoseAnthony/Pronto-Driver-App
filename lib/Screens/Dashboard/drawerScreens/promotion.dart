import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fronto_rider/Models/promotion.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/Services/firebase/firestore.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/constants.dart';

class PromotionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Container(
            height: size,
            padding: EdgeInsets.only(
              left: 40,
              right: 40,
            ),
            child: StreamBuilder<List<Promotion>>(
              stream: DatabaseService(
                      firebaseUser: AuthService().getCurrentUser(),
                      context: context)
                  .promotionStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return buildStreamBuilderNullContainer();
                } else if (snapshot.connectionState == ConnectionState.active) {
                  List<Promotion> promotionList = snapshot.data;
                  if (snapshot.data != null && promotionList.length >= 1) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: size * 0.15),
                      scrollDirection: Axis.vertical,
                      itemCount: promotionList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              enableDrag: false,
                              isDismissible: false,
                              builder: (context) => Container(
                                height: size,
                                child: PromotionDetailView(
                                  title: promotionList[index].title,
                                  body: promotionList[index].body,
                                  imageUrl: promotionList[index].imageUrl,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: buildCard(
                              promotionList[index].title,
                              promotionList[index].body,
                              promotionList[index].imageUrl,
                              size,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return buildNullFutureBuilderStream(context, 'promotion');
                  }
                } else {
                  return buildStreamBuilderLoader();
                }
              },
            ),
          ),
          getDrawerNavigator(context, size, 'Promotion'),
        ],
      ),
    );
  }

  buildCard(String title, String body, String imagePath, size) {
    return Card(
      shadowColor: kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, bottom: size * 0.02, top: size * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                buildTitlenSubtitleText('$title !!!', Colors.black38, 14,
                    FontWeight.bold, TextAlign.start, null),
                SizedBox(
                  width: 3,
                ),
                Container(
                  height: 20,
                  width: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SvgPicture.asset(
                      'assets/images/promotionDollar.svg',
                      semanticsLabel: 'dollar icon',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            buildTitlenSubtitleText(body, Colors.black26, 13, FontWeight.w700,
                TextAlign.start, null),
          ],
        ),
      ),
    );
  }
}

class PromotionDetailView extends StatelessWidget {
  String title;
  String body;
  String imageUrl;

  PromotionDetailView({
    this.title,
    this.body,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          height: size,
          padding: EdgeInsets.only(left: 40, right: 40, top: size * 0.14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitlenSubtitleText(title, Color(0xFF4F4F4F), 22,
                    FontWeight.bold, TextAlign.start, null),
                SizedBox(
                  height: 30,
                ),
                CachedNetworkImage(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  imageUrl: imageUrl,
                  placeholder: (context, url) => Padding(
                    padding: const EdgeInsets.all(120.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 30,
                ),
                buildTitlenSubtitleText(body, Color(0xFF828282), 14,
                    FontWeight.bold, TextAlign.start, null),
              ],
            ),
          ),
        ),
        getDrawerNavigator(context, size, 'Promotion'),
      ],
    );
  }
}
