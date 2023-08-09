/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:images/app.dart';
import 'package:images/app_const.dart';
import 'package:images/common/util/log_util.dart';
import 'package:images/main.dart';
import 'package:images/manager/memory_cache.dart';
import 'package:images/pages/dialog_image_info.dart';
import 'package:images/pages/views/SimpleNetworkImageBuilder.dart';
import 'package:images/pages/views/buttons.dart';
import 'package:images/pages/views/desktop/win_titlebars.dart';
import 'package:images/routes/routes.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../apis/jsons.dart' as img;
import 'datas/IndexData.dart';
import 'datas/search_menu.dart';
import 'dialog_menu_manager.dart';

///create by itz on 2022/11/14 16:31
///desc : 图片主页
///

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var indexData = IndexData();
    MemoryCache.getInstance().put(AppKey.MC_IndexData, indexData);
    indexData.init();
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: indexData),
      ChangeNotifierProvider.value(value: indexData.menuData),
      ChangeNotifierProvider.value(value: indexData.loadData),
    ], child: const _Page());
  }
}

class _Page extends StatelessWidget {
  const _Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var init = context.select((IndexData indexData) => indexData.dataInit);
    if (init) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: WAppBar(title: const Text("壁纸~"), actions: [
          StyleButton(
              style: StyleButton.windowMenuButtonStyle(),
              onPressed: () {
                App.getRouter().navigateTo(context, Routes.settings);
              },
              child: const Icon(Icons.settings)),
          StyleButton(
              style: StyleButton.windowMenuButtonStyle(),
              onPressed: () {
                App.getRouter().navigateTo(context, Routes.ftoolsTest);
              },
              child: const Icon(Icons.abc))
        ]),
        body: Column(
          children: [
            _MenuListWidget(onMenuPressedCallback: (index, menu) {
              context.read<IndexData>().setSelectMenu(menu);
            }, searchCallback: (String text) {
              if (StringUtils.isNullOrEmpty(text)) {
                toast("请先输入");
                return;
              }
              context.read<IndexData>().loadImageList(word: text);
            }, addCallback: (String text, bool select) {
              if (StringUtils.isNullOrEmpty(text)) {
                toast("请先输入");
                return;
              }
              context.read<IndexData>().addMenu(text, select);
            }, settingClickedCallback: () {
              _showMenuManagerDialog(context, context.read<IndexData>());
            }),
            Expanded(child: _Body(itemClickedCallback: (position, imageInfo) {
              _showInfoDialog(context, imageInfo);
            })),
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  void _showInfoDialog(BuildContext context, img.ImageInfo imageInfo) {
    showDialog(
        context: context,
        builder: (context) {
          return ImageInfoDialog(imageInfo: imageInfo);
        });
  }

  void _showMenuManagerDialog(BuildContext context, IndexData indexData) {
    showDialog(
        context: context,
        builder: (context) {
          return MenuManagerPage(
            indexData: indexData,
          );
        });
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key, this.itemClickedCallback}) : super(key: key);

  final ItemClickedCallback? itemClickedCallback;

  @override
  State<StatefulWidget> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final String _TAG = "_BodyState";

  EasyRefreshController? _refreshController;
  OnLoadListener? _onLoadListener;

  @override
  void initState() {
    _refreshController = EasyRefreshController(controlFinishLoad: true);
    _onLoadListener = OnLoadListener(onStart: (requestId) {
      LogUtil.d(_TAG, "开始加载：$requestId");
    }, onFinish: (requestId, code, data) {
      LogUtil.d(_TAG, "结束加载：$requestId,$code,$data");
      _refreshController?.finishLoad(IndicatorResult.success);
    });
    context.read<IndexData>().setLoadListener(_onLoadListener);
    super.initState();
  }

  @override
  void dispose() {
    context.read<IndexData>().setLoadListener(null);
    _refreshController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int columnItemSize = width ~/ 256;
    //用来监听列表刷新
    context.select((LoadData loadData) => loadData.lastUpdateTime);
    return EasyRefresh(
        controller: _refreshController,
        onLoad: () {
          if (context.read<LoadData>().isLoading) return IndicatorResult.none;
          context.read<IndexData>().loadMore();
        },
        child: CustomScrollView(
          slivers: [
            SliverLayoutBuilder(builder: (context, type) {
              LoadData loadData = context.read<LoadData>();
              int length = loadData.imgList.length;
              int itemCount = ((length % columnItemSize > 0) ? 1 : 0) +
                  length ~/ columnItemSize;
              return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return ItemView(
                  imgList: loadData.imgList,
                  startIndex: index * columnItemSize,
                  size: columnItemSize,
                  itemClickedCallback: widget.itemClickedCallback,
                );
              }, childCount: itemCount));
            }),
          ],
        ));
  }
}

