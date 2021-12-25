

import 'package:comment_reply_both_pagination/model/comment_model.dart';
import 'package:comment_reply_both_pagination/model/reply_model.dart';
import 'package:comment_reply_both_pagination/repository/comment_repository.dart';
import 'package:comment_reply_both_pagination/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CommentNoLibraryPage extends StatefulWidget {
  const CommentNoLibraryPage({Key? key}) : super(key: key);

  @override
  _CommentNoLibraryState createState() => _CommentNoLibraryState();
}

class _CommentNoLibraryState extends State<CommentNoLibraryPage> {

  ScrollController _scrollController = ScrollController();
  List<CommentModel> commentModelList = [];
  bool loading = false, allLoaded = false;

  fetchData() async {
    if (allLoaded) {
      return;
    }

    setState(() {
      loading = true;
    });

    List<CommentModel> newData =
        commentModelList.length >= 60 ? [] : await CommentRepository().fetchCommentData(1, 3);
    if (newData.isNotEmpty) {
    commentModelList.addAll(newData);
    }

    setState(() {
    loading = false;
    allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !loading) {
        // listview reached to the bottom and new Data called
        print("new data called");
        fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("simple pagination no library"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (commentModelList.isNotEmpty) {
            return Stack(
              children: [
                ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (context, fatherIndex) {
                     return CommentListItemWidget(context, commentModelList[fatherIndex], fatherIndex);
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1,
                      );
                    },
                    itemCount: commentModelList.length),

                if(loading)...[
                  Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(

                        decoration: BoxDecoration(
                          color: Color.fromRGBO(64, 60, 60, 0.5019607843137255),
                        ),

                        height: 80,
                        // width: MediaQuery.of(context).size.width,
                        width: constraints.maxWidth,
                        child: Center(
                            child: CircularProgressIndicator()),
                      ))
                ]

                //show more loading view
              ],
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }



  Widget CommentListItemWidget(
      BuildContext context, CommentModel item, int fatherIndex) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          mainHeader(context, item, fatherIndex),

          Container(
            // height: 150,
              padding: EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              margin: EdgeInsets.only(top: 5),
              child: nestedListView(item)
          ),

          SizedBox(
            height: 10,
          ),


          RaisedButton(
              child: Text("بیشتر"),
              onPressed: () async{
                List<ReplyModel> newItems = await CommentRepository().fetchReplyData(fatherIndex, 3);

                final myList = item.replyList + newItems;
                commentModelList[fatherIndex].replyList = myList;
                setState(() {});
              })
        ],
      ),
    );
  }



  Widget nestedListView(CommentModel item) {

    List<ReplyModel> list = item.replyList;
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(), // to prevent scrolling
        shrinkWrap: true, // necessary to show nested list
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Container( padding:EdgeInsets.all(5),child: Text(list[index].reply));
        }
    );
  }




  Widget mainHeader(BuildContext context, CommentModel item, int fatherIndex) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "1400/10/01",
            style: TextStyle(color: AppColors.white2),
          ),
          Spacer(),
          Text(
            item.name + fatherIndex.toString(),
            style: TextStyle(fontSize: 15, color: AppColors.white2),
          ),
          Center(
            child: Container(
              height: 50, width: 50,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/apple.png"))),
              // child: Image.asset("assets/images/user_icon.png")
            ),
          ),
        ],
      ),
    );
  }
}




