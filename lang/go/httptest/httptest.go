package main
import (
  "http";
  "io";
  "net";
  "bufio";
  "fmt";
  "strconv";
)

type readClose struct {
  io.Reader;
  io.Closer;
}

func main(){
  url := "http://twitter.com/statuses/public_timeline.json";
  var req http.Request;
  req.URL, _ = http.ParseURL(url); 
  addr := req.URL.Host;
  addr += ":http";
  conn, _ := net.Dial("tcp", "", addr);
  _ = req.Write(conn);
  reader := bufio.NewReader(conn);
  resp, _ := http.ReadResponse(reader);
  r := io.Reader(reader);
  if v := resp.GetHeader("Content-Length"); v != "" {
    n, _ := strconv.Atoi64(v);
    r = io.LimitReader(r, n);
  }
  resp.Body = readClose{r, conn};
  b, _ := io.ReadAll(resp.Body);
  resp.Body.Close();
  fmt.Println(string(b))
}
