
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/features/orders/controller/order_controller.dart';
import 'package:opulencia/features/orders/model/order_history_model.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:opulencia/utils/widgets/my_textfield.dart';

// ignore: must_be_immutable
class RatingScreen extends ConsumerStatefulWidget {
  ProductDetails? product;
  RatingScreen({required this.product, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  int _rating = 0; // Default rating value
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = ref.watch(orderControllerProvider);
    final catData = ref.watch(catControllerProvider);
    return Scaffold(
      appBar: myAppBar(
        context: context,
        title: "Rate this purchase",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            Text('Your Feedback', style: Styles.mediumBoldText(context)),
            const SizedBox(height: 10),
            MyTextField(
                maxLines: 5,
                controller: _feedbackController,
                hintText: 'Write your feedback here...'),
            const Gap(10),
            MyCustomButton(
                onPressed: () async {
                  // Handle submit action
                  final rating = _rating;
                  final feedback = _feedbackController.text;
                  if (rating != 0) {
                    await orderData.addReview(
                        context: context,
                        rating: rating,
                        review: feedback,
                        productId: widget.product!.id.toString());

                    // ignore: use_build_context_synchronously
                    await catData.getSubCatProducts(context: context);
                    // ignore: use_build_context_synchronously
                    await catData.getFramesByCat(context: context);
                  } else {
                    MyToast.infoToast("Please rate", context);
                  }
                  // Use the rating and feedback values as needed
                  print('Rating: $rating');
                  print('Feedback: $feedback');
                },
                label: 'Submit'),
          ],
        ),
      ),
    );
  }
}
