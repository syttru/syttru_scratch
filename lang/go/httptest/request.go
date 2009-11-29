package main

import (
  "http";
  "fmt"
)

func main(){
  var req http.Request;
  req.URL, _ = http.ParseURL("http://www.yahoo.co.jp/");
  host := req.URL.Host;
  fmt.Println(req.Method);
  fmt.Println(req.RawURL);
  fmt.Println(req.URL);
  fmt.Println(req.Proto);
  fmt.Println(req.ProtoMajor);
  fmt.Println(req.ProtoMinor);
  fmt.Println(host);
}
