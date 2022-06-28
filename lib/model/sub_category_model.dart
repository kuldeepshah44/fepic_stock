import 'package:flutter/cupertino.dart';
import 'package:fepic_stock/utility/api.dart';

class SubCategoryModel with ChangeNotifier {
  List<SubCategoryData> subCategoryList = [];
  List<SubCategoryData> mySubCategoryList = [];
  String version, iosURL, androidURL;

  void add(Map<String, dynamic> data) {
    subCategoryList.add(SubCategoryData.fromJson(data));
  }

  void setList(List<SubCategoryData> subList) {
    subCategoryList = subList;
  }

  List<SubCategoryData> getSubCategoryList() {
    return subCategoryList;
  }

  Future<Map> fatchSubCategory(context, param, loader) async {
    try {
      if (param['page'].toString() == "1") {
        subCategoryList.clear();
      }

      await Api().apiPostFormData(getCommon, param, context,loader).then((value){
        debugPrint("category======${value['subcategories']}");
        if(value['subcategories'].toString() != "null")
          {
            value['subcategories'].forEach((value1){
              add(value1);
            });
          }
      });

    } catch (error, trace) {
      debugPrint(trace.toString());
      notifyListeners();
      return null;
    }
  }
}

class SubCategoryData {
  String cid, title, slug, image, minmax, design, meta_data;

  SubCategoryData.fromJson(Map<String, dynamic> jsonData) {
    cid = jsonData['cid'].toString();
    title = jsonData['title'].toString();
    slug = jsonData['slug'].toString();
    image = jsonData['image'].toString();
    minmax = jsonData['minmax'].toString();
    design = jsonData['design'].toString();
    meta_data = jsonData['wh_meta_data'].toString();
  }
}
