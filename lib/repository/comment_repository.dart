

import 'package:comment_reply_both_pagination/model/comment_model.dart';
import 'package:comment_reply_both_pagination/model/reply_model.dart';

class CommentRepository{


  Future<List<CommentModel>> fetchCommentData(int pageKey, int pageSize) async{

    await Future.delayed(Duration(seconds: 2));

    List<ReplyModel> replyList = [];
    replyList.add(ReplyModel("پاسخ 1"));
    replyList.add(ReplyModel("پاسخ 2"));
    replyList.add(ReplyModel("پاسخ 3"));



    List<CommentModel> commentList = [];
    commentList.add(CommentModel(1, "نظر 0 ",  replyList , false));
    commentList.add(CommentModel(1, "نظر1 ",  replyList , false));
    commentList.add(CommentModel(1, "نظر2 ",  replyList , false));

    return commentList;

  }



  Future<List<ReplyModel>> fetchReplyData(int pageKey, int pageSize) async{
    await Future.delayed(Duration(seconds: 1));
    List<ReplyModel> replyList = [];
    replyList.add(ReplyModel("پاسخ 4"));
    replyList.add(ReplyModel("پاسخ 5"));
    replyList.add(ReplyModel("پاسخ 6"));


    return replyList;
  }

}