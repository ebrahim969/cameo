import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tigor_store/core/utils/app_images.dart';
import 'package:tigor_store/core/widgets/custom_text_feild.dart';

class AddDataToDatabase extends StatefulWidget {
  const AddDataToDatabase({super.key});

  @override
  State<AddDataToDatabase> createState() => _AddDataToDatabaseState();
}

class _AddDataToDatabaseState extends State<AddDataToDatabase> {
  GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              InkWell(
                  onTap: () async {
                    //! Step1 : picke image by image_picker
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (file == null) return;
                    String uniqeFileName =
                        DateTime.now().microsecondsSinceEpoch.toString();
                    //! Step2 : upload to firebase storage

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImage = referenceRoot.child('images');
                    Reference referenceImageToUpload =
                        referenceDirImage.child(uniqeFileName);

                    try {
                      await referenceImageToUpload.putFile(File(file.path));
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                      setState(() {
                        
                      });
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      child:imageUrl.isEmpty ?  Image.asset(
                        Assets.imagesNotimage,
                        fit: BoxFit.cover,
                      ): Image.network(imageUrl, fit: BoxFit.cover,))),
              CustomTextFormField(
                labelText: "category",
                controller: categoryController,
              ),
              // CustomTextFormField(
              //   labelText: "image",
              //   controller: imageController,
              // ),
              CustomTextFormField(
                labelText: "title",
                controller: titleController,
              ),
              CustomTextFormField(
                labelText: "desc",
                controller: descController,
              ),
              CustomTextFormField(
                labelText: "price",
                controller: priceController,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      Map<String, dynamic> saveData = {
                        'category': categoryController.text,
                        'image': imageUrl,
                        'title': titleController.text,
                        'desc': descController.text,
                        'price': int.parse(priceController.text)
                      };

                      FirebaseFirestore.instance
                          .collection("products")
                          .add(saveData);

                      categoryController.clear();
                      titleController.clear();
                      descController.clear();
                      priceController.clear();
                      imageUrl = '';
                      setState(() {});
                    }
                  },
                  child: const Text("Send Data"))
            ]),
          ),
        ),
      ),
    );
  }
}