import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var username = TextEditingController();
  var password = TextEditingController();
  bool _obscure = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          height: size.height,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie.asset("assets/lottie/1.json",
                //     width: size.width * 0.9, height: size.height * 0.3),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextField(
                    controller: username,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: 'Email',
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide.none),
                        prefixIcon: const Icon(
                          Icons.mail,
                          color: Colors.blue,
                        )),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: password,
                    obscureText: _obscure,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide.none),
                        hintText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(_obscure ? Icons.remove_red_eye_outlined : Icons.remove_red_eye),
                          onPressed: (){
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                        ),
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      minimumSize:
                      MaterialStateProperty.all(Size(size.width * 0.9, 40)),
                      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                      // splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {},
                    child: const Text("Login"),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
