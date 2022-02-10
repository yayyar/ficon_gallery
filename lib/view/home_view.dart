import 'package:clipboard/clipboard.dart';
import 'package:ficon_gallery/data/cupertino_icon_data.dart';
import 'package:ficon_gallery/data/material_icon_data.dart';
import 'package:ficon_gallery/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const List<Map<String, dynamic>> materialIconList = materialIconData;
  static const List<Map<String, dynamic>> cupertinoIconList = cupertinoIconData;

  List<Map<String, dynamic>> currentIconList = materialIconList;
  List<Map<String, dynamic>> resultIconList = materialIconList;
  TextEditingController searchController = TextEditingController();
  String searchKey = '';
  late ScrollController _scrollController;
  bool _show = false;

  String selectedIconType = MATERIAL_ICON;

  @override
  initState() {
    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    handleScroll();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void _toPageTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        showFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward ||
          _scrollController.position.userScrollDirection ==
              ScrollDirection.idle) {
        hideFloationButton();
      }
    });
  }

  void hideFloationButton() {
    setState(() {
      if (_show) _show = false;
    });
  }

  Widget customAppBar = Row(
    children: [
      Image.asset(
        'assets/logo/ficon_gallery_logo.png',
        height: 40,
      ),
      const Text('icon Gallery')
    ],
  );

  changeIconType(String iconType) {
    hideFloationButton();
    setState(() {
      selectedIconType = iconType;
      currentIconList =
          iconType == MATERIAL_ICON ? materialIconList : cupertinoIconList;
      if (searchKey.isNotEmpty) {
        searchIcon(searchKey);
      } else {
        resultIconList = currentIconList;
      }
    });
  }

  searchIcon(String enteredKeyword) {
    searchKey = enteredKeyword;
    setState(() {
      if (searchKey.isEmpty) {
        resultIconList = currentIconList;
      } else {
        resultIconList = currentIconList
            .where((icon) =>
                icon["name"].toLowerCase().contains(searchKey.toLowerCase()))
            .toList();
      }
    });
  }

  _clearSearchKey() {
    searchController.clear();
    searchKey = '';
    searchIcon(searchKey);
  }

  Widget customSearchBar(double width) {
    return SizedBox(
      width: width > 500 ? 60.w : 150.w,
      child: TextField(
        controller: searchController,
        onChanged: (value) => searchIcon(value),
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchKey.isNotEmpty
                ? IconButton(
                    onPressed: () => _clearSearchKey(),
                    icon: const Icon(
                      Icons.clear,
                      size: 18,
                    ))
                : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0)),
            filled: true,
            fillColor: const Color(0xfff5f6fa),
            hintText: 'Search...',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
      ),
    );
  }

  Widget iconGridView(List<Map<String, dynamic>> iconList, {required Key key}) {
    return GridView.builder(
        key: key,
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15),
        itemCount: iconList.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: () => FlutterClipboard.copy('${iconList[index]['label']}')
                .then((value) =>
                    showToast(message: '${iconList[index]['label']}')),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconList[index]['icon']),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(iconList[index]['name'])
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ScreenUtilInit(
        designSize: const Size(375, 667),
        builder: () => Scaffold(
              appBar: AppBar(
                title: width >= 500 ? customAppBar : null,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => changeIconType(MATERIAL_ICON),
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0.0),
                              backgroundColor: MaterialStateProperty.all(
                                  selectedIconType == MATERIAL_ICON
                                      ? Colors.white
                                      : Colors.transparent),
                              foregroundColor: MaterialStateProperty.all(
                                  selectedIconType == MATERIAL_ICON
                                      ? Colors.blue
                                      : Colors.white),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500))),
                          child: const Text(
                            'Material',
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextButton(
                          onPressed: () => changeIconType(CUPERTINO_ICON),
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0.0),
                              backgroundColor: MaterialStateProperty.all(
                                  selectedIconType == CUPERTINO_ICON
                                      ? Colors.white
                                      : Colors.transparent),
                              foregroundColor: MaterialStateProperty.all(
                                  selectedIconType == CUPERTINO_ICON
                                      ? Colors.blue
                                      : Colors.white),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500))),
                          child: const Text(
                            'Cupertino',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        customSearchBar(width),
                      ],
                    ),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: selectedIconType == MATERIAL_ICON
                    ? iconGridView(resultIconList, key: const ValueKey(1))
                    : iconGridView(resultIconList, key: const ValueKey(2)),
              ),
              floatingActionButton: Visibility(
                visible: _show,
                child: FloatingActionButton(
                  onPressed: () => _toPageTop(),
                  mini: true,
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),
            ));
  }
}
