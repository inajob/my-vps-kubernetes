kubectl --kubeconfig=:admin.conf proxy  --port=8080 --disable-filter=true --accept-hosts='^*$' --reject-paths='^$'
