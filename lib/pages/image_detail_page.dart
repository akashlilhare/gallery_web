import 'package:flutter/material.dart';
import 'package:gallery_web/model/image_model.dart';

class ImageDetailPage extends StatelessWidget {
  final Hits hits;

  const ImageDetailPage({super.key, required this.hits});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.1, vertical: size.height * 0.1),
        child: Column(
          children: [

            Container(padding:EdgeInsets.all(8),decoration: BoxDecoration(
              color: Colors.white,
                
                shape: BoxShape.circle),
            child: CloseButton(color: Colors.black,),),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Hero(
                    tag: hits.webformatURL,
                    child: Image.network(
                      hits.webformatURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(hits.isHover ? 18 : 0))),
              ),
            ),
            SizedBox(height: 18,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children:
                    hits.tags.split(",").map((tag) => Container(
                      padding: EdgeInsets.symmetric(vertical: 18,horizontal: 18),
                      margin: EdgeInsets.only(right: 18),
                      
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),color: Colors.blue.withOpacity(.05)),
                      child: Text(tag,style: TextStyle(color: Colors.white,fontSize: 16),),
                    )).toList())
          ],
        ),
      ),
    );
  }
}
