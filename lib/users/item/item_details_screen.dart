import 'dart:convert';
import 'package:clothis/users/cart/cart_list_screen.dart';
import 'package:clothis/users/model/Clothes.dart';
import 'package:clothis/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../api/api_connect.dart';

import '../controllers/item_details_controller.dart';

class ItemDetailsScreen extends StatefulWidget {

  final Clothes? itemInfo;

  const ItemDetailsScreen({this.itemInfo,});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  
  final itemDetailsController = Get.put(ItemDetailsController());
  final currentOnlineUser = Get.put(CurrentUser());


  addToCard() async{

    try{
      var res =  await http.post(
         Uri.parse(API.addToCard),
         body: {
           'user_id' : currentOnlineUser.user.user_id.toString(),
           'item_id' : widget.itemInfo!.item_id.toString(),
           'size' : widget.itemInfo!.sizes![itemDetailsController.size],
           'color' : widget.itemInfo!.colors![itemDetailsController.color],
           'quantity' : itemDetailsController.quantity.toString() ,
         }
       );

       if(res.statusCode == 200) {
         var result = jsonDecode(res.body);

         if (result['success'] == true) {
           Fluttertoast.showToast(msg: result['message']);
         }else{
           Fluttertoast.showToast(msg: result['message']);
         }
       }
         }catch(e){
      print("Card: "+e.toString());
    }

  }

  validateFavoriteList() async{
    
    try{
      var res =  await http.post(
          Uri.parse(API.validateFavourite),
          body: {
            'user_id' : currentOnlineUser.user.user_id.toString(),
            'item_id' : widget.itemInfo!.item_id.toString(),
          }
      );

      if(res.statusCode == 200) {
        var result = jsonDecode(res.body);

        if (result['favouriteFound'] == true) {
        //  Fluttertoast.showToast(msg: "Items is in favourite list");

          itemDetailsController.setFavorite(result['favouriteFound']);
        }else{
         // Fluttertoast.showToast(msg: "Item is not in Favourite list");
          itemDetailsController.setFavorite(false);
        }
      }else{
        Fluttertoast.showToast(msg: "Status is not 200");
      }


    }catch(e){
      print(e.toString());
    }

  }


  addItemToFavoriteList() async{

    try{
      var res =  await http.post(
          Uri.parse(API.addFavourite),
          body: {
            'user_id' : currentOnlineUser.user.user_id.toString(),
            'item_id' : widget.itemInfo!.item_id.toString(),
          }
      );

      if(res.statusCode == 200) {
        var result = jsonDecode(res.body);

        if (result['success'] == true) {
          Fluttertoast.showToast(msg: "Favourite Items Save successfully");

          validateFavoriteList();
        }else{
          Fluttertoast.showToast(msg: "Item not save to Favourite list");
        }
      }else{
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }catch(e){
      print(e.toString());
    }

  }

  deleteItemFromFavoriteList() async{

    try{
      var res =  await http.post(
          Uri.parse(API.deleteFavourite),
          body: {
            'user_id' : currentOnlineUser.user.user_id.toString(),
            'item_id' : widget.itemInfo!.item_id.toString(),
          }
      );

      if(res.statusCode == 200) {
        var result = jsonDecode(res.body);

        if (result['success'] == true) {
          Fluttertoast.showToast(msg: "Favourite Items deleted successfully");

          validateFavoriteList();

        }else{
          Fluttertoast.showToast(msg: "Item not couldnt be deleted from list");
        }
      }else{
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }catch(e){
      print(e.toString());
    }

  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  validateFavoriteList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //items images
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage("images/place_holder.png"),
            image: NetworkImage(
              "${API.HOST_PATH}/items/image/dd/${widget.itemInfo!.image!}",
            ),
            imageErrorBuilder: (context,error,stackTraceError){
              return const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                ),
              );
            },
          ),

