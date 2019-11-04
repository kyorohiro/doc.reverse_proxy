import 'dart:io'  as io;

import 'dart:typed_data';


main() async {
  io.HttpServer server = await io.HttpServer.bind("0.0.0.0", 8080);

  server.listen((io.HttpRequest request) async {
    String url = "https://www.google.com:443"+request.requestedUri.path;
    String params = "";
    Map<String, List<String>>  parameter = request.requestedUri.queryParametersAll;
    for(String key in parameter.keys) {
      for(String v in parameter[key]) {
        params +=(params.length == 0?"?":"&");
        params += ""+key+"="+v;
      }
    }
    url += params;
    print(">>${url}");
    //
    //
    //
    io.HttpHeaders headers =  request.headers;

    io.HttpClientRequest req = await io.HttpClient().openUrl(request.method, Uri.parse(url));
    headers.forEach((String key,List<String> values){
      for(String value in values) {
        print("#># ${key} : ${value}");
        if(key.toLowerCase().trim() == "referer") {
          value = value.trim().replaceAll(new RegExp(r"http[s]?://[^/]*"), "https://www.google.com");
          print("#># ${key} : ${value}");
        }
        if(key.toLowerCase().trim() == "host") {
          value = value.replaceAll(new RegExp(r'^.*$'), "www.google.com");
          //continue;
        }
        print("#># ${key} : ${value}");
        //req.headers.add(key, value);
      }
    });
    io.HttpClientResponse res = await req.close();
    request.response.headers.contentType = res.headers.contentType;
    request.response.headers.forEach((String key,List<String> values){
      for(String value in values) {
        print("#<# ${key} : ${value}");
        //request.response.headers.add(key, value);
      }
    });
    for(io.Cookie c in request.response.cookies) {
      print("#<# cookie : ${c.toString()}");
    }
    await for(Uint8List data in res) {
      request.response.add(data);
    }
    request.response.close();
  });
  print("Hello, World!!");
}

