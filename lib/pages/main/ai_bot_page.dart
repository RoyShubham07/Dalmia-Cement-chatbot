import 'dart:math';
// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:healthsphere/components/chat_ui/chat_bubble.dart';
import 'package:healthsphere/main.dart';
import 'package:healthsphere/models/message.dart';
import 'package:healthsphere/models/order.dart';
import 'package:healthsphere/pages/home_page.dart';

class AIBotScreen extends StatefulWidget {
  const AIBotScreen({super.key});

  @override
  State<AIBotScreen> createState() => _AIBotScreenState();
}

enum ChatState { init, orderPlacement, options, orderConfirmation }

class _AIBotScreenState extends State<AIBotScreen> {
  final TextEditingController promptController = TextEditingController();
  final ScrollController _controller = ScrollController();
  List<Message> chats = [];
  bool isMessageLoading = false;
  bool loading = false;
  int cementQty = 0;

  ChatState state = ChatState.init;

  void getInitMessages() async {
    if (supabase.auth.currentUser == null) {
      setState(() {
        loading = false;
      });
      return;
    }
    final res = await supabase.from("messages").select() as List;
    List<Message> temp = [];
    for (var ele in res) {
      temp.add(Message(
          message: ele["prompt"],
          isUser: true,
          date: DateTime.parse(ele["created_at"] ?? "")));
      temp.add(Message(
          message: ele["response"],
          isUser: false,
          date: DateTime.parse(ele["created_at"] ?? "")));
    }
    setState(() {
      chats.addAll(temp);
      loading = false;
    });
  }

  void sendMessage() async {
    if (isMessageLoading || loading) {
      return;
    }
    final message = promptController.text.trim();
    if (message.isEmpty) {
      return;
    }
    setState(() {
      chats.add(Message(message: message, isUser: true, date: DateTime.now()));
    });
    _controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );

