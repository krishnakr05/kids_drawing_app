import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraOverlayScreen extends StatefulWidget {
  final String imageUrl;
  final XFile? selectedImage;
  
  const CameraOverlayScreen({super.key, required this.imageUrl, this.selectedImage});

  @override
  State<CameraOverlayScreen> createState() => _CameraOverlayScreenState();
}

class _CameraOverlayScreenState extends State<CameraOverlayScreen> {
  CameraController? controller;
  double opacity = 0.3;
  double scale = 1.0;
  XFile? selectedImage;
  
  @override
  void initState(){
    super.initState();
    initializeCamera();
  }
  

  Future<void> initializeCamera() async{
    var status = await Permission.camera.request();
    if (!status.isGranted) {
    // You can show a dialog here if needed
    return;
  }
    final cameras= await availableCameras();
    final frontCamera=cameras.first;

    controller= CameraController(frontCamera, ResolutionPreset.medium);
    await controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> pickImage() async{
    final XFile? pickedFile= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile!= null){
      setState(() {
        selectedImage= pickedFile;
      });
      
    }
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(controller == null || !controller!.value.isInitialized){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Draw and have fun!', style: TextStyle(color: Colors.white), ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.info_outline, color: Colors.white,))
        ],
        
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CameraPreview(controller!),
                Center(
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: scale,
                      child: selectedImage != null
                          ? Image.file(File(selectedImage!.path))
                          : (widget.selectedImage != null
                              ? Image.file(File(widget.selectedImage!.path))
                              : Image.asset(widget.imageUrl)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            //color: Colors.black.withOpacity(0.4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Opacity', ),
                Slider(
                  value: opacity,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    setState(() {
                      opacity = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                const Text('Size', ),
                Slider(
                  value: scale,
                  min: 0.5,
                  max: 2.0,
                  onChanged: (value) {
                    setState(() {
                      scale = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          pickImage();
        },
        child: const Icon(Icons.image),
      ),
    );
  }
}

/*
Column(
        children: [
          Stack(
            children: [
              CameraPreview(controller!),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: scale,
                      child: selectedImage!=null
                      ? Image.file(File(selectedImage!.path))
                      : (widget.selectedImage!=null
                        ? Image.file(File(widget.selectedImage!.path))
                        :Image.asset(widget.imageUrl)),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Opacity', ),
                      Slider(
                        value: opacity, 
                        min: 0.0,
                        max: 1.0,
                        onChanged: (value){
                          setState(() {
                            opacity= value;
                          });
                        }
                      ),
                      const SizedBox(height: 8,),
                      const Text('Size', ),
                      Slider(
                        value: scale, 
                        min: 0.5,
                        max: 2.0,
                        onChanged: (value){
                          setState(() {
                            scale= value;
                          });
                        }
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ],
      ),
      */