import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kids_drawing_app/Presentation/camera_overlay_screen.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  /*
  final List<String> imageUrls= [
    'https://i.pinimg.com/736x/74/96/8c/74968c5fda6efc47c25f1d7b37a3e5e9.jpg',
    'https://easydrawingguides.com/wp-content/uploads/2024/07/how-to-draw-a-fox-outline-for-kids-featured-image-1200.png',
    'https://img.freepik.com/premium-vector/line-art-drawing-kids-coloring-page_29937-8821.jpg?w=360',
    'https://img.freepik.com/premium-vector/line-art-drawing-kids-coloring-page_29937-8830.jpg?w=360',
    'https://img.freepik.com/premium-vector/line-art-drawing-kids-coloring-page_29937-8827.jpg',
    'https://previews.123rf.com/images/yusufdemirci/yusufdemirci2104/yusufdemirci210400015/167335154-line-art-drawing-for-kids-coloring-page.jpg',
    'https://static.vecteezy.com/system/resources/previews/002/407/192/non_2x/line-art-drawing-for-kids-coloring-page-vector.jpg',
    'https://static.vecteezy.com/system/resources/previews/002/407/199/non_2x/line-art-drawing-for-kids-coloring-page-vector.jpg',
    'https://www.splashlearn.com/blog/wp-content/uploads/2023/09/foiled-scribble-flowers-1024x1024.jpeg',
    'https://i.pinimg.com/736x/6e/8f/f6/6e8ff6bf13cb4615ed8b87d0f412bf25.jpg',

  ];
  */

  XFile? _selectedImage;

  /*
  bool _isWakelockEnabled= false;

  @override
  void initState(){
    super.initState();

    _enableWakelock();
  }
  
  void _enableWakelock(){
    setState(() {
      _isWakelockEnabled= true;
    });
    Wakelock.enable();
  }

  void _disableWakelock(){
    setState(() {
      _isWakelockEnabled= false;
    });
    Wakelock.disable();
  }
  */

  Future<void> pickImage() async{
    final XFile? pickedFile= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile!= null){
      setState(() {
        _selectedImage= pickedFile;
      });
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_)=> CameraOverlayScreen(imageUrl: '', selectedImage: _selectedImage,)
        )
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kidzee Drawing App', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index){
            final path= 'assets/image${index+1}.jpg';          
          
            return GestureDetector(
              onTap: (){
                //print('Image tapped');
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => CameraOverlayScreen(imageUrl: path)),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(path, fit: BoxFit.cover,),
              ),
            );
          }
        ),
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