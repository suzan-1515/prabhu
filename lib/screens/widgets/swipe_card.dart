import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prabhu_movie_recommendation_system/style/style.dart';
import 'package:prabhu_movie_recommendation_system/utils/imageUtils.dart';

import 'custom_network_image.dart';

class SwipeCard extends StatelessWidget {
  final Map movie;

  const SwipeCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            customNetworkImage(
                ImageUtils.getTMDBImagePath(movie['poster_path'] ??
                    ImageUtils.getAvatarPath(movie['original_title'][0],
                        movie['original_title'][1])),
                width: size.width,
                height: size.height,
                borderRadius: const BorderRadius.all(Radius.circular(6))),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    height: size.height * 0.17,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['original_title'],
                      style: textpoppinssemiboldlgwhite(),
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      movie['overview'],
                      style:
                          textpoppinsRegularsm().copyWith(color: Colors.white),
                      maxLines: 4,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
