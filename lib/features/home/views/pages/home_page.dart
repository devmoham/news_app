import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/core/views/widgets/shimmer_effect_article_widget.dart';
import 'package:news_app/features/home/home_cubit/home_cubit.dart';
import 'package:news_app/features/home/views/pages/wifi_not_connected_page.dart';
import 'package:news_app/features/home/views/widgets/custom_carousel_slider.dart';
import 'package:news_app/features/home/views/widgets/recommendation_list_widget.dart';
import 'package:news_app/features/home/views/widgets/shimmer_effect_carousel.dart';
import 'package:news_app/features/home/views/widgets/title_headline_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // ✅ Delay cubit call until after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getRecommendationItems();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<HomeCubit>().getRecommendationItems(fromLoading: true);
      debugPrint('loading more data');
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBarButton(
            iconData: Icons.menu,
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
        ),
        actions: [
          AppBarButton(
            iconData: Icons.search,
            hasPaddingBetween: true,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.search,
            ),
          ),
          const SizedBox(width: 8),
          AppBarButton(
            iconData: Icons.notifications_none_rounded,
            hasPaddingBetween: true,
            onTap: () {},
          ),
          const SizedBox(width: 12),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          final homeCubit = BlocProvider.of<HomeCubit>(context);

          // Handle No Internet state
          if (state is NoInternet) {
            return WifiNotConnectedPage();
          }

          // Main Content
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TitleHeadlineWidget(
                    title: 'Breaking News',
                    onTap: () {},
                  ),
                  SizedBox(
                    height: 280,
                    child: BlocBuilder<HomeCubit, HomeState>(
                      bloc: homeCubit,
                      buildWhen: (previous, current) =>
                          current is TopHeadlinesLoading ||
                          current is TopHeadlinesLoaded ||
                          current is TopHeadlinesError ||
                          current is NoInternet,
                      builder: (context, state) {
                        if (state is TopHeadlinesLoading) {
                          return ListView.separated(
                            itemCount: 7,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            itemBuilder: (_, index) {
                              return ShimmerEffectCarouselSlider();
                            },
                          );
                        } else if (state is TopHeadlinesLoaded) {
                          final articles = state.articles;
                          return CustomCarouselSlider(
                            articles: articles ?? [],
                          );
                        } else if (state is TopHeadlinesError) {
                          return Center(
                            child: Text(state.message),
                          );
                        } else {
                          return const ShimmerEffectCarouselSlider();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      final cubit = context.read<HomeCubit>();
                      return SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: cubit.categories.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final category = cubit.categories[index];
                            final isSelected =
                                category == cubit.selectedCategory;
                            return GestureDetector(
                              onTap: () {
                                if (state is NoInternet) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No internet connection'),
                                    ),
                                  );
                                } else {
                                  cubit.selectCategory(category);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  category[0].toUpperCase() +
                                      category.substring(1),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TitleHeadlineWidget(
                    title: 'Recommendation',
                    onTap: () {},
                  ),
                  BlocBuilder<HomeCubit, HomeState>(
                    bloc: homeCubit,
                    buildWhen: (previous, current) =>
                        current is RecommendedNewsLoaded ||
                        current is RecommendedNewsLoading ||
                        current is RecommendedNewsError ||
                        current is! RecommendedNewsFromPaginationLoading &&
                            current is! RecommendedNewsInitial &&
                            current is! RecommendedNewsFromPaginationFailed,
                    builder: (context, state) {
                      if (state is RecommendedNewsLoading) {
                        return ListView.separated(
                          itemCount: 7,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (_, index) {
                            return ShimmerEffectArticleWidget();
                          },
                        );
                      } else if (state is RecommendedNewsLoaded) {
                        final articles = state.articles;
                        return RecommendationListWidget(
                          articles: articles ?? [],
                        );
                      } else if (state is RecommendedNewsError) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 50,
          child: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  current is RecommendedNewsFromPaginationLoading ||
                  current is RecommendedNewsLoaded ||
                  current is RecommendedNewsInitial ||
                  current is RecommendedNewsFromPaginationFailed,
              builder: (context, state) {
                if (state is RecommendedNewsFromPaginationLoading) {
                  return Center(child: CircularProgressIndicator.adaptive());
                } else if (state is RecommendedNewsFromPaginationFailed) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox.shrink();
                }
              }),
        ),
      ),
    );
  }
}
