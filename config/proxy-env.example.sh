export http_proxy='http://127.0.0.1:1081'
export https_proxy='http://127.0.0.1:1081'
export HTTP_PROXY='http://127.0.0.1:1081'
export HTTPS_PROXY='http://127.0.0.1:1081'
export ALL_PROXY='socks5h://127.0.0.1:1080'
export all_proxy="$ALL_PROXY"

# Keep loopback, RFC1918, and common local domains out of the proxy path.
export no_proxy='localhost,127.0.0.1,::1,steamloopback.host,.local,.lan,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12'
export NO_PROXY="$no_proxy"
