import 'package:fl_paging/fl_paging.dart' as paging;
import 'package:flutter/material.dart';
import 'package:happypigs_app/db/Plate.dart';

import '../../data/note_repository.dart';
import '../../note_widgets/note_grid_widget.dart';
import 'list_view_page.dart';

class GridViewPage extends StatefulWidget {
  static const ROUTE_NAME = 'GridViewPage';

  @override
  _GridViewPageState createState() => _GridViewPageState();
}

class _GridViewPageState extends State<GridViewPage> {
  static const TAG = 'GridViewPage';
  final GlobalKey key = GlobalKey();
  ListViewDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = ListViewDataSource(PlateRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: paging.PagingGridView<Plate>(
        emptyBuilder: (context) {
          return Container();
        },
        key: key,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, data, child) {
          return NoteGridWidget(data);
        },
        delegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
        pageDataSource: dataSource,
      ),
    );
  }
}
