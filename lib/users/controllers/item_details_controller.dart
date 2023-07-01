import 'package:get/get.dart';

class ItemDetailsController extends GetxController{
   final RxInt _itemQuanty = 1.obs;
   final RxInt _itemSize = 0.obs;
   final RxInt _itemColor = 0.obs;
   final RxBool _isFavorite = false.obs;

  int get quantity => _itemQuanty.value;
  int get size => _itemSize.value;
  int get color => _itemColor.value;
  bool get isFavorite => _isFavorite.value;

  setQuantity(int quantityOfItem){
    _itemQuanty.value = quantityOfItem;
  }

  setSize(int sizeOfItem){
    _itemSize.value = sizeOfItem;
  }

  setColor(int colorOfItem){
    _itemColor.value = colorOfItem;
  }

  setFavorite(bool favouriteOfItem){
    _isFavorite.value = favouriteOfItem;
  }
}