import 'package:flutter/material.dart';

class FrontbodyView extends StatefulWidget {
  const FrontbodyView({super.key});

  @override
  State<FrontbodyView> createState() => _FrontbodyViewState();
}

class _FrontbodyViewState extends State<FrontbodyView> {
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
                right: 180,
                child: Image.asset(
                  height: 498,
                  width: 179,
                  'assets/back_border.png', // 確保圖片資源的路徑正確
                  fit: BoxFit.cover, // 根據需要調整
                ),
              ),
            Positioned(
                top: 30,
                left: 160,
                child: Image.asset(
                  height: 533,
                  width: 242,
                  'assets/body.png', // 確保圖片資源的路徑正確
                  fit: BoxFit.cover, // 根據需要調整
                ),
              ),
            Positioned(
                left: 187, // Adjust according to your image
                top: 227,   // Adjust according to your image
                width: 33, // Adjust according to your image
                height: 73.2, // Adjust according to your image
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
                        image: AssetImage('assets/右臂正面.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                left: 320, // Adjust according to your image
                top: 227,   // Adjust according to your image
                width: 33, // Adjust according to your image
                height: 73.2, // Adjust according to your image
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
                        image: AssetImage('assets/左臂正面.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                left: 298.2, // Adjust according to your image
                top: 147,   // Adjust according to your image
                width: 38.5, // Adjust according to your imag8
                height: 93, // Adjust according to your image
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
                        image: AssetImage('assets/左肩正面.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                left: 203.5, // Adjust according to your image
                top: 148,   // Adjust according to your image
                width: 31.2, // Adjust according to your imag8
                height: 93, // Adjust according to your image
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
                        image: AssetImage('assets/右肩正面.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                left: 217.5, // Adjust according to your image
                top: 285,   // Adjust according to your image
                width: 105.03, // Adjust according to your imag8
                height:  107.73, // Adjust according to your image
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
                        image: AssetImage('assets/大腿正面.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                left: 252.7, // Adjust according to your image
                top: 213,   // Adjust according to your image
                width: 34.56, // Adjust according to your imag8
                height:  88.54, // Adjust according to your image
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
                        image: AssetImage('assets/腹部正面.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                left: 230, // Adjust according to your image
                top: 150.7,   // Adjust according to your image
                width: 37.76, // Adjust according to your imag8
                height:  36.48, // Adjust according to your image
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
                        image: AssetImage('assets/右胸正面.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                left: 272.3, // Adjust according to your image
                top: 151.5,   // Adjust according to your image
                width: 37.76, // Adjust according to your imag8
                height:  36.48, // Adjust according to your image
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
                        image: AssetImage('assets/左胸正面.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                left: 226, // Adjust according to your image
                top: 395,   // Adjust according to your image
                width: 30.42, // Adjust according to your imag8
                height:  96.2, // Adjust according to your image
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
                        image: AssetImage('assets/右小腿正面.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
                left: 281, // Adjust according to your image
                top: 395,   // Adjust according to your image
                width: 34.4, // Adjust according to your imag8
                height:  95.4, // Adjust according to your image
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
                        image: AssetImage('assets/左小腿正面.png'),
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
