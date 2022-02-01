import 'package:clipboard/clipboard.dart';
import 'package:ficon_gallery/data/cupertino_icon_data.dart';
import 'package:ficon_gallery/data/material_icon_data.dart';
import 'package:ficon_gallery/utils/toast_helper.dart';
import 'package:flutter/material.dart';
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

  String selectedIconType = MATERIAL_ICON;

  Widget customAppBar = Row(
    children: [
      Image.asset(
        'assets/logo/ficon_gallery_logo.png',
        height: 40,
      ),
      const Text('icon Gallery')
    ],
  );

  _changeIconType(String iconType) {
    setState(() {
      if (iconType == MATERIAL_ICON) {
        currentIconList = materialIconList;
        selectedIconType = iconType;
        if (searchKey.isNotEmpty) {
          _searchIcon(searchKey);
        } else {
          resultIconList = currentIconList;
        }
      } else if (iconType == CUPERTINO_ICON) {
        currentIconList = cupertinoIconList;
        selectedIconType = iconType;
        if (searchKey.isNotEmpty) {
          _searchIcon(searchKey);
        } else {
          resultIconList = currentIconList;
        }
      }
    });
  }

  _searchIcon(String enteredKeyword) {
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
    _searchIcon(searchKey);
  }

  Widget customSearchBar(double width) {
    return SizedBox(
      width: width > 500 ? 60.w : 150.w,
      child: TextField(
        controller: searchController,
        onChanged: (value) => _searchIcon(value),
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
                          onPressed: () => _changeIconType(MATERIAL_ICON),
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
                          onPressed: () => _changeIconType(CUPERTINO_ICON),
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
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 1,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15),
                    itemCount: resultIconList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        onTap: () => FlutterClipboard.copy(
                                '${resultIconList[index]['label']}')
                            .then((value) => showToast(
                                message: '${resultIconList[index]['label']}')),
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(resultIconList[index]['icon']),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(resultIconList[index]['name'])
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey)),
                        ),
                      );
                    }),
              ),
            ));
  }
}
