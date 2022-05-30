import 'package:flutter/material.dart';
import 'package:flutter_3_linux/main_model.dart';
import 'package:provider/provider.dart';
import 'package:snapd/snapd.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaru_icons/yaru_icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainModel(),
      child: Consumer<MainModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Flutter 3 Linux'),
          ),
          body: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                child: TextFormField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: const Icon(YaruIcons.search),
                    suffixIcon: model.searchQuery.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(
                              YaruIcons.edit_clear,
                              size: 24.0,
                            ),
                            onPressed: () {
                              model.searchQuery = '';
                              _searchController.clear();
                            },
                          ),
                    hintText: 'Search a snap...',
                  ),
                  onChanged: (String term) => model.searchQuery = term,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
                  child: StreamBuilder<List<Snap>>(
                    stream: model.snapStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final snaps = snapshot.data!;

                        return ListView.separated(
                            itemBuilder: (context, index) {
                              final snap = snaps[index];

                              return ListTile(
                                title: Text(snap.title),
                                subtitle: Text(
                                  snap.summary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  snap.version,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                onTap: snap.storeUrl != null
                                    ? () async {
                                        final uri = Uri.parse(snap.storeUrl!);

                                        if (await canLaunchUrl(uri)) {
                                          launchUrl(uri);
                                        }
                                      }
                                    : null,
                              );
                            },
                            separatorBuilder: (context, index) => Container(
                                  padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                  ),
                                  child: const Divider(),
                                ),
                            itemCount: snaps.length);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
