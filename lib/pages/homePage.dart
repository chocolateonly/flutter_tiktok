import 'package:flutter_tiktok/mock/video.dart';
import 'package:flutter_tiktok/other/pageView.dart';
import 'package:flutter_tiktok/pages/cameraPage.dart';
import 'package:flutter_tiktok/pages/followPage.dart';
import 'package:flutter_tiktok/pages/folderPage.dart';
import 'package:flutter_tiktok/pages/searchPage.dart';
import 'package:flutter_tiktok/pages/userPage.dart';
import 'package:flutter_tiktok/views/tikTokCommentBottomSheet.dart';
import 'package:flutter_tiktok/views/tikTokHeader.dart';
import 'package:flutter_tiktok/views/tikTokScaffold.dart';
import 'package:flutter_tiktok/views/tikTokVideo.dart';
import 'package:flutter_tiktok/views/tikTokVideoButtonColumn.dart';
import 'package:flutter_tiktok/controller/tikTokVideoListController.dart';
import 'package:flutter_tiktok/views/tiktokTabBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safemap/safemap.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'msgPage.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';

/// 单独修改了bottomSheet组件的高度
import 'package:flutter_tiktok/other/bottomSheet.dart' as CustomBottomSheet;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  TikTokPageTag tabBarType = TikTokPageTag.home;

  TikTokScaffoldController tkController = TikTokScaffoldController();

  TikTokPageController _pageController = TikTokPageController();

  TikTokVideoListController _videoListController = TikTokVideoListController();

  /// 记录点赞
  Map<int, bool> favoriteMap = {};

  List<UserVideo> videoDataList = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _videoListController.currentPlayer.pause();
    super.dispose();
  }
  getVideos()async{
    var list = await UserVideo.fetchVideo2(context);
    videoDataList =list.length>0?list:UserVideo.fetchVideo();

    WidgetsBinding.instance!.addObserver(this);
    _videoListController.init(
    pageController: _pageController,
    initialList: videoDataList
        .map(
    (e) => VPVideoController(
    videoInfo: e,
//    '/storage/emulated/0/Download/test-video-7.MP4'
    builder: () => e.url.contains('http')? VideoPlayerController.network(e.url):VideoPlayerController.file(new File(e.url)),
    ),
    )
        .toList(),
    videoProvider: (int index, List<VPVideoController> list) async {
    return videoDataList
        .map(
    (e) => VPVideoController(
    videoInfo: e,
    builder: () => e.url.contains('http')? VideoPlayerController.network(e.url):VideoPlayerController.file(new File(e.url)),
    ),
    )
        .toList();
    },
    );
  }
  @override
  void initState() {
    getVideos();

    _videoListController.addListener(() {
      setState(() {});
    });
    tkController.addListener(
          () {
        if (tkController.value == TikTokPagePositon.middle) {
          _videoListController.currentPlayer.play();
        } else {
          _videoListController.currentPlayer.pause();
        }
      },
    );

    super.initState();

    //初始化
        () async{
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterDownloader.initialize(
          debug: true // optional: set false to disable printing logs to console
      );
      //监听回调
      FlutterDownloader.registerCallback(downloadCallback);
    }();
    }
  //下载回调方法
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    print("id:" + id);
    print("status:" + status.toString());
    print("progress:" + progress.toString());
  }
  @override
  Widget build(BuildContext context) {
    Widget? currentPage;

    switch (tabBarType) {
      case TikTokPageTag.home:
        break;
      case TikTokPageTag.follow:
        currentPage = FollowPage();
        break;
      case TikTokPageTag.folder:
        currentPage = FolderPage('');
        break;
      case TikTokPageTag.msg:
        currentPage = MsgPage();
        break;
      case TikTokPageTag.me:
        currentPage = UserPage(isSelfPage: true);
        break;
    }
    double a = MediaQuery.of(context).size.aspectRatio;
    bool hasBottomPadding = a < 0.55;

    bool hasBackground = hasBottomPadding;
    hasBackground = tabBarType != TikTokPageTag.home;
    if (hasBottomPadding) {
      hasBackground = true;
    }
    Widget tikTokTabBar = TikTokTabBar(
      hasBackground: hasBackground,
      current: tabBarType,
      onTabSwitch: (type) async {
        setState(() {
          tabBarType = type;
          if (type == TikTokPageTag.home) {
            _videoListController.currentPlayer.play();
          } else {
            _videoListController.currentPlayer.pause();
          }
        });
      },
      onAddButton: () {
        _videoListController.currentPlayer.pause();
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CameraPage(),
          ),
        );
      },
    );

    var userPage = UserPage(
      isSelfPage: false,
      canPop: true,
      onPop: () {
        tkController.animateToMiddle();
      },
    );
    var searchPage = SearchPage(
      onPop: tkController.animateToMiddle,
    );

    var header = tabBarType == TikTokPageTag.home
        ? TikTokHeader(
      onSearch: () {
        tkController.animateToLeft();
      },
    )
        : Container();

    // 组合
    return TikTokScaffold(
      controller: tkController,
      hasBottomPadding: hasBackground,
      tabBar: tikTokTabBar,
      header: header,
      leftPage: searchPage,
      rightPage: userPage,
      enableGesture: tabBarType == TikTokPageTag.home,
      // onPullDownRefresh: _fetchData,
      page: Stack(
        // index: currentPage == null ? 0 : 1,
        children: <Widget>[
          TikTokPageView.builder(
            key: Key('home'),
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _videoListController.videoCount,
            itemBuilder: (context, i) {
              // 拼一个视频组件出来
              bool isF = SafeMap(favoriteMap)[i].boolean ?? false;
              var player = _videoListController.playerOfIndex(i)!;
              var data = player.videoInfo!;
              // 右侧按钮列
              Widget buttons = TikTokButtonColumn(
              isFavorite: isF,
              onAvatar: () {
              tkController.animateToPage(TikTokPagePositon.right);
              },
              onFavorite: () {
              setState(() {
              favoriteMap[i] = !isF;
              });
              // showAboutDialog(context: context);
              },
              onComment: () {
              CustomBottomSheet.showModalBottomSheet(
              backgroundColor: Colors.white.withOpacity(0),
              context: context,
              builder: (BuildContext context) =>
              TikTokCommentBottomSheet(),
              );
              },
              onShare: () {},
              );
              // video
              Widget currentVideo = Center(
              child: videoDataList[i].image!=''?
              videoDataList[i].image.contains('http')?
              CachedNetworkImage(
              imageUrl: videoDataList[i].image,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress,color:Colors.orange),
              errorWidget: (context, url, error) => Icon(Icons.error,color:Colors.orange),
              ):
              Image.file(new File(videoDataList[i].image)):
              AspectRatio(
              aspectRatio: player.controller.value.aspectRatio,
              child: VideoPlayer(player.controller),
              ),
              );

              currentVideo = TikTokVideoPage(
              // 手势播放与自然播放都会产生暂停按钮状态变化，待处理
              hidePauseIcon: !player.showPauseIcon.value,
              aspectRatio: 9 / 16.0,
              key: Key(data.url + '$i'),
              tag: data.url,
              bottomPadding: hasBottomPadding ? 16.0 : 16.0,
              userInfoWidget: VideoUserInfo(
              desc: data.desc,
              bottomPadding: hasBottomPadding ? 16.0 : 50.0,
              ),
              onSingleTap: () async {
              print('开始播放');
              if (player.controller.value.isPlaying) {
              await player.pause();
              } else {
              await player.play();
              }
              setState(() {});
              },
              onAddFavorite: () {
              setState(() {
              favoriteMap[i] = true;
              });
              },
              rightButtonColumn: buttons,
              video: currentVideo,
              );
              return currentVideo;
            },
          ),
          currentPage ?? Container(),
        ],
      ),
    );
  }
}
