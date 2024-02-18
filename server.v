module main

import time
import x.vweb
import v.util
import net.http

pub struct Context {
	vweb.Context
}

pub struct App {
	vweb.Middleware[Context]
}

@['/:path...']
pub fn (app &App) wildcard(mut ctx Context, path string) vweb.Result {
	mut file_path := path
	if !file_path.ends_with('/') && !file_path.contains('.') {
		file_path += '/'
	}
	if file_path.ends_with('/') {
		file_path += 'index.html'
	}

	ctx.set_header(.server, 'Tiniest_vWeb_Server')
	
	not_found := util.read_file('dist/404.html') or {
		ctx.res.status_code = 500
		return ctx.text('Internal server error')
	}

	data := util.read_file('dist' + file_path) or {
		ctx.res.status_code = 404
		return ctx.html(not_found)
	}

	ctx.res.header.add(http.CommonHeader.cache_control, 'public, max-age=3600')

	ctx.res.header.add(.expires, time.utc()
		.add_seconds(3600)
		.http_header_string())

	if file_path == '/404.html' {
		ctx.res.status_code = 404
		return ctx.html(data)
	} else if file_path.ends_with('.html') {
		return ctx.html(data)
	} else if file_path.ends_with('.css') {
		ctx.content_type = 'text/css'
	} else if file_path.ends_with('.js') {
		ctx.content_type = 'application/javascript'
	} else if file_path.ends_with('.json') {
		ctx.content_type = 'application/json'
	} else if file_path.ends_with('.png') {
		ctx.content_type = 'image/png'
	} else if file_path.ends_with('.jpg') {
		ctx.content_type = 'image/jpeg'
	} else if file_path.ends_with('.jpeg') {
		ctx.content_type = 'image/jpeg'
	} else if file_path.ends_with('.svg') {
		ctx.content_type = 'image/svg+xml'
	} else if file_path.ends_with('.ico') {
		ctx.content_type = 'image/x-icon'
	} else if file_path.ends_with('.webp') {
		ctx.content_type = 'image/webp'
	} else if file_path.ends_with('.xml') {
		ctx.content_type = 'application/xml'
	}

	return ctx.text(data)
}

fn main() {
	port := 8080
	mut app := &App{}
	app.use(vweb.encode_gzip[Context]())
	vweb.run[App, Context](mut app, port)
}