          //items infomation
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),

          // 3 buttons - favorite - shopping cart
          Positioned(
              top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              color:Colors.transparent,
              child: Row(
                children: [
                  IconButton(
                      onPressed: (){
                        Get.back();
                      },
                      icon: const Icon(
                          Icons.arrow_back,
                        color: Colors.purpleAccent,
                      ),

                  ),

                  const Spacer(),
                  //favorite

                  Obx(() => IconButton(
                      onPressed: (){

                        if(itemDetailsController.isFavorite){

                          //delete items from favorite list
                          deleteItemFromFavoriteList();

                        }else{

                          //save items to User favorites
                          addItemToFavoriteList();

                        }

                      },
                    icon: Icon(
                    itemDetailsController.isFavorite ?  Icons.bookmark   : Icons.bookmark_border_outlined,
                      color: Colors.purpleAccent,
                  ),
                  ),),
                  //shopping cart icon button
                  IconButton(
                    onPressed: (){
                      Get.to(CartListScreen());
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.purpleAccent,
                    ),

                  ),

                ],
              ),
            ),

          ),

        ],
      ),
    );
  }

  itemInfoWidget(){
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width:MediaQuery.of(Get.context!).size.height,
      decoration:const BoxDecoration(
        color: Colors.black,
        borderRadius:  BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
          offset: Offset(0, -3),
            blurRadius: 6,
            color: Colors.purpleAccent,
      ),
        ]
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18,),
            Center(
              child: Container(
                height: 8,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(30),

                ),
              ),
            ),
            const SizedBox(height: 30,),

            //name
            Text(
              widget.itemInfo!.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.purpleAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10,),

            // items counter
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //items rating + number of rating
                // tags
                // price
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //rating + raating num
                      Row(
                        children: [
                          //rating bar
                          RatingBar.builder(
                            initialRating: widget.itemInfo!.rating!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) =>
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (updatingRating){
                            },
                            ignoreGestures: true,
                            unratedColor: Colors.grey,
                            itemSize: 20,
                          ),

                          //rating number

                          SizedBox(width: 8,),
                          Text(
                            "("+ widget.itemInfo!.rating.toString()+")",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                            ),
                          ),

                        ],
                      ),

                      //tags
                      const SizedBox(height: 10,),

                      Text(
                        widget.itemInfo!.tags!.toString().replaceAll("[", "").replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16,),
                      //price
                      Text(
                        "₦"+widget.itemInfo!.price.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.purpleAccent,
                        ),
                      ),
                    ],
                    ),
                ),

                //items counter
                Obx(() =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // + button
                        IconButton(
                          onPressed: (){
                            itemDetailsController.setQuantity(itemDetailsController.quantity + 1);

                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,),
                        ),

                        Text(
                          itemDetailsController.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                          // - button

                        ),

                        IconButton(
                          onPressed: (){
                            if(itemDetailsController.quantity - 1 >= 1){
                              itemDetailsController.setQuantity(itemDetailsController.quantity - 1);
                            }else{
                              Fluttertoast.showToast(msg: "Quantity must be 1 or greater than 1");
                            }
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.white,),
                        ),
                      ],
                    ),
                ),

              ],
            ),

            //size of the items
            const Text("Size:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
              fontSize: 18,
            ),
            ),
            const SizedBox(height: 8,),
            Wrap(
            runSpacing: 8,
            spacing: 8,
            children: List.generate(widget.itemInfo!.sizes!.length, (index) {

              return Obx(() => GestureDetector(
                onTap: (){

                  itemDetailsController.setSize(index);

              },
                child: Container(
                  height: 35,
                    width: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: itemDetailsController.size == index
                          ? Colors.white
                          : Colors.grey,
                    ),
                    color: itemDetailsController.size == index
                      ? Colors.purpleAccent.withOpacity(0.4)
                        : Colors.black,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.itemInfo!.sizes![index].replaceAll("[", "").replaceAll("]", ""),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
              ),
              );
            }),
          ),
            const SizedBox(height: 10,),

            //color
            const Text("Colors:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10,),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.colors!.length, (index) {

                return Obx(() => GestureDetector(
                  onTap: (){
                    itemDetailsController.setColor(index);
                  },
                  child: Container(
                    height: 35,
                    width: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: itemDetailsController.color == index
                            ? Colors.white
                            : Colors.grey,
                      ),
                      color: itemDetailsController.color == index
                          ? Colors.yellow.withOpacity(0.4)
                          : Colors.black,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.itemInfo!.colors![index].replaceAll("[", "").replaceAll("]", ""),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                );
              }),
            ),

            const SizedBox(height: 8,),

            //description
            const Text("Description:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              widget.itemInfo!.description!,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 25,),
            Material(
              elevation: 4,
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: (){
                  addToCard();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
