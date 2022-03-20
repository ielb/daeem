import 'package:flutter/cupertino.dart';
import 'package:daeem/services/services.dart';

class Rating extends StatefulWidget {
  final int maximumRating;
  final Function(int) onRatingSelected;
  final int _currentRating;

  Rating(this.onRatingSelected, this._currentRating, [this.maximumRating = 5]);

  @override
  _Rating createState() => _Rating();
}

class _Rating extends State<Rating> {
  int _currentRating = 0;

  Widget _buildRatingStar(int index) {
    if (index < _currentRating) {
      return Icon(CupertinoIcons.star_fill, size: 20, color: Colors.orange);
    } else {
      return Icon(
        CupertinoIcons.star_fill,
        size: 20,
        color: Colors.grey,
      );
    }
  }

  Widget _buildBody() {
    final stars = List<Widget>.generate(this.widget.maximumRating, (index) {
      return GestureDetector(
        child: _buildRatingStar(index),
        onTap: () {
          setState(() {
            _currentRating = index + 1;
          });

          this.widget.onRatingSelected(_currentRating);
        },
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: stars,
        ),
        Text("$_currentRating/5").paddingOnly(left: 5, top: 3)
      ],
    );
  }

  @override
  void initState() {
    _currentRating = widget._currentRating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
