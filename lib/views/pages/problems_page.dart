import 'package:education_app/views/widgets/problem_timer.dart';
import 'package:flutter/material.dart';
import 'package:education_app/views/widgets/main_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  bool isLoading = true;
  final _solutionController = TextEditingController();
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    setState(() {
      isLoading = false;
    });
    CollectionReference problems =
        FirebaseFirestore.instance.collection("problems");
    QuerySnapshot curProblem =
        await problems.where("topics", arrayContains: "C++").get();
    curProblem.docs.forEach((element) {
      data.add(element);
    });
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _solutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data[0]['id']}. ${data[0]['title']}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "C++",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                        const ProblemTimer()
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "${data[0]['problem']}",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _solutionController,
                          decoration: const InputDecoration(
                            labelText: 'Solution',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) => value!.isNotEmpty
                              ? null
                              : 'Please enter your solution',
                        ),
                        const SizedBox(height: 16.0),
                        MainButton(text: "Submit", onTap: () {})
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ));
  }
}
