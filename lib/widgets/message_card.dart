import 'package:chat_app/helper/my_date_util.dart';

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
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
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
              //double tick blue icon for message read
              const Icon(Icons.done_all_outlined, color: Colors.blue, size: 18),

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
}
