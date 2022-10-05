import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/screens/password/verification_page.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/inputField.dart';

class ResetPasswordPage extends StatefulWidget {
  static const id = "password/reset";

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController _emailController;
  late AuthProvider _auth;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    _emailController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _auth = Provider.of<AuthProvider>(context, listen: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Reset Password"),
        titleTextStyle: GoogleFonts.ubuntu(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                Config.password,
                height: 300,
              ),
              Text(
                "Enter your registerd email",
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ).paddingOnly(),
              Spacer(),
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Input(
                          _emailController,
                          AppLocalizations.of(context)!.email,
                          Icons.email_outlined),
                    ],
                  )).center(),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            CircularProgressIndicator().center());
                    Map<String,dynamic>? value =
                        await _auth.resetPassword(_emailController.text);
                    Navigator.pop(context);
                    if (value != null) {
                      print(value['client'].first);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CodeVerificationPage(client: Client.fromJson(value['client'].first,null),passCode: value['confirmation_code'])));
                         
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Email not found"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    "Register",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 18, color: Config.color_2),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, SignUp.id);
                                  },
                                )
                              ],
                            );
                          });
                    }
                  }
                },
                child: Text(
                  "Send email",
                  style: GoogleFonts.ubuntu(fontSize: 22),
                ),
                style: ElevatedButton.styleFrom(
                    shadowColor: Config.color_1,
                    backgroundColor: Config.color_1,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15),
                    ),
                    fixedSize: Size(270, 50)),
              ).paddingOnly(top: 5, bottom: 10),
              Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
