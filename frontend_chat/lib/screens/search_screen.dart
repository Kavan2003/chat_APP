import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/searchbloc/search_bloc.dart';
import 'package:frontend_chat/models/search_models.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<SearchBloc>().add(SearchEmpty());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              context.read<SearchBloc>().add(SearchEmpty());
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final query = _searchController.text;
              if (query.isNotEmpty) {
                context.read<SearchBloc>().add(SearchUser(query));
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchhHistoryResults) {
            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Trending Terms',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...state.history.trending.map((term) {
                  return ListTile(
                    title: Text(term.term),
                    trailing: Text(term.count.toString()),
                  );
                }).toList(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Recent Searches',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...state.history.recents.map((search) {
                  return ListTile(
                    title: Text(search.search),
                    subtitle: Text(search.createdAt),
                  );
                }).toList(),
              ],
            );
          }

          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchResults) {
            return ListView.builder(
              itemCount: state.users.data.length,
              itemBuilder: (context, index) {
                final user = state.users.data[index];
                return ListTile(
                  title: Text(user.username),
                  subtitle: Text(user.branch),
                  trailing: Text(user.skills.join(', ')),
                );
              },
            );
          } else if (state is SearchError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return Container(
              // show History

              );
        },
      ),
    );
  }
}
