import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:didauday_app/src/resources/screens/auth/blocs/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final DateFormat format = DateFormat("dd/MM/yyyy");

  var _valueGender = 'male';

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  RegisterBloc registerBloc = RegisterBloc();


  void _onRegister() {
    var email = _emailController.text;
    var password = _passwordController.text;
    var confirmPassword = _confirmPasswordController.text;
    var firstName = _firstNameController.text;
    var lastName = _lastNameController.text;
    var birthday = _birthdayController.text;
    var address = _addressController.text;
    var phoneNumber = _phoneNumberController.text;

    var gender = _valueGender;

    if (registerBloc.isValidDataRegister(email, password, confirmPassword, firstName, lastName, birthday, gender, address, phoneNumber)) {
      print('oke');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(
            20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    'Authentication info',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: StreamBuilder<Object>(
                      stream: registerBloc.emailStream,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.email,
                              )),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: StreamBuilder<Object>(
                      stream: registerBloc.passwordStream,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.lock,
                              )),
                        );
                      }),
                ),
                StreamBuilder<Object>(
                  stream: registerBloc.confirmPasswordStream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            errorText:
                            snapshot.hasError ? snapshot.error : null,
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.lock,
                            )),
                      ),
                    );
                  }
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    'Personal info',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: StreamBuilder<Object>(
                      stream: registerBloc.firstNameStream,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              labelText: 'First name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.person,
                              )),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: StreamBuilder<Object>(
                      stream: registerBloc.lastNameStream,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              labelText: 'Last name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.person,
                              )),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: StreamBuilder<Object>(
                      stream: registerBloc.birthdayStream,
                      builder: (context, snapshot) {
                        return DateTimeField(
                          controller: _birthdayController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Birthday",
                            prefixIcon: Icon(
                              Icons.date_range,
                            ),
                          ),
                          format: format,
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                          },
                        );
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: "Gender", border: OutlineInputBorder()),
                      items: [
                        DropdownMenuItem(
                          value: "male",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.male,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Male",
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "female",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.female,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Female",
                              ),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _valueGender = value;
                        });
                      },
                      value: _valueGender,
                      hint: Text(
                        "Please choose gender",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: StreamBuilder<Object>(
                      stream: registerBloc.addressStream,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.location_on,
                              )),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: StreamBuilder<Object>(
                      stream: registerBloc.phoneNumberStream,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: 'Phone number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.phone,
                            ),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Color(0xfffd5739),
                      onPressed: _onRegister,
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
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
