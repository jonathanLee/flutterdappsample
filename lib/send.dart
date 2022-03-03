import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class Send extends StatelessWidget {


  //아래 상수는 ganache에 있는 주소를 복사해서 사용하는 것임.
  //어플리케이션 사용시는 상수로 빼던지 아님 DB 에서 받아오는 방법으로 구현해야함.

  String rpcUrl = "http://127.0.0.1:7545";
  String wcUrl = "http://127.0.0.1:7545/";

  String strCenter = "송금 Data";



  void  sendToken() async{
    Web3Client client = Web3Client(rpcUrl, Client(), socketConnector: (){
      return IOWebSocketChannel.connect(wcUrl).cast<String>();
    });


    //개인키 : ganache 복사해서
    String privateKey = "0a55cf8fe88a5b36e74aa1354cb3d8c498f2282d51c7b9dbcfa00e0be22ba8ad";

    Credentials credentials = await client.credentialsFromPrivateKey(privateKey);

    //이더리움 개인 hex address 를 가지고 온다.(보내는 사람의 주소) 
    EthereumAddress ownAddress = await credentials.extractAddress();

    //받을 사람의 hexa address 
    EthereumAddress receiverAddress = EthereumAddress.fromHex("0xdCBB475f6Ffd263c91DB1A8461B7F149bCDbd673");

    client.sendTransaction(credentials, Transaction(from: ownAddress, to: receiverAddress, value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 5)));




    print('ownAddress :  '+ ownAddress.toString());
    // print(await client.getBalance(ownAddress));



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('송금'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text(strCenter)
          ]

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendToken,
        tooltip: 'Send',
        child: Icon(Icons.add),
      ),
    );
  }
}
