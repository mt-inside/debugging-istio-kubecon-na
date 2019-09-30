# Set up
> Have a cluster with bookinfo installed and working.
> Want RBAC to make it more secure.

`./20-rbac-on.sh`
* `kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/rbac-config-ON.yaml`

> Nothing can be reached now.

`./21-rbac-allow.sh`
* run script

> Should be able to use everything. But `details` and `reviews` don't work.

# Access logs
> Let's see what's happening on the wire. RBAC is a reasonable guess cause
> it's what we just changed, but let's look.

`./30a-envoy-access-logs.sh`
* Run the script

`./30b-details-envoy-logs.sh`
* kubectl logs -l app=details -c istio-proxy -f

> These are a bit hard to read (slide). There's a tool that can help us.

Install engarde
* `go get github.com/nitishm/engarde`

`./30c-envoy-engarge.sh`
* kubectl logs -l app=details -c istio-proxy -f | engarde --use-istio
* kubectl logs -l app=details -c istio-proxy -f | engarde --use-istio | jq
* kubectl logs -l app=details -c istio-proxy -f | engarde --use-istio | jq -c '.status_code'

> So the sidecar is indeed returning 403.
> Let's check that that's _generated_ by Envoy, not the app.

# Traffic Sniffing

> We can get all the traffic off the wire, which will give us a few more
> insights. It's also very shiny, and we like shiny.
> Since `1.12`, `kubectl` has supported plugins.
> Krew is like a meta-pluging, which is package manager for other plugins.

Install _krew_
* complicated

Install _ksniff_
* `kubectl krew install sniff`
* needs a shell in the container, but there is some privledged mode where it can sniff scratch

Install wireshark
* Use the DMG from their website.
* I already have that, cause who doesn't have `ethereal` and `nmap` on their laptop?

./31-ksniff.sh
* kubectl sniff $pod -c details
  * Have to use details becuase it has a shell
  * It's the same netns so we see what we want anyway
* http.response.code==403 (or: `!(ip.addr==10.244.0.1) and !(ip.addr==127.0.0.1)` )
  * lots of traffic from localhost, that's envoy, can ignore
  * lots from the host's IP, that's the kubelet eg liveness checks, can ignore
  * Is coming from envoy, see the user-agent, see the IP (envoy issues to app from loopback)
  * And see the body - it's RBAC.

> So it is coming from Envoy. We opened RBAC up, so something's broken with
> RBAC.

# Permissive RBAC
> So wtf RBAC? We can make it permissive but have it still evaluate
> the rules and log them.

`./32a-rbac-permissive-with-logging.sh`
* `kubectl apply -f istio-1.3.1/samples/bookinfo/platform/kube/rbac/rbac-config-on-permissive.yaml`

> So it's definitely RBAC. Now let's make it log the decision it would have
> taken.

* `kubectl apply -f istio-1.3.1/samples/bookinfo/platform/kube/rbac/rbac-permissive-telemetry.yaml`

> Let's have a look.

`./32b-mixer-logs.sh`
* `kubectl logs -n istio-system -l istio-mixer-type=telemetry -c mixer -f | grep \"destination\":\"details\" | grep --color -E "permissiveResponseCode|responseCode"`

> And it's JSON, so we can use `jq` again

* `kubectl logs -n istio-system -l istio-mixer-type=telemetry -c mixer -f | grep \"destination\":\"details\" | grep --color -E "permissiveResponseCode|responseCode" | jq -c '.permissiveResponseCode'`

> Turn RBAC back on so it's easier to see what's happeneing

`./20-rbac-on.sh`
* `kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/rbac-config-ON.yaml`

# Pilot RBAC debugging

> So yes, this isn't some weird Envoy thing, can confim that it's taking a
> deny decision. Why?

> Think about how the config from your `ServiceRole[Binding]s` propagates.

> Let's look at Pilot first.

`./33a-pilot-controlz.sh`
* `istioctl dashboard controlz -n istio-system $pilot_pod`
* Logging scopes -> RBAC -> Debug

./33b-pilot-logs.sh
* `kubectl logs -n istio-system -l app=pilot -c discovery -f`
* remove and re-apply RBAC rules
* logs make sense, no errors

# Envoy RBAC debugging

`./34-envoy-controlz.sh`
* `istioctl dashboard envoy $pod`
* config_dump
* Search "permissions", explain

`./35a-envoy-rbac-logs-on.sh`
* try adding `?rbac=debug` in browser
* need to cURL it, could hit the `dashboard envoy` port-forward. Used to have to cURL from within the container, but now there's a command on `pilot-agent` to do that.
* kubectl exec $(kubectl get pods -l app=details -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- pilot-agent request POST 'logging?rbac=debug'

`./35b-envoy-rbac-logs-read.sh`
* `kubectl logs -l app=details -c istio-proxy -f`

> Hmm, `istio_authn` is empty
> Think about where the authn principal comes from... have you worked it
> out yet?

`./36-tls-check.sh`
* `istioctl authn tls-check $productpage-pod details.default.svc.cluster.local`

> Empty because No TLS...

`./40-secret-fix.sh`
* Traffic again
* `cat ./40-secret-fix.sh`

> There it is

`./36-tls-check.sh`
* `istioctl authn tls-check $productpage-pod details.default.svc.cluster.local`
