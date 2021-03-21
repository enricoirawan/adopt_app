import 'package:app_adopt/providers/adopt.dart';
import 'package:app_adopt/providers/user.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdoptScreen extends StatefulWidget {
  static const routeName = '/adopt';

  @override
  _AdoptScreenState createState() => _AdoptScreenState();
}

class _AdoptScreenState extends State<AdoptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _reasonFocusNode = FocusNode();

  String _name, _phone, _reason;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _phoneFocusNode.dispose();
    _reasonFocusNode.dispose();
  }

  void _submit(adoptionId, name, reason, phone, userId) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState.save();

    var errorMessage = 'Ada kesalahan, silahkan coba lagi';
    //logic kirim request
    try {
      final response =
          await Provider.of<Adopt>(context, listen: false).requestAdopt(
        adoptionId,
        name,
        reason,
        phone,
        userId,
      );
      if (response['success']) {
        setState(() {
          _isLoading = false;
        });
        if (response['success'] == true) {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text:
                  'Terima kasih. Permintaan adopsi anda sudah terkirim. Info lanjut akan langsung dihubungi oleh Tim Helena',
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: errorMessage,
        );
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      CoolAlert.show(
        context: context,
        type: CoolAlertType.info,
        text:
            'Silahkan cek data anda kembali sebelum meneruskan, pastikan data anda sudah benar.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<User>(context).userId;
    final adoptInfo = ModalRoute.of(context).settings.arguments as Map;
    print('adoptInfo, user id');
    print(adoptInfo);
    print(userId);
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                height: double.infinity,
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        iconSize: 30,
                      ),
                      Center(
                        child: Text(
                          'Permintaan Adopsi',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(adoptInfo['name'],
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 3,
                                      softWrap: true),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(adoptInfo['orphanage_name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.w300,
                                      ),
                                      maxLines: 3,
                                      softWrap: true),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                    adoptInfo['orphanage_address'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Ubuntu',
                                      fontWeight: FontWeight.w300,
                                    ),
                                    maxLines: 10,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://demo.demangkonting.com/images/adoptions/' +
                                    adoptInfo['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value.isEmpty) return 'Nama wajib diisi';
                                if (value.length <= 5)
                                  return 'Masukan nama lengkap, minimal 5 karakter';
                                return null;
                              },
                              onSaved: (_) => _name = _nameController.text,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_phoneFocusNode),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: 'Nama pihak pengadopsi',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Ubuntu',
                                ),
                                hintText:
                                    'Masukan nama lengkap orang yang ingin mengadopsi',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Ubuntu',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _phoneController,
                              focusNode: _phoneFocusNode,
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Nomor telepon wajib diisi';
                                if (value.length < 11)
                                  return 'Masukan nomor telepon dengan benar';
                                return null;
                              },
                              onSaved: (_) => _phone = _phoneController.text,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_reasonFocusNode),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: 'Nomor telepon',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Ubuntu',
                                ),
                                hintText: 'Masuikan nomor telepon',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Ubuntu',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _reasonController,
                              focusNode: _reasonFocusNode,
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Bagian ini wajib diisi';
                                if (value.length <= 10)
                                  return 'Minimal 10 karakter, deskripsikan alasan dengan jelas';
                                return null;
                              },
                              onSaved: (_) => _reason = _reasonController.text,
                              maxLines: 5,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: 'Alasan ingin mengadopsi',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Ubuntu',
                                ),
                                hintText: 'Saya ingin...',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Ubuntu',
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  _submit(
                                    adoptInfo['adoption_id'],
                                    _name,
                                    _reason,
                                    _phone,
                                    userId,
                                  );
                                },
                                child: Text('Kirim Permintaan'),
                                color: Colors.orange[400],
                                textColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
