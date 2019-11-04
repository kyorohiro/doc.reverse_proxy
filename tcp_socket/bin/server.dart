import 'dart:io';
import 'dart:typed_data';

main(List<String> args) async {
  ServerSocket server = await ServerSocket.bind("0.0.0.0", 8080);
  server.listen((Socket ssocket) async {
    Socket tsocket = await Socket.connect("www.google.com", 443);
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

