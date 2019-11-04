
# TCP Socket Reserver Proxy

I create reverse proxy at 

```
import 'dart:io';
import 'dart:typed_data';


// 
// リバース Proxy探報
// 
main(List<String> args) async {
  ServerSocket server = await ServerSocket.bind("0.0.0.0", 8080);
  server.listen((Socket ssocket) async {
    SecureSocket tsocket = await SecureSocket.connect("github.com", 443);
    ssocket.listen((Uint8List data){
      tsocket.add(data);
    },onDone: (){
      tsocket.close();
    });

    tsocket.listen((Uint8List data){
      ssocket.add(data);
    }, onDone: (){
      ssocket.close();
    });
  });
}

```
