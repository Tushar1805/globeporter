import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver/view/driver_tab_screen.dart';
import 'package:globeporter/presentation/driver/view/owner_tab_screen.dart';
import 'package:globeporter/presentation/driver/view/vehicle_tab_screen.dart';
import 'package:globeporter/resources/app_colors.dart';

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotSpacing;
  final double dotRadius;

  DottedLinePainter({
    this.color = Colors.grey,
    this.dotSpacing = 8,
    this.dotRadius = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // draw dots along the horizontal mid‑line
    final double centerY = size.height / 2;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawCircle(Offset(startX, centerY), dotRadius, paint);
      startX += dotSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OwnerDetailsScreen extends StatefulWidget {
  const OwnerDetailsScreen({super.key});

  @override
  State<OwnerDetailsScreen> createState() => _OwnerDetailsScreenState();
}

class _OwnerDetailsScreenState extends State<OwnerDetailsScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  int maxAllowedIndex = 0;
  void animateToPage(int index) {
    setState(() => currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> labels = [
      AppLocalizations.of(context)!.ownerString,
      AppLocalizations.of(context)!.vehicleString,
      AppLocalizations.of(context)!.driverString,
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '${labels[currentIndex]} ${AppLocalizations.of(context)!.detailsString}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Custom Stepper
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(labels.length * 2 - 1, (index) {
                if (index.isOdd) {
                  // Dashed/dotted line between steps
                  return Expanded(
                    child: CustomPaint(
                      painter: DottedLinePainter(dotRadius: 1, dotSpacing: 8),
                      child: const SizedBox(height: 40), // height controls vertical alignment
                    ),
                  );
                } else {
                  int stepIndex = index ~/ 2;
                  bool isSelected = currentIndex == stepIndex;

                  return GestureDetector(
                    onTap: () {
                      if (stepIndex <= maxAllowedIndex) {
                        animateToPage(stepIndex);
                      }
                    },
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : Colors.white,
                            border: Border.all(color: isSelected ? primaryColor : greyTextColor),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${stepIndex + 1}',
                              style: TextStyle(
                                color: isSelected ? Colors.white : greyTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isSelected ? primaryColor : greyTextColor,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ) ??
                              TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? primaryColor : greyTextColor,
                              ),
                          child: Text(labels[stepIndex]),
                        )
                      ],
                    ),
                  );
                }
              }),
            ),
          ),
          const SizedBox(height: 20),

          // Tab Content
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollUpdateNotification && _pageController.page != null) {
                  final double currentPage = _pageController.page!;
                  final double nextPage =
                      currentPage + notification.scrollDelta! / context.size!.width;

                  // Block forward scroll beyond max allowed
                  if (nextPage > maxAllowedIndex) {
                    _pageController.jumpToPage(maxAllowedIndex);
                    return true; // prevent default scroll
                  }
                }
                return false;
              },
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => currentIndex = index),
                children: [
                  OwnerTab(animateToPage: () {
                    setState(() {
                      currentIndex = 1;
                      maxAllowedIndex = 1;
                    });
                    animateToPage(1);
                  }),
                  VehicleTab(animateToPage: () {
                    setState(() {
                      currentIndex = 2;
                      maxAllowedIndex = 2;
                    });
                    animateToPage(2);
                  }),
                  DriverTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