///图片列表item视图-----------------------------------------------------------------------------------------------
///每行显示的图片数量,高度固定，宽度是根据计算得出

typedef ItemClickedCallback = void Function(
    int position, img.ImageInfo imageInfo);
typedef DownloadClickedCallback = void Function(
    int position, img.ImageInfo imageInfo);

class ItemView extends StatelessWidget {
  const ItemView({
    Key? key,
    this.height = 192,
    required this.imgList,
    required this.startIndex,
    required this.size,
    this.itemClickedCallback,
    this.downloadClickedCallback,
  }) : super(key: key);

  final double height;
  final int startIndex;
  final int size;
  final List<img.ImageInfo> imgList;
  final ItemClickedCallback? itemClickedCallback;
  final DownloadClickedCallback? downloadClickedCallback;

  @override
  Widget build(BuildContext context) {
    int realSize = min(size, imgList.length - startIndex);
    return Row(
      children: [
        for (int i = 0; i < realSize; i++)
          Flexible(
              //按高度等比缩放后占的高度
              flex: _getItemData(startIndex + i)!.showFlex(),
              child: Container(
                width: double.maxFinite,
                height: height,
                //超出部分，可裁剪
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(8),
                child: LayoutBuilder(builder: (context, _) {
                  var data = _getItemData(startIndex + i);
                  String? url = data?.thumbURL;
                  String name = data?.getDType() ?? "";
                  return url == null
                      ? const Text("error url")
                      : (App.isMobilePlatform()
                          ? _getItemViewMobile(data!, name, startIndex, i)
                          : _getItemView(data!, name, startIndex, i));
                }),
              ))
      ],
    );
  }

  Widget _getItemView(
      img.ImageInfo data, String name, int startIndex, int position) {
    //控制item菜单的显示隐藏
    StateSetter? showItemMenuSetter;
    var hover = false;
    String url = data.thumbURL!;
    return MouseRegion(
      onEnter: (event) {
        hover = true;
        showItemMenuSetter?.call(() {});
      },
      onExit: (event) {
        hover = false;
        showItemMenuSetter?.call(() {});
      },
      child: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: SimpleNetworkImageBuilder(
              name: name,
              url: url,
              builder: (img) {
                return Image.file(img, fit: BoxFit.cover);
              },
              placeHolder: const LinearProgressIndicator(
                backgroundColor: Colors.white54,
                color: Colors.white60,
              ),
            ),
          ),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            showItemMenuSetter = setState;
            return Visibility(
              visible: hover,
              child: StyleButton(
                onPressed: () {
                  itemClickedCallback?.call(startIndex + position, data);
                },
                child: Column(
                  children: [
                    Text(
                      data.fromPageTitle ?? "",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          "${data.width}x${data.height}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _getItemViewMobile(
      img.ImageInfo data, String name, int startIndex, int position) {
    String url = data.thumbURL!;
    return Stack(
      children: [
        SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: SimpleNetworkImageBuilder(
              name: name,
              url: url,
              builder: (img) {
                return Image.file(img, fit: BoxFit.cover);
              },
              placeHolder: const LinearProgressIndicator(
                backgroundColor: Colors.white54,
                color: Colors.white60,
              )),
        ),
        StyleButton(
          //style: ElevatedButton.styleFrom(shadowColor: Colors.white),
          onPressed: () {
            itemClickedCallback?.call(startIndex + position, data);
          },
          child: Column(children: [
            Text(data.fromPageTitle ?? "",
                style: const TextStyle(color: Colors.white)),
            const Spacer(),
            Row(
              children: [
                Text("${data.width}x${data.height}",
                    style: const TextStyle(color: Colors.white)),
              ],
            )
          ]),
        ),
      ],
    );
  }

  img.ImageInfo? _getItemData(int index) {
    if (0 <= index && index < imgList.length) {
      return imgList[index];
    }
    return null;
  }
}

///菜单栏---------------------------------------------------------------------------------------------------------------
///callback,菜单栏点击时的回调
typedef MenuSearchCallback = void Function(String text);
typedef MenuAddCallback = void Function(String text, bool select);
typedef OnMenuPressedCallback = Function(int index, SearchMenu searchMenu);

///菜单栏组件
class _MenuListWidget extends StatelessWidget {
  final MenuSearchCallback? searchCallback;
  final MenuAddCallback? addCallback;
  final VoidCallback? settingClickedCallback;
  final OnMenuPressedCallback? onMenuPressedCallback;

  const _MenuListWidget(
      {this.onMenuPressedCallback,
      this.searchCallback,
      this.addCallback,
      this.settingClickedCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: HEIGHT_WIN_BAR,
      color: myAppTheme.primarySwatch,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: _SearchView(
                  searchCallback: searchCallback, addCallback: addCallback)),
          Expanded(
              child:
                  _MenuListView(onMenuPressedCallback: onMenuPressedCallback)),
          StyleButton(
              onPressed: settingClickedCallback,
              style: StyleButton.iconButtonCircle(),
              child: const AspectRatio(
                  aspectRatio: 1, child: Icon(Icons.chevron_right)))
        ],
      ),
    );
  }
}

class _MenuListView extends StatelessWidget {
  const _MenuListView(
      {Key? key, this.scrollController, this.onMenuPressedCallback})
      : super(key: key);

