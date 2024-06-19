import 'dart:io';

import 'package:dark_view/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:http/http.dart' as http;

class Details extends StatefulWidget {
  String imgUrl;
  Details(this.imgUrl);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  setWallpaperHomeScreen(url) async {
    try {
      int location = WallpaperManager.HOME_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      await WallpaperManager.setWallpaperFromFile(file.path, location);
      Fluttertoast.showToast(msg: 'set successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed');
    }
  }

  setWallpaperLockScreen(url) async {
    try {
      int location = WallpaperManager.LOCK_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      await WallpaperManager.setWallpaperFromFile(file.path, location);
      Fluttertoast.showToast(msg: 'set successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed');
    }
  }

Future<void> _requestPermission() async {
  if (await Permission.storage.request().isGranted) {
    // Permission is granted, proceed with download
  } else {
    // Handle the case where permission is denied
  }
}


 Future<void> _downloadImage(String url, String fileName) async {
    try {
      // Request permission
      await _requestPermission();

      // Fetch the image from the URL
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Get the external storage directory path
        final directory = await getApplicationDocumentsDirectory();
        print("directory path ${directory?.path}");
        final path = Directory('${directory?.path}/Dark View');
        
        // Create the directory if it doesn't exist
        if (!await path.exists()) {
          await path.create(recursive: true);
        }

        // Save the image file
        final filePath = '${path.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('Image saved to $filePath');
      } else {
        print('Failed to download image');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  shareImage(url) {
    Share.share(
      url,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.imgUrl);
    return Scaffold(
      floatingActionButton: SpeedDial(
        labelsBackgroundColor: AppColors.vividYellow,
        labelsStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        speedDialChildren: [
          //Set Homescreen
          SpeedDialChild(
            child: const Icon(
              Icons.wallpaper,
              size: 18,
            ),
            label: 'Set Homescreen',
            onPressed: () => setWallpaperHomeScreen(widget.imgUrl),
          ),
          //Set Lockscreen
          SpeedDialChild(
            child: const Icon(
              Icons.lock,
              size: 18,
            ),
            label: 'Set Lockscreen',
            onPressed: () => setWallpaperLockScreen(widget.imgUrl),
          ),
          //Download
          SpeedDialChild(
            child: const Icon(
              Icons.cloud_download,
              size: 18,
            ),
            label: 'Download',
            onPressed: () => _downloadImage(widget.imgUrl, 'dark-view_wallpaper_${DateTime.now().microsecondsSinceEpoch}'),
          ),
          //Share
          SpeedDialChild(
            child: const Icon(
              Icons.share,
              size: 18,
            ),
            label: 'Share',
            onPressed: () => shareImage(widget.imgUrl),
          ),
        ],
        child: const Icon(
          Icons.add_circle_outline_outlined,
        ),
      ),
      body: Hero(
        tag: widget.imgUrl,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.imgUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}