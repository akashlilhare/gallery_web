import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gallery_web/enum/app_connection_status.dart';
import 'package:provider/provider.dart';
import '../model/image_model.dart';
import '../provider/gallery_provider.dart';
import 'image_detail_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var provdier = Provider.of<GalleryProvider>(context, listen: false);
      provdier.loadGallery();
      _scrollController.addListener(_scrollListener);
    });
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      var provdier = Provider.of<GalleryProvider>(context, listen: false);
      provdier.onPageChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    buildCard({required Hits hits}) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        child: MouseRegion(
          onEnter: (event) {
            setState(() {
              hits.isHover = true;
            });
          },
          onExit: (event) {
            setState(() {
              hits.isHover = false;
            });
          },
          child: Column(
            children: [
              Expanded(
                child: Hero(
                  tag: hits.webformatURL,
                  child: Image.network(
                    hits.webformatURL,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                color: hits.isHover
                    ? Colors.blue.shade700
                    : Colors.blue.withOpacity(.2),
                child: Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye_outlined,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      hits.views.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      hits.likes.toString(),
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Consumer<GalleryProvider>(builder: (context, galleryProvider, _) {
        if (galleryProvider.galleryModel == null) {
          return Text("no data");
        }
        if (galleryProvider.connectionStatus == AppConnectionStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          // bottomNavigationBar: galleryProvider.pageConnectionStatus ==
          //         AppConnectionStatus.loading
          //     ? CircularProgressIndicator()
          //     : Container(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * .02, bottom: size.height * 0.03),
                  child: Row(
                    children: [
                      if (size.width > 600)
                        Text("Gallery",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w600)),
                      if (size.width > 600) Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(.1),
                            borderRadius: BorderRadius.circular(18)),
                        width: 280,
                        child: Row(
                          children: [
                            Icon(Icons.search),
                            SizedBox(width: 12,),
                            Expanded(
                              child: TextField(
                                onChanged: (val) {
                                  if (val.length > 3) {
                                    galleryProvider.onSearch();
                                  }
                                },
                                controller: galleryProvider.searchController,
                                decoration: InputDecoration(
                                    hintText: "Search photos",
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.width ~/ 350,
                      crossAxisSpacing: size.width * 0.02,
                      mainAxisSpacing: size.width * 0.02,
                    ),
                    itemCount: galleryProvider.galleryModel!.hits.length,
                    itemBuilder: (context, index) {
                      List<Hits> hits = galleryProvider.galleryModel!.hits;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageDetailPage(
                                      hits: hits[index],
                                    )),
                          );
                        },
                        child: buildCard(hits: hits[index]),
                      );
                    },
                    physics: AlwaysScrollableScrollPhysics(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
