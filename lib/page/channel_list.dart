import 'package:flutter/material.dart';
import 'package:google_signin_example/model/channel.dart';
import 'package:google_signin_example/model/channel_id_list.dart';
import 'package:google_signin_example/page/single_channel.dart';
import 'package:google_signin_example/services/youtube_service.dart';

class ChannelListView extends StatefulWidget {
  @override
  _ChannelListViewState createState() => _ChannelListViewState();
}

class _ChannelListViewState extends State<ChannelListView> {
  final YoutubeAPIService _youtubeAPIService =
      YoutubeAPIService.youtubeAPIService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<Channel>>(
            stream: this
                ._youtubeAPIService
                .getListOfChannels(channelListID: CHANNEL_ID_LIST1),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: snapshot.data
                          .map((e) => _buildChannelItem(e))
                          .toList(),
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
              }
              return Text(snapshot.data.toString());
              // return Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text('Be sure your internet is fine and retry'),
              //       FlatButton(
              //         color: Colors.grey[400],
              //         child: Text(
              //           'Retry again',
              //         ),
              //         onPressed: () => this.setState(() {}),
              //       )
              //     ],
              //   ),
              // );
            },
          ),
          StreamBuilder<List<Channel>>(
            stream: this
                ._youtubeAPIService
                .getListOfChannels(channelListID: CHANNEL_ID_LIST2),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: snapshot.data
                          .map((e) => _buildChannelItem(e))
                          .toList(),
                    ),
                  ),
                );
                // return ListView.builder(
                //   itemCount: snapshot.data.length,
                //   itemBuilder: (context, index) =>
                //       _buildChannelItem(snapshot.data[index]),
                // );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
              }
              return Text(snapshot.data.toString());
              // return Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text('Be sure your internet is fine and retry'),
              //       FlatButton(
              //         color: Colors.grey[400],
              //         child: Text(
              //           'Retry again',
              //         ),
              //         onPressed: () => this.setState(() {}),
              //       )
              //     ],
              //   ),
              // );
            },
          ),
        ],
      ),
    ));
  }

  //CHannel Item
  Widget _buildChannelItem(Channel channel) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SingleChannelView(
            channel: channel,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(channel.profilePictureUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                channel.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
