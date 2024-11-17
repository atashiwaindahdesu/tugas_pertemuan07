import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/comment.dart';
import '../widgets/comment_item.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _dbHelper = DatabaseHelper.instance;
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final comments = await _dbHelper.fetchComments();
    setState(() {
      _comments = comments;
    });
  }

  void _showCommentForm({Comment? existingComment}) {
    final _nameController = TextEditingController(
        text: existingComment != null ? existingComment.name : '');
    final _contentController = TextEditingController(
        text: existingComment != null ? existingComment.content : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existingComment == null ? 'Add Comment' : 'Edit Comment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name')),
            TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Comment')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newComment = Comment(
                id: existingComment?.id,
                name: _nameController.text,
                content: _contentController.text,
                date: DateTime.now().toIso8601String(),
              );

              if (existingComment == null) {
                await _dbHelper.insertComment(newComment);
              } else {
                await _dbHelper.updateComment(newComment);
              }
              Navigator.of(ctx).pop();
              _fetchComments();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteComment(int id) async {
    await _dbHelper.deleteComment(id);
    _fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comment')),
      body: ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (ctx, i) => CommentItem(
          comment: _comments[i],
          onEdit: () => _showCommentForm(existingComment: _comments[i]),
          onDelete: () => _deleteComment(_comments[i].id!),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showCommentForm(),
      ),
    );
  }
}
