import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({super.key, required this.type});
  //* urban or rural
  final String? type;

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  final myRequestsUrban = [
    {
      'destination': ' Flat No. 203, Sai Residency, MG Road, Pune ',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod',
      'status': 'Pending',
      'type': 'Urban',
      'date': '07 June',
    },
    {
      'destination': ' Flat No. 203, Sai Residency, MG Road, Pune ',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod',
      'status': 'Confirm',
      'type': 'Urban',
      'date': '07 June',
    },
    {
      'destination': ' Flat No. 203, Sai Residency, MG Road, Pune ',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod',
      'status': 'Pending',
      'type': 'Urban',
      'date': '07 June',
    },
    {
      'destination': ' Flat No. 203, Sai Residency, MG Road, Pune ',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod',
      'status': 'Pending',
      'type': 'Urban',
      'date': '07 June',
    }
  ];

  final myRequestsRural = [
    {
      'destination': ' Flat No. 203, Sai Residency, MG Road, Pune ',
      'status': 'Pending',
      'type': 'Rural',
      'date': '07 June',
    },
    {
      'destination': ' Flat No. 203, Sai Residency, MG Road, Pune ',
      'status': 'Confirm',
      'type': 'Rural',
      'date': '07 June',
    },
    {
      'destination': ' Flat No. 203, Sai Residency, MG Road, Pune ',
      'status': 'Pending',
      'type': 'Rural',
      'date': '07 June',
    },
    {
      'destination': ' Flat No. 203, Sai Residency, MG Road, Pune ',
      'status': 'Pending',
      'type': 'Rural',
      'date': '07 June',
    }
  ];

  final show = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomStatusBarWidget(
              title: AppLocalizations.of(context)!.myRequestString,
              fontSize: 22,
            ),
            const SizedBox(
              height: 20,
            ),
            show
                ? Expanded(
                    child: widget.type == 'urban'
                        ? customListView(itemList: myRequestsUrban, type: 'urban')
                        : customListView(itemList: myRequestsRural, type: 'rural'),
                  )
                : Column(
                    children: [
                      SizedBox(height: size.width * 0.2),
                      SizedBox(
                        height: size.width * 0.6,
                        width: size.width * 0.6,
                        child: Card(
                          elevation: 10,
                          color: Color(0xFFE0FFDD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(size.width),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: SvgPicture.asset(emptyBoxImage),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.noRequestString,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.orderHistoryDesc,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF7D7171),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.width * 0.2),
                      CustomElevatedButton(
                        name: AppLocalizations.of(context)!.createRequestString,
                        borderRadius: 8,
                        alignment: Alignment.center,
                        onPressed: () {
                          context.pushNamed(createRequestScreen);
                        },
                      )
                    ],
                  ),
            SizedBox(height: size.width * 0.1),
          ],
        ),
      ),
    );
  }

  Widget customListView(
      {required final List<Map<String, String>> itemList, required final String type}) {
    return ListView.builder(
      itemCount: itemList.length,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemBuilder: (final context, final index) {
        return GestureDetector(
          onTap: () {
            context.pushNamed(myRequestDetailsScreen, extra: {'type': type});
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        locationPinImage,
                        width: 24,
                        height: 32,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomRichText(
                          title: '${AppLocalizations.of(context)!.destinationLocationString}: ',
                          value: itemList[index]['destination'],
                        ),
                      )
                    ],
                  ),
                  type == 'urban'
                      ? const SizedBox(
                          height: 8,
                        )
                      : SizedBox.shrink(),
                  type == 'urban'
                      ? CustomRichText(
                          title: '${AppLocalizations.of(context)!.descriptionString}: ',
                          value: itemList[index]['description'],
                        )
                      : SizedBox.shrink(),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomRichText(
                    title: '${AppLocalizations.of(context)!.statusString}: ',
                    value: itemList[index]['status'],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomRichText(
                        title: '${AppLocalizations.of(context)!.typeString}: ',
                        value: itemList[index]['type'],
                      ),
                      CustomRichText(
                        title: '${AppLocalizations.of(context)!.dateString}: ',
                        value: itemList[index]['date'],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
