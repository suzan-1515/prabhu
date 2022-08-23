import 'package:flutter/material.dart';

import '../../style/style.dart';

PreferredSize customAppBar(BuildContext context,
        {required String title, bool showBackArrow = false}) =>
    PreferredSize(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 20.0, bottom: 20.0),
          child: Row(
            children: [
              showBackArrow
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              const SizedBox(
                width: 40,
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: textpoppinssemiboldlgwhite(),
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            gradient: const LinearGradient(colors: <Color>[
              primary,
              secondary,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500]!,
                blurRadius: 20.0,
                spreadRadius: 1.0,
              )
            ]),
      ),
      preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
    );
