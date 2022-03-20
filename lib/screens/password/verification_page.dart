import 'package:daeem/screens/client/change_password.dart';
import 'package:daeem/services/services.dart';
import 'package:pinput/pin_put/pin_put.dart';

class CodeVerificationPage extends StatefulWidget {
  static const id = "password/verification";
  CodeVerificationPage({required this.client,required this.passCode});
  final int passCode;
  final Client client ;
  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  late TextEditingController _pinPutController;
  final _pinPutFocusNode = FocusNode();
  bool called=false;
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color:  Config.color_1),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  @override
  void initState() {
    _pinPutController = TextEditingController();
    print(widget.passCode);
    super.initState();
  }

  dispose() {
    _pinPutController.dispose();
    super.dispose();
  }

  void _submit(String _code){
    print(widget.client.id);
    if(int.parse(_code) == widget.passCode){
      
       Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePassword(client: widget.client,)));
    }
    else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Wrong Code"),
          content: Text("Please try again"),
          actions: <Widget>[
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
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
              Config.emailSent(height: 280, width: 280),
              Text(
                "Enter the code that we sent you",
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ).paddingOnly(top: 20, bottom: 30),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(left:20.0,right: 20.0),
                padding: const EdgeInsets.only(left:20.0,right: 20.0),
                child: PinPut(
                  fieldsCount: 5,
                  onSubmit: (String pin) => _submit(pin),
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Config.color_1.withOpacity(.5),
                    ),
                  ),
                ).center(),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Verify",
                  style: GoogleFonts.ubuntu(fontSize: 22),
                ),
                style: ElevatedButton.styleFrom(
                    shadowColor: Config.color_1,
                    primary: Config.color_1,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15),
                    ),
                    fixedSize: Size(270, 50)),
              ).paddingOnly(top: 5, bottom: 10),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
