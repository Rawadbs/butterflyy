import 'package:flutter/material.dart';

class ContainersHabbit extends StatelessWidget {
  const ContainersHabbit({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 157,
                    height: 115,
                    decoration: const BoxDecoration(
                        color: Color(0xff4B4DED),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Center(
                      child: Text(
                        'العادات الشخصية',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: 157,
                    height: 115,
                    decoration: const BoxDecoration(
                        color: Color(0xff986CF5),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 17,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 157,
                    height: 115,
                    decoration: const BoxDecoration(
                        color: Color(0xffFF8762),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  Container(
                    width: 157,
                    height: 115,
                    decoration: const BoxDecoration(
                        color: Color(0xff31D097),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 90,
          left: (MediaQuery.of(context).size.width - 70) / 2,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 60,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 33,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