    switch (state) {
      case ChatState.init:
        setState(() {
          chats.add(Message(
              message:
                  "Hey there! Please select any one options \n1.Order Status \n2.Delivery Details \n3.Order history \n4.Place an order  ",
              isUser: false,
              date: DateTime.now()));
          state = ChatState.options;
        });
        _controller.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
        promptController.clear();
        break;
      case ChatState.options:
        int opt = int.tryParse(message) ?? 99;
        switch (opt) {
          case 1:
            setState(() {
              isMessageLoading = true;
              chats.add(
                  Message(message: "", isUser: false, date: DateTime.now()));
            });
            _controller.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            );
            promptController.clear();
            try {
              final orderRes = await supabase
                  .from('orders')
                  .select()
                  .order("id", ascending: false)
                  .limit(1)
                  .single() as Map<String, dynamic>;
              final order = Order.fromMap(orderRes);
              setState(() {
                isMessageLoading = false;
                chats[chats.length - 1] = (Message(
                    message: order.toStatusText(),
                    isUser: false,
                    date: DateTime.now()));
                state = ChatState.init;
              });
              _controller.animateTo(
                0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
            } catch (e) {
              setState(() {
                isMessageLoading = false;
                chats[chats.length - 1] = (Message(
                    message: "No Orders found.",
                    isUser: false,
                    date: DateTime.now()));
                state = ChatState.init;
              });
              _controller.animateTo(
                0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
            }

            break;

          case 2:
            setState(() {
              isMessageLoading = true;
              chats.add(
                  Message(message: "", isUser: false, date: DateTime.now()));
            });
            promptController.clear();
            try {
              final orderRes = await supabase
                  .from('orders')
                  .select()
                  .order("id", ascending: false)
                  .limit(1)
                  .single() as Map<String, dynamic>;

              final order = Order.fromMap(orderRes);
              setState(() {
                isMessageLoading = false;
                chats[chats.length - 1] = (Message(
                    message: order.toDeliveryDetails(),
                    isUser: false,
                    date: DateTime.now()));
                state = ChatState.init;
              });
              _controller.animateTo(
                0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
            } catch (e) {
              setState(() {
                isMessageLoading = false;
                chats[chats.length - 1] = (Message(
                    message: "No Orders found.",
                    isUser: false,
                    date: DateTime.now()));
                state = ChatState.init;
              });
              _controller.animateTo(
                0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
            }
            break;

          case 3:
            setState(() {
              isMessageLoading = true;
              chats.add(
                  Message(message: "", isUser: false, date: DateTime.now()));
            });
            promptController.clear();
            final orderRes = await supabase
                .from('orders')
                .select()
                .order("id", ascending: true) as List;
            if (orderRes.isEmpty) {
              setState(() {
                isMessageLoading = false;
                chats[chats.length - 1] = (Message(
                    message: "No Orders found.",
                    isUser: false,
                    date: DateTime.now()));
                state = ChatState.init;
              });
              _controller.animateTo(
                0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
              break;
            }
            List<Message> temp = [];
            for (var element in orderRes) {
              temp.add(Message(
                  message: Order.fromMap(element).toOrderHistory(),
                  isUser: false,
                  date: DateTime.now()));
            }

            setState(() {
              isMessageLoading = false;
              chats.removeLast();
              chats.addAll(temp);
              state = ChatState.init;
            });
            _controller.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            );
            break;
          case 4:
            setState(() {
              state = ChatState.orderPlacement;
              chats.add(Message(
                  message: "Please enter the quantity of cement in kg",
                  isUser: false,
                  date: DateTime.now()));
            });
            promptController.clear();

            _controller.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            );
            break;

          default:
            promptController.clear();

            setState(() {
              chats.add(
                Message(
                  message: "Please enter a valid option",
                  isUser: false,
                  date: DateTime.now(),
                ),
              );
            });
            _controller.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            );
            break;
        }
        break;

      case ChatState.orderPlacement:
        int qty = int.tryParse(message) ?? -1;
        double amt = qty * 7.8;
        promptController.clear();

        if (qty < 0) {
          setState(() {
            chats.add(
              Message(
                message: "Please enter a valid quantity",
                isUser: false,
                date: DateTime.now(),
              ),
            );
          });
          _controller.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
          break;
        }
        setState(() {
          state = ChatState.orderConfirmation;
          chats.add(
            Message(
              message:
                  'Your order of $qty kilograms of cement, totaling $amt, is ready to be placed. Kindly confirm by replying with "yes" or "no".',
              isUser: false,
              date: DateTime.now(),
            ),
          );
          cementQty = qty;
        });
        _controller.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
        break;

      case ChatState.orderConfirmation:
        promptController.clear();
        if (message.toLowerCase() == "yes" || message.toLowerCase() == "no") {
          bool ans = message.toLowerCase() == "yes" ? true : false;
          double amt = cementQty * 7.8;
          if (ans) {
            setState(() {
              isMessageLoading = true;
              chats.add(
                  Message(message: "", isUser: false, date: DateTime.now()));
            });
            await supabase.from("orders").insert({
              "quantity": cementQty,
              "expected_delivery": DateTime.now()
                  .add(Duration(days: Random().nextInt(3) + 1))
                  .toIso8601String(),
              "amount": amt,
              "ordered_by": supabase.auth.currentUser?.id
            });
            setState(() {
              chats.removeLast();
              isMessageLoading = false;
              
              chats.add(
                Message(
                  message: 'Order Placed. Thank you.',
                  isUser: false,
                  date: DateTime.now(),
                ),
              );
              state = ChatState.init;
              cementQty = 0;
            });
            _controller.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            );
          } else {
            setState(() {
              chats.add(
                Message(
                  message: 'Order Canceled',
                  isUser: false,
                  date: DateTime.now(),
                ),
              );
              state = ChatState.init;
              cementQty = 0;
            });
            _controller.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            );
          }
          break;
        }
        setState(() {
          chats.add(
            Message(
              message: "Please enter a valid input (Yes/No)",
              isUser: false,
              date: DateTime.now(),
            ),
          );
        });
        _controller.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
        break;

      default:
    }
  }

 

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hercules"),
          
          backgroundColor: Colors.yellow,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const homepage()),
              );
            },
          ),
        ),
        body: Column(
          children: [
            loading
                ? const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                    backgroundColor: Colors.teal,
                  )))
                : Expanded(
                    child: ListView.builder(
                        controller: _controller,
                        itemCount: chats.length,
                        reverse: true,
                        itemBuilder: (context, i) {
                          final index = chats.length - 1 - i;
                          if (index == chats.length - 1 && isMessageLoading) {
                            return ChatBubble(
                              text: chats[index].message,
                              isUser: chats[index].isUser,
                              date: chats[index].date,
                              isLoading: true,
                            );
                          }
                          return ChatBubble(
                            text: chats[index].message,
                            isUser: chats[index].isUser,
                            date: chats[index].date,
                            isLoading: false,
                          );
                        }),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    enabled: !isMessageLoading && !loading,
                    controller: promptController,
                    decoration:
                        const InputDecoration(hintText: "Type anything"),
                  )),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      color: Colors.yellow,
                      child: IconButton(
                        onPressed: sendMessage,
                        icon: const Icon(Icons.send_rounded),
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}