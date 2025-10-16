import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lessonplan/presentation/core/labeled_custom_dropdown.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

class LPFormDropDown<T> extends StatelessWidget {
  final ValueListenable listenable;
  final String label;
  final List<T> items;
  final String hintText;
  final void Function(T item) onChange;

  const LPFormDropDown({
    super.key,
    required this.listenable,
    this.label = '',
    required this.items,
    this.hintText = '',
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listenable,
      builder: (context, value, child) {
        return LabeledCustomDropdpwn<T>(
          isRequired: true,
          label: label,
          items: items,
          onChange: onChange,
          itemBuilder: (int count, T item, int index) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: (index != 0 || index != count - 1) ? 8 : 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.toString(),
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                      ),
                      maxLines: 3,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: value.toString() == item.toString()
                            ? ColorConstants.primaryBlue
                            : ColorConstants.lightGrey9,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: value.toString() == item.toString()
                            ? ColorConstants.primaryBlue
                            : ColorConstants.lightGrey9,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          child: Container(
            width: 340,
            constraints: BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorConstants.lightGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      value?.toString() ?? hintText,
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: (value == null || value!.toString().isEmpty)
                            ? ColorConstants.grey
                            : ColorConstants.primaryBlack,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
