

import 'package:comment_reply_both_pagination/model/reply_model.dart';

class CommentModel {

  int id = 0;
  String name;
  List<ReplyModel> _replyList = [];
  late bool _showMore;

  CommentModel(this.id, this.name, this._replyList, this._showMore);


  List<ReplyModel> get replyList => _replyList;

  set replyList(List<ReplyModel> value) {
    _replyList = value;
  }

  bool get showMore => _showMore;
  set showMore(bool value) {
    _showMore = value;
  }


}
