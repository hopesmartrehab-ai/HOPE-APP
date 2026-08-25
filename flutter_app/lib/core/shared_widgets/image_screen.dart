import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hope_app/core/constants/locale_keys.dart';
import 'package:hope_app/core/theme/theme_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../theme/styles/app_text_styles.dart';
import 'custom_network_image.dart';

class ImageScreen extends StatefulWidget {
  final List<String> images;
  final String? title;
  final int initialIndex;

  const ImageScreen({
    required this.images,
    super.key,
    this.title,
    this.initialIndex = 0,
  });

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.buttomSheetTopColor,
      appBar: AppBar(
        title: Text(widget.title ?? LocaleKeys.images.tr()),
        backgroundColor: context.buttomSheetTopColor,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: CustomNetworkImage(
                      imageUrl: widget.images[index],
                      fit: BoxFit.contain,
                      borderRadius: 0,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.images.length,
                  effect: ScrollingDotsEffect(
                    dotColor: context.lightGray,
                    dotHeight: 2,
                    dotWidth: 40,
                    activeDotScale: 1,
                    activeDotColor: context.blackColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${_currentPage + 1} / ${widget.images.length}',
                  style: Styles.s14(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
