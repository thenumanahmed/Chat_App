import 'package:chat_app/helper/my_date_util.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../headers.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMyMessage = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMyMessage);
        },
        child: isMyMessage ? _greenMessage() : _blueMessage());
  }

  // other message
  Widget _blueMessage() {
    // update last read message if sender and reciever are diff
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Padding(
      padding: EdgeInsets.only(right: mq.width * .04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //message content
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: mq.height * 0.04, vertical: mq.height * 0.01),
              padding: EdgeInsets.all(widget.message.type == 'text'
                  ? mq.width * 0.04
                  : mq.width * 0.025),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 201, 232, 255),
                  border: Border.all(color: Colors.lightBlue),
                  //making borders curved
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              child: widget.message.type == 'text'
                  ? Text(
                      widget.message.msg,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg, // msg has image url
                        // placeholder: (context, url) => const Icon(Icons.error),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 70),
                      ),
                    ),
            ),
          ),
          //time
          Row(
            children: [
              // //double tick blue icon for message read
              // const Icon(Icons.done_all_outlined, color: Colors.blue, size: 18),

              // for adding some space
              // const SizedBox(width: 2),

              //send time
              Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // our message
  Widget _greenMessage() {
    return Padding(
      padding: EdgeInsets.only(left: mq.width * .04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //time
          Row(
            children: [
              //double tick blue icon for message read
              if (widget.message.read.isNotEmpty)
                const Icon(Icons.done_all_outlined,
                    color: Colors.blue, size: 18),

              // for adding some space
              const SizedBox(width: 2),

              //send time
              Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          //message content
          Flexible(
            child: Container(
              padding: EdgeInsets.all(widget.message.type == 'text'
                  ? mq.width * 0.04
                  : mq.width * 0.025),
              margin: EdgeInsets.symmetric(
                  horizontal: mq.height * 0.04, vertical: mq.height * 0.01),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 223, 249, 216),
                  border: Border.all(color: Colors.lightGreen),
                  //making borders curved
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )),
              child: widget.message.type == 'text'
                  ? Text(
                      widget.message.msg,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg, // msg has image url
                        // placeholder: (context, url) => const Icon(Icons.error),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 70),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                  vertical: mq.height * .015,
                  horizontal: mq.width * 0.4,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == 'text'
                  ?
                  //copy text
                  _OptionItem(
                      icon: const Icon(
                        Icons.copy_all_outlined,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Copy Text',
                      onTap: () {
                        Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //hide the bottom sheet
                          Navigator.pop(context);
                          Dialogs.showSnackbar(context, 'Text Copied!');
                        });
                      })
                  :
                  //save image
                  _OptionItem(
                      icon: const Icon(
                        Icons.download,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          await GallerySaver.saveImage(widget.message.msg,albumName: 'Chat App')
                              .then((success) {
                            //hide the bottom sheet
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, 'Image Saved Successfully! ');
                            }
                          });
                        } catch (e) {
                          print("error while saving image $e ");
                        }
                      }),

              //divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  indent: mq.width * 0.04,
                  endIndent: mq.width * 0.04,
                ),

              //edit message
              if (widget.message.type == 'text' && isMe)
                _OptionItem(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Edit Message',
                    onTap: () {}),

              //delete message
              if (isMe)
                _OptionItem(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 26,
                    ),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((v) {
                        print('delete');
                        //hiding the bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //divider
              Divider(
                color: Colors.black54,
                indent: mq.width * 0.04,
                endIndent: mq.width * 0.04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                  ),
                  name:
                      'Sent at: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.red,
                  ),
                  name: widget.message.read.isNotEmpty
                      ? 'Read at: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}'
                      : 'Read at: Not seen yet',
                  onTap: () {}),
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
          top: mq.height * .015,
          left: mq.height * .04,
          bottom: mq.height * .015,
        ),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text('    $name',
                  style: const TextStyle(color: Colors.black54)),
            )
          ],
        ),
      ),
    );
  }
}
