# V Web Gzipped Static Server

A small web server written in [V](https://github.com/vlang/v), using the new [x.vweb vlib](https://github.com/vlang/v/vlib/x/vweb) to serve static website with `gzip`. I use it to host [my tech blog](https://labs.davlgd.fr) waiting for a way to add `gzip` support to [Tiniest Web Server](https://github.com/davlgd/tws).

You can `git clone` this repository and start the server to test it (you need [V](https://github.com/vlang/v) already setup):

```bash
v run .
```

 It will serve the `dist` directory on `http://localhost:8080`. Just try to access this URL or any other to see `404.html` page. You can also `curl` the `test.json` file to see the `gzip` compression in action:

```bash
curl --compressed http://localhost:8080/test.json | jq
```