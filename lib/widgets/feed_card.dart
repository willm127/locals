import 'package:flutter/material.dart';

import '../models/post.dart';

class FeedCard extends StatelessWidget {
  final Post post;

  const FeedCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    const _cardPadding = 20.0;
    const _infoHeight = 50.0;
    const _div = Divider(color: Color.fromRGBO(255, 255, 255, .5), height: 0);

    final time = post.timestamp;

    final _year = time.year.toString().substring(2, 4);
    final _month = time.month.toString();
    final _day = time.day.toString();
    final _minute = (time.minute == 0)
        ? '00'
        : (time.minute < 10)
            ? '0${time.minute}'
            : time.minute.toString();

    String _hour = (time.hour == 0) ? '12' : (time.hour).toString();
    String _ampm = 'am';

    if (time.hour > 12) {
      _ampm = 'pm';
      _hour = (time.hour - 12).toString();
    }

    final _fullDate = '$_month-$_day-$_year $_hour:$_minute $_ampm';

    return Container(
      color: const Color.fromRGBO(32, 31, 31, 1),
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _cardPadding,
              vertical: _cardPadding * .75,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: _buildAvatar(post, _cardPadding, _infoHeight),
                  contentPadding: const EdgeInsets.only(left: 0),
                  title: Row(children: [
                    Text(
                      post.author_name,
                      style:
                          _textTheme.labelMedium?.copyWith(color: Colors.red),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        '@${post.author_name}',
                        style: _textTheme.labelMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                  subtitle: Text(_fullDate, style: _textTheme.labelSmall),
                  trailing: const Icon(Icons.push_pin, color: Colors.red),
                ),
                Text(
                  post.title,
                  style: _textTheme.headlineLarge,
                ),
                const SizedBox(height: _cardPadding * .5),
                Text(post.text)
              ],
            ),
          ),
          _div,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _cardPadding,
              vertical: _cardPadding * .5,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.thumb_up,
                  size: 20,
                  color: Colors.white54,
                ),
                const SizedBox(width: 5),
                Text('0', style: _textTheme.labelMedium),
              ],
            ),
          ),
          _div,
        ],
      ),
    );
  }
}

Stack _buildAvatar(Post post, double _cardPadding, double _infoHeight) {
  return Stack(
    children: [
      CircleAvatar(
        backgroundColor: Colors.white,
        radius: _infoHeight * .5,
        child: ClipRRect(
          child: FadeInImage(
            fit: BoxFit.cover,
            image: NetworkImage(post.author_avatar_url),
            placeholder: const AssetImage('assets/images/thumb.png'),
          ),
          borderRadius: BorderRadius.circular(45),
        ),
      ),
      const Positioned(
        bottom: -2,
        right: 0,
        child: Icon(
          Icons.verified,
          color: Colors.black,
          size: 20,
        ),
      ),
      const Positioned(
        bottom: -2,
        right: 0,
        child: Icon(
          Icons.circle,
          color: Colors.black,
          size: 20,
        ),
      ),
      const Positioned(
        bottom: 0,
        right: 2,
        child: Icon(
          Icons.verified,
          color: Colors.blue,
          size: 16,
        ),
      ),
    ],
  );
}
