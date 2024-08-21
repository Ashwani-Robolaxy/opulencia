import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/home/controller/home_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/icon_strings.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/widgets/my_empty_message.dart';
import 'package:opulencia/utils/widgets/my_textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var homeData = ref.watch(homeControllerProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        homeData.searchList!.clear();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          foregroundColor: Theme.of(context).canvasColor,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Hero(
              tag: "search_tag",
              child: MyTextField(
                onChanged: (p0) async {
                  homeData.isLoadingSearch = true;
                  setState(() {});
                  await homeData
                      .searchFrames(context: context, searchText: p0)
                      .then((value) {
                    homeData.isLoadingSearch = false;
                    setState(() {});
                  });
                },
                controller: _controller,
                hintText: "Search",
                prefixIconData: const Icon(Icons.search),
                hasPrefix: true,
                focusNode: _focusNode,
              ),
            ),
          ),
        ),
        body: homeData.isLoadingSearch
            ? GridView.builder(
                padding: const EdgeInsets.all(15),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 15,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100.w,
                        height: 100.h,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              )
            : homeData.searchList!.isEmpty
                ? EmptyStateMessage(
                    message: "No Product Found!",
                    animationAsset: IconStrings.sadLottie)
                : GridView.builder(
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeData.searchList!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      var frames = homeData.searchList![index];
                      return InkWell(
                        onTap: () {
                          context.go(
                              '/${Routes.bottomNav}/${Routes.search}/${Routes.commonProductDetail}',
                              extra: frames);
                        },
                        child: Container(
                          width: 30.w,
                          decoration: BoxDecoration(
                            // color: _randomColor().withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: frames.images![0].images!,
                                  width: 100.w,
                                  height: 100.h,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 100.w,
                                      height: 100.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7)
                                        ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      frames.frame!,
                                      maxLines: 2,
                                      style: Styles.mediumBoldText(context)
                                          .copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
