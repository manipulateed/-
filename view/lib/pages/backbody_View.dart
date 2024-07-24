import 'package:flutter/material.dart';

class BackbodyView extends StatefulWidget {
  const BackbodyView({super.key});

  @override
  State<BackbodyView> createState() => _BackbodyViewState();
}

class _BackbodyViewState extends State<BackbodyView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 540,
        width: 400,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 10,
              left: 200,
              child: Image.asset(
                height: 498,
                width: 170,
                'assets/body_border.png', // 確保圖片資源的路徑正確
                fit: BoxFit.cover, // 根據需要調整
              ),
            ),
            Positioned(
              top: 63.5,
              right: 180,
              child: Image.asset(
                height: 489,
                width: 178,
                'assets/back.png', // 確保圖片資源的路徑正確
                fit: BoxFit.cover, // 根據需要調整
              ),
            ),
            Positioned(
              left: 56, // Adjust according to your image
              top: 147,   // Adjust according to your image
              width: 45.6, // Adjust according to your imag8
              height: 102.3, // Adjust according to your image
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailScreen(painArea: 'Neck'),
                  //   ),
                  // );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/左肩肩膀.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 158.5, // Adjust according to your image
              top: 148.8,   // Adjust according to your image
              width: 45, // Adjust according to your imag8
              height: 103.5, // Adjust according to your image
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailScreen(painArea: 'Neck'),
                  //   ),
                  // );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/右肩背面.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 81, // Adjust according to your image
              top: 172,   // Adjust according to your image
              width: 95.62, // Adjust according to your imag8
              height:  99.01, // Adjust according to your image
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailScreen(painArea: 'Neck'),
                  //   ),
                  // );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/背肌.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 85.3, // Adjust according to your image
              top: 145.5,   // Adjust according to your image
              width: 88.42, // Adjust according to your imag8
              height:  75.66,// Adjust according to your image
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailScreen(painArea: 'Neck'),
                  //   ),
                  // );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/頸部背面.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 81, // Adjust according to your image
              top: 267.5,   // Adjust according to your image
              width: 98.47, // Adjust according to your imag8
              height:  60.2, // Adjust according to your image
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailScreen(painArea: 'Neck'),
                  //   ),
                  // );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/臀部背面.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 88, // Adjust according to your image
              top: 330,   // Adjust according to your image
              width: 34.65, // Adjust according to your imag8
              height:  77, // Adjust according to your image
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailScreen(painArea: 'Neck'),
                  //   ),
                  // );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/左腿背面.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 138, // Adjust according to your image
              top: 330,   // Adjust according to your image
              width: 34.65, // Adjust according to your imag8
              height:  77, // Adjust according to your image
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailScreen(painArea: 'Neck'),
                  //   ),
                  // );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/右腿背面.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 144.5, // Adjust according to your image
              top: 415,   // Adjust according to your image
              width: 31.5, // Adjust according to your imag8
              height:  73.5, // Adjust according to your image
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailScreen(painArea: 'Neck'),
                  //   ),
                  // );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/右小腿背面.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 85.8, // Adjust according to your image
              top: 415,   // Adjust according to your image
              width: 29.9, // Adjust according to your imag8
              height:  75.95, // Adjust according to your image
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailScreen(painArea: 'Neck'),
                  //   ),
                  // );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/左小腿背面.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            // Add more Positioned widgets for other pain areas
            // Continue adding Positioned widgets for other areas...
          ],
        ),
      ),
    );
  }
}
