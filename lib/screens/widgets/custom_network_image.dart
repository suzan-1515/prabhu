import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

customNetworkImage(imageUrl,
        {BoxFit fit = BoxFit.cover,
        BoxShape shape = BoxShape.rectangle,
        Color color = Colors.transparent,
        BorderRadius? borderRadius,
        required double height,
        required double width}) =>
    CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, image) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.zero,
          shape: shape,
          color: color,
          image: DecorationImage(image: image, fit: fit),
        ),
      ),
      placeholder: (context, url) => Container(),
      errorWidget: (context, url, error) => Container(),
    );
