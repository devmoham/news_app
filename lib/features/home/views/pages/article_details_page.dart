import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/cubit/favorite_actions_cubit.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsPage extends StatefulWidget {
  final Article article;

  const ArticleDetailsPage({
    super.key,
    required this.article,
  });

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final String articleUrl = widget.article.url ?? '';
    final Uri url = Uri.parse(widget.article.url ?? '');
    Future<void> _launchUrl() async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    final size = MediaQuery.sizeOf(context);
    final parsedDate =
        DateTime.parse(widget.article.publishedAt ?? DateTime.now().toString());
    final formattedDate = DateFormat.yMMMd().format(parsedDate);

    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.article.urlToImage ??
                'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
            width: double.infinity,
            height: size.height * 0.5,
            fit: BoxFit.cover,
          ),
          Container(
            height: size.height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.center,
                begin: Alignment.bottomCenter,
                colors: [
                  AppColors.black.withOpacity(0.8),
                  AppColors.black.withOpacity(0.1),
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.06,
            left: 8,
            right: 8,
            child: SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBarButton(
                    iconData: Icons.arrow_back_ios_new_outlined,
                    hasPaddingBetween: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      AppBarButton(
                        iconData: Icons.share,
                        hasPaddingBetween: true,
                        onTap: () async {
                          await Share.share(articleUrl);
                        },
                      ),
                      const SizedBox(width: 8),
                      BlocBuilder<FavoriteActionsCubit, FavoriteActionsState>(
                        buildWhen: (previous, current) =>
                            (current is DoingFavorite &&
                                current.title == widget.article.title) ||
                            (current is FavoriteAdded &&
                                current.title == widget.article.title) ||
                            (current is FavoriteRemoved &&
                                current.title == widget.article.title),
                        builder: (context, state) {
                          final cubit = context.read<FavoriteActionsCubit>();
                          bool isFav = widget.article.isFavorite;

                          if (state is FavoriteAdded &&
                              state.title == widget.article.title) {
                            isFav = true;
                          } else if (state is FavoriteRemoved &&
                              state.title == widget.article.title) {
                            isFav = false;
                          }

                          return AppBarButton(
                            iconData: isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_outlined,
                            hasPaddingBetween: true,
                            onTap: () async {
                              await cubit.setFavorite(widget.article);
                              setState(() {
                                widget.article.isFavorite =
                                    !widget.article.isFavorite;
                              });
                            },
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DecoratedBox(
                      //   decoration: BoxDecoration(
                      //     color: AppColors.primary,
                      //     borderRadius: BorderRadius.circular(16),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Text(
                      //      '' ,
                      //       style:
                      //           Theme.of(context).textTheme.bodyLarge!.copyWith(
                      //                 color: AppColors.white,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                      Text(
                        widget.article.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Trending . $formattedDate',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: AppColors.white,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(36),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        24.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: CachedNetworkImageProvider(
                                    widget.article.urlToImage ??
                                        'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: size.width * 0.7,
                                  height: 30,
                                  child: Text(
                                    widget.article.source?.name ?? 'UNKNOWN',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              (widget.article.description ?? '') +
                                  (widget.article.content ?? ''),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: AppColors.black,
                                  ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _launchUrl(),
                              child: Text(
                                'Read More',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: AppColors.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}