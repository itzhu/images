/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'package:flutter/material.dart';
import 'package:images/pages/views/buttons.dart';
import '../apis/jsons.dart' as img;
import '../app.dart';
import 'views/SimpleNetworkImageBuilder.dart';

///create by itz on 2022/11/16 13:41
///desc :
class ImageInfoDialog extends StatelessWidget {
  const ImageInfoDialog({Key? key, required this.imageInfo}) : super(key: key);
  final img.ImageInfo imageInfo;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SimpleNetworkImageBuilder(
            name: imageInfo.getDType(),
            dirPath: App.getConfigData().imageDownloadPath,
            url: imageInfo.getDownloadUrl(),
            builder: (img) {
              return SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: InteractiveViewer(
                  maxScale: 3,
                  minScale: 0.01,
                  scaleEnabled: true,
                  child: Image.file(img, fit: BoxFit.scaleDown),
                ),
              );
            },
            placeHolder: const LinearProgressIndicator(
              backgroundColor: Colors.white54,
              color: Colors.white12,
            ),
          ),
        ),
        Column(
          children: [
            Row(children: [
              const Spacer(),
              StyleButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  // style: ButtonStyle(
                  //   padding:MaterialStateProperty.all(const EdgeInsets.all(12)) ,
                  //     elevation: MaterialStateProperty.all(0),
                  //     backgroundColor: MaterialStateProperty.all(Colors.black),
                  //     shape: MaterialStateProperty.all(const CircleBorder())),
                  child: const Icon(Icons.close))
            ]),
          ],
        ),
      ],
    );
  }

  void _downloadClick() {}
}