  final OnMenuPressedCallback? onMenuPressedCallback;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    var menuData = context.watch<MenuData>();
    List<SearchMenu> menus = menuData.menus();
    return EasyRefresh(
      child: ListView.separated(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: menus.length,
          separatorBuilder: (context, index) {
            return const VerticalDivider(width: 4, color: Colors.transparent);
          },
          itemBuilder: (context, index) {
            //菜单按钮
            return ChangeNotifierProvider.value(
                value: menus[index],
                builder: (context, child) {
                  var select = context.watch<SearchMenu>().selected;
                  return StyleButton(
                    style: StyleButton.textButtonStyle(
                        backgroundColor:
                            select ? const Color(0xEEFFFFFF) : Colors.black12),
                    onPressed: () {
                      var menu = menus[index];
                      onMenuPressedCallback?.call(index, menu);
                    },
                    child: Text(
                      menus[index].showText ?? "",
                      style: TextStyle(
                          color: select ? Colors.black : Colors.white60),
                    ),
                  );
                });
          }),
    );
  }
}

///search 搜索按钮
class _SearchView extends StatefulWidget {
  const _SearchView({Key? key, this.searchCallback, this.addCallback})
      : super(key: key);
  final MenuSearchCallback? searchCallback;
  final MenuAddCallback? addCallback;

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  bool _searchOpen = false;
  bool _animEnd = true;
  TextEditingController? _editController;
  String _text = "";

  @override
  void initState() {
    _editController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.linear,
      width: _searchOpen ? 196 : 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        color: _searchOpen ? Colors.white : Colors.transparent,
      ),
      onEnd: () {
        setState(() {
          _animEnd = true;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyleButton(
            onPressed: () {
              setState(() {
                _animEnd = false;
                _searchOpen = !_searchOpen;
              });
            },
            style: StyleButton.iconButtonCircle(radius: 36),
            child: AspectRatio(
              aspectRatio: 1,
              child: Icon(_searchOpen ? Icons.close : Icons.search,
                  color: _searchOpen ? Colors.black : Colors.white),
            ),
          ),
          Visibility(
              visible: _animEnd && _searchOpen,
              child: Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _editController,
                      onChanged: (text) {
                        _text = text;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: '壁纸',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                      ),
                      onSubmitted: (value) {
                        widget.searchCallback?.call(value);
                      },
                    )),
                    StyleButton(
                        onPressed: () {
                          widget.searchCallback?.call(_text);
                        },
                        style: StyleButton.iconButtonCircle(
                          backgroundColor: Colors.black12,
                          radius: 36,
                        ),
                        child: const AspectRatio(
                            aspectRatio: 1,
                            child:
                                Icon(Icons.search_sharp, color: Colors.black))),
                    StyleButton(
                        onPressed: () {
                          //添加菜单项目
                          widget.addCallback?.call(_text, true);
                        },
                        style: StyleButton.iconButtonCircle(
                          backgroundColor: Colors.black12,
                          radius: 36,
                        ),
                        child: const AspectRatio(
                          aspectRatio: 1,
                          child: Icon(Icons.add, color: Colors.black),
                        ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
