import 'package:flutter/material.dart';
import 'package:happypigs_app/db/Plate.dart';

class NoteGridWidget extends StatelessWidget {
  final Plate note;

  NoteGridWidget(this.note);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          image: DecorationImage(
              image: AssetImage("assets/plate/wood_plate.png")),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
          color: Theme
              .of(context)
              .cardColor),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(fit: BoxFit.cover,
            image: AssetImage("assets/plate/food.jpeg"),),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              note.whereToEat,
              style: Theme
                  .of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              note.description,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText2,
            )
          ],
        ),
      ),
    );
  }
}
