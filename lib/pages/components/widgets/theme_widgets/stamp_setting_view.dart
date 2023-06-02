import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:io';
import 'package:nichinichi/data_management/stamp_manager.dart';
import 'package:nichinichi/global_widgets/stamp_view.dart';
import 'package:nichinichi/global_widgets/framed_button.dart';

class StampSettingView extends StatefulWidget {

  final CompletionLevel level;

  const StampSettingView({ super.key, required this.level });

  @override
  State<StampSettingView> createState() => _StampSettingViewState();
}

class _StampSettingViewState extends State<StampSettingView> {

  late Future<Image> _currentImage;

  void _selectNewImage() {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'images',
        extensions: <String>['jpg', 'png'],
      );
      openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]).then(
        (file) {
          if (file != null) {
            setState(() {
              _currentImage = StampManager.updateStampImage(
                widget.level, File(file.path)
              );
            });
          }
        }
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _currentImage = StampManager.getStampImage(widget.level);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            width: 100,
            child: AspectRatio(
              aspectRatio: 0.85,
              child: FutureBuilder<Image>(
                future: _currentImage,
                builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return StampView(level: widget.level, image: snapshot.data);
                    } else {
                      return StampView(level: widget.level, image: StampManager.getDefaultStampImage(widget.level));
                    }
                  } else {
                    return Text("load");
                  }
                },
              )
            ),
          ),
          const SizedBox(height: 10),
          Text(
            Constants.levelToString(widget.level).toUpperCase(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 2),
          Text(
            Constants.getLevelPercentageString(widget.level).toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.normal
            ),
          ),
          const SizedBox(height: 10),
          FramedButton(
            text: "UPLOAD NEW",
            onTap: () { _selectNewImage(); }
          )
        ],
      ),
    );
  }
}
