import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hope_app/core/theme/theme_extension.dart';

import '../constants/locale_keys.dart';
import '../theme/styles/app_text_styles.dart';

class CustomDropDown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) titleExtractor;
  final String Function(T) idExtractor;
  final Function(String) onSelected;
  final Function()? onClear;
  final String? hintText;
  final bool enableSearch;
  final String? selectedId;
  final bool enableClear;
  final bool isAcceptEdits;
  final String? selectedTitle;

  const CustomDropDown({
    required this.items,
    required this.titleExtractor,
    required this.idExtractor,
    required this.onSelected,
    super.key,
    this.hintText,
    this.enableSearch = true,
    this.selectedId,
    this.onClear,
    this.enableClear = true,
    this.isAcceptEdits = true,
    this.selectedTitle,
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  // Text controller for search functionality
  final TextEditingController _searchController = TextEditingController();
  // Filtered items based on search query
  List<T> filteredItems = [];
  // Currently selected item id
  String? selectedId;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    selectedId = widget.selectedId;
  }

  @override
  void didUpdateWidget(CustomDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filterItems(_searchController.text);
    }
    if (oldWidget.selectedId != widget.selectedId) {
      selectedId = widget.selectedId;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter items based on search query
  void _filterItems(String query) {
    if (!mounted) return;

    setState(() {
      if (query.isEmpty) {
        filteredItems = widget.items;
      } else {
        filteredItems = widget.items
            .where(
              (item) => widget
                  .titleExtractor(item)
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  // Clear search field and reset filter
  void _clearSearch() {
    _searchController.clear();
    _filterItems('');
  }

  // Show dropdown modal bottom sheet
  void _showDropdownModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Modal header with title
            Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: Text(
                widget.hintText ?? LocaleKeys.selectItem.tr(),
                style: Styles.s14(
                  context,
                ).copyWith(color: context.darkLightestColor),
              ),
            ),
            // Search field
            if (widget.enableSearch)
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterItems,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.search.tr(),
                    prefixIcon: Padding(
                      padding: const EdgeInsetsDirectional.all(18.0),
                      child: SvgPicture.asset(
                        Assets.assetsIconsInactiveSearchIcon,
                      ),
                    ),
                    // Clear search field button
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: context.redColor,
                              size: 16,
                            ),
                            onPressed: _clearSearch,
                          )
                        : null,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.primaryColor),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.bordersColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.bordersColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Dropdown items list or empty state
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        LocaleKeys.noResultsFound.tr(),
                        style: Styles.s12(
                          context,
                        ).copyWith(color: context.textHintLight),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final itemId = widget.idExtractor(item);
                        final isSelected = selectedId == itemId;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedId = itemId;
                              });
                              widget.onSelected(itemId);
                              _searchController.clear();
                              _filterItems('');
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.primaryColor.withValues(
                                        alpha: 0.1,
                                      )
                                    : context.bordersColor.withValues(
                                        alpha: 0.3,
                                      ),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: context.primaryColor,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Text(
                                widget.titleExtractor(item),
                                style: Styles.s12(context).copyWith(
                                  color: isSelected
                                      ? context.primaryColor
                                      : null,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isAcceptEdits
          ? () {
              FocusScope.of(context).unfocus();
              _showDropdownModal();
            }
          : null,
      // Main dropdown container with fixed height
      child: Container(
        height: 56,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 12,
          vertical: 0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: context.bordersColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Display selected item or hint text
            Expanded(
              child: Builder(
                builder: (context) {
                  T? selectedItem;
                  if (selectedId != null) {
                    try {
                      selectedItem = widget.items.firstWhere(
                        (item) => widget.idExtractor(item) == selectedId,
                      );
                    } catch (_) {
                      selectedItem = null;
                    }
                  }
                  return Text(
                    widget.selectedTitle ??
                        (selectedItem != null
                            ? widget.titleExtractor(selectedItem)
                            : widget.hintText ?? LocaleKeys.selectItem.tr()),
                    style: selectedItem != null || widget.selectedTitle != null
                        ? Styles.s12(context)
                        : Styles.s12(
                            context,
                          ).copyWith(color: context.darkLightestColor),
                  );
                },
              ),
            ),
            // Clear button - shows when item is selected
            if (selectedId != null &&
                widget.enableClear &&
                widget.isAcceptEdits)
              IconButton(
                icon: Icon(Icons.clear, size: 16, color: context.redColor),
                onPressed: () {
                  setState(() {
                    selectedId = null;
                  });
                  widget.onClear?.call();
                },
              ),
            // Dropdown arrow icon
            Icon(Icons.keyboard_arrow_down, color: context.darkMediumColor),
          ],
        ),
      ),
    );
  }
}
