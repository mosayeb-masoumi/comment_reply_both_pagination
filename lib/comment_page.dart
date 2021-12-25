

import 'package:comment_reply_both_pagination/model/comment_model.dart';
import 'package:comment_reply_both_pagination/model/reply_model.dart';
import 'package:comment_reply_both_pagination/repository/comment_repository.dart';
import 'package:comment_reply_both_pagination/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {


  List<CommentModel> commentModelList = [];

  static const _pageSize = 3;
  final PagingController<int, CommentModel> _pagingController =
  PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchData(pageKey);
    });
  }



  Future<void> _fetchData(int pageKey) async {
    try {
      final newItems = await CommentRepository().fetchCommentData(pageKey, _pageSize);
      commentModelList.addAll(newItems);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.grey3,
      backgroundColor: AppColors.transparent1,
      appBar: AppBar(
        title: Center(child: Text("لیست نظرات")),
        backgroundColor: AppColors.transparent1,
        elevation: 0,
      ),
      body: Container(
          child: PagedListView<int, CommentModel>.separated(
            physics: BouncingScrollPhysics(),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<CommentModel>(
                animateTransitions: true,
                itemBuilder: (context, item, fatherIndex) {
                  return CommentListItemWidget(context, item, fatherIndex);
                }),
            separatorBuilder: (context, index) => const Divider(
              color: AppColors.white2,
            ),
          )),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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






//
// Widget nestedListItemWidget(
//     CommentModel item, int index, BuildContext context, int fatherIndex) {
//   return InkWell(
//     child: Container(
//         height: 50,
//         child: Align(
//             alignment: Alignment.centerRight,
//             child: Text(item.replyList[index].reply))),
//     onTap: () {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content:
//         Text("father item $fatherIndex " + item.replyList[index].reply),
//       ));
//       print("father item $fatherIndex " + item.replyList[index].reply);
//     },
//   );
// }















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


