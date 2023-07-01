import 'dart:convert';
import 'dart:io';
import 'package:clothis/admin/admin_login.dart';
import 'package:clothis/api/api_connect.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


    class AdminUploadItemsScreen extends StatefulWidget {
       const AdminUploadItemsScreen({Key? key}) : super(key: key);
      //
      @override
      State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
    }

    class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {

      final ImagePicker _picker = ImagePicker();
      File? pickedImageXFile;

      var formKey = GlobalKey<FormState>();

      var nameController = TextEditingController();
      var colorController = TextEditingController();
      var ratingController = TextEditingController();
      var tagsController = TextEditingController();
      var priceController = TextEditingController();
      var sizeController = TextEditingController();
      var descriptionController = TextEditingController();


      // //default screen method here
      // caputureImageWithPhoneCamera() async {
      //   final pickedImage = await _picker.pickImage(source: ImageSource.camera);
      //   if (pickedImage != null) {
      //     pickedImageXFile = File(pickedImage.path);
      //     Get.back();
      //     setState(() {});
      //   }
      // }

      Future pickImageFromPhoneGallery()async{
        final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          pickedImageXFile = File(pickedImage.path);
          Get.back();
          setState(() {});
        }
      }

      showDialogBoxForImagePick(){

        return showDialog(
            context: context,
            builder: (context){
              return SimpleDialog(
                backgroundColor: Colors.black,
                title: const Text(
                  "Item Image",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  // SimpleDialogOption(
                  //   onPressed: (){
                  //     caputureImageWithPhoneCamera();
                  //   },
                  //   child: const Text(
                  //     "Capture with Phone Camera",
                  //     style: TextStyle(
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  // ),
                  SimpleDialogOption(
                    onPressed: (){
                      pickImageFromPhoneGallery();
                    },
                    child: const Text(
                      "Pick image from Phone Gallery",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: (){
                      Get.back();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              );
            });
      }

      Widget defaultScreen(){
      return Scaffold(
        appBar: AppBar(

          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black54,
                  Colors.deepPurple
                ],
              ),
            ),


          ),
          automaticallyImplyLeading: false,
          title: Text(
            "Welcome Admin",
          ),
          centerTitle: true,

        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.deepPurple
              ],
            ),
          ),
          child:  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Icon(
                  Icons.add_photo_alternate,
                  color: Colors.white54,
                  size: 200,
                ),

                // button input
                Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: (){
                      showDialogBoxForImagePick();

                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 28,
                      ),
                      child: Text(
                        "Add New Item",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    // uploaditemsForm Screen method
    Widget uploadItemFormScreen(){
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black54,
                    Colors.deepPurple
                  ],
                ),
              ),

            ),
            automaticallyImplyLeading: false,
            title: const Text(
              "Upload Form"
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.clear
              ),
              onPressed: () {
                setState(() {
                  pickedImageXFile =null;
                  nameController.clear();
                  priceController.clear();
                  tagsController.clear();
                  colorController.clear();
                  sizeController.clear();
                  descriptionController.clear();
                  ratingController.clear();

                });
                Get.to(AdminUploadItemsScreen());
                //Get.to(defaultScreen());
              },
            ),
            actions: [
              TextButton(
                  onPressed: (){

                    Fluttertoast.showToast( msg: "Uploading items....");

                    if(formKey.currentState!.validate()) {
                      Fluttertoast.showToast(msg: "Uploading items....");

                      uploadItemImage(pickedImageXFile);
                    }

                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.green
                    ),
                  ),

              )
            ],
          ),

          body: ListView(
            children: [

              //image
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(
                      File(pickedImageXFile!.path),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              //upload item form
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.all(
                        Radius.circular(60),
                      ),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, -3)),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30,30,30,8),
                      child: Column(
                        children: [

                          //this is our form with email password details
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                //items name
                                TextFormField(
                                  controller: nameController,
                                  validator: (val) => val == ""
                                      ? "Items title here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.title,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items name ...",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),

                                const SizedBox(height: 18,),


                              //items rating
                                TextFormField(
                                  controller: ratingController,
                                  validator: (val) => val == ""
                                      ? "Items rating here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.rate_review,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items rating ...",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),

                                const SizedBox(height: 18,),

                                //items tags

                                TextFormField(
                                  controller: tagsController,
                                  validator: (val) => val == ""
                                      ? "Items tags here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.tag_sharp,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items tags ...",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),

                                const SizedBox(height: 18,),

                                //items price

                                TextFormField(
                                  controller: priceController,
                                  validator: (val) => val == ""
                                      ? "Items price here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.money,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items price ...",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),

                                const SizedBox(height: 18,),

                                //items size
                                TextFormField(
                                  controller: sizeController,
                                  validator: (val) => val == ""
                                      ? "Items size here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.picture_in_picture,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items size ...",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),

                                const SizedBox(height: 18,),

                                //items color
                                TextFormField(
                                  controller: colorController,
                                  validator: (val) => val == ""
                                      ? "Items color here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.color_lens,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items color ...",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),

                                const SizedBox(height: 18,),

                                //items description
                                TextFormField(
                                  controller: descriptionController,
                                  validator: (val) => val == ""
                                      ? "Items description here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.description,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items description ...",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),

                                const SizedBox(height: 18,),

                                // button input
                                Material(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: (){

                                      if(formKey.currentState!.validate()){

                                        Fluttertoast.showToast( msg: "Uploading items....");

                                        uploadItemImage( pickedImageXFile);
                                      }

                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 28,
                                      ),
                                      child: Text(
                                        "Upload now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                        ],
                      ),
                    )),
              ),
            ],
          ),
        );
    }

      Future uploadItemImage(File? imageFile) async {
        List<String> tagList = tagsController.text.split(',');
        List<String> sizeList = sizeController.text.split(',');
        List<String> colorList = colorController.text.split(',');
        var uri = Uri.parse(API.uploadItems);
        var request = http.MultipartRequest("POST", uri);
        request.fields['name'] = nameController.text;
        request.fields['rating'] = ratingController.text;
        request.fields['tags'] = tagList.toString();
        request.fields['price'] = priceController.text;
        request.fields['sizes'] = sizeList.toString();
        request.fields['colors'] = colorList.toString();
        request.fields['description'] = descriptionController.text;
        var pic = await http.MultipartFile.fromPath('image', imageFile!.path);
        request.files.add(pic);

        var response = await request.send();
        if (response.statusCode == 200) {
          print("image uploaded");
        } else {
          print("upload failed");
        }
        nameController.text = "";
        ratingController.text = "";
        priceController.text = "";
        descriptionController.text = "";
      }

 @override
      Widget build(BuildContext context) {

        return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen() ;
      }
    }
