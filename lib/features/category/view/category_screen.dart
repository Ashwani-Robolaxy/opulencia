import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  Color _randomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final catData = ref.watch(catControllerProvider);
    return Scaffold(
        appBar: myAppBar(context: context, title: "Categories"),
        body: MasonryGridView.count(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: catData.catList!.length,
          itemBuilder: (context, index) {
            var cat = catData.catList![index];
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                catData.selectedCatName = cat.category;
                catData.selectedCatIndex = index;
                context.go(
                    "/${Routes.bottomNav}/${Routes.category}/${Routes.subCategory}");
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _randomColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  cat.category,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: Styles.mediumText(context),
                ),
              ),
            );
          },
        ));
  }
}
