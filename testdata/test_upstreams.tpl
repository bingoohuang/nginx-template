{{- /* Refer https://danielparker.me/nginx/consul-template/consul/nginx-consul-template/ */ -}}
{{- /* Refer http://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream  */ -}}
{{- range .upstreams }}{{ if eq (or .state "1") "1" -}}
upstream {{.name}} {
	least_conn;
	{{if .keepalive }}keepalive {{.keepalive}};{{end}}
	{{- range .servers }}{{ if eq (or .state "1") "1" }}
	server {{.address}}:{{.port}}
	{{- if .weight }} weight={{.weight}}{{end}}
	{{- if .maxConns }} max_conns={{.maxConns}}{{end}}
	{{- if .maxFails }} max_fails={{.maxFails}}{{end}}
	{{- if .failTimeout }} fail_timeout={{.failTimeout}}{{end}}
	{{- if .backup}}{{ if eq .backup "yes" }} backup{{end}}{{end}}
	{{- if .slowStart}} slow_start={{.slowStart}}{{end}};
	{{- end }}
	{{- end }}
}
{{ end }}{{ end }}
