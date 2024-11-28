// search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/searchbloc/search_bloc.dart';
import 'package:frontend_chat/screens/chat_screen.dart';
import 'package:frontend_chat/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    context.read<SearchBloc>().add(SearchEmpty());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search...',

            prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
            // border: InputBorder.none,
          ),
          style: AppTheme.bodyText.copyWith(color: AppTheme.primaryColor),
          onChanged: (value) {
            if (value.isEmpty) {
              context.read<SearchBloc>().add(SearchEmpty());
            }
          },
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              context.read<SearchBloc>().add(SearchUser(query));
            }
          },
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchhHistoryResults) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Trending Terms', style: AppTheme.heading2),
                const SizedBox(height: 8),
                ...state.history.trending.map((term) {
                  return ListTile(
                    title: Text(term.term, style: AppTheme.bodyText),
                    trailing: Text(
                      term.count.toString(),
                      style: AppTheme.bodyText.copyWith(
                        color: AppTheme.accentColor,
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                Text('Recent Searches', style: AppTheme.heading2),
                const SizedBox(height: 8),
                ...state.history.recents.map((search) {
                  return ListTile(
                    title: Text(search.search, style: AppTheme.bodyText),
                    subtitle: Text(
                      search.createdAt,
                      style: AppTheme.bodyText.copyWith(
                        color: AppTheme.onBackgroundColor.withOpacity(0.6),
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          } else if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchResults) {
            return ListView.separated(
              itemCount: state.users.data.length,
              separatorBuilder: (context, index) => Divider(
                color: AppTheme.onSurfaceColor.withOpacity(0.2),
              ),
              itemBuilder: (context, index) {
                final user = state.users.data[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      user.username[0].toUpperCase(),
                      style: AppTheme.bodyText.copyWith(
                        color: AppTheme.onPrimaryColor,
                      ),
                    ),
                  ),
                  title: Text(user.username, style: AppTheme.bodyText),
                  subtitle: Text(
                    user.branch,
                    style: AppTheme.bodyText.copyWith(
                      color: AppTheme.onBackgroundColor.withOpacity(0.6),
                    ),
                  ),
                  trailing: Text(
                    user.skills.join(', '),
                    style: AppTheme.bodyText.copyWith(
                      color: AppTheme.accentColor,
                    ),
                  ),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final myId = prefs.getString('id') ?? '';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          userId: user.id,
                          myId: myId,
                          username: user.username,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is SearchError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: AppTheme.bodyText.copyWith(color: AppTheme.errorColor),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
