import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/data_management/stamp_manager.dart';
import 'package:nichinichi/global_widgets/stamp_view.dart';
import 'package:nichinichi/utils/error_management.dart';


class StampSettingView extends StatefulWidget {

  final CompletionLevel level;
  final OverlayManager manager;

  const StampSettingView({ super.key, required this.level, required this.manager });

  @override
  State<StampSettingView> createState() => _StampSettingViewState();
}

class _StampSettingViewState extends State<StampSettingView> with ErrorMixin {

  late Future<Image?> _currentImage;

  Future<Image?> getImage(String path) async {
    File? file = await StampManager.updateStampImage(widget.level, File(path));
    imageCache.clear();
    imageCache.clearLiveImages();
    return file != null
      ? Image.file(
        file,
        key: UniqueKey(),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity
      ) : null;
  }

  void _selectNewImage() {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'images',
        extensions: <String>['jpg', 'png'],
      );
      openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]).then(
        (file) {
          if (file != null) { setState((){ _currentImage = getImage(file.path); }); }
        }
      );
    } catch (e) { showError(widget.manager, ErrorType.other); }
  }

  @override
  void initState() {
    _currentImage = StampManager.getStampImage(widget.level);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    imageCache.clearLiveImages();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 0.85,
            child: FutureBuilder<Image?>(
              future: _currentImage,
              builder: (BuildContext context, AsyncSnapshot<Image?> snapshot) {
                if (snapshot.hasData) {
                  return StampView(
                    level: widget.level,
                    image: snapshot.data ?? StampManager.getDefaultStampImage(widget.level)
                  );
                } else { return Container(); }
              },
            )
          ),
          const SizedBox(height: 10),
          Text(
            Constants.levelToString(widget.level).toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 2),
          Text(
            Constants.getLevelPercentageString(widget.level).toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _selectNewImage,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.white54,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  "NEW",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white54
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
