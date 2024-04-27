import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gallery_web/constants/app_connstants.dart';
import 'package:gallery_web/enum/app_connection_status.dart';
import 'package:http/http.dart' as http;

import '../model/image_model.dart';

class GalleryProvider with ChangeNotifier {
  int currPage = 1;
  AppConnectionStatus connectionStatus = AppConnectionStatus.none;
  AppConnectionStatus newPageConnectionStatus = AppConnectionStatus.none;
  GalleryModel? galleryModel;
  TextEditingController searchController = TextEditingController();

  loadGallery() async {
    try {
      connectionStatus = AppConnectionStatus.loading;
      notifyListeners();
      final String url = 'https://pixabay.com/api/'
          '?key=${AppConstants.apiKey}'
          '&per_page=20'
          '&page=1';

      print(url);

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        galleryModel = GalleryModel.fromJson(json.decode(response.body));
        connectionStatus = AppConnectionStatus.success;
        notifyListeners();
      }
    } catch (e) {
      connectionStatus = AppConnectionStatus.error;
      notifyListeners();
    }
  }

  onSearch() async {
    currPage = 1;
    try {
      connectionStatus = AppConnectionStatus.loading;
      notifyListeners();
      final String url = 'https://pixabay.com/api/'
          '?key=${AppConstants.apiKey}'
          '&q=${searchController.text}'
          '&per_page=20'
          '&page=1';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        galleryModel = GalleryModel.fromJson(json.decode(response.body));
        connectionStatus = AppConnectionStatus.success;
      }
    } catch (e) {
      connectionStatus = AppConnectionStatus.error;
    } finally {
      notifyListeners();
    }
  }

  onPageChange() async {
    try {
      currPage++;
      newPageConnectionStatus = AppConnectionStatus.loading;
      notifyListeners();
      final String url = 'https://pixabay.com/api/'
          '?key=${AppConstants.apiKey}'
          '&q=${searchController.text}'
          '&per_page=20'
          '&page=$currPage';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        galleryModel!.hits
            .addAll(GalleryModel.fromJson(json.decode(response.body)).hits);
        newPageConnectionStatus = AppConnectionStatus.success;
      }
    } catch (e) {
      newPageConnectionStatus = AppConnectionStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
