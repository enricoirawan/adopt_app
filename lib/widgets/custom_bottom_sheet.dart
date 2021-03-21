import 'package:app_adopt/screens/home.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';

class CustomBottomSheet extends StatefulWidget {
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool login = true;
  bool _passwordVisible = true;
  String _nama, _email, _password;
  bool _isLoading = false;
  bool _isValid = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isValid = false;
      });
      return;
    } else {
      setState(() {
        _isValid = true;
      });
      _formKey.currentState.save();
    }

    // logic login / register
    var errorMessage = 'Gagal untuk autentikasi, silahkan coba lagi';
    try {
      if (login) {
        //logic login
        final responseData = await Provider.of<User>(context, listen: false)
            .login(_email, _password);
        print('login response');
        print(responseData);
        if (responseData['success'] == false) {
          setState(() {
            _isLoading = false;
          });
          if (responseData['message'] == 'Email or password did not match') {
            errorMessage =
                'Email atau password salah, pastikan email dan password sudah terdaftar';
          }
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: errorMessage,
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      } else {
        //logic register
        final responseData = await Provider.of<User>(context, listen: false)
            .register(_nama, _email, _password);
        print('response register');
        print(responseData);
        print(responseData['success'] is String);
        //cek error
        if (responseData['success'] == 'false') {
          setState(() {
            _isLoading = false;
          });
          if (responseData['message'] == 'Error Field required to fill') {
            setState(() {
              errorMessage = 'Data yang anda masukan salah, silahkan coba lagi';
            });
          } else if (responseData['message'] == 'Email already used') {
            setState(() {
              errorMessage = 'Email sudah dipakai, silahkan ganti email';
            });
          }
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: errorMessage,
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          _emailController.clear();
          _passwordController.clear();
          _nameController.clear();
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: 'Yeay kamu berhasil terdaftar! Silahkan login dulu ya',
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: 'Autentikasi gagal, silahkan coba beberapa saat lagi',
      );
    }
  }

  Widget _nameForm() {
    return TextFormField(
      controller: _nameController,
      validator: (value) {
        if (value.isEmpty) return 'Nama harus diisi';
        if (value.length <= 5) return 'Nama minimal terdiri dari 5 karakter';
        return null;
      },
      onSaved: (value) => _nama = _nameController.text,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 12,
        ),
        hintText: 'Masukan Nama',
        labelText: 'Nama Anda',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.orange[300],
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        prefixIcon: Icon(
          Icons.account_circle,
          size: 24,
        ),
      ),
    );
  }

  Widget _emailForm() {
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value.isEmpty || !value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) => _email = _emailController.text,
      focusNode: _emailFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      decoration: InputDecoration(
        hintText: 'Masukan Email',
        labelText: 'Email',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.orange[300],
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        errorStyle: TextStyle(
          fontSize: 12,
        ),
        prefixIcon: Icon(
          Icons.email,
          size: 24,
        ),
      ),
    );
  }

  Widget _passwordForm() {
    return TextFormField(
      controller: _passwordController,
      validator: (value) {
        if (value.isEmpty) return 'Password harus diisi';
        if (value.length < 6) return 'Password minimal 6 karakter';
        return null;
      },
      onSaved: (value) => _password = _passwordController.text,
      focusNode: _passwordFocusNode,
      obscureText: _passwordVisible ? true : false,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 12,
        ),
        hintText: 'Masukan Password',
        labelText: 'Password',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.orange[300],
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        prefixIcon: Icon(
          Icons.lock,
          size: 24,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility_off : Icons.visibility,
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buttonFirst() {
    return InkWell(
      onTap: _submit,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(3, 4),
              blurRadius: 0.75,
            ),
          ],
          color: Colors.orange[400],
        ),
        child: Center(
          child: Text(
            login ? 'Masuk' : 'Daftar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Ubuntu',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonSecond() {
    return InkWell(
      onTap: () {
        setState(() {
          login = !login;
        });
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(3, 4),
              blurRadius: 0.75,
            ),
          ],
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            login ? 'Daftar' : 'Login',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontFamily: 'Ubuntu',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        height: login ? 400 : 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              login ? 'Masuk' : 'Daftar',
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: login ? 0 : 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  login
                      ? SizedBox(
                          height: 0,
                        )
                      : _nameForm(),
                  SizedBox(
                    height: 10,
                  ),
                  _emailForm(),
                  SizedBox(
                    height: 10,
                  ),
                  _passwordForm(),
                  SizedBox(
                    height: 10,
                  ),
                  _isLoading && _isValid
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _buttonFirst(),
                  SizedBox(height: 16),
                  Center(
                    child: Text('Atau'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _isLoading && _isValid
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _buttonSecond(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
