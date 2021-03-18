import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_events.dart';
import 'package:my_lawn/screens/calendar/widgets/product_status_widget.dart';
import 'package:my_lawn/widgets/product_image.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    @required this.event,
    Key key,
  }) : super(key: key);

  final CalendarEvents event;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildDescriptionColumn()),
        _buildImage(),
      ],
    );
  }

  Widget _buildDescriptionColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.task.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Styleguide.color_gray_9,
          ),
          textAlign: TextAlign.start,
          key: Key('event_name'),
        ),
        const SizedBox(height: 16),
        ProductStatusWidget(product: event.task),
      ],
    );
  }

  Widget _buildImage() {
    final image = event.task.childProducts?.first?.imageUrl;
    return image != null
        ? ProductImage(productImageUrl: image, width: 56, height: 56)
        : const SizedBox();
  }
}
