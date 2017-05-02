# goCD Blue/Green deployment

## To push to Blue
Assuming you do your development in the `master` branch (you could do it within the `blue` branch or a separate `dev` branch)

```
    git checkout blue
    git add -A
    git commit -m ''
    git push origin blue
```

This will triger a pipeline within goCD that will run the `./build.sh` script.

The working of the script is documented via comments within the file. But here's a breakdown:

1. Auth to Gitlab
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