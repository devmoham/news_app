import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/core/views/widgets/article_widget_item.dart';
import 'package:news_app/features/search/search_cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<SearchCubit>(context);
    return Scaffold(
      appBar: AppBar(
        leading: AppBarButton(
          iconData: Icons.arrow_back,
          hasPaddingBetween: true,
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 40),
              ),
              Text(
                'News from all around the world',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: AppColors.grey),
                    prefixIcon:
                        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    suffixIcon: BlocBuilder<SearchCubit, SearchState>(
                      bloc: searchCubit,
                      buildWhen: (previous, current) =>
                          current is Searching ||
                          current is SearchLoaded ||
                          current is SearchError,
                      builder: (context, state) {
                        if (state is Searching) {
                          return TextButton(
                              onPressed: null,
                              child: Text(
                                'search',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: AppColors.primary),
                              ));
                        }
                        return TextButton(
                            onPressed: () {
                              searchCubit.search(_searchController.text);
                            },
                            child: Text(
                              'search',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: AppColors.primary),
                            ));
                      },
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              BlocBuilder<SearchCubit, SearchState>(
                bloc: searchCubit,
                buildWhen: (previous, current) =>
                    current is Searching ||
                    current is SearchLoaded ||
                    current is SearchError,
                builder: (context, state) {
                  if (state is Searching) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchLoaded) {
                    final articles = state.articles;
                    return ListView.separated(
                      itemCount: articles!.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return ArticleWidgetItem(article: article);
                      },
                    );
                  } else if (state is SearchError) {
                    return Text(state.message);
                  }
                  
                  return Center(child: Text('search for articles'));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
