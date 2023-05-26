// screens/screen_login.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/model_auth.dart';
import 'package:untitled/models/model_login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( //상태변경알리미. 상태 변경이 필요한 Widget에 상태를 전달 하고 변경되었다는 연락을 받으면 UI를 다시 그려주는 역할
        create: (_) => LoginModel(), //데이터를 관리할 State를 생성.
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 6, 67, 117),
            title: Text('로그인'),
          ),
          body: Column( //세로방향으로 ..
            children: [
              EmailInput(),
              PasswordInput(),
              LoginButton(),
              Padding(
                padding: EdgeInsets.all(10),//상하좌우 전체 여백
                child: Divider(//Divider : 구분하는 선.
                  thickness: 1,
                ),
              ),
              RegisterButton(),
            ],
          ),
        ));
  }
}//로그인 화면 위젯

class EmailInput extends StatelessWidget {
  final e_controller = TextEditingController();
  // GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginModel>(context, listen: false);//LoginModel을 가져옴.
    //listen : True -> 데이터가 변경될때마다 위젯 rebuild
    //false로 해서, 데이터가 변경되더라도 다시 빌드되지 않도록.
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(//사용자의 동작(클릭,길게 누르기 등)을 감지할 수 없는 위젯들에게 감지 기능을 부여 하는 위젯
        // onTap: () {//따라서 동작을 감지했을 경우 어떤 동작을 할 지 선언하는 코드
        //   _controller.text = ''; //컨트롤러의 text를 공백으로 해놓고
        // },
        child: TextFormField(
          onChanged: (email) {//텍스트가 입력될 때마다 호출되어 email값 update
            login.setEmail(email);
          },
          keyboardType: TextInputType.emailAddress,
          controller: e_controller,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'MOMA@google.com',
            suffixIcon: IconButton(
              onPressed: () => e_controller.clear(),//누르면 텍스트 지우기
              icon: Icon(Icons.clear),
            ),
          ),
        ),
      ),
    );
  }
}//이메일 입력 버튼 위젯


class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginModel>(context, listen: false);
    final p_controller = TextEditingController();
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        onChanged: (password) {
          login.setPassword(password);
        },
        obscureText: true,
        controller: p_controller,
        decoration: InputDecoration(
          labelText: '비밀번호',
          hintText: '6자리 이상을 입력해주세요.',
          suffixIcon: IconButton(
            onPressed: () => p_controller.clear(),
            //suffixIcon(우측 X 아이콘)을 눌렀을 경우 clear
            icon: Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}//비밀번호 입력 위젯

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient =
    Provider.of<FirebaseAuthProvider>(context, listen: false);
    final login = Provider.of<LoginModel>(context, listen: false);

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(//걍 버튼 스타일 중 하나임.
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          await authClient
              .loginWithEmail(login.email, login.password)
              .then((loginStatus) {
            if (loginStatus == AuthStatus.loginSuccess) {
              // sendLoginInfoToServer(login.email);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content:
                    Text('환영합니다:) ' + authClient.user!.email! + ' ')));
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('로그인 실패')));
            }
          });
        },
        child: Text('로그인'),
      ),
    );
  }
}//로그인버튼 위젯

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/register');
        },//pushNamed이므로,현재 페이지위에 쌓이게됨(스택개념)
        child: Text(
          '이메일로 회원가입하기',
        ));
  }
}//회원가입버튼 위젯

//
// Future<void> sendLoginInfoToServer(String id) async {
//   var url = Uri.parse('http://34.170.39.54:6000/login');
//   var data = {'id': id};
//   var body = json.encode(data);
//   var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);
//   if(response.statusCode == 200) {
//     return ;
//   }else{
//     throw Exception('Failed to send Login Information to server');
//   }
// }