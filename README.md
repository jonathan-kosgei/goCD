# goCD Blue/Green deployment

## Prerequisites
1. On every node that the go agent is running do, to allow the agent to run docker commands
```
    sudo EDITOR=nano visudo
    # At the end of the file add
    go ALL = NOPASSWD: /bin/docker
```
2. Set your Gitlab CI credentials i.e. the Username and Password as two secret variables - USERNAME and PASSWORD as referenced in the build script
3. Also set the above credential as a kubernetes secret that will be mounted to all pods with
```
kubectl \
create \
secret \
docker-registry \
regsecret \
--docker-server=<your-registry-server> \
--docker-username=<your-name> \
--docker-password=<your-pword> \
--docker-email=<your-email>
```

## To push to Blue
Assuming you do your development in the `master` branch (you could do it within the `blue` branch or a separate `dev` branch)

```
    git checkout blue
    git add -A
    git commit -m ''
    git push origin blue
```

This will trigger a pipeline within goCD that will run the `./build.sh` script.

The working of the script is documented via comments within the file. But here's a breakdown:

1. Auth to Gitlab (The USERNAME and PASSWORD are set as secret variables within goCD)
2. Build a new image with the new code
3. Push the image to Gitlab CI
4. Perform a rolling update to update the image being used by the blue (or green) deployment
5. Change the `proxy.default.svc` service to point to the blue (or green) deployment

## To deploy to Green

```
    git checkout green
    git add -A
    git commit -m ''
    git push origin green
```

## How it works

When you `git push origin green` the service updates to point to the `green` deployment
```
testing@ubuntu ~/P/goCD> kubectl describe svc nginx
Name:	nginx
Namespace:	default
Labels:	name=nginx
Selector:	name=green
Type:	ClusterIP
IP:	10.43.46.104
Port:	nginx	80/TCP
Endpoints:	<none>
Session Affinity:	None
No events.
```

When you `git push origin blue` it points to the `blue`
```
testing@ubuntu ~/P/goCD> kubectl describe svc nginx
Name:	nginx
Namespace:	default
Labels:	name=nginx
Selector:	name=blue
Type:	ClusterIP
IP:	10.43.46.104
Port:	nginx	80/TCP
Endpoints:	<none>
Session Affinity:	None
No events.
```